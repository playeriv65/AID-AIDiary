// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Headless tablet screenshots, no window:
//   flutter test tool/screenshots/
// Output: artifacts/ui-tablet-*.png.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();

  testWidgets('tablet', (tester) async {
    await session.start(tester, const Size(1280, 800));
    await session.tapKey(
        tester, 'journal-entry-${await session.starredEntryId(tester)}');
    await session.capture(tester, 'tablet-journal');
    await DiaryAppHarness.goTo(tester, 1);
    await session.capture(tester, 'tablet-calendar');
    await DiaryAppHarness.goTo(tester, 2);
    await session.capture(tester, 'tablet-media');
    await DiaryAppHarness.goTo(tester, 4);
    await session.tapKey(tester, 'coach-program-everyday');
    await session.capture(tester, 'tablet-coach');
    await session.finish(tester);
  });
}
