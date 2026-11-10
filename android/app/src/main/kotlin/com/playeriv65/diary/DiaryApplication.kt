// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package com.playeriv65.diary

import android.app.Application

/** Sets up the process before any Flutter engine starts, including the
 * background ones. */
class DiaryApplication : Application() {
  override fun onCreate() {
    super.onCreate()
    SemanticsGate.install(this)
  }
}
