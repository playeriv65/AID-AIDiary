// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/formats/archive_export.dart';
import 'package:aid_diary/utils/formats/journey_format.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'archive_files.dart';

const double unset = 1.7976931348623157e308;

void main() {
  ImportedPhoto? noPhoto(String name) => null;

  group('decodeJourneyEntry', () {
    test('reads a schema 1 entry with HTML text', () {
      final created = DateTime(2025, 6, 7, 8, 9);
      final decoded = decodeJourneyEntry({
        'id': '1-a',
        'type': 'html',
        'text': '<p dir="auto">Day <b>one</b></p><p dir="auto">rain</p>',
        'date_journal': created.millisecondsSinceEpoch,
        'date_modified': created.millisecondsSinceEpoch + 60000,
        'lat': 31.2,
        'lon': 121.5,
        'address': 'Bund',
        'weather': {'id': 500, 'degree_c': 14.0, 'icon': '10d'},
        'tags': ['walk', 'city'],
        'favourite': true,
        'photos': ['1-a-0.jpg'],
      }, (name) => ImportedPhoto(name, () async => Uint8List(1)))!;

      expect(decoded.entry.text, 'Day **one**\n\nrain');
      expect(decoded.entry.timeCreate, created);
      expect(
          decoded.entry.timeModified, created.add(const Duration(minutes: 1)));
      expect(decoded.entry.location,
          const EntryLocation(latitude: 31.2, longitude: 121.5, name: 'Bund'));
      expect(decoded.entry.weather,
          const EntryWeather(code: 61, temperature: 14.0));
      expect(decoded.tags.map((tag) => tag.name), ['walk', 'city']);
      expect(decoded.favorite, isTrue);
      expect(decoded.photos.single.name, '1-a-0.jpg');
    });

    test('treats Journey\'s unset markers as missing', () {
      final decoded = decodeJourneyEntry({
        'text': 'plain',
        'type': '',
        'date_journal': 1000,
        'lat': unset,
        'lon': unset,
        'address': '',
        'weather': {'id': -1, 'degree_c': unset},
      }, noPhoto)!;

      expect(decoded.entry.text, 'plain');
      expect(decoded.entry.location, isNull);
      expect(decoded.entry.weather, isNull);
      expect(decoded.entry.timeModified, decoded.entry.timeCreate);
    });

    test('reads a schema 2 entry', () {
      final decoded = decodeJourneyEntry({
        'schemaVersion': 2,
        'type': 'markdown',
        'text': '# Title',
        'dateOfJournal': '2025-06-07T13:09:00Z',
        'updatedAt': '2025-06-07T14:00:00Z',
        'location': {'lat': 1.5, 'lng': 2.5},
        'weather': {'id': 800, 'degreeC': 25.0},
        'activity': 3,
      }, noPhoto)!;

      expect(decoded.entry.text, '# Title');
      expect(
          decoded.entry.timeCreate, DateTime.utc(2025, 6, 7, 13, 9).toLocal());
      expect(decoded.entry.location,
          const EntryLocation(latitude: 1.5, longitude: 2.5));
      expect(decoded.entry.weather,
          const EntryWeather(code: 0, temperature: 25.0));
      expect(decoded.entry.activity, EntryActivity.walking);
    });

    test('skips an entry without a date', () {
      expect(decodeJourneyEntry({'text': 'x', 'date_journal': 0}, noPhoto),
          isNull);
    });
  });

  test('decodes a backup with photos beside nested entry files', () async {
    final archive = MemoryArchive({
      'backup/a.json': MemoryArchive.json({
        'text': 'a',
        'date_journal': 2000,
        'photos': ['a-0.png', 'missing.jpg'],
      }),
      'backup/a-0.png': Uint8List.fromList([7]),
      'backup/notes.json': MemoryArchive.json({'text': 'no date'}),
    });

    final entries = await decodeJourneyArchive(archive);

    expect(entries.map((e) => e.entry.text), ['a']);
    final photo = entries.single.photos.single;
    expect(photo.name, 'a-0.png');
    expect(await photo.read(), [7]);
  });

  test('an export reads back through the importer', () async {
    final store = InMemoryFileStore();
    final writer = JourneyExportWriter(store);
    final created = DateTime(2026, 10, 18, 21, 30);
    final entry = Entry(
        id: 42,
        text: '# 雨天\n\n散步 *慢慢*',
        timeCreate: created,
        timeModified: created.add(const Duration(hours: 1)),
        location:
            const EntryLocation(name: '外滩', latitude: 31.2, longitude: 121.5),
        weather: const EntryWeather(code: 61, temperature: 14.5));
    await writer.write(ExportedEntry(entry,
        tags: [(name: 'walk', value: null)],
        favorite: true,
        images: [
          (
            EntryImage(
                entryId: 42, imgPath: 'x.png', imgRank: 0, timeCreate: created),
            Uint8List.fromList([1, 2, 3])
          )
        ]));
    await writer.close();

    final back =
        (await decodeJourneyArchive(await MemoryArchive.of({'': store})))
            .single;
    expect(back.entry.text, entry.text);
    expect(back.entry.timeCreate, created);
    expect(back.entry.timeModified, entry.timeModified);
    expect(back.entry.location, entry.location);
    expect(back.entry.weather, entry.weather);
    expect(back.tags.map((tag) => tag.name), ['walk']);
    expect(back.favorite, isTrue);
    expect(back.photos.single.name, endsWith('.png'));
    expect(await back.photos.single.read(), [1, 2, 3]);
  });
}
