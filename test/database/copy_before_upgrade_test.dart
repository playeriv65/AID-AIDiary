// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:crypto/crypto.dart';
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
  const legacyVersion = 16;
  const note = 'The original diary';
  const photoName = 'original.jpg';
  final photo = [1, 2, 3, 4];

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await AppConfig.load();
  });
  tearDown(diary.close);

  String path() => p.join(folders().support.path, AppDatabase.databaseFileName);
  Directory backupFolder() => Directory(
      p.join(folders().support.path, AppDatabase.beforeUpgradeFolder));

  List<File> copies() {
    final kept = backupFolder();
    return kept.existsSync() ? kept.listSync().whereType<File>().toList() : [];
  }

  Future<Database> openAt(String path, {bool readOnly = false}) =>
      databaseFactory.openDatabase(path,
          options:
              OpenDatabaseOptions(readOnly: readOnly, singleInstance: false));

  Future<Database> legacyDiary() async {
    final db = await openAt(path());
    await db.rawQuery('PRAGMA journal_mode = WAL');
    await db.rawQuery('PRAGMA wal_autocheckpoint = 0');
    await diary.createVersion10Schema(db);
    await diary.upgradeSchema(db, 10, legacyVersion);
    await db.setVersion(legacyVersion);
    final entryId = await db.insert(entriesTable, {
      EntryFields.text: note,
      EntryFields.timeCreate: '2026-02-01T08:00:00.000',
      EntryFields.timeModified: '2026-02-01T08:00:00.000',
      EntryFields.diaryDate: '2026-02-01',
    });
    await db.insert(imagesTable, {
      EntryImageFields.entryId: entryId,
      EntryImageFields.imgPath: photoName,
      EntryImageFields.imgRank: 0,
    });
    diary.database = null;
    return db;
  }

  Future<List<Map<String, Object?>>> notes(Database db) =>
      db.query(entriesTable, columns: [EntryFields.text]);

  test('upgrades a WAL diary and restores its pre-upgrade snapshot', () async {
    final writer = await legacyDiary();
    addTearDown(writer.close);
    final before = await writer.query(entriesTable);
    final imageRows = await writer.query(imagesTable);
    final photoFile = File(
        p.join(await ImageStorage.instance.getInternalFolder(), photoName));
    await photoFile.writeAsBytes(photo);

    final header =
        await File(path()).openRead(60, 64).expand((b) => b).toList();
    expect(ByteData.sublistView(Uint8List.fromList(header)).getUint32(0), 0);
    expect(await writer.getVersion(), legacyVersion);
    expect(await File('${path()}-wal').length(), greaterThan(0));

    expect(await diary.init(forceWithoutSync: true), isTrue);
    expect(await diary.database!.getVersion(), AppDatabase.currentVersion);
    expect(await notes(diary.database!), [
      {EntryFields.text: note},
    ]);
    final hash = sha256.convert(photo);
    expect(sha256.convert(await photoFile.readAsBytes()), hash);

    final snapshot = copies().single;
    expect(p.basename(snapshot.path), startsWith('v$legacyVersion-'));
    final restoreFolder = folders().folder('restored');
    final restoredFile = await snapshot
        .copy(p.join(restoreFolder.path, AppDatabase.databaseFileName));
    final restored = await openAt(restoredFile.path, readOnly: true);
    try {
      expect(await restored.getVersion(), legacyVersion);
      expect(await restored.query(entriesTable), before);
      expect(await restored.query(imagesTable), imageRows);
      final reference = imageRows.single[EntryImageFields.imgPath] as String;
      final restoredImages =
          await Directory(p.join(restoreFolder.path, 'Images')).create();
      final restoredPhoto =
          await photoFile.copy(p.join(restoredImages.path, reference));
      expect(sha256.convert(await restoredPhoto.readAsBytes()), hash);
    } finally {
      await restored.close();
    }
  });

  test('snapshot excludes concurrent uncommitted writes', () async {
    final writer = await legacyDiary();
    addTearDown(writer.close);
    final source = await openAt(path(), readOnly: true);
    addTearDown(source.close);
    final changed = Completer<void>();
    final finish = Completer<void>();
    final writing = writer.transaction((transaction) async {
      await transaction.update(entriesTable, {EntryFields.text: 'Uncommitted'});
      changed.complete();
      await finish.future;
    });
    try {
      await Future.any([changed.future, writing]);
      await AppDatabase.copyBeforeUpgrade(source);
      final restored = await openAt(copies().single.path, readOnly: true);
      try {
        expect(await notes(restored), [
          {EntryFields.text: note},
        ]);
      } finally {
        await restored.close();
      }
    } finally {
      finish.complete();
      await writing;
    }
    expect(await notes(writer), [
      {EntryFields.text: 'Uncommitted'},
    ]);
  });

  test('a backup write failure prevents migration and preserves the diary',
      () async {
    final writer = await legacyDiary();
    await writer.close();
    await File(backupFolder().path).writeAsString('Blocks snapshot creation');

    await expectLater(
      diary.init(forceWithoutSync: true),
      throwsA(isA<FileSystemException>()),
    );
    expect(diary.database, isNull);
    final preserved = await openAt(path(), readOnly: true);
    try {
      expect(await preserved.getVersion(), legacyVersion);
      expect(await notes(preserved), [
        {EntryFields.text: note},
      ]);
    } finally {
      await preserved.close();
    }
  });

  test('a new diary and the current schema do not produce a snapshot',
      () async {
    expect(await diary.init(forceWithoutSync: true), isTrue);
    expect(copies(), isEmpty);
    await diary.close();
    expect(await diary.init(forceWithoutSync: true), isTrue);
    expect(copies(), isEmpty);
  });

  test('a failed migration rolls back and keeps the verified snapshot',
      () async {
    final writer = await legacyDiary();
    // The v17 migration changes the sync guard before creating this table.
    await writer.execute('CREATE TABLE $dayWeatherTable (id INTEGER)');
    final before = await writer.query(entriesTable);
    final syncGuard = await writer.query(syncGuardTable);
    await writer.close();

    await expectLater(
      diary.init(forceWithoutSync: true),
      throwsA(isA<DatabaseException>()),
    );
    expect(diary.database, isNull);

    for (final candidate in [path(), copies().single.path]) {
      final restored = await openAt(candidate, readOnly: true);
      try {
        expect(await restored.getVersion(), legacyVersion);
        expect(await restored.query(entriesTable), before);
        expect(await restored.query(syncGuardTable), syncGuard);
      } finally {
        await restored.close();
      }
    }
  });

  test('a newer schema keeps its version and contents', () async {
    final futureVersion = AppDatabase.currentVersion + 1;
    final db = await openAt(path());
    await diary.createSchema(db);
    await db.setVersion(futureVersion);
    await db.insert(entriesTable, {EntryFields.text: note});
    await db.close();

    await expectLater(
      diary.init(forceWithoutSync: true),
      throwsA(isA<FormatException>()),
    );
    expect(copies(), isEmpty);
    final preserved = await openAt(path(), readOnly: true);
    try {
      expect(await preserved.getVersion(), futureVersion);
      expect(await notes(preserved), [
        {EntryFields.text: note},
      ]);
    } finally {
      await preserved.close();
    }
  });

  test('retention uses snapshot time across versions', () async {
    final writer = await legacyDiary();
    await writer.close();
    final folder = await backupFolder().create();
    final older = await File(path())
        .copy(p.join(folder.path, 'v16-2024-01-01T00-00-00.000Z-aid_diary.db'));
    final newer = await File(path())
        .copy(p.join(folder.path, 'v10-2025-01-01T00-00-00.000Z-aid_diary.db'));
    final unrelated = File(p.join(folder.path, 'manual-aid_diary.db'));
    await unrelated.writeAsString('Manual backup');
    final sidecar = File('${older.path}-wal');
    await sidecar.writeAsString('Legacy WAL');

    expect(await diary.init(forceWithoutSync: true), isTrue);
    expect(await newer.exists(), isTrue);
    expect(await older.exists(), isFalse);
    expect(await sidecar.exists(), isFalse);
    expect(await unrelated.readAsString(), 'Manual backup');
    expect(copies(), hasLength(3));
  });
}
