// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInfo
import android.content.pm.PackageInstaller
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.security.MessageDigest

/** Installs a downloaded build of this app over itself (docs/UPDATES.md).
 * Only a package with this app's name, signed with this app's key and of a
 * newer version reaches the system installer. */
class AppUpdater(private val activity: Activity, messenger: BinaryMessenger) {
  private val context: Context = activity.applicationContext
  private val packageName: String = context.packageName
  private var waiting: MethodChannel.Result? = null
  private var listening = false

  private class Rejected(val code: String, message: String) : Exception(message)

  init {
    MethodChannel(messenger, "aid.updates").setMethodCallHandler { call, result ->
      try {
        when (call.method) {
          // F-Droid's client updates its builds, signed with F-Droid's key.
          "enabled" -> result.success(BuildConfig.FLAVOR != "fdroid")
          "canInstallSilently" -> result.success(canInstallSilently())
          "install" -> install(File(call.argument<String>("path") ?: ""), result)
          else -> result.notImplemented()
        }
      } catch (error: Rejected) {
        result.error(error.code, error.message, null)
      } catch (error: Exception) {
        result.error("install_failed", error.message, null)
      }
    }
  }

  private fun mayInstall() = Build.VERSION.SDK_INT < 26 ||
    context.packageManager.canRequestPackageInstalls()

  @Suppress("DEPRECATION")
  private fun installer(): String? = if (Build.VERSION.SDK_INT >= 30) {
    context.packageManager.getInstallSourceInfo(packageName).installingPackageName
  } else context.packageManager.getInstallerPackageName(packageName)

  /** Android 12 lets an app replace itself unasked once it is the one that
   * installed itself. */
  private fun canInstallSilently() = Build.VERSION.SDK_INT >= 31 && mayInstall() &&
    installer() == packageName

  @Suppress("DEPRECATION")
  private fun signers(info: PackageInfo): Set<String> {
    val signatures = if (Build.VERSION.SDK_INT >= 28) {
      info.signingInfo?.apkContentsSigners
    } else info.signatures
    val sha = MessageDigest.getInstance("SHA-256")
    return signatures.orEmpty().map { sha.digest(it.toByteArray()).joinToString("") { b -> "%02x".format(b) } }.toSet()
  }

  @Suppress("DEPRECATION")
  private fun versionCode(info: PackageInfo): Long =
    if (Build.VERSION.SDK_INT >= 28) info.longVersionCode else info.versionCode.toLong()

  private fun check(file: File) {
    val cache = context.cacheDir.canonicalPath + File.separator
    if (!file.canonicalPath.startsWith(cache) || !file.isFile) {
      throw Rejected("bad_args", "The package is not a downloaded update")
    }
    val flags = if (Build.VERSION.SDK_INT >= 28) PackageManager.GET_SIGNING_CERTIFICATES
      else @Suppress("DEPRECATION") PackageManager.GET_SIGNATURES
    val manager = context.packageManager
    val archive = manager.getPackageArchiveInfo(file.path, flags)
      ?: throw Rejected("corrupt", "Not an Android package")
    if (archive.packageName != packageName) {
      throw Rejected("wrong_app", "The package is another app")
    }
    val installed = manager.getPackageInfo(packageName, flags)
    val signedBy = signers(archive)
    if (signedBy.isEmpty() || signedBy != signers(installed)) {
      throw Rejected("wrong_key", "The package is not signed with this app's key")
    }
    if (versionCode(archive) <= versionCode(installed)) {
      throw Rejected("not_newer", "The package is not newer than this app")
    }
  }

  private fun install(file: File, result: MethodChannel.Result) {
    check(file)
    if (!mayInstall()) {
      activity.startActivity(Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
        Uri.parse("package:$packageName")))
      result.success("needsPermission")
      return
    }
    val installer = context.packageManager.packageInstaller
    val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL).apply {
      setAppPackageName(packageName)
      setSize(file.length())
      if (Build.VERSION.SDK_INT >= 31) {
        setRequireUserAction(PackageInstaller.SessionParams.USER_ACTION_NOT_REQUIRED)
      }
    }
    val id = installer.createSession(params)
    installer.openSession(id).use { session ->
      file.inputStream().use { input ->
        session.openWrite("update.apk", 0, file.length()).use { output ->
          input.copyTo(output)
          session.fsync(output)
        }
      }
      listen()
      waiting?.error("superseded", "Another install started", null)
      waiting = result
      val status = Intent(statusAction).setPackage(packageName)
      val flags = PendingIntent.FLAG_UPDATE_CURRENT or
        (if (Build.VERSION.SDK_INT >= 31) PendingIntent.FLAG_MUTABLE else 0)
      session.commit(PendingIntent.getBroadcast(context, id, status, flags).intentSender)
    }
  }

  private val statusAction = "$packageName.UPDATE_STATUS"

  private fun listen() {
    if (listening) return
    listening = true
    ContextCompat.registerReceiver(context, object : BroadcastReceiver() {
      override fun onReceive(receiverContext: Context, intent: Intent) = status(intent)
    }, IntentFilter(statusAction), ContextCompat.RECEIVER_NOT_EXPORTED)
  }

  @Suppress("DEPRECATION")
  private fun status(intent: Intent) {
    val result = waiting ?: return
    when (intent.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE)) {
      PackageInstaller.STATUS_PENDING_USER_ACTION -> {
        val confirm = if (Build.VERSION.SDK_INT >= 33) {
          intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
        } else intent.getParcelableExtra(Intent.EXTRA_INTENT)
        if (confirm == null) {
          result.error("install_failed", "The installer asked for nothing to show", null)
        } else {
          activity.startActivity(confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
          result.success("confirming")
        }
      }
      PackageInstaller.STATUS_SUCCESS -> result.success("started")
      else -> result.error("install_failed",
        intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: "Install failed", null)
    }
    waiting = null
  }
}
