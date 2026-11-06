// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/app_folders_harness.dart';
import '../support/config_provider_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final folders = useTemporaryAppFolders();
  useTemporaryConfig();
  final diary = AppDatabase.instance;
  final config = ConfigProvider.instance;
  late InMemoryFileStore images;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await AppConfig.load();
  });

  setUp(() async {
    images = InMemoryFileStore();
    ImageStorage.instance.overrideStores(images, InMemoryFileStore());
    expect(await diary.init(forceWithoutSync: true), isTrue);
    await diary.database!.insert(entriesTable, {EntryFields.text: 'Local'});
    await diary.reload();
  });

  tearDown(() async {
    await diary.close();
    ImageStorage.instance.clearStoreOverrides();
  });

  String databaseIn(Directory dir) =>
      p.join(dir.path, AppDatabase.databaseFileName);

  List<String> loadedText() =>
      EntryStore.instance.entries.map((entry) => entry.text).toList();

  Future<Database> externalDiary(
          Directory dir, int version, Future<void> Function(Database) create) =>
      databaseFactory.openDatabase(databaseIn(dir),
          options: OpenDatabaseOptions(
              version: version, onCreate: (db, _) => create(db)));

  test('exports committed WAL rows to a path containing an apostrophe',
      () async {
    final db = diary.database!;
    await db.rawQuery('PRAGMA journal_mode = WAL');
    await db.rawQuery('PRAGMA wal_autocheckpoint = 0');
    await db.insert(entriesTable, {EntryFields.text: 'In WAL'});
    expect(await File('${db.path}-wal').length(), greaterThan(0));

    final output =
        p.join(folders().folder("writer's backups").path, "writer's diary.db");
    expect(await diary.exportSnapshotTo(output), isTrue);
    final copy = await databaseFactory.openDatabase(output,
        options: OpenDatabaseOptions(readOnly: true, singleInstance: false));
    try {
      expect(await copy.query(entriesTable, columns: [EntryFields.text]), [
        {EntryFields.text: 'Local'},
        {EntryFields.text: 'In WAL'},
      ]);
    } finally {
      await copy.close();
    }
  });

  test('a snapshot collision preserves the original bytes', () async {
    final output = p.join(folders().temporary.path, 'existing.db');
    expect(await diary.exportSnapshotTo(output), isTrue);
    final before = await File(output).readAsBytes();
    await diary.database!.insert(entriesTable, {EntryFields.text: 'New'});

    expect(await diary.exportSnapshotTo(output), isFalse);
    expect(await File(output).readAsBytes(), before);
    expect(
        await folders().temporary.list().map((e) => e.path).toList(), [output]);
  });

  test('starting with a newer unsupported external diary keeps the local one',
      () async {
    final external = folders().folder('future');
    final db = await externalDiary(
        external, AppDatabase.currentVersion + 1, diary.createSchema);
    await db.close();
    await File(databaseIn(external))
        .setLastModified(DateTime.now().add(const Duration(hours: 1)));
    await config.set(Settings.externalDbUri, external.path);
    await config.set(Settings.useExternalDb, true);
    await diary.close();

    expect(await diary.init(), isFalse);
    expect(loadedText(), ['Local']);
    expect(config.get(Settings.externalDbUri), external.path);
    expect(config.get(Settings.useExternalDb), isTrue);
  });

  test('an unrelated SQLite file does not change the diary or settings',
      () async {
    final external = folders().folder('unrelated');
    final db = await externalDiary(external, AppDatabase.currentVersion,
        (db) => db.execute('CREATE TABLE unrelated(id INTEGER)'));
    await db.close();
    final original = diary.database;

    final outcome = await diary.useExternalLocation(external.path, (_) {});
    expect(outcome.failed, isTrue);
    expect(outcome.error, isA<FormatException>());
    expect(diary.database, same(original));
    expect(loadedText(), ['Local']);
    expect(config.get(Settings.externalDbUri), '');
    expect(config.get(Settings.useExternalDb), isFalse);
  });

  test('a failed upgrade restores the previous local database and settings',
      () async {
    final previous = folders().folder('previous');
    expect((await diary.useExternalLocation(previous.path, (_) {})).succeeded,
        isTrue);
    final external = folders().folder('broken');
    // It has a diary header, but the version-17 upgrade needs sync tables.
    final db = await externalDiary(
        external, AppDatabase.currentVersion - 1, diary.createVersion10Schema);
    await db.close();
    final localPath = await diary.getInternalPath();
    final original = await File(localPath).readAsBytes();
    final source = await File(databaseIn(external)).readAsBytes();

    final outcome = await diary.useExternalLocation(external.path, (_) {});
    expect(outcome.failed, isTrue);
    expect(outcome.error, isA<DatabaseException>());
    expect(await File(localPath).readAsBytes(), original);
    expect(await File(databaseIn(external)).readAsBytes(), source);
    expect(loadedText(), ['Local']);
    expect(config.get(Settings.externalDbUri), previous.path);
    expect(config.get(Settings.useExternalDb), isTrue);
  });

  test('a failed store reload restores the previous local database', () async {
    final external = folders().folder('bad-row');
    final db = await externalDiary(
        external, AppDatabase.currentVersion, diary.createSchema);
    await db.insert(entriesTable,
        {EntryFields.text: 'Invalid mood', EntryFields.mood: 'bad'});
    await db.close();

    final outcome = await diary.useExternalLocation(external.path, (_) {});
    expect(outcome.failed, isTrue);
    await diary.reload();
    expect(loadedText(), ['Local']);
    expect(config.get(Settings.useExternalDb), isFalse);
    expect(config.get(Settings.externalDbUri), '');
  });

  test('startup validates older rows beyond the first screen', () async {
    final external = folders().folder('bad-older-row');
    final db = await externalDiary(
        external, AppDatabase.currentVersion, diary.createSchema);
    await db.insert(entriesTable, {
      EntryFields.text: 'Invalid mood',
      EntryFields.mood: 'bad',
      EntryFields.timeCreate: '2026-01-01T00:00:00',
    });
    await db.insert(entriesTable, {
      EntryFields.text: 'Healthy first row',
      EntryFields.timeCreate: '2026-01-02T00:00:00',
    });
    await db.close();
    await File(databaseIn(external))
        .setLastModified(DateTime.now().add(const Duration(hours: 1)));
    await config.set(Settings.externalDbUri, external.path);
    await config.set(Settings.useExternalDb, true);
    await diary.close();

    expect(await diary.init(firstScreen: 1), isFalse);
    await EntryStore.instance.complete;
    expect(loadedText(), ['Local']);
  });

  test('a failed settings write rolls back a loaded external diary', () async {
    const attachment = 'retained.jpg';
    final contents = Uint8List.fromList([1, 2, 3]);
    await images.write(attachment, contents);
    final localId = EntryStore.instance.entries.single.id!;
    Future<void> attach(Database db, int id) async {
      await db.insert(imagesTable, {
        EntryImageFields.entryId: id,
        EntryImageFields.imgPath: attachment,
        EntryImageFields.imgRank: 0,
      });
    }

    await attach(diary.database!, localId);
    final external = folders().folder('valid');
    final db = await externalDiary(
        external, AppDatabase.currentVersion, diary.createSchema);
    await db.insert(entriesTable, {EntryFields.text: 'External'});
    final expired = await db.insert(entriesTable, {
      EntryFields.text: 'Expired',
      EntryFields.deletedAt: '2000-01-01T00:00:00',
    });
    await attach(db, expired);
    await db.close();
    await config.flushConfig();
    final configPath = config.configFilePath;
    final oldConfig = await File(configPath).readAsString();
    config.configFilePath = folders().folder('blocked-config-path').path;
    try {
      final outcome = await diary.useExternalLocation(external.path, (_) {});
      expect(outcome.failed, isTrue);
      expect(outcome.error, isA<FileSystemException>());
      expect(loadedText(), ['Local']);
      expect(config.get(Settings.useExternalDb), isFalse);
      expect(config.get(Settings.externalDbUri), '');
      expect(await File(configPath).readAsString(), oldConfig);
      expect(await images.read(attachment), contents);
    } finally {
      config.configFilePath = configPath;
    }
  });

  test('selects a valid external diary including its committed WAL rows',
      () async {
    final external = folders().folder('with-wal');
    final db = await externalDiary(
        external, AppDatabase.currentVersion, diary.createSchema);
    try {
      await db.rawQuery('PRAGMA journal_mode = WAL');
      await db.rawQuery('PRAGMA wal_autocheckpoint = 0');
      await db.insert(entriesTable, {EntryFields.text: 'External WAL'});
      expect(await File('${db.path}-wal').length(), greaterThan(0));

      final outcome = await diary.useExternalLocation(external.path, (_) {});
      expect(outcome.succeeded, isTrue, reason: '${outcome.error}');
      expect(loadedText(), ['External WAL']);
      expect(config.get(Settings.externalDbUri), external.path);
      expect(config.get(Settings.useExternalDb), isTrue);
    } finally {
      await db.close();
    }
  });
}
