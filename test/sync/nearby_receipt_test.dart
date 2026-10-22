// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/storage/secret_store.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/nearby_migration.dart';
import 'package:aid_diary/sync/nearby_receipt.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/config_provider_harness.dart';

class _FailClear implements SecretStore {
  _FailClear(this.inner);
  final SecretStore inner;
  bool failed = false;
  @override
  Future<bool> isAvailable() => inner.isAvailable();
  @override
  Future<String?> read(String key) => inner.read(key);
  @override
  Future<void> delete(String key) => inner.delete(key);
  @override
  Future<void> write(String key, String value) async {
    if (!failed &&
        key == Settings.nearbyMigration.key &&
        value == jsonEncode('')) {
      failed = true;
      throw StateError('Native clear unavailable');
    }
    await inner.write(key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();
  test('a native clear failure preserves receipt state and retries quietly',
      () async {
    final identity = DiaryIdentity.create();
    await identity.keep();
    final grant = NearbyMigrationGrant(
        spaceId: '00000000-0000-0000-0000-000000000000',
        deviceId: 'source',
        dataKey: identity.masterKey,
        expires: DateTime.now().add(const Duration(hours: 1)),
        endpoints: [
          Uri(
              scheme: 'http',
              host: InternetAddress.loopbackIPv4.address,
              port: 12345)
        ]);
    final pending = jsonEncode({
      'phase': 'receipt',
      'identity': identity.toJson(),
      'transfer': grant.toJson()
    });
    await ConfigProvider.instance.set(Settings.nearbyMigration, pending);
    final store = _FailClear(SecretStore.instance);
    SecretStore.instance = store;
    var sent = 0;
    final queue = NearbyReceiptQueue(
        send: (grant, identity) async {
          sent++;
        },
        retryDelay: const Duration(hours: 1));
    addTearDown(queue.dispose);
    expect(await queue.flush(), false);
    expect(store.failed, true);
    expect(sent, 1);
    expect(ConfigProvider.instance.get(Settings.nearbyMigration), pending);
    expect(ConfigProvider.instance.get(Settings.identity),
        jsonEncode(identity.toJson()));
    expect(await queue.flush(), true);
    expect(sent, 1,
        reason:
            'the successful sender receipt does not need network again to retry its local clear');
    expect(ConfigProvider.instance.get(Settings.nearbyMigration), isEmpty);
  });
}
