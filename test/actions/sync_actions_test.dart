// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {},
          bool confirmed = false]) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  Future<void> connectedTo(
          {required bool encrypted}) =>
      DiaryAppHarness.setSetting(
          Settings.syncTarget,
          jsonEncode(SyncTarget(
                  provider: SyncProvider.webdav,
                  server: Uri.parse('https://dav.example.test/'),
                  username: 'diary',
                  spaceId: 'space',
                  encrypted: encrypted)
              .toJson()));

  tearDown(() => SyncService.instance.unsyncedEntryIds = const {});

  test('the status names the entries still waiting to go up', () async {
    expect(await run('sync.status'), containsPair('unsyncedIds', isEmpty));
    SyncService.instance.unsyncedEntryIds = {7, 3};
    final status = await run('sync.status');
    expect(status['unsyncedIds'], [3, 7]);
    expect(status['unsyncedEntries'], 2);
  });

  test('keys are only handled for a space this device is connected to',
      () async {
    expect(() => run('sync.unlock', {'passphrase': 'a'}),
        refused('not_connected'));
    expect(() => run('sync.change_passphrase', {'passphrase': 'a'}),
        refused('not_connected'));
    expect(() => run('sync.reset_encryption', {'passphrase': 'a'}, true),
        refused('not_connected'));

    await connectedTo(encrypted: false);
    expect(() => run('sync.change_passphrase', {'passphrase': 'a'}),
        refused('not_encrypted'));
    expect(() => run('sync.reset_encryption', {'passphrase': 'a'}, true),
        refused('not_encrypted'));
  });

  test('a key needs something to open the space with, and wiping asks first',
      () async {
    await connectedTo(encrypted: true);
    expect(() => run('sync.unlock'), refused('bad_args'));
    expect(() => run('sync.change_passphrase', {'passphrase': ''}),
        refused('bad_args'));
    expect(() => run('sync.reset_encryption', {'passphrase': 'a'}),
        refused('needs_confirmation'));
    expect(actions.find('sync.reset_encryption').risk, ActionRisk.destructive);
    expect(actions.find('sync.unlock').risk, ActionRisk.write);
  });
}
