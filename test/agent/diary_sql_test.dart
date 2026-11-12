@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/agent/diary_sql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../support/diary_file.dart';

void main() {
  late Directory folder;
  late DiarySql sql;

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('diary_sql_test');
    final path = p.join(folder.path, 'diary.db');
    await writeDiaryFile(path, entries: [
      for (var id = 1; id <= 5; id++) {'id': id, 'text': 'day $id'},
    ]);
    sql = DiarySql(path, rowLimit: 3, timeout: const Duration(seconds: 5));
  });

  tearDown(() => folder.delete(recursive: true));

  test('prints rows as JSON, bytes as their size', () async {
    final out = await sql.run([
      "SELECT id, text, x'010203' AS picture, 'ATTACH VACUUM' AS words "
          'FROM entries WHERE id = 2'
    ], '');
    expect(out.exitCode, 0);
    expect(jsonDecode(out.stdout), [
      {
        'id': 2,
        'text': 'day 2',
        'picture': '<3 bytes>',
        'words': 'ATTACH VACUUM'
      },
    ]);
  });

  test('stops at the row limit and says so', () async {
    final out = await sql.run(['SELECT id FROM entries'], '');
    expect((jsonDecode(out.stdout) as List).length, 3);
    expect(out.stderr, contains('first 3 of 5'));
    final more = await sql.run(['--limit', '10', 'SELECT id FROM entries'], '');
    expect((jsonDecode(more.stdout) as List).length, 5);
    expect(more.stderr, isEmpty);
  });

  test('reads the query from standard input', () async {
    final out = await sql.run([], 'SELECT count(*) AS n FROM entries\n');
    expect(jsonDecode(out.stdout), [
      {'n': 5},
    ]);
  });

  test('cannot attach other database files', () async {
    final out =
        await sql.run(["ATTACH '${p.join(folder.path, 'x.db')}' AS x"], '');
    expect(out.exitCode, 1);
    expect(out.stderr, contains('ATTACH'));
  });

  test('shows the schema', () async {
    final out = await sql.run(['--schema'], '');
    expect(out.stdout, contains('CREATE TABLE "entries"'));
    expect(out.stdout, contains('sealed time capsule'));
  });
}
