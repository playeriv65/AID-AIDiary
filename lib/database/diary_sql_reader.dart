// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:aid_diary/database/read_only_sql.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:sqlite3/sqlite3.dart';

/// Why a read-only diary query gave no rows: SQLite's own words, or that it
/// ran out of time.
class DiarySqlException implements Exception {
  const DiarySqlException(this.message, {this.timedOut = false});

  final String message;
  final bool timedOut;

  @override
  String toString() => message;
}

/// What a query returned: how many rows it had and the first ones of them.
typedef DiarySqlRows = ({int total, List<Map<String, Object?>> rows});

/// How the copy that queries read treats each table of the diary
/// (docs/ARCHITECTURE.md, "Read-only SQL"). A table missing here is left
/// out of the copy, so a new table holds nothing a query can read until it
/// is placed here.
enum SqlCopy {
  /// Copied as it is: nothing in it belongs to one entry.
  whole,

  /// The entries: a sealed time capsule keeps only [sealedEntryColumns].
  entries,

  /// Rows of one entry (by `entry_id`): a sealed entry's rows are left out.
  ofEntry,

  /// Citations: a sealed entry's own are left out, and quotes from a
  /// sealed entry or its kept passages are blanked.
  citations,

  /// Sync conflicts: both versions are blanked when either is sealed.
  conflicts,

  /// Weather of a day and place that only sealed entries share is left
  /// out, since its place is theirs.
  weather,

  /// Ciphertext waiting to sync: paths stay, the bytes read as NULL.
  ciphertext,
}

/// Every table of the diary and how the query copy treats it.
const Map<String, SqlCopy> sqlCopyOf = {
  entriesTable: SqlCopy.entries,
  imagesTable: SqlCopy.ofEntry,
  entryTagsTable: SqlCopy.ofEntry,
  passagesTable: SqlCopy.ofEntry,
  'import_sources': SqlCopy.ofEntry,
  entryRefsTable: SqlCopy.citations,
  dayWeatherTable: SqlCopy.weather,
  syncConflictsTable: SqlCopy.conflicts,
  'sync_media_objects': SqlCopy.ciphertext,
  tagsTable: SqlCopy.whole,
  tagCategoriesTable: SqlCopy.whole,
  templatesTable: SqlCopy.whole,
  templateTagsTable: SqlCopy.whole,
  syncChangesTable: SqlCopy.whole,
  syncSeenTable: SqlCopy.whole,
  syncItemsTable: SqlCopy.whole,
  syncGuardTable: SqlCopy.whole,
  'sync_media_tasks': SqlCopy.whole,
};

/// What a sealed time capsule shows in `entries`, as in the GUI: that it
/// exists, its day and when it opens. Every other column reads as NULL.
const Set<String> sealedEntryColumns = {
  EntryFields.id,
  syncIdColumn,
  EntryFields.timeCreate,
  EntryFields.utcOffset,
  EntryFields.diaryDate,
  EntryFields.openAt,
  EntryFields.deletedAt,
  EntryFields.isHidden,
};

/// How the diary database writes its values, for whoever writes queries on
/// it (`sql.schema`, the in-app agent's `sql --schema`).
const String sqlConventions = '''
- entries: one row per diary entry. `title` is separate from `text`; `text` is Markdown. `mood` is -2 (worst) to 2 (best) or NULL.
- Times are the local clock where the entry was written, as ISO 8601 without a zone ('2026-10-20T23:30:00.000'), with that place's offset from UTC in minutes in `utc_offset` (NULL: written in the device's own time zone, unknown). Compare times as text or with SQLite's date functions; do not convert them to UTC unless you add utc_offset yourself.
- `diary_date` ('yyyy-MM-dd') is the diary day the entry belongs to. It can differ from the date of `time_create`: a day starts at a configured hour (4 AM by default), and the user may move an entry to another day. Use diary_date for anything per day, month or year.
- `deleted_at` set: the entry is in Recently deleted and will be erased later; leave such rows out unless asked about deleted entries. `is_hidden` = 1: the user hid it from everyday views; it is still the user's entry.
- `open_at` in the future: a sealed time capsule. Its row shows only id, uuid, time_create, utc_offset, diary_date, open_at, deleted_at and is_hidden; every other column reads as NULL, and its tags, attachments, kept passages and citations are left out until it opens.
- Places: `location_name`, `latitude`, `longitude` (decimal degrees), `location_source` (how it was set).
- Weather belongs to a day and a place, not to an entry: `day_weather` (`day` as 'yyyy-MM-dd', `place` as 'lat,lon' rounded to 0.1 degree or 'name:' plus the lower-case place name, `code` a WMO weather code, `temperature` in degrees Celsius, `source` queried < imported < manual, the higher one counts).
- Tags: `tags` (`name`, `tag_type` 0 = label, 1 = tracker with a value), linked by `entry_tags` (`entry_id`, `tag_id`, `value`). The tag whose `icon` is 'favorite' is the star. Tag categories are in `tag_categories`.
- Attachments: `entry_images` (`entry_id`, `img_path` file name, `img_rank` order); the files are not in the database.
- Citations: `entry_refs` (`entry_id` cites `target_uuid`, the `uuid` of an entry or of a kept passage, with an optional `quote`); kept passages: `kept_passages` (`entry_id`, `quote`).
- `uuid` columns are ids shared across the user's synced devices; tables starting with `sync_` are sync bookkeeping, and `templates` are writing templates, not entries.
''';

/// Runs one read-only [query] on the diary at [databasePath] and returns
/// how many rows it gave and the first [limit] of them.
///
/// The query runs on a copy of the diary made for it in memory, in an
/// isolate of its own that is stopped after [timeout]. Sealed time capsules
/// are not in the copy (see [SqlCopy]), so no query, however written, can
/// read them; the copy cannot be written, and statements that open another
/// database file are refused.
Future<DiarySqlRows> readDiarySql(String databasePath, String query,
    {List<Object?> args = const [],
    required int limit,
    required Duration timeout}) async {
  final command = databaseFileCommand(query);
  if (command != null) {
    throw DiarySqlException(
        '$command is not allowed: only the diary can be read');
  }
  return _within(timeout, () {
    final db = _sealedSafeCopy(databasePath, DateTime.now());
    try {
      final statement = db.prepare(query, checkNoTail: true);
      try {
        final cursor = statement.selectCursor(args);
        final rows = <Map<String, Object?>>[];
        var total = 0;
        while (cursor.moveNext()) {
          total++;
          if (rows.length < limit) rows.add(_plain(cursor.current));
        }
        return (total: total, rows: rows);
      } finally {
        statement.close();
      }
    } finally {
      db.close();
    }
  });
}

/// The diary's tables, indexes and views as their `CREATE` statements,
/// tables first: only the schema, none of the rows.
Future<List<({String type, String name, String sql})>> diarySchema(
        String databasePath,
        {required Duration timeout}) =>
    _within(timeout, () {
      final db = sqlite3.open(databasePath, mode: OpenMode.readOnly);
      try {
        return [
          for (final row in db.select(
              "SELECT type, name, sql FROM sqlite_master WHERE sql IS NOT NULL "
              "AND type IN ('table', 'index', 'view') "
              "AND name NOT LIKE 'sqlite_%' "
              "ORDER BY CASE type WHEN 'table' THEN 0 WHEN 'view' THEN 1 "
              "ELSE 2 END, tbl_name, name"))
            if (row['type'] != 'table' ||
                sqlCopyOf.containsKey(row['name'] as String))
              (
                type: row['type'] as String,
                name: row['name'] as String,
                sql: row['sql'] as String,
              ),
        ];
      } finally {
        db.close();
      }
    });

/// Runs [work] in an isolate of its own, stopped after [timeout].
Future<T> _within<T>(Duration timeout, T Function() work) async {
  final reply = ReceivePort();
  final isolate = await Isolate.spawn(_answer<T>, (reply.sendPort, work),
      onExit: reply.sendPort);
  try {
    final answer = await reply.first.timeout(timeout);
    return switch (answer) {
      (true, final Object? result) => result as T,
      (false, final String message) => throw DiarySqlException(message),
      _ => throw const DiarySqlException('The query stopped unexpectedly'),
    };
  } on TimeoutException {
    isolate.kill(priority: Isolate.immediate);
    throw DiarySqlException(
        'The query took longer than ${timeout.inSeconds} s and was stopped; '
        'narrow it down',
        timedOut: true);
  } finally {
    reply.close();
  }
}

void _answer<T>((SendPort, T Function()) job) {
  final (send, work) = job;
  try {
    send.send((true, work()));
  } on SqliteException catch (error) {
    send.send((false, error.message));
  } on DiarySqlException catch (error) {
    send.send((false, error.message));
  } on ArgumentError catch (error) {
    // package:sqlite3 refuses a second statement after the first this way.
    send.send((false, '${error.message}'));
  }
}

/// A writable-for-now in-memory copy of the diary at [path] without what
/// sealed time capsules hold as of [now], then made read-only.
Database _sealedSafeCopy(String path, DateTime now) {
  final db = sqlite3.open(':memory:', uri: true);
  try {
    db.execute('ATTACH DATABASE ? AS diary',
        ['${Uri.file(path, windows: _windowsPath(path))}?mode=ro']);
    final tables = {
      for (final row in db
          .select("SELECT name FROM diary.sqlite_master WHERE type = 'table'"))
        row['name'] as String,
    };
    for (final table in tables) {
      final copy = sqlCopyOf[table];
      if (copy == null) continue;
      final columns = copy == SqlCopy.ciphertext ? 'path, NULL AS bytes' : '*';
      db.execute('CREATE TABLE main."$table" AS '
          'SELECT $columns FROM diary."$table"');
    }
    db.execute('DETACH DATABASE diary');
    _removeSealed(db, tables, now);
    db.execute('PRAGMA query_only = ON');
    return db;
  } catch (_) {
    db.close();
    rethrow;
  }
}

bool _windowsPath(String path) => RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);

void _removeSealed(Database db, Set<String> tables, DateTime now) {
  bool sealed(Object? openAt) =>
      openAt is String && parseLocalTime(openAt).isAfter(now);

  final sealedIds = <int>{};
  final sealedUuids = <String>{};
  final openWeather = <String>{};
  final sealedWeather = <String>{};
  for (final row in db.select('SELECT * FROM entries')) {
    final entry = Entry.fromJson(row);
    final weather =
        '${DiaryDay.format(entry.day)}|${weatherPlaceOf(entry.location)}';
    if (sealed(row[EntryFields.openAt])) {
      sealedIds.add(entry.id!);
      if (row[syncIdColumn] case final String uuid) sealedUuids.add(uuid);
      sealedWeather.add(weather);
    } else {
      openWeather.add(weather);
    }
  }
  if (sealedIds.isEmpty) return;
  final ids = sealedIds.join(',');

  final hidden = [
    for (final row in db.select('PRAGMA table_info(entries)'))
      if (!sealedEntryColumns.contains(row['name'])) '"${row['name']}" = NULL',
  ];
  if (hidden.isNotEmpty) {
    db.execute('UPDATE entries SET ${hidden.join(', ')} WHERE id IN ($ids)');
  }
  if (tables.contains(passagesTable)) {
    for (final row in db.select('SELECT $syncIdColumn FROM $passagesTable '
        'WHERE ${PassageFields.entryId} IN ($ids)')) {
      if (row[syncIdColumn] case final String uuid) sealedUuids.add(uuid);
    }
  }
  for (final MapEntry(key: table, value: copy) in sqlCopyOf.entries) {
    if (!tables.contains(table)) continue;
    switch (copy) {
      case SqlCopy.ofEntry:
        db.execute('DELETE FROM "$table" WHERE entry_id IN ($ids)');
      case SqlCopy.citations:
        db.execute('DELETE FROM "$table" '
            'WHERE ${EntryRefFields.entryId} IN ($ids)');
        for (final uuid in sealedUuids) {
          db.execute(
              'UPDATE "$table" SET ${EntryRefFields.quote} = NULL, '
              '${EntryRefFields.quoteStart} = NULL '
              'WHERE ${EntryRefFields.target} = ?',
              [uuid]);
        }
      case SqlCopy.conflicts:
        for (final row
            in db.select('SELECT id, entry, held, synced FROM "$table"')) {
          bool versionSealed(Object? json) {
            if (json is! String) return false;
            final data = (jsonDecode(json) as Map)['data'];
            return data is Map && sealed(data[EntryFields.openAt]);
          }

          if (sealedUuids.contains(row['entry']) ||
              versionSealed(row['held']) ||
              versionSealed(row['synced'])) {
            db.execute(
                'UPDATE "$table" SET held = NULL, synced = NULL WHERE id = ?',
                [row['id']]);
          }
        }
      case SqlCopy.weather:
        for (final key in sealedWeather.difference(openWeather)) {
          final split = key.indexOf('|');
          final (day, place) =
              (key.substring(0, split), key.substring(split + 1));
          db.execute(
              'DELETE FROM "$table" WHERE ${DayWeatherFields.day} = ? '
              'AND ${DayWeatherFields.place} = ?',
              [day, place]);
        }
      case SqlCopy.whole || SqlCopy.entries || SqlCopy.ciphertext:
        break;
    }
  }
}

Map<String, Object?> _plain(Row row) => {
      for (final MapEntry(:key, :value) in row.entries)
        key: value is Uint8List ? '<${value.length} bytes>' : value,
    };
