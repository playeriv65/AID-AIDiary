@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/database/diary_sql_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/diary_file.dart';

void main() {
  late Directory folder;
  late String path;
  const timeout = Duration(seconds: 10);
  const secret = 'the sealed secret';

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('diary_sql_reader');
    path = p.join(folder.path, 'diary.db');
    final opensLater = DateTime.now().add(const Duration(days: 365));
    await writeDiaryFile(path, entries: [
      {
        'id': 1,
        'uuid': 'open-entry',
        'title': 'An ordinary day',
        'text': 'walked to the lake',
        'diary_date': '2026-01-02',
        'location_name': 'Lake',
      },
      {
        'id': 2,
        'uuid': 'sealed-entry',
        'title': 'For later',
        'text': secret,
        'mood': 2,
        'diary_date': '2026-01-03',
        'location_name': 'Secret garden',
        'open_at': opensLater.toIso8601String(),
      },
      {
        'id': 3,
        'uuid': 'opened-entry',
        'text': 'a capsule that has opened',
        'diary_date': '2026-01-04',
        'open_at': '2026-01-05T00:00:00.000',
      },
    ]);
    final db = await databaseFactoryFfi.openDatabase(path);
    await db.insert('tags', {'id': 1, 'name': 'friends', 'tag_type': 0});
    for (final entry in [1, 2]) {
      await db.insert(
          'entry_tags', {'entry_id': entry, 'tag_id': 1, 'value': 'v$entry'});
      await db.insert('entry_images',
          {'entry_id': entry, 'img_path': 'p$entry.jpg', 'img_rank': 0});
      await db.insert('import_sources', {
        'source_format': 'test',
        'source_id': '$entry',
        'source_hash': 'h$entry',
        'entry_id': entry,
        'source_json': jsonEncode({'text': entry == 2 ? secret : 'plain'}),
      });
    }
    await db.insert('kept_passages', {
      'entry_id': 2,
      'uuid': 'sealed-passage',
      'quote': secret,
      'time_create': '2026-01-03T09:00:00.000',
    });
    for (final (from, target) in [
      (1, 'sealed-entry'),
      (1, 'sealed-passage'),
      (2, 'open-entry'),
    ]) {
      await db.insert('entry_refs', {
        'entry_id': from,
        'target_uuid': target,
        'quote': from == 1 ? secret : 'walked',
        'time_create': '2026-01-03T09:00:00.000',
      });
    }
    for (final (day, place) in [
      ('2026-01-02', 'name:lake'),
      ('2026-01-03', 'name:secret garden'),
    ]) {
      await db.insert('day_weather', {
        'day': day,
        'place': place,
        'source': 'manual',
        'code': 1,
        'temperature': 3.0,
        'time_modified': '2026-01-03T09:00:00.000',
      });
    }
    await db.insert('sync_conflicts', {
      'entry': 'sealed-entry',
      'held_by': 'device',
      'held': jsonEncode({
        'data': {'text': secret}
      }),
      'synced': jsonEncode({
        'data': {'text': secret}
      }),
    });
    await db.close();
  });

  tearDown(() => folder.delete(recursive: true));

  Future<List<Map<String, Object?>>> rows(String query) async =>
      (await readDiarySql(path, query, limit: 100, timeout: timeout)).rows;

  test('every table of the diary has a rule in the query copy', () async {
    final db = await databaseFactoryFfi.openDatabase(path);
    final tables = [
      for (final row in await db.rawQuery("SELECT name FROM sqlite_master "
          "WHERE type = 'table' AND name NOT LIKE 'sqlite_%'"))
        row['name'] as String,
    ];
    await db.close();
    expect(sqlCopyOf.keys, unorderedEquals(tables));
  });

  test('a sealed capsule shows only that it exists and when it opens',
      () async {
    final entries = await rows('SELECT * FROM main.entries ORDER BY id');
    expect(entries[0]['text'], 'walked to the lake');
    expect(entries[2]['text'], 'a capsule that has opened');
    final sealed = entries[1];
    expect(sealed['id'], 2);
    expect(sealed['open_at'], isNotNull);
    expect(sealed['diary_date'], '2026-01-03');
    for (final column in ['title', 'text', 'mood', 'location_name']) {
      expect(sealed[column], isNull, reason: column);
    }
  });

  test('no table gives a sealed capsule away', () async {
    final db = await databaseFactoryFfi.openDatabase(path);
    final tables = [
      for (final row in await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type = 'table'"))
        row['name'] as String,
    ];
    await db.close();
    for (final table in tables) {
      if (!sqlCopyOf.containsKey(table)) continue;
      final dump = jsonEncode(await rows('SELECT * FROM "$table"'));
      expect(dump, isNot(contains(secret)), reason: table);
      expect(dump, isNot(contains('Secret garden')), reason: table);
      expect(dump, isNot(contains('secret garden')), reason: table);
    }
    expect(await rows('SELECT entry_id FROM entry_tags'), [
      {'entry_id': 1}
    ]);
    expect(await rows('SELECT day FROM day_weather'), [
      {'day': '2026-01-02'}
    ]);
    expect(
        await rows('SELECT target_uuid, quote FROM entry_refs ORDER BY id'), [
      {'target_uuid': 'sealed-entry', 'quote': null},
      {'target_uuid': 'sealed-passage', 'quote': null},
    ]);
  });

  test('cannot reach the diary file or write to it', () async {
    for (final query in [
      "ATTACH '$path' AS diary",
      "SELECT 1; ATTACH '$path' AS diary",
      "UPDATE entries SET text = 'x'",
      "VACUUM INTO '${p.join(folder.path, 'copy.db')}'",
    ]) {
      await expectLater(readDiarySql(path, query, limit: 10, timeout: timeout),
          throwsA(isA<DiarySqlException>()),
          reason: query);
    }
    // Each query reads a fresh copy, so turning query_only off is forgotten.
    await rows('PRAGMA query_only = OFF');
    await expectLater(rows("UPDATE entries SET text = 'x' RETURNING id"),
        throwsA(isA<DiarySqlException>()));
    expect(await rows('SELECT text FROM entries WHERE id = 1'), [
      {'text': 'walked to the lake'}
    ]);
    expect(File(p.join(folder.path, 'copy.db')).existsSync(), isFalse);
  });

  test('returns the first rows and how many there were', () async {
    final result = await readDiarySql(
        path,
        'WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n '
        'WHERE i < 50) SELECT i FROM n',
        limit: 5,
        timeout: timeout);
    expect(result.total, 50);
    expect(result.rows.map((row) => row['i']), [1, 2, 3, 4, 5]);
  });

  test('stops a query that runs too long', () async {
    final started = DateTime.now();
    await expectLater(
        readDiarySql(
            path,
            'WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n) '
            'SELECT count(*) FROM n',
            limit: 5,
            timeout: const Duration(seconds: 1)),
        throwsA(isA<DiarySqlException>()
            .having((error) => error.timedOut, 'timedOut', isTrue)));
    expect(DateTime.now().difference(started), lessThan(timeout));
  });

  test('the schema has the diary tables, not their rows', () async {
    final schema = await diarySchema(path, timeout: timeout);
    final entries = schema.firstWhere((item) => item.name == 'entries');
    expect(entries.type, 'table');
    expect(entries.sql, contains('open_at'));
    expect(jsonEncode([for (final item in schema) item.sql]),
        isNot(contains(secret)));
  });
}
