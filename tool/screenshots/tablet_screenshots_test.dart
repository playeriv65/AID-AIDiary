// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Headless tablet screenshots, no window:
//   flutter test tool/screenshots/
// Output: artifacts/ui-tablet-*.png.

import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/search_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();

  // Pops the route that holds [page]; the search page has no standard back
  // button and the editor sits on the root navigator.
  Future<void> close(WidgetTester tester, Finder page) async {
    Navigator.of(tester.element(page)).pop();
    await tester.pumpAndSettle();
  }

  testWidgets('tablet', (tester) async {
    // Same size as Journey's tablet reference shots.
    await session.start(tester, const Size(1280, 800));
    await session.capture(tester, 'tablet-home');
    await session.tapKey(
        tester, 'journal-entry-${await session.starredEntryId(tester)}');
    await session.capture(tester, 'tablet-journal');
    await session.tapKey(tester, 'journal-profile');
    await session.capture(tester, 'tablet-avatar');
    await tester.tapAt(const Offset(640, 40));
    await tester.pumpAndSettle();
    await session.tapKey(tester, 'journal-search');
    await session.capture(tester, 'tablet-search');
    await close(tester, find.byType(SearchPage));
    await session.tapKey(tester, 'diary-new-entry');
    await session.capture(tester, 'tablet-editor');
    await close(tester, find.byType(AddEditEntryPage));
    await DiaryAppHarness.goTo(tester, 1);
    await session.capture(tester, 'tablet-calendar');
    await DiaryAppHarness.goTo(tester, 2);
    await session.capture(tester, 'tablet-media');
    await DiaryAppHarness.goTo(tester, 3);
    await session.capture(tester, 'tablet-atlas');
    await DiaryAppHarness.goTo(tester, 4);
    await session.tapKey(tester, 'coach-program-everyday');
    await session.capture(tester, 'tablet-coach');
    await session.finish(tester);
  });
}
