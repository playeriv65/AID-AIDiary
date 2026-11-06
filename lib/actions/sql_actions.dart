// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Folder beside the diary that keeps it as it was before `sql.execute`.
const beforeSqlFolder = 'before-sql';

/// The diary's database, for changes no single action makes: a query, or
/// any number of statements in one transaction.
final sqlActions = [
  AppAction(
    id: 'sql.query',
    describe: 'Runs one SQL query on the diary database and returns its rows. '
        'The schema is in sqlite_master.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('query', ParamType.string, 'The SQL query'),
      ActionParam('args', ParamType.string,
          'Values for its ? placeholders, as a JSON array',
          required: false),
      ActionParam('limit', ParamType.integer,
          'At most this many rows; the configured limit by default',
          required: false),
    ],
    run: (_, args) async {
      final limit = args['limit'] as int? ?? AppConfig.instance.agentSqlRows;
      final rows = await _guarded(() =>
          _database.rawQuery(args['query'] as String, _values(args['args'])));
      return {
        'total': rows.length,
        'rows': [for (final row in rows.take(limit)) _plain(row)],
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

Map<String, Object?> _plain(Map<String, Object?> row) => {
      for (final MapEntry(:key, :value) in row.entries)
        key: value is Uint8List ? '<${value.length} bytes>' : value,
    };
