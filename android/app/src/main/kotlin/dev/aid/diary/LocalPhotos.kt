// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import android.Manifest
import android.content.ContentUris
import android.content.Context
import android.content.pm.PackageManager
import android.media.ExifInterface
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.content.ContentResolver
import android.webkit.MimeTypeMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.io.File
import java.util.UUID

/** Bounded metadata queries. Original image bytes are copied only after an
 * explicit card selection, and originals are never modified or deleted. */
class LocalPhotos(private val context: Context, messenger: BinaryMessenger) {
  private val maxBytes = 32L * 1024 * 1024
  init {
    MethodChannel(messenger, "aid.local_photos", StandardMethodCodec.INSTANCE,
      messenger.makeBackgroundTaskQueue()).setMethodCallHandler { call, result ->
      try {
        if (!allowed()) {
          result.error("permission", "Photo access has not been granted", null)
        } else when (call.method) {
          "query" -> result.success(query(
            call.argument<Number>("after")?.toLong() ?: System.currentTimeMillis(),
            (call.argument<Number>("limit")?.toInt() ?: 500).coerceIn(1, 500),
            call.argument<Boolean>("locations") == true))
          "copy" -> result.success(copy(call.argument<String>("id") ?: ""))
          else -> result.notImplemented()
        }
      } catch (_: SecurityException) {
        result.error("permission", "Photo access is no longer available", null)
      } catch (_: Exception) {
        result.error("photo_read", "Could not read the selected local photo", null)
      }
    }
  }
  private fun granted(permission: String) = Build.VERSION.SDK_INT < 23 ||
    context.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
  private fun allowed() = if (Build.VERSION.SDK_INT >= 33) {
    granted(Manifest.permission.READ_MEDIA_IMAGES) ||
      (Build.VERSION.SDK_INT >= 34 &&
        granted(Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED))
  } else granted(Manifest.permission.READ_EXTERNAL_STORAGE)

  private fun query(after: Long, limit: Int, locations: Boolean): List<Map<String, Any?>> {
    require(after >= 0)
    val projection = arrayOf(MediaStore.Images.Media._ID,
      MediaStore.Images.Media.DATE_TAKEN, MediaStore.Images.Media.DATE_ADDED,
      MediaStore.Images.Media.SIZE)
    val selection = "(${MediaStore.Images.Media.DATE_TAKEN} >= ? OR " +
      "((${MediaStore.Images.Media.DATE_TAKEN} IS NULL OR ${MediaStore.Images.Media.DATE_TAKEN} <= 0) " +
      "AND ${MediaStore.Images.Media.DATE_ADDED} >= ?))"
    val args = arrayOf(after.toString(), (after / 1000).toString())
    val resolver = context.contentResolver
    val cursor = if(Build.VERSION.SDK_INT >= 26) {
      val options = Bundle().apply {
        putString(ContentResolver.QUERY_ARG_SQL_SELECTION, selection)
        putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS, args)
        putStringArray(ContentResolver.QUERY_ARG_SORT_COLUMNS,
          arrayOf(MediaStore.Images.Media.DATE_TAKEN, MediaStore.Images.Media.DATE_ADDED))
        putInt(ContentResolver.QUERY_ARG_SORT_DIRECTION, ContentResolver.QUERY_SORT_DIRECTION_DESCENDING)
        putInt(ContentResolver.QUERY_ARG_LIMIT, limit)
      }
      resolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, projection, options, null)
    } else resolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, projection,
      selection, args, "${MediaStore.Images.Media.DATE_TAKEN} DESC")
    val rows = mutableListOf<Map<String, Any?>>()
    val readLocations = locations && (Build.VERSION.SDK_INT < 29 ||
      granted(Manifest.permission.ACCESS_MEDIA_LOCATION))
    cursor?.use {
      var inspected = 0
      while(it.moveToNext() && rows.size < limit && inspected++ < 2000) {
        val size = it.getLong(3)
        if(size <= 0 || size > maxBytes) continue
        val id = it.getLong(0)
        val taken = it.getLong(1).takeIf { value -> value > 0 } ?: it.getLong(2) * 1000
        val row = mutableMapOf<String, Any?>("id" to id.toString(), "taken" to taken)
        if(readLocations && rows.size < 80 && Build.VERSION.SDK_INT >= 24) {
          try {
            var uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id)
            if(Build.VERSION.SDK_INT >= 29) uri = MediaStore.setRequireOriginal(uri)
            resolver.openInputStream(uri)?.use { stream ->
              val exif = ExifInterface(stream)
              val latLong = FloatArray(2)
              if(exif.getLatLong(latLong) && (latLong[0] != 0f || latLong[1] != 0f)) {
                row["latitude"] = latLong[0].toDouble()
                row["longitude"] = latLong[1].toDouble()
              }
            }
          } catch (_: Exception) { /* Coordinates are optional metadata. */ }
        }
        rows.add(row)
      }
    }
    return rows
  }
  private fun copy(id: String): String {
    require(Regex("^[0-9]{1,20}$").matches(id))
    val uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id.toLong())
    val resolver = context.contentResolver
    val mime = resolver.getType(uri) ?: throw IllegalArgumentException("Missing photo type")
    require(mime.startsWith("image/"))
    val extension = MimeTypeMap.getSingleton().getExtensionFromMimeType(mime) ?: "jpg"
    require(Regex("^[A-Za-z0-9]{1,10}$").matches(extension))
    val directory = File(context.cacheDir, "local-photo-import").apply { mkdirs() }
    val file = File(directory, "${UUID.randomUUID()}.$extension")
    try {
      require(file.createNewFile())
      resolver.openInputStream(uri)?.use { input ->
        file.outputStream().use { output ->
          val buffer = ByteArray(64 * 1024)
          var total = 0L
          while(true) {
            val count = input.read(buffer)
            if(count < 0) break
            total += count
            require(total <= maxBytes)
            output.write(buffer, 0, count)
          }
          require(total > 0)
        }
      } ?: throw IllegalArgumentException("Photo unavailable")
      return file.absolutePath
    } catch(error: Exception) {
      file.delete()
      throw error
    }
  }
}
