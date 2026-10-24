// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';
import 'dart:convert';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/entry_image_dao.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app_folders_harness.dart';
import '../../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  useTemporaryAppFolders();

  test('repeated source skips user edits, separate IDs and revisions survive',
      () async {
    final time = DateTime(2025, 8, 15, 23, 55);
    ImportedEntry row(String id, String hash, String text) =>
        ImportedEntry(Entry(text: text, timeCreate: time, timeModified: time),
            source: ImportedSource(
                format: 'one_diary', id: id, hash: hash, json: '{}'));
    final rows = [row('a', 'v1', 'First'), row('b', 'v1', 'Second')];
    await addImportedEntries(rows, (_) {});
    await EntryStore.instance.load();
    expect(EntryStore.instance.entries, hasLength(2));
    final original =
        EntryStore.instance.entries.firstWhere((e) => e.text == 'First');
    final edit = EntryStore.instance.beginDraft(original);
    await edit
        .save((_) => EntryDraft(entry: original.copy(text: 'User edited')));
    await edit.commit();
    await addImportedEntries(rows, (_) {});
    await EntryStore.instance.load();
    expect(EntryStore.instance.entries.map((e) => e.text),
        unorderedEquals(['User edited', 'Second']));
    await addImportedEntries([row('a', 'v2', 'New source revision')], (_) {});
    await EntryStore.instance.load();
    expect(EntryStore.instance.entries, hasLength(3));
  });

  test('an unreadable source attachment rolls its new entry back', () async {
    final time = DateTime(2025, 6, 1);
    final entry = ImportedEntry(
        Entry(text: 'Incomplete', timeCreate: time, timeModified: time),
        photos: [ImportedPhoto('missing.jpg', () async => null)],
        source: const ImportedSource(
            format: 'one_diary', id: 'failed', hash: 'v1', json: '{}'));
    await expectLater(addImportedEntries([entry], (_) {}), throwsStateError);
    expect(await AppDatabase.instance.database!.query('entries'), isEmpty);
    expect(
        await AppDatabase.instance.database!.query('import_sources'), isEmpty);
  });

  test('GUI registry and CLI add the fixture without exposing hidden text',
      () async {
    final actions = AppActions(devBuild: true);
    final args = {
      'format': 'one_diary',
      'path': File('test/fixtures/one_diary/v3.zip').absolute.path
    };
    await actions.run('data.import', args);
    expect(EntryStore.instance.entries.map((e) => e.text),
        ['# A day\n\nEvening notes.']);
    final db = AppDatabase.instance.database!;
    expect(await db.query('entries'), hasLength(2));
    expect(await db.query('import_sources'), hasLength(2));
    await actions.run('data.import', args);
    expect(await db.query('entries'), hasLength(2));
    expect(await db.query('entry_images'), hasLength(1));
  });

  test('consolidated JSON retains hidden rows, identity and attachment bytes',
      () async {
    final folder = await Directory.systemTemp.createTemp('diary-json-import-');
    final file = File('${folder.path}/consolidated.json');
    addTearDown(() => folder.delete(recursive: true));
    await file.writeAsString(jsonEncode([
      for (final id in ['first', 'second'])
        {
          'text': id,
          'timeCreated': '2025-08-15T23:55:00.000',
          'timeModified': '2025-08-15T23:55:00.000',
          'diaryDate': '2025-08-14',
          'utcOffsetMinutes': -300,
          'isHidden': id == 'second',
          'importSource': {
            'format': 'archive',
            'id': id,
            'hash': 'revision',
            'metadata': {}
          },
          'photos': [
            {
              'name': 'first.jpg',
              'base64': base64Encode([1, 2, 3])
            },
            {
              'name': 'second.jpg',
              'base64': base64Encode([4, 5, 6])
            }
          ],
        }
    ]));
    final actions = AppActions(devBuild: true);
    final args = {'format': 'json', 'path': file.path};
    await actions.run('data.import', args);
    final db = AppDatabase.instance.database!;
    expect(await db.query('entries'), hasLength(2));
    expect(EntryStore.instance.entries.single.text, 'first');
    expect(EntryStore.instance.hiddenEntries.single.day, DateTime(2025, 8, 14));
    expect(await db.query('entry_images'), hasLength(4));
    final photos =
        await EntryImageDao.getForEntry(EntryStore.instance.entries.single.id!);
    expect(
        await ImageStorage.instance.getBytes(photos.first.imgPath), [1, 2, 3]);
    expect(
        await ImageStorage.instance.getBytes(photos.last.imgPath), [4, 5, 6]);
    await actions.run('data.import', args);
    expect(await db.query('entries'), hasLength(2));
    expect(await db.query('entry_images'), hasLength(4));

    await file.writeAsString(jsonEncode([
      {
        'text': 'Incomplete',
        'timeCreated': '2020-01-01T12:00:00',
        'timeModified': '2020-01-01T12:00:00',
        'photos': [
          {'name': 'scan.jpg', 'base64': 'invalid'}
        ]
      }
    ]));
    await expectLater(actions.run('data.import', args), throwsA(anything));
    expect(await db.query('entries'), hasLength(2));
  });

  test('tags an import makes come after the diary\'s own, most used first',
      () async {
    final now = DateTime.now();
    await TagsProvider.instance.add(Tag(
        name: 'Mine',
        tagType: TagType.label,
        timeCreate: now,
        timeModified: now));
    final folder = await Directory.systemTemp.createTemp('diary-tag-order-');
    final file = File('${folder.path}/tags.json');
    addTearDown(() => folder.delete(recursive: true));
    await file.writeAsString(jsonEncode([
      for (final (day, tags) in [
        (1, ['Rare', 'Often']),
        (2, ['Often', 'Mine']),
        (3, ['Often']),
      ])
        {
          'text': 'Day $day',
          'timeCreated': '2026-01-0${day}T12:00:00',
          'timeModified': '2026-01-0${day}T12:00:00',
          'tags': [
            for (final name in tags) {'name': name},
          ],
        },
    ]));
    await AppActions(devBuild: true)
        .run('data.import', {'format': 'json', 'path': file.path});
    expect(TagsProvider.instance.tags.map((tag) => tag.name),
        ['Mine', 'Often', 'Rare']);
  });
}
