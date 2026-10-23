// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  for (final (name, size) in [
    ('phone', const Size(360, 800)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('direct mood choices $name', (tester) async {
      await session.start(tester, size);
      await tester.tap(find.byKey(const ValueKey('diary-new-entry')));
      await tester.pumpAndSettle();
      await tester.enterText(DiaryAppHarness.entryBody, '今天在河边散步，心情不错。');
      await tester.tap(find.byKey(const ValueKey('editor-mood')));
      await tester.pumpAndSettle();
      await session.capture(tester, '$name-editor-mood');
      await session.finish(tester);
    });
  }
}
