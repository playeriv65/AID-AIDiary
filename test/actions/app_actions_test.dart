// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../support/app_folders_harness.dart';
import '../support/diary_app_harness.dart';

class FakeScreen implements ActionScreen {
  final List<String> opened = ['journal'];

  @override
  String get current => opened.last;

  @override
  List<ScreenDestination> get destinations => const [
        ScreenDestination('journal', 'The journal'),
        ScreenDestination('settings', 'The settings'),
        ScreenDestination('entry', 'One entry',
            params: [ActionParam('id', ParamType.integer, 'The entry')]),
      ];

  @override
  Future<void> navigate(String destination, ActionArgs args) async =>
      opened.add([destination, ...args.values].join('/'));

  @override
  Future<bool> back() async {
    if (opened.length == 1) return false;
    opened.removeLast();
    return true;
  }
}

void main() {
  DiaryAppHarness().register();
  useTemporaryAppFolders();
  final actions = AppActions(devBuild: true);

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {},
          bool confirmed = false]) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  test('every action is named, described and listed in the guide', () {
    final ids = [for (final action in AppActions.everyAction) action.id];
    expect(ids.toSet(), hasLength(ids.length));
    for (final action in AppActions.everyAction) {
      expect(action.id, matches(RegExp(r'^[a-z]+\.[a-z_]+$')));
      expect(action.describe, endsWith('.'), reason: action.id);
      for (final param in action.params) {
        expect(param.describe, isNotEmpty,
            reason: '${action.id} ${param.name}');
      }
      expect(actions.guide(), contains('`${action.id}`'));
    }
    // Test data stays out of builds people keep their diary in.
    expect(AppActions(devBuild: false).available.map((action) => action.id),
        isNot(contains('entry.seed')));
  });

  test('an entry is written, found, changed, deleted and brought back',
      () async {
    final created = await run(
        'entry.create', {'text': 'From the command line', 'day': '2026-10-20'});
    final id = created['id'] as int;
    expect(created['day'], '2026-10-20');
    expect(EntryStore.instance.entries.single.text, 'From the command line');

    expect((await run('entry.list', {'search': 'command'}))['total'], 1);
    await run('entry.update', {'id': '$id', 'text': 'Changed by an agent'});
    expect(
        (await run('entry.get', {'id': '$id'}))['text'], 'Changed by an agent');

    expect(
        () => run('entry.delete', {'id': '$id'}),
        throwsA(isA<ActionException>()
            .having((e) => e.code, 'code', 'needs_confirmation')));
    await run('entry.delete', {'id': '$id'}, true);
    expect(EntryStore.instance.entries, isEmpty);
    await run('entry.restore', {'id': '$id'});
    expect(EntryStore.instance.entries.single.id, id);
  });

  test('test data goes in at once and the list pages through it', () async {
    final seeded = await run('entry.seed', {'count': '300', 'words': '5'});
    expect(seeded['added'], 300);
    expect(EntryStore.instance.entries, hasLength(300));
    final page = await run('entry.list', {'limit': '10', 'offset': '290'});
    expect(page['total'], 300);
    expect(page['entries'] as List, hasLength(10));
  });

  test('test data may come with photos, each in a file of its own', () async {
    final seeded =
        await run('entry.seed', {'count': '40', 'words': '5', 'photos': '4'});
    expect(seeded['photos'], 4);
    final photos = EntryImagesProvider.instance.images;
    expect(photos, hasLength(4));
    expect(photos.map((photo) => photo.imgPath).toSet(), hasLength(4));
    for (final photo in photos) {
      expect(await ImageStorage.instance.exists(photo.imgPath), isTrue);
    }
  });

  test('wrong arguments are refused with a reason', () async {
    Matcher refused(String code) =>
        throwsA(isA<ActionException>().having((e) => e.code, 'code', code));
    expect(() => run('entry.get'), refused('bad_args'));
    expect(() => run('entry.get', {'id': 'twelve'}), refused('bad_args'));
    expect(
        () => run('entry.get', {'id': '1', 'extra': 'x'}), refused('bad_args'));
    expect(() => run('entry.get', {'id': '404'}), refused('not_found'));
    expect(() => run('no.such'), refused('unknown_action'));
  });

  test('settings show no secrets and change by their type', () async {
    final settings = await run('settings.list');
    expect(settings.keys, isNot(contains(Settings.syncSecrets.key)));
    expect(settings.keys, isNot(contains(Settings.passwordHash.key)));
    expect(
        await run('settings.set', {'key': 'showFlashbacks', 'value': 'false'}),
        {'showFlashbacks': false});
    expect(ConfigProvider.instance.get(Settings.showFlashbacks), isFalse);
    await run('settings.set', {'key': 'showFlashbacks', 'value': 'true'});
  });

  test('the screen actions need a GUI, and move it when there is one',
      () async {
    expect(
        () => run('ui.screen'),
        throwsA(
            isA<ActionException>().having((e) => e.code, 'code', 'no_screen')));
    final screen = FakeScreen();
    actions.screen = screen;
    addTearDown(() => actions.screen = null);
    expect(
        (await run('ui.navigate', {'to': 'settings'}))['current'], 'settings');
    expect(() => run('ui.navigate', {'to': 'nowhere'}),
        throwsA(isA<ActionException>()));
    // A place's own arguments, typed from command-line text.
    expect((await run('ui.navigate', {'to': 'entry', 'id': '12'}))['current'],
        'entry/12');
    for (final wrong in [
      {'to': 'entry'},
      {'to': 'entry', 'id': 'twelve'},
      {'to': 'settings', 'id': '12'},
    ]) {
      expect(
          () => run('ui.navigate', wrong),
          throwsA(isA<ActionException>()
              .having((e) => e.code, 'code', 'bad_args')));
    }
    final screenInfo = await run('ui.screen');
    expect(
        (screenInfo['destinations'] as List).last,
        containsPair('params', [
          {
            'name': 'id',
            'type': 'integer',
            'describe': 'The entry',
            'required': true
          }
        ]));
    expect(await run('ui.back'), {'closed': true, 'current': 'settings'});
  });

  test('the agent API runs actions for whoever has the token', () async {
    HttpOverrides.global = null;
    final folder = await Directory.systemTemp.createTemp('aid_api');
    addTearDown(() => folder.delete(recursive: true));
    final info = File('${folder.path}/agent_api.json');
    final api = AgentApi(actions, infoFile: info);
    await api.start(port: 0);
    addTearDown(api.stop);

    final written = jsonDecode(await info.readAsString()) as Map;
    final base = Uri.parse('http://127.0.0.1:${written['port']}/v1/');
    final auth = {'Authorization': 'Bearer ${written['token']}'};

    expect((await http.get(base.resolve('actions'))).statusCode, 401);
    final listed = jsonDecode(
        (await http.get(base.resolve('actions'), headers: auth)).body) as Map;
    expect((listed['result'] as List).map((action) => action['id']),
        contains('entry.create'));
    expect((await http.get(base.resolve('guide'), headers: auth)).body,
        startsWith('# AID Diary for agents'));

    final created = await http.post(base.resolve('run'),
        headers: auth,
        body: jsonEncode({
          'action': 'entry.create',
          'args': {'text': 'Over HTTP'},
        }));
    expect(jsonDecode(created.body)['ok'], isTrue);
    expect(EntryStore.instance.entries.single.text, 'Over HTTP');

    final refused = await http.post(base.resolve('run'),
        headers: auth,
        body: jsonEncode({
          'action': 'entry.delete',
          'args': {'id': '1'}
        }));
    expect(refused.statusCode, 400);
    expect(jsonDecode(refused.body)['error']['code'], 'needs_confirmation');

    await api.stop();
    expect(await info.exists(), isFalse);
  });
}
