// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keyboard dismissal takes effect immediately at the final inset',
      (tester) async {
    final focus = FocusNode();
    final session = EditorKeyboardSession(focusNode: focus, initialInset: 300);
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Focus(focusNode: focus, child: const SizedBox())));
    focus.requestFocus();
    await tester.pump();
    expect(session.state, EditorFocusState.docked);
    for (final inset in [240.0, 120.0, 40.0]) {
      session.noteKeyboardInset(inset);
      await tester.pump(const Duration(milliseconds: 100));
      expect(session.isUp, isTrue, reason: 'still sliding at $inset');
    }
    session.noteKeyboardInset(0);
    expect(session.isUp, isFalse);
    expect(session.state, EditorFocusState.dismissed);
    session.noteKeyboardInset(200);
    expect(session.isUp, isTrue);
    expect(session.state, EditorFocusState.docked);
    session.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    focus.dispose();
  });
}
