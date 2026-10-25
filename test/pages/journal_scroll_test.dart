@Tags(['integration'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/widgets/journal_entry_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  for (final (size, platform) in [
    (const Size(390, 844), TargetPlatform.android),
    (const Size(1000, 800), TargetPlatform.android),
    (const Size(1280, 800), TargetPlatform.windows),
  ]) {
    testWidgets(
        'search stays visible and usable while scrolling $size $platform',
        (tester) async {
      final now = DateTime.now();
      EntryStore.instance.entries = [
        for (var i = 0; i < 60; i++)
          Entry(
              id: i + 1,
              text: 'Entry $i',
              timeCreate: now.subtract(Duration(days: i)),
              timeModified: now),
      ];
      DiaryAppHarness.size(tester, size);
      await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage()),
          themeData: ThemeData(platform: platform)));
      await tester.pumpAndSettle();
      final search = find.byKey(const ValueKey('journal-search'));
      final before = tester.getRect(search);
      await tester.drag(find.byKey(const PageStorageKey('journal-list')),
          const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(tester.getRect(search), before);
      expect(search.hitTestable(), findsOneWidget);
      final position = tester
          .state<ScrollableState>(find
              .descendant(
                  of: find.byKey(const PageStorageKey('journal-list')),
                  matching: find.byType(Scrollable))
              .first)
          .position;
      position.jumpTo(2000);
      await tester.pumpAndSettle();
      // Just below the search card, centred over the entries.
      final shortcut =
          tester.getRect(find.byKey(const ValueKey('journal-scroll-to-top')));
      expect(shortcut.top, greaterThanOrEqualTo(before.bottom));
      expect(shortcut.top - before.bottom, lessThan(24));
      final list =
          tester.getRect(find.byKey(const PageStorageKey('journal-list')));
      expect(shortcut.center.dx, moreOrLessEquals(list.center.dx, epsilon: 1));
      await tester.tap(find.byKey(const ValueKey('journal-scroll-to-top')));
      // It glides up rather than jumping there.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(position.pixels, inExclusiveRange(0, 2000));
      await tester.pumpAndSettle();
      expect(position.pixels, 0);
      expect(find.byKey(const ValueKey('journal-scroll-to-top')), findsNothing);
      await tester.tap(search);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('search-field')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  for (final scale in [1.0, 2.0, 3.0]) {
    testWidgets('desktop preview slots fit text at scale $scale',
        (tester) async {
      final now = DateTime.now();
      EntryStore.instance.entries = [
        Entry(
            id: 1,
            text:
                '# 标题 Title عنوان\n日记内容 with emoji 🙂 and multiple lines. ' * 8,
            timeCreate: now,
            timeModified: now,
            mood: 2),
        Entry(id: 2, text: 'Short', timeCreate: now, timeModified: now),
        Entry(
            id: 3,
            text: 'Sealed',
            timeCreate: now,
            timeModified: now,
            openAt: now.add(const Duration(days: 3))),
      ];
      DiaryAppHarness.size(tester, const Size(1280, 800));
      await tester.pumpWidget(harness.app(
          Builder(
              builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: const Scaffold(body: JournalPage()))),
          themeData: ThemeData(platform: TargetPlatform.windows)));
      await tester.pumpAndSettle();
      await tester.drag(find.byKey(const PageStorageKey('journal-list')),
          const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('desktop far jumps build visible rows rather than traversed days',
      (tester) async {
    final now = DateTime.now();
    EntryStore.instance.entries = [
      for (var i = 0; i < 4000; i++)
        Entry(
            id: i + 1,
            text: 'Entry $i',
            timeCreate: now.subtract(Duration(days: i)),
            timeModified: now),
    ];
    DiaryAppHarness.size(tester, const Size(1280, 800));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage()),
        themeData: ThemeData(platform: TargetPlatform.windows)));
    await tester.pumpAndSettle();
    final list = find
        .descendant(
            of: find.byKey(const PageStorageKey('journal-list')),
            matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(list).position;
    var rows = 0;
    final previous = debugOnRebuildDirtyWidget;
    debugOnRebuildDirtyWidget = (element, builtOnce) {
      previous?.call(element, builtOnce);
      if (element.widget is JournalEntryRow) rows++;
    };
    addTearDown(() => debugOnRebuildDirtyWidget = previous);
    expect(position.maxScrollExtent, greaterThan(10000));
    position.jumpTo(position.maxScrollExtent * .9);
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(10000));
    expect(rows, greaterThan(0));
    expect(rows, lessThan(100),
        reason: 'A scrollbar jump must not build the skipped diary.');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
