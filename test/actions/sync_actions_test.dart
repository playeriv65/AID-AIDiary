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
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/pairing.dart';
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

  test('network diagnostics distinguish pending and confirmed remote media',
      () async {
    final db = AppDatabase.instance.database!;
    for (final (id, sending, completed, durable) in [
      ('pending-upload', 1, 0, 0),
      ('pending-download', 0, 0, 0),
      ('confirmed-upload', 1, 1, 1),
      ('temporary-upload', 1, 1, 0),
      ('finished-download', 0, 1, 1),
    ]) {
      await db.insert('sync_media_tasks', {
        'id': id,
        'name': '$id.jpg',
        'sending': sending,
        'completed': completed,
        'durable': durable,
      });
    }
    expect(
        await run('sync.network'),
        allOf(
          containsPair('pendingMedia', 2),
          containsPair('durableRemoteMedia', 1),
          containsPair('temporaryOrUnconfirmedRemoteMedia', 1),
        ));
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

  test('an invalid reset password leaves the active space intact', () async {
    final storage = MemorySyncBackend();
    final login = MemoryLogin(storage);
    await sync.createSpace(login);
    await run('entry.create', {'text': 'A local diary entry'});
    await sync.syncNow();
    final original = (await storage.read(SpaceLayout.info))!;
    final packs = await storage.list(SpaceLayout.packs);
    expect(packs, isNotEmpty);

    await expectLater(run('sync.reset_space', {'password': 'short'}, true),
        refused('bad_args'));
    expect(await storage.read(SpaceLayout.info), original);
    expect(await storage.list(SpaceLayout.packs), packs);
    expect(storage.files.keys.where((path) => path.startsWith('generations/')),
        isEmpty);
  });

  test('reset sync and pairing use new paths while legacy objects stay intact',
      () async {
    final storage = MemorySyncBackend();
    final login = MemoryLogin(storage);
    final owner = await DiaryIdentity.current();
    await sync.createSpace(login);
    await run('entry.create', {'text': 'A local diary entry'});
    await sync.syncNow();
    final original = (await storage.read(SpaceLayout.info))!;
    final originalSpace = SpaceInfo.fromBytes(original);
    expect(originalSpace.format, SpaceInfo.legacy);
    final originalPacks = await storage.list(SpaceLayout.packs);
    expect(originalPacks, isNotEmpty);

    final result = await run('sync.reset_space', {}, true);
    final active = SpaceInfo.fromBytes((await storage.read(SpaceLayout.info))!);
    expect(active.format, SpaceInfo.current);
    expect(active.id, isNot(originalSpace.id));
    expect(sync.target?.spaceId, active.id);
    expect(sync.error, isNull);
    final generation = SpaceLayout.generation(active.id);
    final scoped = active.storageFor(storage);
    expect(await scoped.list(SpaceLayout.packs), isNotEmpty);
    expect(await storage.list(SpaceLayout.packs), originalPacks);
    expect(await storage.read('$generation/previous-space.json'), original);

    // An already running old client writes to the legacy paths only.
    await storage.write('packs/pack-old-client', Uint8List.fromList([0]));
    await sync.syncNow();
    expect(sync.error, isNull);
    expect(await scoped.read('packs/pack-old-client'), isNull);

    final offered = await sync.offerPairing();
    expect(await storage.list('pairing'), isEmpty);
    expect(await scoped.list('pairing'), isNotEmpty);
    final stranger = Pairing(
        backend: scoped,
        space: active,
        identity: DiaryIdentity.create(),
        holdsKey: false,
        deviceName: 'New device',
        poll: const Duration(milliseconds: 5),
        timeout: const Duration(seconds: 10));
    final paired = await stranger.accept(offered);
    expect(paired.received?.masterKey, owner.masterKey);

    final previousCode = result['recoveryCode'] as String;
    final changedCode = await sync.changeRecoveryCode();
    final changed =
        SpaceInfo.fromBytes((await storage.read(SpaceLayout.info))!);
    expect(changed.id, active.id);
    expect(await changed.recovery.unlock(owner.userId, changedCode),
        owner.masterKey);
    await expectLater(changed.recovery.unlock(owner.userId, previousCode),
        throwsA(isA<WrongKeyException>()));
    expect(await storage.read('$generation/previous-space.json'), original);
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
