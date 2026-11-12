// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/agent/native/api/shell.dart';
import 'package:aid_diary/database/diary_sql_reader.dart';

/// `sql` inside the agent's shell: read-only queries on the diary, through
/// [readDiarySql] as `sql.query` runs them, so sealed time capsules stay
/// sealed and changes go through `aid` and its actions.
///
///     sql "SELECT ..."     rows as a JSON array
///     sql --schema         the tables, indexes and views
///     sql --limit N ...    at most N rows instead of [rowLimit]
///     ... | sql            the query from standard input
class DiarySql {
  DiarySql(this.databasePath, {required this.rowLimit, required this.timeout});

  final String databasePath;
  final int rowLimit;
  final Duration timeout;

  static const usage = '''
sql "SELECT ..."     rows as a JSON array
sql --schema         the tables, indexes and views, and what their values mean
sql --limit N ...    at most N rows
... | sql            the query from standard input
''';

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
      if (schema) {
        final items = await diarySchema(databasePath, timeout: timeout);
        return ShellOutput(
            stdout: '$sqlConventions\n'
                '${items.map((item) => '${item.sql};').join('\n')}\n',
            stderr: '',
            exitCode: 0);
      }
      final query = words.isEmpty ? stdin.trim() : words.join(' ');
      if (query.isEmpty) return _fail(usage);
      final result = await readDiarySql(databasePath, query,
          limit: limit, timeout: timeout);
      return ShellOutput(
          stdout: '${jsonEncode(result.rows)}\n',
          stderr: result.total > limit
              ? 'Showing the first $limit of ${result.total} rows; '
                  'narrow the query or use LIMIT/OFFSET.\n'
              : '',
          exitCode: 0);
    } on DiarySqlException catch (error) {
      return _fail(error.message);
    }
  }

  static ShellOutput _fail(String message) =>
      ShellOutput(stdout: '', stderr: '$message\n', exitCode: 1);
}
