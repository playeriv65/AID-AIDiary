// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/export_utils.dart';
import 'package:aid_diary/utils/formats/archive_export.dart';
import 'package:aid_diary/utils/formats/journey_format.dart';
import 'package:aid_diary/utils/formats/day_one_format.dart';
import 'package:aid_diary/utils/imports/import_json.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late InMemoryFileStore noteStore;
  late InMemoryFileStore imageStore;
  late MarkdownExportWriter writer;

  setUpAll(() => initializeDateFormatting('en'));

  setUp(() {
    noteStore = InMemoryFileStore();
    imageStore = InMemoryFileStore();
    writer = MarkdownExportWriter(
        noteStore: noteStore, imageStore: imageStore, locale: 'en');
  });

  Entry entryOn(DateTime timeCreate, {String text = ''}) =>
      Entry(text: text, timeCreate: timeCreate, timeModified: timeCreate);

  Future<String> noteNamed(String name) async =>
      utf8.decode((await noteStore.read(name))!);

  Future<void> write(Entry entry,
          [List<(EntryImage, Uint8List)> images = const []]) =>
      writer.write(ExportedEntry(entry, images: images));

  test('names a note after the day it was written', () async {
    await write(entryOn(DateTime(2026, 3, 4), text: 'a good day'));

    expect(await noteStore.list(), equals(['log_2026-03-04.md']));
    expect(await noteNamed('log_2026-03-04.md'),
        equals('Wed, Mar 4, 2026\na good day\n'));
  });

  test('numbers later notes that share a day', () async {
    await write(entryOn(DateTime(2026, 3, 4, 8)));
    await write(entryOn(DateTime(2026, 3, 4, 20)));
    await write(entryOn(DateTime(2026, 3, 5)));

    expect(
        await noteStore.list(),
        unorderedEquals(
            ['log_2026-03-04.md', 'log_2026-03-04_2.md', 'log_2026-03-05.md']));
  });

  test('writes images beside the note and links them by rank', () async {
    final timeCreate = DateTime(2026, 3, 4);
    await write(entryOn(timeCreate, text: 'body'), [
      (
        EntryImage(
            entryId: 1,
            imgPath: 'aid_diary_a.png',
            imgRank: 1,
            timeCreate: timeCreate),
        Uint8List.fromList([1, 2])
      ),
      (
        EntryImage(
            entryId: 1,
            imgPath: 'aid_diary_b.jpg',
            imgRank: 0,
            timeCreate: timeCreate),
        Uint8List.fromList([3, 4])
      ),
    ]);

    expect(await imageStore.list(),
        equals(['image_2026-03-04_1.png', 'image_2026-03-04_0.jpg']));
    expect(await imageStore.read('image_2026-03-04_1.png'),
        equals(Uint8List.fromList([1, 2])));
    expect(
        await noteNamed('log_2026-03-04.md'),
        startsWith('![](Images/image_2026-03-04_1.png)\n'
            '![](Images/image_2026-03-04_0.jpg)\n'));
  });

  test('carries the note suffix into its image names', () async {
    final timeCreate = DateTime(2026, 3, 4);
    final image = EntryImage(
        entryId: 1,
        imgPath: 'aid_diary_a.png',
        imgRank: 0,
        timeCreate: timeCreate);
    final bytes = Uint8List.fromList([1]);

    await write(entryOn(timeCreate), [(image, bytes)]);
    await write(entryOn(timeCreate), [(image, bytes)]);

    expect(await imageStore.list(),
        equals(['image_2026-03-04_0.png', 'image_2026-03-04_2_0.png']));
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
        activity: EntryActivity.walking,
        openAt: DateTime(2020, 1, 1));
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
    expect(back.entry.openAt, DateTime(2020, 1, 1));
    expect(back.images.single.imgPath, 'a.jpg');
    expect(back.tags, [(name: '精力', value: '7')]);
  });

  test(
      'JSON exchange includes open entries without reading sealed content or attachment metadata',
      () {
    final open = entryOn(DateTime(2026, 1, 1), text: 'Open');
    final sealed = open.copy(text: 'Private', openAt: DateTime(2099));
    final json = encodeJsonEntries([sealed, open], imagesOf: (entry) {
      expect(entry, same(open));
      return [];
    }, tagsOf: (entry) {
      expect(entry, same(open));
      return [];
    });
    expect((jsonDecode(json) as List).single['text'], 'Open');
    expect(json, isNot(contains('Private')));
  });

  test('archive writers exclude sealed text and attachment bytes', () async {
    final time = DateTime(2026, 1, 1);
    final sealed = entryOn(time, text: 'Private').copy(openAt: DateTime(2099));
    final exported = ExportedEntry(sealed, images: [
      (
        EntryImage(
            entryId: 1, imgPath: 'private.jpg', imgRank: 0, timeCreate: time),
        Uint8List.fromList([1, 2, 3])
      ),
    ]);
    final journey = JourneyExportWriter(noteStore);
    final dayOne =
        DayOneExportWriter(journalStore: noteStore, photoStore: imageStore);
    await writer.write(exported);
    await journey.write(exported);
    await dayOne.write(exported);
    expect(await noteStore.list(), isEmpty);
    expect(await imageStore.list(), isEmpty);
  });
}
