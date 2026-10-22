// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets runs timers on fake time, which tester.pump advances.
  testWidgets(
      'the keyboard counts as dismissed only once it is all the way down',
      (tester) async {
    final focus = FocusNode();
    final session = EditorKeyboardSession(focusNode: focus, initialInset: 300);
    for (final inset in [240.0, 120.0, 40.0]) {
      session.noteKeyboardInset(inset);
      await tester.pump(const Duration(milliseconds: 100));
      expect(session.isUp, isTrue, reason: 'still sliding at $inset');
    }
    session.noteKeyboardInset(0);
    await tester.pump(EditorKeyboardSession.dismissDebounceDuration);
    expect(session.isUp, isFalse);
    session.dispose();
    focus.dispose();
  });
}
