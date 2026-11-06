@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);
  late Directory folder;

  setUp(() async {
    ImageStorage.instance
        .overrideStores(InMemoryFileStore(), InMemoryFileStore());
    folder = await Directory.systemTemp.createTemp('aid_batch');
  });
  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    await folder.delete(recursive: true);
  });

  Future<Map<String, Object?>> run(
          String id, Map<String, Object?> args) async =>
      (await actions.run(id, args)) as Map<String, Object?>;

  Future<String> file(List<Object?> steps) async {
    final path = '${folder.path}/steps.json';
    await File(path).writeAsString(jsonEncode(steps));
    return path;
  }

  test('a batch runs every step inside the app and reports the failures',
      () async {
    final first = (await run('entry.create',
        {'text': '一', 'time': '2019-05-13T00:00:00+08:00'}))['id'] as int;
    final second = (await run('entry.create',
        {'text': '二', 'time': '2019-05-14T00:00:00+08:00'}))['id'] as int;
    await run('tag.create', {'name': '无忌'});

    final result = await run('actions.batch', {
      'path': await file([
        {
          'action': 'entry.update',
          'args': {'id': first, 'time': '2019-05-13T18:26:47+08:00'}
        },
        {
          'action': 'entry.tag',
          'args': {'id': second, 'tag': '无忌'}
        },
        {
          'action': 'entry.update',
          'args': {'id': second, 'time': 'not a time'}
        },
        {
          'action': 'entry.delete',
          'args': {'id': first}
        },
      ])
    });

    expect(result['steps'], 4);
    expect(result['failed'], 2);
    expect([for (final f in result['failures'] as List) (f as Map)['code']],
        ['bad_args', 'refused']);
    final updated = await run('entry.get', {'id': '$first'});
    expect(updated['time'], '2019-05-13T18:26:47.000');
    expect(updated['utcOffsetMinutes'], 480);
    final tagged = await run('entry.get', {'id': '$second'});
    expect(tagged['tags'], [
      {'tag': '无忌'}
    ]);
  });

  test('a file that is not a list of steps is refused', () async {
    await expectLater(
        run('actions.batch', {
          'path': await file([
            {'args': {}}
          ])
        }),
        throwsA(anything));
  });
}
