@Tags(['widget'])
library;

import 'dart:ui' as ui;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/pages/recently_deleted_page.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/entry_share_page.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:aid_diary/widgets/quick_check_in.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

Entry _entry(String text, DateTime created,
        {DateTime? modified, EntryLocation? location}) =>
    Entry(
        text: text,
        timeCreate: created,
        timeModified: modified ?? created,
        location: location);

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('the journal can sort by last update', (tester) async {
    await tester.runAsync(() async {
      // Written on the 1st, edited last.
      await EntryStore.instance.add(_entry('旧的', DateTime(2026, 10, 1, 9),
          modified: DateTime(2026, 10, 9)));
      await EntryStore.instance.add(_entry('新的', DateTime(2026, 10, 5, 9)));
    });
    await DiaryAppHarness.setSetting(Settings.journalSort, 'updated');
    DiaryAppHarness.size(tester, const Size(390, 1200));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('旧的')).dy,
        lessThan(tester.getTopLeft(find.text('新的')).dy));
  });

  testWidgets('deleting moves an entry to Recently deleted', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '要删的', DateTime(2026, 10, 1));
    final store = EntryStore.instance;
    await tester.runAsync(() => store.delete(entry));
    expect(store.entries, isEmpty);
    var deleted = (await tester.runAsync(store.deleted))!;
    expect(deleted.single.entry.text, '要删的');

    await tester.runAsync(() => store.restore(deleted.single.entry));
    expect(store.entries.single.id, entry.id);
    expect(await tester.runAsync(store.deleted), isEmpty);

    await tester.runAsync(() async {
      await store.delete(entry);
      await store.erase(entry);
    });
    deleted = (await tester.runAsync(store.deleted))!;
    expect(deleted, isEmpty);
    expect(store.entries, isEmpty);
  });

  testWidgets('old deletions are erased when entries load', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '很久以前删的', DateTime(2026, 9, 1));
    final store = EntryStore.instance;
    await tester.runAsync(() async {
      await EntryDao.setDeleted(
          entry.id!, DateTime.now().subtract(const Duration(days: 31)));
      await store.load();
    });
    expect(await tester.runAsync(store.deleted), isEmpty);
  });

  testWidgets('Recently deleted restores an entry', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '找回来', DateTime(2026, 10, 2));
    await tester.runAsync(() => EntryStore.instance.delete(entry));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.pumpWidget(harness.app(const RecentlyDeletedPage())),
        () => find.text('找回来').evaluate().isNotEmpty);
    expect(find.text('还剩 30 天'), findsOneWidget);
    await tester.tap(find.text('找回来'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('deleted-restore')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.text('没有最近删除的日记').evaluate().isNotEmpty);
    expect(EntryStore.instance.entries.single.text, '找回来');
    expect(find.text('没有最近删除的日记'), findsOneWidget);
  });

  testWidgets('a quick check-in saves mood and note', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    showQuickCheckIn(tester.element(find.byType(SizedBox).first));
    await tester.pumpAndSettle();
    final save = find.byKey(const ValueKey('check-in-save'));
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    await tester.tap(find.byKey(const ValueKey('check-in-mood-1')));
    await tester.enterText(
        find.byKey(const ValueKey('check-in-note')), '跑了五公里');
    await tester.pump();
    await tester.tap(save);
    await DiaryAppHarness.pumpUntil(
        tester, () => EntryStore.instance.entries.isNotEmpty);
    final entry = EntryStore.instance.entries.single;
    expect(entry.mood, 1);
    expect(entry.text, '跑了五公里');
  });

  testWidgets('an entry renders to a share picture', (tester) async {
    final entry = Entry(
        text: '## 今天\n去了公园',
        mood: 2,
        timeCreate: DateTime(2026, 10, 18, 9),
        timeModified: DateTime(2026, 10, 18, 9),
        location: const EntryLocation(name: '公园'));
    DiaryAppHarness.size(tester, const Size(430, 900));
    await tester.pumpWidget(
        harness.app(EntrySharePage(entry: entry, images: const [])));
    await tester.pumpAndSettle();
    expect(find.byType(EntryShareCard), findsOneWidget);
    expect(find.text('公园'), findsOneWidget);
    final boundary = tester.renderObject<RenderRepaintBoundary>(find
        .ancestor(
            of: find.byType(EntryShareCard),
            matching: find.byType(RepaintBoundary))
        .first);
    final size = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return (image.width, data!.lengthInBytes);
    });
    expect(size!.$1, 760);
    expect(size.$2, greaterThan(1000));
  });
}
