// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  testWidgets('top calendar shortcut through phone and wide layouts',
      (tester) async {
    // Keep one seeded store: image-loader caches live for the whole isolate.
    await session
        .start(tester, const Size(390, 844), systemBars: (top: 40, bottom: 20));
    for (final (name, home) in [('phone', 'journal'), ('tablet', 'home')]) {
      if (name == 'tablet') {
        await DiaryAppHarness.goTo(tester, 0);
        DiaryAppHarness.size(tester, const Size(1280, 800));
        await tester.pumpAndSettle();
      }
      await session.capture(tester, '$name-$home');
      await session.tapKey(tester, 'journal-calendar');
      await session.capture(tester, '$name-calendar');
      await tester.tap(find.byType(BackButton).hitTestable());
      await tester.pumpAndSettle();
      await DiaryAppHarness.goTo(tester, 1);
      await session.capture(tester, '$name-media');
    }
    await session.finish(tester);
  });
}
