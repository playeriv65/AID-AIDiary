// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:sqflite/sqflite.dart';

/// What syncs as one item. An entry carries its photos and tag values, and a
/// template its tags, so each item is whole on its own.
enum SyncKind {
  category(tagCategoriesTable),
  tag(tagsTable),
  template(templatesTable),
  entry(entriesTable);

  const SyncKind(this.table);

  /// The table whose rows are the items of this kind.
  final String table;

  static SyncKind byName(String name) =>
      values.firstWhere((kind) => kind.name == name);
}

/// Column holding an item's id, the same on every device.
const String syncIdColumn = 'uuid';

/// Items changed locally since they were last sent, with when.
const String syncChangesTable = 'sync_changes';

/// The remote version of every item as of the last sync.
const String syncSeenTable = 'sync_seen';

/// One row; while its flag is set, writes are not recorded as changes. Set
/// while remote items are written into the database.
const String syncGuardTable = 'sync_guard';

/// Milliseconds since the epoch, in SQL.
const String _nowMs =
    "CAST(ROUND((julianday('now') - 2440587.5) * 86400000) AS INTEGER)";

const String _newId = 'lower(hex(randomblob(16)))';

/// Adds sync ids to every synced table, and the triggers that give new rows
/// an id and record each change. Changes come from triggers so that no write
/// path can forget to report one.
Future<void> addSyncSchema(DatabaseExecutor db) async {
  for (final table in [
    entriesTable,
    imagesTable,
    tagsTable,
    tagCategoriesTable,
    templatesTable,
  ]) {
    await db.execute('ALTER TABLE $table ADD COLUMN $syncIdColumn TEXT');
    await db.execute(
        'UPDATE $table SET $syncIdColumn = $_newId WHERE $syncIdColumn IS NULL');
    await db.execute('CREATE UNIQUE INDEX ${table}_$syncIdColumn '
        'ON $table ($syncIdColumn)');
    await db.execute('''
CREATE TRIGGER ${table}_new_id AFTER INSERT ON $table
WHEN NEW.$syncIdColumn IS NULL
BEGIN
  UPDATE $table SET $syncIdColumn = $_newId WHERE id = NEW.id;
END''');
  }

  await db.execute('''
CREATE TABLE $syncChangesTable (
  kind TEXT NOT NULL,
  $syncIdColumn TEXT NOT NULL,
  changed_at INTEGER NOT NULL,
  PRIMARY KEY (kind, $syncIdColumn)
)''');
  await db.execute('''
CREATE TABLE $syncSeenTable (
  path TEXT NOT NULL PRIMARY KEY,
  version TEXT NOT NULL
)''');
  await db.execute('CREATE TABLE $syncGuardTable (active INTEGER NOT NULL)');
  await db.execute('INSERT INTO $syncGuardTable (active) VALUES (0)');

  // Rows of an item's own table.
  for (final kind in SyncKind.values) {
    await _changeTriggers(db, kind.table, kind,
        idOf: (row) => '$row.$syncIdColumn');
  }
  // Rows that belong to an entry or a template.
  for (final (table, parentColumn, kind) in [
    (imagesTable, EntryImageFields.entryId, SyncKind.entry),
    (entryTagsTable, EntryTagFields.entryId, SyncKind.entry),
    (templateTagsTable, TemplateTagFields.templateId, SyncKind.template),
  ]) {
    await _changeTriggers(db, table, kind,
        idOf: (row) => '(SELECT $syncIdColumn FROM ${kind.table} '
            'WHERE id = $row.$parentColumn)');
  }
}

Future<void> _changeTriggers(DatabaseExecutor db, String table, SyncKind kind,
    {required String Function(String row) idOf}) async {
  for (final (event, row) in [
    ('INSERT', 'NEW'),
    ('UPDATE', 'NEW'),
    ('DELETE', 'OLD'),
  ]) {
    await db.execute('''
CREATE TRIGGER ${table}_sync_${event.toLowerCase()} AFTER $event ON $table
WHEN (SELECT active FROM $syncGuardTable) = 0
BEGIN
  INSERT OR REPLACE INTO $syncChangesTable (kind, $syncIdColumn, changed_at)
  SELECT '${kind.name}', id, $_nowMs FROM (SELECT ${idOf(row)} AS id)
  WHERE id IS NOT NULL;
END''');
  }
}

/// Runs [writes] with change recording off, for writing remote items.
Future<T> withoutRecording<T>(
    Database db, Future<T> Function(Transaction txn) writes) {
  return db.transaction((txn) async {
    await txn.execute('UPDATE $syncGuardTable SET active = 1');
    try {
      return await writes(txn);
    } finally {
      await txn.execute('UPDATE $syncGuardTable SET active = 0');
    }
  });
}

/// Records every item as changed now, so the next sync sends them all: for
/// a diary that starts syncing to a space.
Future<void> markAllChanged(DatabaseExecutor db) async {
  for (final kind in SyncKind.values) {
    await db.execute('''
INSERT OR REPLACE INTO $syncChangesTable (kind, $syncIdColumn, changed_at)
SELECT '${kind.name}', $syncIdColumn, $_nowMs FROM ${kind.table}''');
  }
}

/// Forgets what was synced where, for a diary that leaves its space.
Future<void> clearSyncState(DatabaseExecutor db) async {
  await db.delete(syncChangesTable);
  await db.delete(syncSeenTable);
}
