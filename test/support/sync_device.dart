// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_conflicts.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

/// Room for every test's changes in one pack, and no compaction unless a
/// test asks for it.
const SyncLimits testLimits =
    SyncLimits(packBytes: 1 << 20, compactAfter: 1000, parallel: 3);

/// One device: its own database, photo folder and device id.
class Device {
  Device._(this.db, this.name);

  final Database db;
  final InMemoryFileStore photos = InMemoryFileStore();
  final String name;
  late final SyncDevice device = (id: const Uuid().v4(), name: name);

  static Future<Device> create({String name = 'Device'}) async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(singleInstance: false));
    await AppDatabase.instance.createSchema(db);
    await AppDatabase.enforceForeignKeys(db);
    return Device._(db, name);
  }

  Future<SyncReport> sync(SyncBackend backend,
          {ItemCipher? cipher, SyncLimits limits = testLimits}) =>
      SyncEngine(
              db: db,
              backend: backend,
              photos: FileStorePhotos(photos),
              limits: limits,
              device: device,
              cipher: cipher)
          .sync();

  Future<List<SyncConflict>> conflicts() => listConflicts(db, device);

  /// Keeps [keep] of the conflict of the entry that reads [text] here.
  Future<void> resolve(String text, ConflictKeep keep) async =>
      resolveEntryConflict(db,
          photos: FileStorePhotos(photos),
          device: device,
          entry: await rowOf(text),
          keep: keep);

  Future<int> write(String text, {String day = '2026-10-20T09:00:00.000'}) =>
      db.insert(entriesTable, {
        EntryFields.text: text,
        EntryFields.timeCreate: day,
        EntryFields.timeModified: day,
      });

  Future<void> edit(String from, String to) =>
      db.update(entriesTable, {EntryFields.text: to},
          where: '${EntryFields.text} = ?', whereArgs: [from]);

  Future<List<String>> texts({bool deleted = false}) async => [
        for (final row in await db.query(entriesTable,
            where: '${EntryFields.deletedAt} IS ${deleted ? 'NOT ' : ''}NULL',
            orderBy: EntryFields.text))
          row[EntryFields.text] as String,
      ];

  Future<int> rowOf(String text) async => (await db.query(entriesTable,
          where: '${EntryFields.text} = ?', whereArgs: [text]))
      .single['id'] as int;
}
