import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/agent/diary_sql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory folder;
  late String path;
  late DiarySql sql;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('diary_sql_test');
    path = p.join(folder.path, 'diary.db');
    final db = await databaseFactoryFfi.openDatabase(path);
    await db.execute('CREATE TABLE entries (id INTEGER PRIMARY KEY, '
        'text TEXT, picture BLOB)');
    for (var id = 1; id <= 5; id++) {
      await db.insert('entries', {
        'id': id,
        'text': 'day $id',
        'picture': Uint8List.fromList([1, 2, 3]),
      });
    }
    await db.close();
    sql = DiarySql(
        () => databaseFactoryFfi.openDatabase(path,
            options:
                OpenDatabaseOptions(readOnly: true, singleInstance: false)),
        rowLimit: 3);
  });

  tearDown(() async {
    await sql.close();
    await folder.delete(recursive: true);
  });

  test('prints rows as JSON, bytes as their size', () async {
    final out = await sql
        .run(['SELECT id, text, picture FROM entries WHERE id = 2'], '');
    expect(out.exitCode, 0);
    expect(jsonDecode(out.stdout), [
      {'id': 2, 'text': 'day 2', 'picture': '<3 bytes>'},
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

  test('cannot change the diary', () async {
    // Turning query_only off leaves the connection itself read-only.
    await sql.run(['PRAGMA query_only = OFF'], '');
    for (final statement in [
      "UPDATE entries SET text = 'x'",
      'DELETE FROM entries',
      'DROP TABLE entries',
    ]) {
      final out = await sql.run([statement], '');
      expect(out.exitCode, 1, reason: statement);
    }
    final count = await sql.run(['SELECT count(*) AS n FROM entries'], '');
    expect(jsonDecode(count.stdout), [
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
    expect(out.stdout, contains('CREATE TABLE entries'));
  });
}
