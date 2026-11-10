// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package com.playeriv65.diary

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
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.security.MessageDigest
import java.util.concurrent.FutureTask
import java.util.concurrent.TimeUnit
import java.util.concurrent.TimeoutException
import kotlin.concurrent.thread

/** Installs a downloaded build of this app over itself (docs/UPDATES.md):
 * with the system installer, or with `pm` as root when the user granted
 * this app root. Only a package with this app's name, signed with this
 * app's key and of a newer version reaches either. */
class AppUpdater(private val activity: Activity, messenger: BinaryMessenger) {
  private val context: Context = activity.applicationContext
  private val packageName: String = context.packageName
  private var waiting: MethodChannel.Result? = null
  private var listening = false

  private class Rejected(val code: String, message: String) : Exception(message)

  init {
    MethodChannel(messenger, "$NAMESPACE/updates").setMethodCallHandler { call, result ->
      try {
        when (call.method) {
          // F-Droid's client updates its builds, signed with F-Droid's key.
          "enabled" -> result.success(BuildConfig.FLAVOR != "fdroid")

          "canInstallSilently" -> result.success(canInstallSilently())

          "silentSupported" -> result.success(Build.VERSION.SDK_INT >= 31 && !xiaomi)

          "install" -> install(File(call.argument<String>("path") ?: ""), result)

          "rootId" -> {
            val timeoutMs = call.argument<Number>("timeoutMs")?.toLong() ?: 0
            if (timeoutMs <= 0) throw Rejected("bad_args", "No probe timeout")
            background(result) { rootId(timeoutMs) }
          }

          "installAsRoot" -> installAsRoot(
            File(call.argument<String>("path") ?: ""),
            call.argument<String>("stagingDir") ?: throw Rejected("bad_args", "No staging folder"),
            result,
          )

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
  } else {
    context.packageManager.getInstallerPackageName(packageName)
  }

  /** HyperOS (and MIUI) refuse an install session that asks for no user
   * action from any app Xiaomi has not listed, with INSTALL_FAILED_ABORTED
   * "Permission denied" (PKMSImpl.assertCallerAndPackage); there the system
   * always asks, unless the app installs as root. */
  private val xiaomi = Build.MANUFACTURER.equals("Xiaomi", ignoreCase = true)

  /** Android 12 lets an app replace itself unasked once it is the one that
   * installed itself. */
  private fun canInstallSilently() = Build.VERSION.SDK_INT >= 31 && !xiaomi &&
    mayInstall() && installer() == packageName

  @Suppress("DEPRECATION")
  private fun signers(info: PackageInfo): Set<String> {
    val signatures = if (Build.VERSION.SDK_INT >= 28) {
      info.signingInfo?.apkContentsSigners
    } else {
      info.signatures
    }
    val sha = MessageDigest.getInstance("SHA-256")
    return signatures.orEmpty().map { sha.digest(it.toByteArray()).joinToString("") { b -> "%02x".format(b) } }.toSet()
  }

  @Suppress("DEPRECATION")
  private fun versionCode(info: PackageInfo): Long = if (Build.VERSION.SDK_INT >= 28) info.longVersionCode else info.versionCode.toLong()

  private fun check(file: File) {
    val cache = context.cacheDir.canonicalPath + File.separator
    if (!file.canonicalPath.startsWith(cache) || !file.isFile) {
      throw Rejected("bad_args", "The package is not a downloaded update")
    }
    val flags = if (Build.VERSION.SDK_INT >= 28) {
      PackageManager.GET_SIGNING_CERTIFICATES
    } else {
      @Suppress("DEPRECATION")
      PackageManager.GET_SIGNATURES
    }
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
      activity.startActivity(
        Intent(
          Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
          Uri.parse("package:$packageName"),
        ),
      )
      result.success("needsPermission")
      return
    }
    val installer = context.packageManager.packageInstaller
    val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL).apply {
      setAppPackageName(packageName)
      setSize(file.length())
      if (Build.VERSION.SDK_INT >= 31) {
        setRequireUserAction(
          if (xiaomi) {
            PackageInstaller.SessionParams.USER_ACTION_REQUIRED
          } else {
            PackageInstaller.SessionParams.USER_ACTION_NOT_REQUIRED
          },
        )
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

  private val main = Handler(Looper.getMainLooper())

  /** Runs [work] off the main thread and answers [result] on it. */
  private fun background(result: MethodChannel.Result, work: () -> Any?) {
    thread(name = "AppUpdater") {
      val answer = runCatching(work)
      main.post {
        answer.fold(
          { result.success(it) },
          { error ->
            if (error is Rejected) {
              result.error(error.code, error.message, null)
            } else {
              result.error("install_failed", error.message, null)
            }
          },
        )
      }
    }
  }

  /** The `su` on this app's PATH: none on an unrooted device, so nothing
   * runs there. KernelSU never asks: for an app it has not granted root,
   * running su fails. */
  private fun su(): String? {
    val folders = System.getenv("PATH").orEmpty().split(':').filter { it.isNotEmpty() }
    return folders.map { File(it, "su") }.firstOrNull { it.exists() }?.path
  }

  /** Runs [script] in a root shell: its exit code and output, or null when
   * it has not finished after [timeoutMs] (0 waits for it). A shell that
   * became root cannot be stopped by this app, so it is left behind. */
  private fun runAsRoot(su: String, script: String, timeoutMs: Long): Pair<Int, String>? {
    val process = ProcessBuilder(su, "-c", script).redirectErrorStream(true).start()
    process.outputStream.close()
    val run = FutureTask {
      val output = process.inputStream.bufferedReader().use { it.readText() }
      process.waitFor() to output
    }
    thread(name = "AppUpdater su") { run.run() }
    return try {
      if (timeoutMs > 0) run.get(timeoutMs, TimeUnit.MILLISECONDS) else run.get()
    } catch (_: TimeoutException) {
      process.destroy()
      null
    }
  }

  /** What `su -c id` answered within [timeoutMs], for Dart to judge
   * (AppUpdates.canInstallAsRoot); null without su, when su could not
   * start, or when it did not answer in time. */
  private fun rootId(timeoutMs: Long): Map<String, Any>? {
    val su = su() ?: return null
    val (code, output) = try {
      runAsRoot(su, "id", timeoutMs)
    } catch (_: Exception) {
      null
    } ?: return null
    return mapOf("code" to code, "output" to output)
  }

  /** Installs [file] with `pm` as root, so no system confirmation appears.
   * The app is replaced (and so closed) before pm answers; it opens again
   * when the user was in it. A failure answers "root_failed" with pm's
   * output, and the caller falls back to the system installer. */
  private fun installAsRoot(file: File, stagingDir: String, result: MethodChannel.Result) {
    check(file)
    val su = su() ?: throw Rejected("root_failed", "su is not available")
    val state = (activity as? LifecycleOwner)?.lifecycle?.currentState
    val inApp = state?.isAtLeast(Lifecycle.State.RESUMED) == true
    val launch = context.packageManager.getLaunchIntentForPackage(packageName)?.component?.flattenToShortString()
    val script = rootInstallScript(file.canonicalPath, stagingDir, launch.takeIf { inApp })
    background(result) {
      val (code, output) = try {
        runAsRoot(su, script, 0)!!
      } catch (error: Exception) {
        throw Rejected("root_failed", error.message ?: "su failed")
      }
      if (code != 0) throw Rejected("root_failed", output.trim().ifEmpty { "pm install failed ($code)" })
      "started"
    }
  }

  /** The root shell's steps. The shell first leaves the app's process
   * group: replacing the app kills every process in it, and the shell still
   * removes the staged copy and opens the app again. pm writes to a file, as
   * the app's end of the pipe is gone once pm succeeds. */
  private fun rootInstallScript(path: String, stagingDir: String, launch: String?): String {
    val staged = quote("$stagingDir/$packageName.update.apk")
    val log = quote("$stagingDir/$packageName.update.log")
    return listOfNotNull(
      "for group in /sys/fs/cgroup /acct; do echo \$\$ > \$group/cgroup.procs; done 2>/dev/null",
      "cp ${quote(path)} $staged && chmod 644 $staged && pm install -r -i $packageName $staged > $log 2>&1",
      "status=\$?",
      "rm -f $staged",
      launch?.let { "[ \$status = 0 ] && am start -n $it > /dev/null 2>&1" },
      "[ \$status = 0 ] || cat $log",
      "rm -f $log",
      "exit \$status",
    ).joinToString("; ")
  }

  private fun quote(value: String) = "'" + value.replace("'", "'\\''") + "'"

  private val statusAction = "$packageName.UPDATE_STATUS"

  private fun listen() {
    if (listening) return
    listening = true
    ContextCompat.registerReceiver(
      context,
      object : BroadcastReceiver() {
        override fun onReceive(receiverContext: Context, intent: Intent) = status(intent)
      },
      IntentFilter(statusAction),
      ContextCompat.RECEIVER_NOT_EXPORTED,
    )
  }

  @Suppress("DEPRECATION")
  private fun status(intent: Intent) {
    val result = waiting ?: return
    when (intent.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE)) {
      PackageInstaller.STATUS_PENDING_USER_ACTION -> {
        val confirm = if (Build.VERSION.SDK_INT >= 33) {
          intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
        } else {
          intent.getParcelableExtra(Intent.EXTRA_INTENT)
        }
        if (confirm == null) {
          result.error("install_failed", "The installer asked for nothing to show", null)
        } else {
          activity.startActivity(confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
          result.success("confirming")
        }
      }

      PackageInstaller.STATUS_SUCCESS -> result.success("started")

      else -> result.error(
        "install_failed",
        intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: "Install failed",
        null,
      )
    }
    waiting = null
  }
}
