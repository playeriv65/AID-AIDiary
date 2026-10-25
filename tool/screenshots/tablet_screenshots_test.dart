// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Headless tablet screenshots, no window:
//   flutter test tool/screenshots/
// Output: artifacts/ui-tablet-*.png.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/pages/coach_page.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/search_page.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/widgets/pairing_dialog.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/support/diary_app_harness.dart';
import '../../test/support/memory_login.dart';
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
    // A common Android tablet size.
    await session.start(tester, const Size(1280, 800));
    await session.capture(tester, 'tablet-home');
    await session.tapKey(
        tester, 'journal-entry-${await session.starredEntryId(tester)}');
    await session.capture(tester, 'tablet-journal');
    await session.tapKey(tester, 'journal-menu');
    await session.capture(tester, 'tablet-menu');
    await tester.tapAt(const Offset(640, 40));
    await tester.pumpAndSettle();
    await session.tapKey(tester, 'journal-search');
    await session.capture(tester, 'tablet-search');
    await close(tester, find.byType(SearchPage));
    await session.tapKey(tester, 'diary-new-entry');
    await session.capture(tester, 'tablet-editor');
    await close(tester, find.byType(AddEditEntryPage));
    await session.tapKey(tester, 'journal-calendar');
    await session.capture(tester, 'tablet-calendar');
    await session.tapKey(tester, 'journal-calendar');
    await DiaryAppHarness.goTo(tester, 1);
    await session.capture(tester, 'tablet-media');
    await DiaryAppHarness.goTo(tester, 2);
    await session.capture(tester, 'tablet-atlas');
    await DiaryAppHarness.goTo(tester, 3);
    await session.capture(tester, 'tablet-coach');
    await session.tapKey(tester, 'coach-program-everyday');
    await session.capture(tester, 'tablet-coach-program');
    // Enrol without letting the debounced config write run for real.
    await tester.tap(find.byKey(const ValueKey('coach-enroll')));
    await tester.pump();
    EasyDebounce.cancel('save-config');
    await tester.pumpAndSettle();
    ScaffoldMessenger.of(tester.element(find.byType(CoachPage)))
        .removeCurrentSnackBar();
    await DiaryAppHarness.goTo(tester, 0);
    await tester.tap(find.byKey(const ValueKey('story-coach')));
    await session.capture(tester, 'tablet-story-coach', settle: false);
    await tester.tapAt(const Offset(900, 400));
    await session.capture(tester, 'tablet-story-prompt', settle: false);
    await tester.tap(find.byKey(const ValueKey('story-close')));
    await tester.pumpAndSettle();

    // Sync against a storage in memory, then pairing another device; the
    // waiting spinner never settles.
    await DiaryAppHarness.setSetting(Settings.deviceName, '我的平板');
    await tester
        .runAsync(() => SyncService.instance.createSpace(MemoryLogin()));
    await tester.runAsync(SyncService.instance.syncNow);
    openPlace(tester.element(find.byType(MobileScaffold)), 'sync');
    await session.capture(tester, 'tablet-sync');
    await tester.tap(find.byKey(const ValueKey('sync-add-device')));
    await session.capture(tester, 'tablet-pairing', settle: false);
    Navigator.of(tester.element(find.byType(PairingDialog))).pop();
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(SyncService.instance.disconnect);

    await DiaryAppHarness.setSetting(Settings.coachProgram, '');
    await session.finish(tester);
  });
}
