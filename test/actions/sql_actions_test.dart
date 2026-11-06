@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/sql_actions.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../support/diary_app_harness.dart';

void main() {
  final actions = AppActions(devBuild: true);
  late Directory folder;

  setUp(() async {
    ImageStorage.instance
        .overrideStores(InMemoryFileStore(), InMemoryFileStore());
    folder = await Directory.systemTemp.createTemp('aid_sql');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (_) async => folder.path);
  });
  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    await folder.delete(recursive: true);
  });
  DiaryAppHarness().register(
      databasePath: () => p.join(folder.path, AppDatabase.databaseFileName));

  Future<Map<String, Object?>> run(String id, Map<String, Object?> args,
          {bool confirmed = false}) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Future<int> create(String text, String time) async =>
      (await run('entry.create', {'text': text, 'time': time}))['id'] as int;

  test('a query reads every entry, hidden ones too', () async {
    final id = await create('藏起来的', '2019-05-13T00:00:00+08:00');
    await run('entry.hide', {'id': '$id'});
    final result = await run('sql.query', {
      'query': "SELECT text, is_hidden, 'ATTACH VACUUM' AS words "
          'FROM entries WHERE id = ?',
      'args': '[$id]'
    });
    expect(result['rows'], [
      {'text': '藏起来的', 'is_hidden': 1, 'words': 'ATTACH VACUUM'}
    ]);
  });

  test('a query cannot change the diary with a returning clause', () async {
    final id = await create('original', '2019-05-13T00:00:00+08:00');
    await expectLater(
      run('sql.query', {
        'query': 'UPDATE entries SET text = ? WHERE id = ? RETURNING text',
        'args': jsonEncode(['changed', id]),
      }),
      throwsA(
          isA<ActionException>().having((e) => e.code, 'code', 'sql_error')),
    );
    final result = await run('sql.query', {
      'query': 'SELECT text FROM entries WHERE id = ?',
      'args': '[$id]',
    });
    expect(result['rows'], [
      {'text': 'original'}
    ]);
  });

  test('a query cannot create another database file', () async {
    final path = p.join(folder.path, 'other.db');
    for (final query in [
      '/* before */ ATTACH /* here */ DATABASE ? AS other',
      '-- before\nVACUUM /* here */ INTO ?',
    ]) {
      await expectLater(
        run('sql.query', {
          'query': query,
          'args': jsonEncode([path])
        }),
        throwsA(
            isA<ActionException>().having((e) => e.code, 'code', 'sql_error')),
      );
      expect(File(path).existsSync(), isFalse);
    }
  });

  test('statements change many entries at once, and the app sees it', () async {
    final first = await create('一', '2019-05-13T00:00:00+08:00');
    final second = await create('二', '2019-05-14T00:00:00+08:00');
    final steps = File(p.join(folder.path, 'steps.json'))
      ..writeAsStringSync(jsonEncode([
        {
          'sql': 'UPDATE entries SET time_create = ? WHERE id = ?',
          'args': ['2019-05-13T18:26:47.000', first]
        },
        {
          'sql': 'UPDATE entries SET time_create = ? WHERE id = ?',
          'args': ['2019-05-14T07:05:00.000', second]
        },
      ]));

    await expectLater(run('sql.execute', {'path': steps.path}),
        throwsA(isA<ActionException>()));
    final result =
        await run('sql.execute', {'path': steps.path}, confirmed: true);

    expect(result['changed'], 2);
    expect(File(result['before'] as String).existsSync(), isTrue);
    expect(p.basename(p.dirname(result['before'] as String)), beforeSqlFolder);
    final entry = await run('entry.get', {'id': '$first'});
    expect(entry['time'], '2019-05-13T18:26:47.000');
  });

  test('a failing statement changes nothing', () async {
    final id = await create('原样', '2019-05-13T00:00:00+08:00');
    await expectLater(
        run(
            'sql.execute',
            {
              'statement': "UPDATE entries SET text = 'x' WHERE id = $id; "
                  'nonsense'
            },
            confirmed: true),
        throwsA(isA<ActionException>()));
    final steps = File(p.join(folder.path, 'bad.json'))
      ..writeAsStringSync(jsonEncode([
        {'sql': "UPDATE entries SET text = 'x' WHERE id = $id"},
        {'sql': 'UPDATE no_such_table SET a = 1'},
      ]));
    await expectLater(
        run('sql.execute', {'path': steps.path}, confirmed: true),
        throwsA(
            isA<ActionException>().having((e) => e.code, 'code', 'sql_error')));
    expect((await run('entry.get', {'id': '$id'}))['text'], '原样');
  });
}
