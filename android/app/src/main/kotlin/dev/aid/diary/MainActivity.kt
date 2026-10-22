// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterFragmentActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "aid.dev/workspace")
      .setMethodCallHandler { call, result ->
        if (call.method != "workspace") {
          result.notImplemented()
        } else {
          val name = intent.getStringExtra("aid_test_workspace")
          if (BuildConfig.FLAVOR != "dev" || name == null) {
            result.success(null)
          } else if (!Regex("^[A-Za-z0-9_-]{1,64}$").matches(name)) {
            result.error("invalid_workspace", "Use a simple development workspace name", null)
          } else {
            result.success(File(filesDir, "network-tests/$name").absolutePath)
          }
        }
      }
  }
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
  }

  // A singleTask activity recreated in its old task keeps the task's first
  // intent and gets the new one here, often before Dart listens. Keep it as
  // the current intent so launch checks (such as a home widget tap) see it.
  override fun onNewIntent(intent: Intent) {
    setIntent(intent)
    super.onNewIntent(intent)
  }
}
