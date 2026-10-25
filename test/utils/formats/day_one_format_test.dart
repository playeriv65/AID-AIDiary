// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/formats/archive_export.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/formats/day_one_format.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'archive_files.dart';

void main() {
  final zh = lookupAppLocalizations(const Locale('zh'));
  test('decodes an entry with photos, escapes and context', () async {
    final archive = MemoryArchive({
      'Journal.json': MemoryArchive.json({
        'metadata': {'version': '1.0'},
        'entries': [
          {
            'uuid': 'A',
            'creationDate': '2024-03-04T05:06:07Z',
            'modifiedDate': '2024-03-04T06:00:00Z',
            'starred': true,
            'tags': ['trip'],
            'text': '![](dayone-moment://P2)\n![](dayone-moment://P1)\n'
                'Arrived\\. Ate 2\\-3 dumplings\\!',
            'location': {
              'latitude': 48.85,
              'longitude': 2.35,
              'placeName': 'Paris'
            },
            'weather': {'weatherCode': 'rain-night', 'temperatureCelsius': 9},
            'userActivity': {'activityName': 'biking'},
            'photos': [
              {
                'identifier': 'P2',
                'md5': 'bbb',
                'type': 'png',
                'orderInEntry': 1
              },
              {
                'identifier': 'P1',
                'md5': 'aaa',
                'type': 'jpeg',
                'orderInEntry': 0
              },
            ],
          },
          {'uuid': 'B', 'text': 'no date'},
        ],
      }),
      'photos/aaa.jpeg': Uint8List.fromList([1]),
      'photos/bbb.png': Uint8List.fromList([2]),
    });

    final entries = await decodeDayOneArchive(archive, zh);

    final entry = entries.single;
    expect(entry.entry.text, 'Arrived. Ate 2-3 dumplings!');
    expect(entry.entry.timeCreate, DateTime.utc(2024, 3, 4, 5, 6, 7).toLocal());
    expect(entry.entry.timeModified, DateTime.utc(2024, 3, 4, 6).toLocal());
    expect(entry.entry.location,
        const EntryLocation(latitude: 48.85, longitude: 2.35, name: 'Paris'));
    expect(entry.weather, const EntryWeather(code: 63, temperature: 9));
    expect(entry.favorite, isTrue);
    // The activity comes in as a tag.
    expect(entry.tags.map((tag) => tag.name), ['trip', '骑行']);
    expect(entry.photos.map((photo) => photo.name), ['aaa.jpeg', 'bbb.png']);
    expect(await entry.photos.last.read(), [2]);
  });

  test('an export reads back through the importer', () async {
    final journal = InMemoryFileStore();
    final photos = InMemoryFileStore();
    final writer =
        DayOneExportWriter(journalStore: journal, photoStore: photos);
    final created = DateTime(2026, 10, 18, 9, 15, 30);
    final entry = Entry(
        id: 7,
        title: '周末',
        text: '去了公园。',
        timeCreate: created,
        timeModified: created.add(const Duration(minutes: 5)),
        location: const EntryLocation(latitude: 31.2, longitude: 121.5));
    const weather = EntryWeather(code: 0, temperature: 21.0);
    final image = EntryImage(
        entryId: 7,
        imgPath: 'aid_diary_x.jpg',
        imgRank: 0,
        timeCreate: created);
    await writer.write(ExportedEntry(entry,
        tags: [(name: 'park', value: null)],
        favorite: true,
        images: [
          (image, Uint8List.fromList([9, 8]))
        ],
        weather: weather));
    await writer.close();

    final written =
        jsonDecode(utf8.decode((await journal.read('Journal.json'))!));
    expect(written['entries'].single['photos'].single['type'], 'jpeg');

    final back = (await decodeDayOneArchive(
            await MemoryArchive.of({'': journal, dayOnePhotoFolder: photos}),
            zh))
        .single;
    // Day One keeps a title as the heading of the text.
    expect(back.entry.text, '# 周末\n去了公园。');
    final titled = titledByHeading(back.entry);
    expect((titled.title, titled.text), ('周末', '去了公园。'));
    expect(back.entry.timeCreate, created);
    expect(back.entry.timeModified, entry.timeModified);
    expect(back.entry.location, entry.location);
    expect(back.weather, weather);
    expect(back.tags.map((tag) => tag.name), ['park']);
    expect(back.favorite, isTrue);
    expect(await back.photos.single.read(), [9, 8]);
  });
}
