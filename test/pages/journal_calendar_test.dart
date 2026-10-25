// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/widgets/entry_card.dart';
import 'package:aid_diary/widgets/top_search_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  for (final platform in [TargetPlatform.android, TargetPlatform.windows]) {
    testWidgets('$platform: the calendar unfolds in place and turns to a day',
        (tester) async {
      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day, 9);
      EntryStore.instance.entries = [
        for (var i = 0; i < 60; i++)
          Entry(
              id: i + 1,
              text: 'Entry $i',
              timeCreate: start.subtract(Duration(days: i)),
              timeModified: start),
      ];
      DiaryAppHarness.size(tester, const Size(390, 844));
      await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage()),
          themeData: ThemeData(platform: platform)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('journal-calendar')));
      await tester.pumpAndSettle();
      // The same page: the list is still there beneath the calendar.
      expect(
          find.byKey(const ValueKey('journal-calendar-panel')), findsOneWidget);
      expect(find.byKey(const PageStorageKey('journal-list')), findsOneWidget);

      final day = DateTime(today.year, today.month, today.day)
          .subtract(const Duration(days: 20));
      final cell = find
          .byKey(ValueKey('calendar-day-${day.year}-${day.month}-${day.day}'));
      await tester.scrollUntilVisible(cell, -100,
          scrollable: find
              .descendant(
                  of: find.byKey(const ValueKey('journal-calendar-panel')),
                  matching: find.byType(Scrollable))
              .first);
      await tester.tap(cell);
      await tester.pumpAndSettle();

      expect(
          find.byKey(const ValueKey('journal-calendar-panel')), findsNothing);
      // That day's group starts just below the search card.
      final group = tester.getRect(find.byWidgetPredicate(
          (widget) => widget is EntryDayGroup && widget.day == day));
      expect(
          group.top, moreOrLessEquals(PinnedSearchHeader.extent, epsilon: 1));
      expect(find.byKey(const ValueKey('journal-entry-21')).hitTestable(),
          findsOneWidget);
    });
  }
}
