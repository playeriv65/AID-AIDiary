// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';
import '../support/memory_login.dart';

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);
  final sync = SyncService.instance;

  setUpAll(() async {
    // The real recovery cost takes seconds per try; tests need none of it.
    final config = jsonDecode(await rootBundle.loadString(AppConfig.assetPath))
        as Map<String, dynamic>;
    (config['sync']['recovery'] as Map)
      ..['argon2MemoryKiB'] = 64
      ..['argon2Iterations'] = 1;
    AppConfig.setForTesting(config);
  });

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {},
          bool confirmed = false]) async =>
      (await actions.run(id, args, confirmed: confirmed))
          as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  tearDown(() async {
    sync.unsyncedEntryIds = const {};
    await sync.disconnect();
  });

  test('the status names the entries still waiting to go up', () async {
    expect(await run('sync.status'), containsPair('unsyncedIds', isEmpty));
    sync.unsyncedEntryIds = {7, 3};
    final status = await run('sync.status');
    expect(status['unsyncedIds'], [3, 7]);
    expect(status['unsyncedEntries'], 2);
  });

  test(
      'copy details use the account device ID and do not list this device twice',
      () async {
    final login = MemoryLogin();
    final registration = DeviceRegistration(
        server: login.server!,
        username: login.username,
        id: 'registered-tablet',
        alias: 'test-key',
        publicKeySpki: 'AQID',
        hardwareBacked: false,
        provider: 'test');
    await ConfigProvider.instance.set(
        Settings.deviceAuthorizations, jsonEncode([registration.toJson()]));
    await sync.createSpace(login);
    await sync.syncNow();
    final copies = await run('sync.copies');
    expect((copies['local'] as Map)['id'], registration.id);
    expect(copies['devices'], isEmpty);
  });

  test('keys and pairing need a space this device is set up with', () async {
    expect(() => run('sync.unlock', {'recoveryCode': 'a'}),
        refused('not_connected'));
    expect(() => run('sync.recovery_code', {}, true), refused('needs_key'));
    expect(() => run('sync.reset_space', {}, true), refused('not_connected'));
    expect(() => run('sync.pair_offer'), refused('not_connected'));
    expect(() => run('sync.pair_accept', {'code': '12-345678'}),
        refused('not_connected'));
    expect(
        () => run('sync.pair_accept', {'code': 'twelve'}), refused('bad_args'));
  });

  test('replacing the recovery code or the space asks first', () {
    expect(actions.find('sync.recovery_code').risk, ActionRisk.destructive);
    expect(actions.find('sync.reset_space').risk, ActionRisk.destructive);
    expect(() => run('sync.recovery_code'), refused('needs_confirmation'));
  });

  test('a space is made, its code replaced, and a new device recovers it',
      () async {
    final storage = MemorySyncBackend();
    final login = MemoryLogin(storage);
    final owner = await DiaryIdentity.current();

    final first = await sync.createSpace(login);
    final space = SpaceInfo.fromBytes((await storage.read(SpaceLayout.info))!);
    expect(space.userId, owner.userId);
    await sync.syncNow();
    expect(sync.error, isNull);

    // A chosen password must be long enough; a random one replaces the
    // first code, which stops working.
    expect(() => run('sync.recovery_code', {'password': 'short'}, true),
        refused('bad_args'));
    final second =
        (await run('sync.recovery_code', {}, true))['recoveryCode'] as String;
    expect(second, isNot(first));
    final changed =
        SpaceInfo.fromBytes((await storage.read(SpaceLayout.info))!);
    expect(changed.recovery.unlock(owner.userId, first),
        throwsA(isA<WrongKeyException>()));

    // Another device: a user of its own, so the space is not its yet.
    await sync.disconnect();
    final stranger = DiaryIdentity.create();
    await stranger.keep();
    await expectLater(
        sync.joinSpace(login, changed), throwsA(isA<NeedsKeyException>()));
    expect(sync.pendingSpace?.id, changed.id);
    expect(await run('sync.status'), containsPair('waitingForKey', true));

    await expectLater(
        sync.recover(login, changed, first), throwsA(isA<WrongKeyException>()));
    await sync.recover(login, changed, second.toLowerCase());
    expect(sync.pendingSpace, isNull);
    final now = await DiaryIdentity.current();
    expect(now.userId, owner.userId);
    expect(now.masterKey, owner.masterKey);
    expect(await sync.holdsKey(changed), isTrue);
  });
}
