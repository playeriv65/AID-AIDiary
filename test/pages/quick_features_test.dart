import 'dart:convert';
import 'dart:ui' as ui;

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/entry_share_page.dart';
import 'package:daily_you/pages/journal_page.dart';
import 'package:daily_you/utils/export_utils.dart';
import 'package:daily_you/utils/imports/import_json.dart';
import 'package:daily_you/utils/text_editing.dart';
import 'package:daily_you/widgets/location_dialog.dart';
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
