// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent;

class MainActivity: FlutterFragmentActivity() {
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
