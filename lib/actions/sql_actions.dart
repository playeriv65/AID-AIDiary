// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/diary_sql_reader.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Folder beside the diary that keeps it as it was before `sql.execute`.
const beforeSqlFolder = 'before-sql';

/// The diary's database, for changes no single action makes: a query, or
/// any number of statements in one transaction.
final sqlActions = [
  AppAction(
    id: 'sql.query',
    describe: 'Runs one read-only SQLite query (a single SELECT, WITH or '
        'PRAGMA statement) on the diary database and returns its rows as '
        'JSON objects, with how many rows it had in all. sql.schema shows '
        'the tables and how their values are written. Sealed time capsules '
        'read as rows without their text, title, mood or place. A query '
        'that runs too long is stopped.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('query', ParamType.string,
          'The SQL query, one statement; use ? for values'),
      ActionParam('args', ParamType.string,
          'Values for its ? placeholders, as a JSON array',
          required: false),
      ActionParam(
          'limit',
          ParamType.integer,
          'At most this many rows; the configured default when left out, '
              'never more than the configured maximum',
          required: false),
    ],
    run: (_, args) async {
      final config = AppConfig.instance;
      final limit =
          min(args['limit'] as int? ?? config.agentSqlRows, config.sqlMaxRows);
      if (limit < 1) {
        throw const ActionException('bad_args', 'limit must be at least 1');
      }
      final result = await _reading(() => readDiarySql(
          _database.path, args['query'] as String,
          args: _values(args['args']),
          limit: limit,
          timeout: config.sqlTimeout));
      return {
        'total': result.total,
        'rows': result.rows,
        if (result.total > result.rows.length) 'truncated': true,
      };
    },
  ),
  AppAction(
    id: 'sql.schema',
    describe: 'Describes the diary database for writing sql.query queries: '
        'every table, index and view as its CREATE statement, and the '
        'conventions its values follow (times, days, places, weather, tags, '
        'deleted, hidden and sealed entries).',
    risk: ActionRisk.read,
    run: (_, args) async {
      final schema = await _reading(() =>
          diarySchema(_database.path, timeout: AppConfig.instance.sqlTimeout));
      return {
        'conventions': sqlConventions,
        'schema': [
          for (final item in schema)
            {'type': item.type, 'name': item.name, 'sql': item.sql},
        ],
      };
    },
  ),
  AppAction(
    id: 'sql.execute',
    describe: 'Changes the diary database with SQL, all in one transaction: '
        'one statement, or a JSON file of [{"sql": ..., "args": [...]}]. '
        'A copy of the diary is kept first; the app then reads its data '
        'again, and the sync records every changed row as usual.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('statement', ParamType.string, 'One SQL statement',
          required: false),
      ActionParam('args', ParamType.string,
          'Values for its ? placeholders, as a JSON array',
          required: false),
      ActionParam('path', ParamType.string,
          'Instead of statement: a JSON file of statements on this device',
          required: false),
    ],
    run: (_, args) async {
      final statements = await _statementsOf(args);
      final snapshot = await _keepCopy();
      var changed = 0;
      await _guarded(() => _database.transaction((txn) async {
            for (final (sql, values) in statements) {
              await txn.execute(sql, values);
              changed += Sqflite.firstIntValue(
                      await txn.rawQuery('SELECT changes()')) ??
                  0;
            }
          }));
      await AppDatabase.instance.reload();
      return {
        'statements': statements.length,
        'changed': changed,
        'before': snapshot,
      };
    },
  ),
];

Database get _database =>
    AppDatabase.instance.database ??
    (throw const ActionException('unavailable', 'The diary is not open'));

/// A read-only query's failure as the action's error.
Future<T> _reading<T>(Future<T> Function() read) async {
  try {
    return await read();
  } on DiarySqlException catch (error) {
    throw ActionException(
        error.timedOut ? 'timeout' : 'sql_error', error.message);
  }
}

/// SQLite's own complaint as the action's error.
Future<T> _guarded<T>(Future<T> Function() run) async {
  try {
    return await run();
  } on DatabaseException catch (error) {
    throw ActionException(
        'sql_error',
        RegExp(r'SqliteException\(\d+\): ([^\n]+)')
                .firstMatch('$error')
                ?.group(1) ??
            '$error');
  }
}

List<Object?> _values(Object? json) => switch (json) {
      null => const [],
      final String text => switch (jsonDecode(text)) {
          final List list => list,
          _ => throw const ActionException(
              'bad_args', 'args must be a JSON array'),
        },
      final List list => list,
      _ => throw const ActionException('bad_args', 'args must be a JSON array'),
    };

Future<List<(String, List<Object?>)>> _statementsOf(ActionArgs args) async {
  final statement = args['statement'] as String?;
  final path = args['path'] as String?;
  if ((statement == null) == (path == null)) {
    throw const ActionException('bad_args', 'Give either statement or path');
  }
  if (statement != null) return [(statement, _values(args['args']))];
  final file = File(path!);
  if (!await file.exists()) {
    throw const ActionException('not_found', 'There is no such file');
  }
  return switch (jsonDecode(await file.readAsString())) {
    final List list when list.every((s) => s is Map && s['sql'] is String) => [
        for (final step in list.cast<Map>())
          (step['sql'] as String, _values(step['args'])),
      ],
    _ => throw const ActionException(
        'bad_args', 'The file must hold a list of {"sql": ..., "args": [...]}'),
  };
}

/// Copies the diary into [beforeSqlFolder] beside it and keeps the newest
/// configured number of copies; returns the copy's path.
Future<String> _keepCopy() async {
  final folder = Directory(p.join(
      p.dirname(await AppDatabase.instance.getInternalPath()),
      beforeSqlFolder));
  await folder.create(recursive: true);
  final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
  final copy = p.join(folder.path, '$stamp-${AppDatabase.databaseFileName}');
  if (!await AppDatabase.instance.exportSnapshotTo(copy)) {
    throw const ActionException(
        'unavailable', 'Could not keep a copy of the diary first');
  }
  final copies = [
    for (final entity in await folder.list().toList())
      if (entity is File) entity
  ]..sort((a, b) => b.path.compareTo(a.path));
  for (final old in copies.skip(AppConfig.instance.sqlSnapshots)) {
    await old.delete();
  }
  return copy;
}
