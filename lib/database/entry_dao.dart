// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/models/entry.dart';
import 'package:sqflite/sqflite.dart';

/// An entry in Recently deleted and when it went there.
typedef DeletedEntry = ({Entry entry, DateTime deletedAt});

class EntryDao {
  /// Entries not in Recently deleted, newest first.
  static Future<List<Entry>> getAll() async {
    final result = await AppDatabase.instance.database!.query(entriesTable,
        where: '${EntryFields.deletedAt} IS NULL',
        orderBy: '${EntryFields.timeCreate} DESC');

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
          deletedAt: DateTime.parse(json[EntryFields.deletedAt] as String),
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

  static Future<Entry> add(Entry entry, {DatabaseExecutor? executor}) async {
    final id = await AppDatabase.executorOr(executor)
        .insert(entriesTable, entry.toJson());

    return entry.copy(id: id);
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
