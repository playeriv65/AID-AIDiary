// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/agent/native/api/shell.dart';
import 'package:sqflite/sqflite.dart';

/// `sql` inside the agent's shell: queries on the diary through a
/// connection of its own that is read-only, so whatever an agent writes in
/// SQL fails, and changes go through `aid` and its actions.
///
///     sql "SELECT ..."     rows as a JSON array
///     sql --schema [name]  the tables, indexes and views
///     sql --limit N ...    at most N rows instead of [rowLimit]
///     ... | sql            the query from standard input
class DiarySql {
  DiarySql(this._open, {required this.rowLimit});

  /// Opens the diary read-only.
  final Future<Database> Function() _open;

  final int rowLimit;
  Database? _database;

  /// Other database files are out of reach even read-only.
  static final _attach = RegExp(r'\battach\b', caseSensitive: false);

  static const usage = '''
sql "SELECT ..."     rows as a JSON array
sql --schema [name]  the tables, indexes and views
sql --limit N ...    at most N rows
... | sql            the query from standard input
''';

  Future<Database> get _db async {
    final open = _database;
    if (open != null) return open;
    final database = await _open();
    await database.execute('PRAGMA query_only = ON');
    return _database = database;
  }

  Future<ShellOutput> run(List<String> args, String stdin) async {
    var limit = rowLimit;
    var schema = false;
    final words = <String>[];
    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--schema':
          schema = true;
        case '--limit':
          final value = i + 1 < args.length ? int.tryParse(args[++i]) : null;
          if (value == null || value < 1) return _fail('--limit takes a count');
          limit = value;
        case '--help' || '-h':
          return const ShellOutput(stdout: usage, stderr: '', exitCode: 0);
        default:
          words.add(args[i]);
      }
    }
    try {
      if (schema) return await _schema(words.firstOrNull);
      final query = words.isEmpty ? stdin.trim() : words.join(' ');
      if (query.isEmpty) return _fail(usage);
      if (_attach.hasMatch(query)) {
        return _fail('ATTACH is not allowed: only the diary can be read');
      }
      final rows = await (await _db).rawQuery(query);
      final shown = rows.take(limit).map(_plain).toList();
      return ShellOutput(
          stdout: '${jsonEncode(shown)}\n',
          stderr: rows.length > limit
              ? 'Showing the first $limit of ${rows.length} rows; '
                  'narrow the query or use LIMIT/OFFSET.\n'
              : '',
          exitCode: 0);
    } on DatabaseException catch (error) {
      return _fail(_reason(error));
    }
  }

  /// SQLite's own words, without the driver's wrapping and the file path.
  static String _reason(DatabaseException error) =>
      RegExp(r'SqliteException\(\d+\): ([^\n]+)')
          .firstMatch('$error')
          ?.group(1) ??
      '$error';

  Future<ShellOutput> _schema(String? name) async {
    final rows = await (await _db).rawQuery(
        "SELECT sql FROM sqlite_master WHERE sql IS NOT NULL "
        "AND name NOT LIKE 'sqlite_%'"
        "${name == null ? '' : ' AND (name = ? OR tbl_name = ?)'} "
        "ORDER BY CASE type WHEN 'table' THEN 0 WHEN 'view' THEN 1 "
        "WHEN 'index' THEN 2 ELSE 3 END, name",
        [
          if (name != null) ...[name, name]
        ]);
    return ShellOutput(
        stdout: '${rows.map((row) => '${row['sql']};').join('\n')}\n',
        stderr: '',
        exitCode: 0);
  }

  static Map<String, Object?> _plain(Map<String, Object?> row) => {
        for (final MapEntry(:key, :value) in row.entries)
          key: value is Uint8List ? '<${value.length} bytes>' : value,
      };

  static ShellOutput _fail(String message) =>
      ShellOutput(stdout: '', stderr: '$message\n', exitCode: 1);

  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }
}
