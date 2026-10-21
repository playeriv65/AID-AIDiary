// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aid_diary/utils/local_time.dart';

class EntryDao {
  /// Entries not in Recently deleted, by diary day then written time, newest
  /// first; only the [limit] newest when given.
  static Future<List<Entry>> getAll({int? limit}) async {
    final result = await AppDatabase.instance.database!.query(entriesTable,
        where: '${EntryFields.deletedAt} IS NULL',
        orderBy:
            '${EntryFields.diaryDate} DESC, ${EntryFields.timeCreate} DESC',
        limit: limit);

    return result.map((json) => Entry.fromJson(json)).toList();
  }

  /// Entries in Recently deleted, most recently deleted first.
  static Future<List<DeletedEntry>> getDeleted() async {
    final result = await AppDatabase.instance.database!.query(entriesTable,
        where: '${EntryFields.deletedAt} IS NOT NULL',
        orderBy: '${EntryFields.deletedAt} DESC');
    return [
      for (final json in result)
        (
          entry: Entry.fromJson(json),
          deletedAt: parseLocalTime(json[EntryFields.deletedAt] as String),
        ),
    ];
  }

  /// Moves an entry into Recently deleted, or back out with null.
  static Future<void> setDeleted(int id, DateTime? deletedAt,
      {DatabaseExecutor? executor}) async {
    await AppDatabase.executorOr(executor).update(
      entriesTable,
      {EntryFields.deletedAt: deletedAt?.toIso8601String()},
      where: '${EntryFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future<Entry?> get(int id) async {
    final maps = await AppDatabase.instance.database!.query(
      entriesTable,
      columns: EntryFields.values,
      where: '${EntryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Entry.fromJson(maps.first);
    } else {
      return null;
    }
  }

  /// Inserts [entry]; without a known UTC offset it was written here, so
  /// it takes this device's.
  static Future<Entry> add(Entry entry, {DatabaseExecutor? executor}) async {
    final placed = entry.utcOffset == null
        ? entry.copy(utcOffset: entry.timeCreate.timeZoneOffset.inMinutes)
        : entry;
    final id = await AppDatabase.executorOr(executor)
        .insert(entriesTable, placed.toJson());

    return placed.copy(id: id);
  }

  static Future<void> update(Entry entry, {DatabaseExecutor? executor}) async {
    await AppDatabase.executorOr(executor).update(
      entriesTable,
      entry.toJson(),
      where: '${EntryFields.id} = ?',
      whereArgs: [entry.id],
    );
  }

  static Future<void> remove(int id, {DatabaseExecutor? executor}) async {
    await AppDatabase.executorOr(executor).delete(
      entriesTable,
      where: '${EntryFields.id} = ?',
      whereArgs: [id],
    );
  }
}
