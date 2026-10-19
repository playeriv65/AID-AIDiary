// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Headless phone screenshots, no window:
//   flutter test tool/screenshots/
// Output: artifacts/ui-phone-*.png.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton).hitTestable().first);
    await tester.pumpAndSettle();
  }

  testWidgets('phone', (tester) async {
    await session.start(tester, const Size(390, 844));
    await session.capture(tester, 'phone-journal');
    await session.tapKey(
        tester, 'journal-entry-${await session.starredEntryId(tester)}');
    await session.capture(tester, 'phone-entry');
    await back(tester);
    await session.tapKey(tester, 'journal-search');
    await session.capture(tester, 'phone-search');
    await back(tester);
    for (final (index, name) in [
      (1, 'calendar'),
      (2, 'media'),
      (4, 'coach'),
    ]) {
      await DiaryAppHarness.goTo(tester, index);
      await session.capture(tester, 'phone-$name');
    }
    await DiaryAppHarness.goTo(tester, 0);
    await session.tapKey(tester, 'diary-new-entry');
    await session.capture(tester, 'phone-editor');
    await session.finish(tester);
  });
}
