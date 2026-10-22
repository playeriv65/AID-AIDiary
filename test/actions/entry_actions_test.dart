// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/entry_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  // Erasing everything also sweeps the attachment folder.
  setUp(() => ImageStorage.instance
      .overrideStores(InMemoryFileStore(), InMemoryFileStore()));
  tearDown(ImageStorage.instance.clearStoreOverrides);

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {},
          bool confirmed = false]) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  Future<int> create(Map<String, Object?> args) async =>
      (await run('entry.create', args))['id'] as int;

  Future<Map<String, Object?>> get(int id) => run('entry.get', {'id': '$id'});

  Future<List<Object?>> listed(Map<String, Object?> args) async =>
      (await run('entry.list', args))['entries'] as List<Object?>;

  String tomorrow() =>
      DiaryDay.format(DateTime.now().add(const Duration(days: 1)));

  test('a mood alone is a quick check-in; an entry may start empty', () async {
    final id = await create({'mood': '2'});
    final entry = await get(id);
    expect(entry['mood'], 2);
    expect(entry['text'], '');
    // As in the editor, which saves an entry before anything is written.
    expect((await get(await create({})))['text'], '');
    await expectLater(
        () => run('entry.create', {'mood': '3'}), refused('bad_args'));
    await expectLater(
        () => run('entry.create', {'text': 'x', 'day': '2026-13-45'}),
        refused('bad_args'));
  });

  test('every field of an entry is set, kept and cleared', () async {
    final id = await create({'text': 'Walk by the river', 'day': '2026-10-20'});
    await run('entry.update', {
      'id': '$id',
      'mood': '-1',
      'place': 'Riverside',
      'latitude': '31.2',
      'longitude': '121.5',
      'weather': '61,12.5',
      'activity': 'walking',
    });
    var entry = await get(id);
    expect(entry, containsPair('text', 'Walk by the river'));
    expect(entry, containsPair('mood', -1));
    expect(entry, containsPair('place', 'Riverside'));
    expect(entry, containsPair('latitude', 31.2));
    expect(entry, containsPair('longitude', 121.5));
    expect(entry, containsPair('weather', {'code': 61, 'temperature': 12.5}));
    expect(entry, containsPair('activity', 'walking'));

    // A new name keeps the spot; a new spot drops the old name.
    await run('entry.update', {'id': '$id', 'place': 'The river'});
    entry = await get(id);
    expect(entry, containsPair('place', 'The river'));
    expect(entry, containsPair('latitude', 31.2));
    await run('entry.update', {'id': '$id', 'latitude': '1', 'longitude': '2'});
    expect(await get(id), containsPair('place', '1.0000, 2.0000'));

    await run('entry.update', {
      'id': '$id',
      'mood': 'none',
      'place': 'none',
      'weather': 'none',
      'activity': '',
    });
    entry = await get(id);
    for (final key in ['mood', 'place', 'weather', 'activity', 'latitude']) {
      expect(entry.containsKey(key), isFalse, reason: key);
    }
    expect(entry['text'], 'Walk by the river');

    await expectLater(
        () => run('entry.update', {'id': '$id'}), refused('bad_args'));
    for (final wrong in [
      {'mood': '9'},
      {'activity': 'swimming'},
      {'weather': 'sunny'},
      {'latitude': '10'},
      {'latitude': '95', 'longitude': '0'},
      {'place': 'none', 'latitude': '1', 'longitude': '2'},
      {'time': 'yesterday'},
    ]) {
      await expectLater(() => run('entry.update', {'id': '$id', ...wrong}),
          refused('bad_args'),
          reason: '$wrong');
    }
  });

  test('the diary day and the written time change on their own', () async {
    final id = await create({'text': 'Late', 'time': '2026-10-20T23:30:00'});
    expect(await get(id), containsPair('day', '2026-10-20'));
    await run('entry.update', {'id': '$id', 'day': '2026-10-19'});
    var entry = await get(id);
    expect(entry['day'], '2026-10-19');
    expect(entry['time'], '2026-10-20T23:30:00.000');
    await run('entry.update', {'id': '$id', 'time': '2026-10-21T08:00:00'});
    entry = await get(id);
    expect(entry['time'], '2026-10-21T08:00:00.000');
    expect(entry['day'], '2026-10-19');
  });

  test('a template starts an entry with its text and tags', () async {
    final tag = TagsProvider.instance.tags.first;
    final template = await TemplatesProvider.instance.add(Template(
        name: 'Year',
        text: 'Year {{date:yyyy}}:',
        timeCreate: DateTime.now(),
        timeModified: DateTime.now()));
    await TagsProvider.instance.setTemplateTags(template.id!, [tag.id!]);

    final id = await create({'template': '${template.id}', 'text': 'Sunny.'});
    final entry = await get(id);
    expect(entry['text'], 'Year ${DateTime.now().year}:\n\nSunny.');
    expect((entry['tags'] as List).single, containsPair('tag', tag.name));

    // A ready-made template needs no text of its own.
    final ready = await get(await create({'template': 'morning'}));
    expect(ready['text'], isNotEmpty);
    await expectLater(() => run('entry.create', {'template': 'no-such'}),
        refused('not_found'));
  });

  test('an entry is starred, copied and added to', () async {
    final id = await create({'text': 'First', 'mood': '1'});
    expect(await run('entry.favorite', {'id': '$id', 'value': 'true'}),
        {'id': id, 'favorite': true});
    expect(await get(id), containsPair('favorite', true));
    expect(await listed({'starred': 'true'}), hasLength(1));
    await run('entry.favorite', {'id': '$id', 'value': 'false'});
    expect(await listed({'starred': 'true'}), isEmpty);

    await run('entry.append', {'id': '$id', 'text': 'Second'});
    expect(await get(id), containsPair('text', 'First\n\nSecond'));

    final copy = await run('entry.duplicate', {'id': '$id'});
    expect(copy['id'], isNot(id));
    expect(EntryStore.instance.entries, hasLength(2));
    expect(
        await get(copy['id'] as int), containsPair('text', 'First\n\nSecond'));
  });

  test('a duplicated entry retains its diary day and recorded context',
      () async {
    final id = await create({
      'text': 'A walk',
      'time': '2026-10-21T09:00:00',
      'day': '2026-10-18',
      'weather': '61,18',
      'activity': 'walking',
      'place': 'Garden'
    });
    final copied = await run('entry.duplicate', {'id': '$id'});
    final copy = await get(copied['id'] as int);
    expect(copy['day'], '2026-10-18');
    expect(copy['weather'], {'code': 61, 'temperature': 18.0});
    expect(copy['activity'], 'walking');
    expect(copy['place'], 'Garden');
    expect(copy['utcOffsetMinutes'], (await get(id))['utcOffsetMinutes']);
  });

  test('a time capsule stays sealed for actions until it opens', () async {
    final id = await create({'text': 'Dear me', 'mood': '2', 'place': 'Home'});
    await run('entry.favorite', {'id': '$id', 'value': 'true'});

    for (final wrong in ['2020-01-01', DiaryDay.format(DateTime.now())]) {
      await expectLater(() => run('entry.seal', {'id': '$id', 'opens': wrong}),
          refused('bad_args'));
    }
    final sealed = await run('entry.seal', {'id': '$id', 'opens': tomorrow()});
    expect(sealed, containsPair('sealed', true));

    for (final shown in [
      await get(id),
      ...await listed({'day': sealed['day']})
    ]) {
      shown as Map<String, Object?>;
      expect(shown['sealed'], isTrue);
      expect(shown['opensAt'], startsWith(tomorrow()));
      for (final hidden in ['text', 'preview', 'mood', 'place', 'tags']) {
        expect(shown.containsKey(hidden), isFalse, reason: hidden);
      }
    }
    // Filters cannot find what is inside either.
    for (final filter in [
      {'search': 'Dear'},
      {'search': 'Home'},
      {'moods': '2'},
      {'starred': 'true'},
    ]) {
      expect(await listed(filter), isEmpty, reason: '$filter');
    }
    final refusedWhileSealed = {
      'entry.update': {'text': 'x'},
      'entry.append': {'text': 'x'},
      'entry.favorite': {'value': 'true'},
      'entry.duplicate': <String, Object?>{},
      'entry.seal': {'opens': tomorrow()},
      'entry.attachments': <String, Object?>{},
      'entry.export': {'format': 'text', 'path': 'unused'},
    };
    for (final MapEntry(key: action, value: more)
        in refusedWhileSealed.entries) {
      await expectLater(
          () => run(action, {'id': '$id', ...more}), refused('sealed'),
          reason: action);
    }

    await expectLater(() => run('entry.unseal', {'id': '$id'}),
        refused('needs_confirmation'));
    final opened = await run('entry.unseal', {'id': '$id'}, true);
    expect(opened.containsKey('sealed'), isFalse);
    expect(await get(id), containsPair('text', 'Dear me'));
    await expectLater(
        () => run('entry.unseal', {'id': '$id'}, true), refused('not_sealed'));
  });

  test('entries are found like the search screen finds them', () async {
    final walk = await create({
      'text': 'A walk',
      'mood': '2',
      'place': 'Riverside Park',
      'latitude': '31.2',
      'longitude': '121.5',
      'activity': 'walking',
    });
    final read = await create({'text': 'Read at home', 'mood': '0'});
    final named = await create({'text': 'Dinner', 'place': 'Riverside Cafe'});
    final tag = TagsProvider.instance.tags.last;
    await TagsProvider.instance.addEntryTag(
        EntryTag(entryId: read, tagId: tag.id!, timeCreate: DateTime.now()));
    await run('entry.favorite', {'id': '$walk', 'value': 'true'});

    Future<Set<Object?>> ids(Map<String, Object?> filter) async =>
        {for (final entry in await listed(filter)) (entry as Map)['id']};

    // The place name is searched as well as the text.
    expect(await ids({'search': 'riverside'}), {walk, named});
    expect(await ids({'search': 'home'}), {read});
    expect(await ids({'tags': tag.name.toUpperCase()}), {read});
    expect(await ids({'tags': '${tag.id}'}), {read});
    expect(await ids({'starred': 'true'}), {walk});
    expect(await ids({'moods': '2,0'}), {walk, read});
    expect(await ids({'activity': 'walking,running'}), {walk});
    expect(await ids({'has_location': 'true'}), {walk});
    expect(await ids({'has_location': 'false'}), {read, named});
    // Every filter given has to match.
    expect(await ids({'search': 'riverside', 'moods': '2'}), {walk});
    expect(await ids({}), {walk, read, named});

    final found = (await listed({'has_location': 'true'})).single as Map;
    expect(found, containsPair('latitude', 31.2));
    expect(found, containsPair('longitude', 121.5));
    await expectLater(() => run('entry.list', {'tags': 'nothing like it'}),
        refused('not_found'));
    await expectLater(
        () => run('entry.list', {'moods': 'happy'}), refused('bad_args'));
  });

  test('Recently deleted is listed, emptied, and everything can be erased',
      () async {
    final first = await create({'text': 'One'});
    final second = await create({'text': 'Two'});
    final third = await create({'text': 'Three'});
    await run('entry.delete', {'id': '$first'}, true);
    // Deleted later, so listed first, even on a coarse clock.
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await run('entry.delete', {'id': '$second'}, true);

    final deleted = await run('entry.deleted');
    expect(deleted['total'], 2);
    final item = (deleted['entries'] as List).first as Map;
    expect(item['id'], second);
    expect(item['deletedAt'], isNotEmpty);
    expect(item['daysLeft'], inInclusiveRange(1, 365));
    expect(await run('entry.deleted', {'limit': '1', 'offset': '1'}),
        containsPair('entries', hasLength(1)));

    await expectLater(
        () => run('entry.empty_deleted'), refused('needs_confirmation'));
    expect(await run('entry.empty_deleted', {}, true), {'erased': 2});
    expect((await run('entry.deleted'))['total'], 0);
    expect(EntryStore.instance.entries.single.id, third);

    await run('entry.delete', {'id': '$third'}, true);
    await create({'text': 'Four'});
    await expectLater(() => run('entry.erase_all', {'confirm': 'yes'}, true),
        refused('bad_args'));
    await expectLater(() => run('entry.erase_all', {'confirm': eraseAllPhrase}),
        refused('needs_confirmation'));
    expect(await run('entry.erase_all', {'confirm': eraseAllPhrase}, true),
        {'erased': 2});
    expect(EntryStore.instance.entries, isEmpty);
    expect((await run('entry.deleted'))['total'], 0);
  });

  test('bulk erasing tells the GUI once', () async {
    for (var i = 0; i < 5; i++) {
      await run(
          'entry.delete',
          {
            'id': '${await create({'text': '$i'})}'
          },
          true);
    }
    var notified = 0;
    void count() => notified++;
    EntryStore.instance.addListener(count);
    addTearDown(() => EntryStore.instance.removeListener(count));
    await run('entry.empty_deleted', {}, true);
    expect(notified, 1);
  });

  test('an entry is saved as text, HTML or ZIP, and never over a file',
      () async {
    final folder = await Directory.systemTemp.createTemp('aid_export');
    addTearDown(() => folder.delete(recursive: true));
    final id = await create({'text': '# Title\nBody *here*', 'mood': '1'});

    final text = File('${folder.path}/entry.txt');
    await run(
        'entry.export', {'id': '$id', 'format': 'text', 'path': text.path});
    expect(await text.readAsString(), endsWith('\n# Title\nBody *here*'));

    final html = File('${folder.path}/entry.html');
    await run(
        'entry.export', {'id': '$id', 'format': 'html', 'path': html.path});
    expect(await html.readAsString(), contains('<em>here</em>'));

    final zip = File('${folder.path}/entry.zip');
    final result = await run(
        'entry.export', {'id': '$id', 'format': 'zip', 'path': zip.path});
    expect(result['bytes'], await zip.length());
    expect(utf8.decode((await zip.readAsBytes()).sublist(0, 2)), 'PK');

    await expectLater(
        () => run(
            'entry.export', {'id': '$id', 'format': 'text', 'path': text.path}),
        refused('write_failed'));
    await expectLater(
        () => run('entry.export',
            {'id': '$id', 'format': 'pdf', 'path': '${folder.path}/entry.pdf'}),
        refused('bad_args'));
  });
}
