import 'dart:convert';
import 'dart:ui' as ui;

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/entry_dao.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/pages/recently_deleted_page.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/entry_share_page.dart';
import 'package:daily_you/pages/journal_page.dart';
import 'package:daily_you/utils/export_utils.dart';
import 'package:daily_you/utils/imports/import_json.dart';
import 'package:daily_you/utils/text_editing.dart';
import 'package:daily_you/widgets/location_dialog.dart';
import 'package:daily_you/widgets/quick_check_in.dart';
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

  test('blocks go on lines of their own', () {
    final controller = TextEditingController(text: 'ab')
      ..selection = const TextSelection.collapsed(offset: 1);
    insertBlock(controller, '---\n', cursorOffset: 4);
    expect(controller.text, 'a\n---\nb');
    expect(controller.selection.baseOffset, 6);

    final empty = TextEditingController();
    insertBlock(empty, '- [ ] ', cursorOffset: 6);
    expect(empty.text, '- [ ] ');
  });

  test('recent places are named, newest first and listed once', () {
    final places = recentPlaces([
      _entry('', DateTime(2026, 10, 3),
          location: const EntryLocation(name: '公园', latitude: 1, longitude: 2)),
      _entry('', DateTime(2026, 10, 2),
          location: const EntryLocation(latitude: 5, longitude: 6)),
      _entry('', DateTime(2026, 10, 1),
          location: const EntryLocation(name: '公园')),
      _entry('', DateTime(2026, 9, 1),
          location: const EntryLocation(name: '学校')),
    ], 5);
    expect(places.map((p) => p.name), ['公园', '学校']);
    expect(places.first.latitude, 1);
  });

  test('the JSON export reads back with place, weather and activity', () {
    final entry = Entry(
        text: '# 雨天\n散步',
        mood: 1,
        timeCreate: DateTime(2026, 10, 18, 9),
        timeModified: DateTime(2026, 10, 18, 10),
        location:
            const EntryLocation(name: '外滩', latitude: 31.2, longitude: 121.5),
        weather: const EntryWeather(code: 61, temperature: 14.5),
        activity: EntryActivity.walking);
    final json = encodeJsonEntries([entry],
        imagesOf: (_) => [
              EntryImage(
                  entryId: 1,
                  imgPath: 'a.jpg',
                  imgRank: 0,
                  timeCreate: DateTime(2026, 10, 18))
            ],
        tagsOf: (_) => [(name: '精力', value: '7')]);
    expect((jsonDecode(json) as List).single['tags'], [
      {'name': '精力', 'value': '7'}
    ]);
    final back = decodeJsonEntries(utf8.encode(json)).single;
    expect(back.entry.text, entry.text);
    expect(back.entry.mood, 1);
    expect(back.entry.timeModified, entry.timeModified);
    expect(back.entry.location, entry.location);
    expect(back.entry.weather, entry.weather);
    expect(back.entry.activity, EntryActivity.walking);
    expect(back.images.single.imgPath, 'a.jpg');
  });

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

  testWidgets('a quick check-in saves mood, activity and note', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    showQuickCheckIn(tester.element(find.byType(SizedBox).first));
    await tester.pumpAndSettle();
    final save = find.byKey(const ValueKey('check-in-save'));
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    await tester.tap(find.byKey(const ValueKey('check-in-mood-1')));
    await tester.tap(find.byKey(const ValueKey('check-in-activity-running')));
    await tester.enterText(
        find.byKey(const ValueKey('check-in-note')), '跑了五公里');
    await tester.pump();
    await tester.tap(save);
    await DiaryAppHarness.pumpUntil(
        tester, () => EntryStore.instance.entries.isNotEmpty);
    final entry = EntryStore.instance.entries.single;
    expect(entry.mood, 1);
    expect(entry.activity, EntryActivity.running);
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
