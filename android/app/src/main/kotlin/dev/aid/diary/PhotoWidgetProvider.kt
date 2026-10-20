// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File
import java.util.Random
import java.util.TimeZone
import org.json.JSONArray
import org.json.JSONObject

/**
 * Home screen widget showing one photo from the diary with its entry's
 * date; a tap opens that entry. The app hands over a list of photos; the
 * widget picks one per day itself, so it turns over at the next periodic
 * update after midnight without the app running.
 */
class PhotoWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val (choice, photo) = todaysPhoto(widgetData.getString("photo_widget_photos", null))
    val empty =
        widgetData.getString(
            "photo_widget_empty", context.getString(R.string.photo_widget_empty_default))

    val tap =
        HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse(
                if (choice != null) "aiddiary://entry?id=${choice.getInt("entry")}"
                else "aiddiary://open"))

    for (id in appWidgetIds) {
      val views =
          RemoteViews(context.packageName, R.layout.photo_widget).apply {
            if (choice != null && photo != null) {
              setImageViewBitmap(R.id.photo_widget_image, photo)
              setViewVisibility(R.id.photo_widget_image, View.VISIBLE)
              setViewVisibility(R.id.photo_widget_scrim, View.VISIBLE)
              setTextViewText(R.id.photo_widget_caption, choice.optString("caption"))
              setViewVisibility(R.id.photo_widget_caption, View.VISIBLE)
              setViewVisibility(R.id.photo_widget_empty, View.GONE)
            } else {
              setViewVisibility(R.id.photo_widget_image, View.GONE)
              setViewVisibility(R.id.photo_widget_scrim, View.GONE)
              setViewVisibility(R.id.photo_widget_caption, View.GONE)
              setTextViewText(R.id.photo_widget_empty, empty)
              setViewVisibility(R.id.photo_widget_empty, View.VISIBLE)
            }
            setOnClickPendingIntent(R.id.photo_widget_root, tap)
          }
      appWidgetManager.updateAppWidget(id, views)
    }
  }

  /** Today's photo: a pick seeded by the date, skipping files that are gone. */
  private fun todaysPhoto(json: String?): Pair<JSONObject?, Bitmap?> {
    val photos = runCatching { JSONArray(json ?: return null to null) }.getOrNull()
    if (photos == null || photos.length() == 0) return null to null
    val now = System.currentTimeMillis()
    val localDay = (now + TimeZone.getDefault().getOffset(now)) / DAY_MILLIS
    val start = Random(localDay).nextInt(photos.length())
    for (offset in 0 until photos.length()) {
      val choice = photos.getJSONObject((start + offset) % photos.length())
      val bitmap = load(choice.optString("path"))
      if (bitmap != null) return choice to bitmap
    }
    return null to null
  }

  /**
   * Upright and at most [MAX_SIDE] px on the long side: widget bitmaps travel
   * through a size-limited channel.
   */
  private fun load(path: String): Bitmap? {
    if (path.isEmpty() || !File(path).exists()) return null
    val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
    BitmapFactory.decodeFile(path, bounds)
    var sample = 1
    while (maxOf(bounds.outWidth, bounds.outHeight) / (sample * 2) >= MAX_SIDE) sample *= 2
    val decoded =
        BitmapFactory.decodeFile(path, BitmapFactory.Options().apply { inSampleSize = sample })
            ?: return null
    val scale = minOf(1f, MAX_SIDE.toFloat() / maxOf(decoded.width, decoded.height))
    val matrix = Matrix().apply {
      postScale(scale, scale)
      postRotate(rotationOf(path))
    }
    return Bitmap.createBitmap(decoded, 0, 0, decoded.width, decoded.height, matrix, true)
  }

  private fun rotationOf(path: String): Float =
      when (runCatching {
            ExifInterface(path)
                .getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)
          }
          .getOrDefault(ExifInterface.ORIENTATION_NORMAL)) {
        ExifInterface.ORIENTATION_ROTATE_90 -> 90f
        ExifInterface.ORIENTATION_ROTATE_180 -> 180f
        ExifInterface.ORIENTATION_ROTATE_270 -> 270f
        else -> 0f
      }

  private companion object {
    const val MAX_SIDE = 720
    const val DAY_MILLIS = 86_400_000L
  }
}
