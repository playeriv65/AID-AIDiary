@Tags(['widget'])
library;

import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/pages/journal_page.dart';
import 'package:daily_you/pages/search_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('a sealed capsule hides its content until opened early',
      (tester) async {
    final entry = await DiaryAppHarness.addEntry(
        tester, '给一年后的自己', DateTime(2026, 10, 1));
    final store = EntryStore.instance;
    await tester.runAsync(() =>
        store.setOpenAt(entry, DateTime.now().add(const Duration(days: 365))));
    DiaryAppHarness.size(tester, const Size(390, 844));

    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    expect(find.textContaining('给一年后的自己'), findsNothing);
    expect(find.byIcon(Icons.lock_clock_rounded), findsOneWidget);

    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.enterText(find.byKey(const ValueKey('search-field')), '一年');
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('journal-entry-${entry.id}')), findsNothing);

    await tester.pumpWidget(harness.app(EntryViewPage(entryId: entry.id!)));
    await tester.pumpAndSettle();
    expect(find.text('时间胶囊'), findsOneWidget);
    expect(find.textContaining('给一年后的自己'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('capsule-open-early')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('capsule-open-confirm')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.textContaining('给一年后的自己').evaluate().isNotEmpty);
    expect(store.entries.single.openAt, isNull);
  });

  testWidgets('a capsule that just opened gets a story card', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '去年写的', DateTime(2025, 10, 1));
    await tester.runAsync(() => EntryStore.instance
        .setOpenAt(entry, DateTime.now().subtract(const Duration(days: 1))));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('story-capsule-${entry.id}')), findsOneWidget);
    expect(find.text('时间胶囊已开启'), findsOneWidget);
  });
}
