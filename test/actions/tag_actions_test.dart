// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

Matcher refused(String code) =>
    throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  Future<Map<String, Object?>> run(String id,
      [Map<String, Object?> args = const {}, bool confirmed = false]) async {
    final result = await actions.run(id, args, confirmed: confirmed);
    // What the CLI prints must survive JSON.
    jsonEncode(result);
    return result as Map<String, Object?>;
  }

  Future<List<String>> names([Map<String, Object?> args = const {}]) async => [
        for (final tag in (await run('tag.list', args))['tags'] as List)
          (tag as Map)['name'] as String,
      ];

  test('a tag is made with its look and category, changed and found', () async {
    final work = await run('category.create',
        {'name': 'Work', 'color': '#336699', 'icon': 'work'});
    expect(work['color'], '#336699');
    expect(work['icon'], 'work');
    expect(work['iconType'], 'icon');

    final meetings = await run('tag.create', {
      'name': 'Meet,ings',
      'type': 'tracker',
      'category': 'work',
      'icon': '🗓',
      'color': '#FF8800',
    });
    expect(meetings['name'], 'Meetings');
    expect(meetings['type'], 'tracker');
    expect(meetings['category'], 'Work');
    expect(meetings['iconType'], 'character');
    expect(meetings['color'], '#FF8800');
    expect(TagsProvider.instance.tags.last.categoryId, work['id']);

    final listed = await run('tag.list', {'category': '${work['id']}'});
    expect(listed['tags'], [meetings]);
    expect(await names({'type': 'tracker', 'search': 'meet'}), ['Meetings']);

    final changed = await run('tag.update', {
      'id': '${meetings['id']}',
      'name': 'Calls',
      'color': 'none',
      'icon': 'work',
      'category': 'none',
    });
    expect(changed['name'], 'Calls');
    expect(changed['color'], isNull);
    expect(changed['icon'], 'work');
    expect(changed['categoryId'], isNull);
    expect(changed['type'], 'tracker');
  });

  test('wrong tags are refused with a reason', () async {
    await run('tag.create', {'name': 'Reading'});
    await expectLater(
        () => run('tag.create', {'name': 'reading'}), refused('exists'));
    await expectLater(
        () => run('tag.create', {'name': ',,'}), refused('bad_args'));
    await expectLater(() => run('tag.create', {'name': 'A', 'type': 'number'}),
        refused('bad_args'));
    await expectLater(() => run('tag.create', {'name': 'A', 'color': 'red'}),
        refused('bad_args'));
    await expectLater(
        () => run('tag.create', {'name': 'A', 'icon': 'no_such_icon'}),
        refused('bad_args'));
    await expectLater(
        () => run('tag.create', {'name': 'A', 'category': 'Nowhere'}),
        refused('not_found'));
    await expectLater(
        () => run('tag.update', {'id': '9999'}), refused('not_found'));
    expect(await names(), isNot(contains('A')));
  });

  test('#12 names the id, even when a name is a number', () async {
    // The GUI refers to tags and categories this way: a name such as a year
    // must not stand in for the tag that has that number as its id.
    final first = await run('tag.create', {'name': 'First'});
    final number = await run('tag.create', {'name': '${first['id']}'});
    final category = await run('category.create', {'name': '${first['id']}'});

    await expectLater(
        () => run('tag.update', {'id': '${first['id']}', 'category': '#999'}),
        refused('not_found'));
    final moved = await run('tag.update',
        {'id': '${first['id']}', 'category': '#${category['id']}'});
    expect(moved['categoryId'], category['id']);

    final entry = await run('entry.create', {'text': 'Run'});
    final tagged = await run(
        'entry.tag', {'id': '${entry['id']}', 'tag': '#${first['id']}'});
    expect(tagged['tags'], [
      {'tag': 'First'}
    ]);
    // Without the hash the name wins, as it always did.
    final byName = await run(
        'entry.untag', {'id': '${entry['id']}', 'tag': '${number['name']}'});
    expect(byName['tags'], [
      {'tag': 'First'}
    ]);
  });

  test('the icons a tag can have are listed by group', () async {
    final groups = (await run('tag.icons'))['groups'] as List;
    final keys = [for (final group in groups) ...(group as Map)['icons']];
    expect(keys, containsAll(['favorite', 'work']));
  });

  test('deleting a tag takes it off entries and needs confirmation', () async {
    final tag = await run('tag.create', {'name': 'Gym'});
    final entry = await run('entry.create', {'text': 'Leg day'});
    await run('entry.tag', {'id': '${entry['id']}', 'tag': 'gym'});
    await expectLater(() => run('tag.delete', {'id': '${tag['id']}'}),
        refused('needs_confirmation'));
    final deleted = await run('tag.delete', {'id': '${tag['id']}'}, true);
    expect(deleted['entries'], 1);
    expect(await names(), isNot(contains('Gym')));
    expect(TagsProvider.instance.getEntryTagsForEntry(entry['id'] as int),
        isEmpty);
  });

  test('deleting a category deletes its tags too', () async {
    final category = await run('category.create', {'name': 'Moods'});
    await run('tag.create', {'name': 'Glad', 'category': 'Moods'});
    await run('tag.create', {'name': 'Sad', 'category': '${category['id']}'});
    await run('tag.create', {'name': 'Plain'});
    expect((await run('category.list'))['categories'],
        contains(containsPair('tags', 2)));
    await expectLater(() => run('category.delete', {'id': '${category['id']}'}),
        refused('needs_confirmation'));
    final deleted =
        await run('category.delete', {'id': '${category['id']}'}, true);
    expect(deleted['tagsDeleted'], 2);
    final left = await names();
    expect(left, contains('Plain'));
    expect(left, isNot(anyOf(contains('Glad'), contains('Sad'))));
    expect([
      for (final c in (await run('category.list'))['categories'] as List)
        (c as Map)['name']
    ], isNot(contains('Moods')));
  });

  test('a category is changed and moved in the order', () async {
    final a = await run('category.create', {'name': 'Alpha'});
    final b = await run('category.create', {'name': 'Beta'});
    final updated = await run('category.update',
        {'id': '${a['id']}', 'name': 'Alpha two', 'color': '#00FF00'});
    expect(updated['name'], 'Alpha two');
    expect(updated['color'], '#00FF00');
    await expectLater(
        () => run('category.update', {'id': '${a['id']}', 'name': 'beta'}),
        refused('exists'));

    Future<List<Object?>> order() async => [
          for (final c in (await run('category.list'))['categories'] as List)
            (c as Map)['name']
        ];
    final before = await order();
    await run('category.move', {'id': '${b['id']}', 'position': '0'});
    final after = await order();
    expect(after.first, 'Beta');
    expect(after.toSet(), before.toSet());
  });

  test('tags move between categories and within them', () async {
    final first = await run('category.create', {'name': 'First'});
    await run('category.create', {'name': 'Second'});
    for (final name in ['One', 'Two', 'Three']) {
      await run('tag.create', {'name': name, 'category': 'First'});
    }
    Future<List<String>> inFirst() => names({'category': 'First'});
    expect(await inFirst(), ['One', 'Two', 'Three']);

    await run('tag.move', {'id': await _id(run, 'Three'), 'position': '0'});
    expect(await inFirst(), ['Three', 'One', 'Two']);

    final moved = await run('tag.move',
        {'id': await _id(run, 'One'), 'category': 'Second', 'position': '0'});
    expect(moved['category'], 'Second');
    expect(await inFirst(), ['Three', 'Two']);
    expect(await names({'category': 'Second'}), ['One']);

    await run('tag.move', {'id': await _id(run, 'Two'), 'category': 'none'});
    expect(await names({'category': 'none'}), contains('Two'));
    expect(await inFirst(), ['Three']);
    expect(first['id'], isNotNull);
  });

  test('tags go on and off entries, a tracker with its value', () async {
    await run('tag.create', {'name': 'Peaceful'});
    await run('tag.create', {'name': 'Sleep hours', 'type': 'tracker'});
    final entry = await run('entry.create', {'text': 'A quiet day'});
    final id = '${entry['id']}';

    var tagged = await run('entry.tag', {'id': id, 'tag': 'peaceful'});
    expect(tagged['tags'], [
      {'tag': 'Peaceful'}
    ]);
    tagged = await run(
        'entry.tag', {'id': id, 'tag': 'Sleep hours', 'value': '7.5'});
    expect(tagged['tags'], [
      {'tag': 'Peaceful'},
      {'tag': 'Sleep hours', 'value': '7.5'},
    ]);
    // Again with another value: the value changes, nothing is added.
    tagged =
        await run('entry.tag', {'id': id, 'tag': 'Sleep hours', 'value': '8'});
    expect((tagged['tags'] as List).last, {'tag': 'Sleep hours', 'value': '8'});
    expect(TagsProvider.instance.getEntryTagsForEntry(entry['id'] as int),
        hasLength(2));
    expect((await run('entry.get', {'id': id}))['tags'], hasLength(2));

    await expectLater(
        () => run('entry.tag', {'id': id, 'tag': 'Peaceful', 'value': '3'}),
        refused('bad_args'));
    await expectLater(() => run('entry.tag', {'id': id, 'tag': 'Sleep hours'}),
        refused('bad_args'));
    await expectLater(
        () =>
            run('entry.tag', {'id': id, 'tag': 'Sleep hours', 'value': 'lots'}),
        refused('bad_args'));
    await expectLater(() => run('entry.tag', {'id': id, 'tag': 'Missing'}),
        refused('not_found'));
    await expectLater(() => run('entry.tag', {'id': '9999', 'tag': 'Peaceful'}),
        refused('not_found'));

    final untagged = await run('entry.untag', {'id': id, 'tag': 'Peaceful'});
    expect(untagged['tags'], [
      {'tag': 'Sleep hours', 'value': '8'}
    ]);
    // Taking off what is not on is no error.
    expect((await run('entry.untag', {'id': id, 'tag': 'Peaceful'}))['tags'],
        hasLength(1));
  });

  test('tags are exported and imported again, with their categories', () async {
    await run('category.create', {'name': 'Body', 'icon': 'spa'});
    await run('tag.create',
        {'name': 'Stretch', 'category': 'Body', 'color': '#112233'});
    await run('tag.create', {'name': 'Steps', 'type': 'tracker'});
    final folder = await Directory.systemTemp.createTemp('aid_tags_export');
    addTearDown(() => folder.delete(recursive: true));
    final path = '${folder.path}/nested/tags.json';

    final exported = await run('tag.export', {'path': path, 'tags': 'Stretch'});
    expect(exported, {'path': path, 'tags': 1});
    final file = jsonDecode(await File(path).readAsString()) as Map;
    expect(file['type'], 'aid_diary_tags');
    expect((file['tags'] as List).single['name'], 'Stretch');
    expect(file['categories'] as List, hasLength(1));

    await run('tag.delete', {'id': await _id(run, 'Stretch')}, true);
    await run(
        'category.delete',
        {
          'id':
              '${((await run('category.list'))['categories'] as List).last['id']}'
        },
        true);
    final imported = await run('tag.import', {'path': path});
    expect(imported, {
      'categoriesAdded': 1,
      'tagsAdded': 1,
      'templatesAdded': 0,
    });
    final back =
        ((await run('tag.list', {'search': 'stretch'}))['tags'] as List).single
            as Map;
    expect(back['category'], 'Body');
    expect(back['color'], '#112233');
    // Importing the same file again adds nothing.
    expect(await run('tag.import', {'path': path}), {
      'categoriesAdded': 0,
      'tagsAdded': 0,
      'templatesAdded': 0,
    });

    await expectLater(
        () => run('tag.import', {'path': '${folder.path}/missing.json'}),
        refused('not_found'));
    final other = File('${folder.path}/other.json')
      ..writeAsStringSync('{"type": "something else"}');
    await expectLater(
        () => run('tag.import', {'path': other.path}), refused('bad_file'));
    other.writeAsStringSync('not json');
    await expectLater(
        () => run('tag.import', {'path': other.path}), refused('bad_file'));
  });
}

Future<String> _id(
    Future<Map<String, Object?>> Function(String, [Map<String, Object?>, bool])
        run,
    String name) async {
  final tags = (await run('tag.list', {'search': name}))['tags'] as List;
  return '${(tags.firstWhere((tag) => (tag as Map)['name'] == name) as Map)['id']}';
}
