// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/export_utils.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:aid_diary/utils/imports/import_json.dart';
import 'package:aid_diary/utils/sync_ids.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_folders_harness.dart';
import '../support/diary_app_harness.dart';
import '../support/sync_device.dart';

void main() {
  DiaryAppHarness().register();
  useTemporaryAppFolders();

  late MemorySyncBackend cloud;
  late Device phone;
  late Device laptop;

  setUp(() async {
    cloud = MemorySyncBackend();
    phone = await Device.create();
    laptop = await Device.create();
  });

  tearDown(() async {
    await phone.db.close();
    await laptop.db.close();
  });

  Future<void> later() => Future.delayed(const Duration(milliseconds: 5));

  Future<List<Map<String, Object?>>> rows(Device device, String table) =>
      device.db.query(table, orderBy: 'id');

  Future<List<String>> ids(Device device, String table) async => [
        for (final row in await device.db
            .query(table, columns: [syncIdColumn], orderBy: syncIdColumn))
          row[syncIdColumn] as String,
      ];

  group('importing on several devices', () {
    Future<void> reloadStores() async {
      await EntryStore.instance.load();
      await EntryImagesProvider.instance.load();
      await TagsProvider.instance.load();
      await LinksProvider.instance.load();
      await WeatherProvider.instance.load();
    }

    /// Runs [action] as the app on [device].
    Future<T> on<T>(Device device, Future<T> Function() action) async {
      final own = AppDatabase.instance.database;
      AppDatabase.instance.database = device.db;
      try {
        await reloadStores();
        return await action();
      } finally {
        AppDatabase.instance.database = own;
        await reloadStores();
      }
    }

    // Both devices keep photos in the app's one image folder here.
    Future<SyncReport> sync(Device device) async => SyncEngine(
            db: device.db,
            backend: cloud,
            photos:
                FileStorePhotos(await ImageStorage.instance.internalStore()),
            limits: testLimits)
        .sync();

    final written = DateTime(2025, 8, 15, 21, 30);
    List<ImportedEntry> exportFile() => [
          ImportedEntry(
              Entry(
                  title: 'Harbor',
                  text: 'Boats at dusk.',
                  timeCreate: written,
                  timeModified: written),
              tags: [(name: 'Travel', value: null)],
              photos: [
                ImportedPhoto(
                    'boat.jpg', () async => Uint8List.fromList([1, 2, 3])),
              ],
              source: const ImportedSource(
                  format: 'one_diary', id: 'n1', hash: 'v1', json: '{}')),
          // A format that names no item; a tag differing only in case.
          ImportedEntry(
              Entry(
                  text: 'A quiet day.',
                  timeCreate: written.add(const Duration(days: 1)),
                  timeModified: written.add(const Duration(days: 1))),
              tags: [(name: 'travel ', value: null)]),
        ];

    Future<void> expectOneCopy(Device device) async {
      final entries = await rows(device, entriesTable);
      expect(entries.map((row) => row[EntryFields.text]),
          unorderedEquals(['Boats at dusk.', 'A quiet day.']));
      expect(
          entries.where((row) => row[EntryFields.deletedAt] != null), isEmpty);
      expect((await rows(device, tagsTable)).map((row) => row[TagFields.name]),
          ['Travel']);
      expect(await rows(device, imagesTable), hasLength(1));
      expect(await rows(device, entryTagsTable), hasLength(2));
    }

    test('one file imported on two devices is one copy once they sync',
        () async {
      await on(phone, () => addImportedEntries(exportFile(), (_) {}));
      await later();
      await on(laptop, () => addImportedEntries(exportFile(), (_) {}));

      // The laptop's newer import goes up first; the phone's own copy loses
      // to it without anything to keep.
      await sync(laptop);
      final report = await sync(phone);
      await sync(laptop);

      expect(report.keptConflicts, 0);
      await expectOneCopy(phone);
      await expectOneCopy(laptop);
      for (final table in [entriesTable, imagesTable, tagsTable]) {
        expect(await ids(phone, table), await ids(laptop, table));
      }
    });

    test('importing what already came from another device adds nothing',
        () async {
      await on(phone, () => addImportedEntries(exportFile(), (_) {}));
      await sync(phone);
      await sync(laptop);

      // The laptop never imported the file: it has no record of its source.
      await on(laptop, () => addImportedEntries(exportFile(), (_) {}));
      await sync(laptop);
      await sync(phone);

      await expectOneCopy(laptop);
      await expectOneCopy(phone);
    });

    test('an entry exported as JSON and imported elsewhere stays one entry',
        () async {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final json = await on(phone, () async {
        await EntryStore.instance.add(Entry(
            text: 'Lighthouse walk.',
            timeCreate: written,
            timeModified: written));
        final syncIds = await EntryDao.syncIds();
        return encodeJsonEntries(EntryStore.instance.entries,
            imagesOf: (_) => [],
            tagsOf: (_) => [],
            weatherOf: (_) => null,
            syncIdOf: (entry) => syncIds[entry.id]);
      });
      await on(
          laptop,
          () => addImportedEntries(
              decodeJsonEntries(utf8.encode(json), l10n), (_) {}));

      await sync(laptop);
      await sync(phone);
      await sync(laptop);

      for (final device in [phone, laptop]) {
        expect(await device.texts(), ['Lighthouse walk.']);
        expect(await device.texts(deleted: true), isEmpty);
      }
    });
  });

  test('a device that leaves its space and joins again keeps one of each',
      () async {
    await phone.write('kept');
    await phone.write('erased while apart');
    await phone.sync(cloud);
    await laptop.sync(cloud);

    // The laptop leaves the space; both go on writing.
    await forgetSpace(laptop.db);
    await phone.write('from the phone meanwhile');
    await laptop.write('from the laptop meanwhile');
    await later();
    await laptop.db.delete(entriesTable,
        where: '${EntryFields.text} = ?', whereArgs: ['erased while apart']);

    // Joining again, twice over, as pairing again would.
    for (var join = 0; join < 2; join++) {
      await forgetSpace(laptop.db);
      await markAllChanged(laptop.db);
      await laptop.sync(cloud);
      await phone.sync(cloud);
    }
    await laptop.sync(cloud);

    const all = [
      'from the laptop meanwhile',
      'from the phone meanwhile',
      'kept'
    ];
    expect(await phone.texts(), all);
    expect(await laptop.texts(), all);
    expect(await phone.texts(deleted: true), isEmpty);
    expect(await laptop.texts(deleted: true), isEmpty);
  });

  test('a sync that fails after keeping a conflict copy keeps it once',
      () async {
    await phone.write('plan');
    await phone.sync(cloud);
    await laptop.sync(cloud);
    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);

    // A pack the laptop cannot write sits beside the phone's edit.
    final broken = SpaceLayout.pack('${SpaceLayout.packPrefix}broken');
    await cloud.write(
        broken,
        Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
          'records': [
            {'kind': 'entry', 'id': 'broken', 'modified': 1, 'data': {}},
          ],
        })))));
    for (var attempt = 0; attempt < 2; attempt++) {
      await expectLater(laptop.sync(cloud), throwsA(anything));
    }
    await cloud.delete(broken);
    await laptop.sync(cloud);

    expect(await laptop.texts(), ['plan from the phone']);
    expect(await laptop.texts(deleted: true), ['plan from the laptop']);
    await phone.sync(cloud);
    expect(await phone.texts(deleted: true), ['plan from the laptop']);
  });

  group('entries imported before version 18', () {
    const source = (format: 'one_diary', id: 'n1', hash: 'v1');
    final shared = importedSourceSyncId(source.format, source.id, source.hash);

    /// An import as it was made before: a random id and its source.
    Future<int> importAsBefore(Device device) async {
      final row = await device.write('Boats at dusk.');
      await device.db.insert('import_sources', {
        'source_format': source.format,
        'source_id': source.id,
        'source_hash': source.hash,
        'entry_id': row,
        'source_json': '{}',
      });
      return row;
    }

    Future<void> upgrade(Device device) async {
      final own = AppDatabase.instance.database;
      await AppDatabase.instance.upgradeSchema(device.db, 17, 18);
      AppDatabase.instance.database = own;
    }

    test('copies made on two devices become one, with what points at them',
        () async {
      final phoneCopy = await importAsBefore(phone);
      await phone.db.insert(passagesTable, {
        PassageFields.entryId: phoneCopy,
        PassageFields.quote: 'Boats',
        PassageFields.timeCreate: '2026-10-24T08:00:00.000',
      });
      final phoneCopyId =
          (await rows(phone, entriesTable)).single[syncIdColumn] as String;
      final reply = await phone.write('A reply.');
      await phone.db.insert(entryRefsTable, {
        EntryRefFields.entryId: reply,
        EntryRefFields.target: phoneCopyId,
        EntryRefFields.quote: 'Boats',
        EntryRefFields.timeCreate: '2026-10-24T08:00:00.000',
      });
      await importAsBefore(laptop);
      await phone.sync(cloud);
      await laptop.sync(cloud);
      await phone.sync(cloud);
      expect(await phone.texts(), hasLength(3), reason: 'the old duplicate');

      await upgrade(phone);
      await later();
      await upgrade(laptop);
      await phone.sync(cloud);
      await laptop.sync(cloud);
      await phone.sync(cloud);

      for (final device in [phone, laptop]) {
        expect(await device.texts(), ['A reply.', 'Boats at dusk.']);
        expect(await device.texts(deleted: true), isEmpty);
        final imported = await device.rowOf('Boats at dusk.');
        expect(
            (await device.db.query(entriesTable,
                    where: 'id = ?', whereArgs: [imported]))
                .single[syncIdColumn],
            shared);
        expect(
            (await rows(device, passagesTable)).single[PassageFields.entryId],
            imported);
        expect(
            (await rows(device, entryRefsTable)).single[EntryRefFields.target],
            shared);
      }
    });

    test(
        'a copy upgraded after the shared one arrived goes to Recently '
        'deleted', () async {
      await importAsBefore(phone);
      await importAsBefore(laptop);
      await upgrade(phone);
      await phone.sync(cloud);
      await laptop.sync(cloud);

      await upgrade(laptop);
      await laptop.sync(cloud);
      await phone.sync(cloud);

      for (final device in [phone, laptop]) {
        expect(await device.texts(), ['Boats at dusk.']);
        expect(await device.texts(deleted: true), ['Boats at dusk.']);
      }
      expect(await laptop.db.query('import_sources'), hasLength(1));
      expect(
          (await laptop.db.rawQuery('SELECT e.$syncIdColumn AS id '
                  'FROM import_sources s JOIN $entriesTable e '
                  'ON e.id = s.entry_id'))
              .single['id'],
          shared);
    });
  });
}
