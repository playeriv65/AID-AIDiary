// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:flutter/services.dart';

/// Touch feedback, one meaning per kind, after Android's haptic constants
/// and Apple's guidelines: felt at moments that matter, never on every tap,
/// and always alongside something seen. The system's touch feedback setting
/// still decides whether any of it plays. Only the GUI calls these; actions
/// run from the command line stay silent.
abstract final class Haptics {
  /// Moving through choices: a tab, a switch, a mood. Android's tick.
  static void selection() => unawaited(HapticFeedback.selectionClick());

  /// Something the person did went through: an entry saved, a sync done.
  static void success() => unawaited(HapticFeedback.successNotification());

  /// A step that is hard to take back is ahead, such as deleting.
  static void warning() => unawaited(HapticFeedback.warningNotification());

  /// What the person tried did not work, such as a wrong passphrase.
  static void error() => unawaited(HapticFeedback.errorNotification());
}
