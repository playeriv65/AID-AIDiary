// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../support/config_provider_harness.dart';

class _Keys implements DeviceKeyStore {
  final signed = <String>[];
  final deleted = <String>[];
  int count = 0;
  @override
  Future<Map<String, Object?>> ensure(String alias) async => {
        'publicKeySpki': base64Encode([1, 2, 3, ++count]),
        'hardwareBacked': false,
        'provider': 'test'
      };
  @override
  Future<Uint8List> sign(String alias, List<int> message) async {
    signed.add(utf8.decode(message));
    return Uint8List.fromList([4, 5, 6]);
  }

  @override
  Future<void> delete(String alias) async {
    deleted.add(alias);
  }
}

DeviceRegistration _registration() => DeviceRegistration(
    server: Uri.parse('https://example.org/dav/'),
    username: 'alice',
    id: 'device-a',
    alias: 'alias-a',
    publicKeySpki: base64Encode([1, 2, 3]),
    hardwareBacked: false,
    provider: 'test');
http.Response _json(Object value) => http.Response(jsonEncode(value), 200,
    headers: {'Content-Type': 'application/json'});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();
  test(
      'concurrent token requests share one nonce/signature exchange and never persist tokens',
      () async {
    final keys = _Keys();
    final record = _registration();
    var challenges = 0, tokens = 0;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/challenge')) {
        challenges++;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return _json({
          'challenge': 'a' * 43,
          'message': base64Encode(utf8.encode(
              'aid-device-token-v1\nalice\ndevice-a\n${record.fingerprint}\n${'a' * 43}'))
        });
      }
      tokens++;
      return _json({
        'token': 'b' * 43,
        'expires': DateTime.now()
                .add(const Duration(minutes: 15))
                .millisecondsSinceEpoch ~/
            1000
      });
    });
    final session = DeviceAuthSession(record, keys, client);
    expect(
        await Future.wait([session.authorization(), session.authorization()]),
        ['Bearer ${'b' * 43}', 'Bearer ${'b' * 43}']);
    expect(challenges, 1);
    expect(tokens, 1);
    expect(keys.signed, hasLength(1));
    expect(ConfigProvider.instance.get(Settings.deviceAuthorizations), isEmpty);
  });
  test(
      'malicious challenge cannot use the native key as another-device or cross-protocol signing oracle',
      () async {
    for (final message in [
      'aid-device-enroll-v1\nalice\nnew-device\nkey',
      'aid-device-token-v1\nalice\nother-device\nwrong-fingerprint\n${'a' * 43}'
    ]) {
      final keys = _Keys();
      final session = DeviceAuthSession(
          _registration(),
          keys,
          MockClient((_) async => _json({
                'challenge': 'a' * 43,
                'message': base64Encode(utf8.encode(message))
              })));
      await expectLater(session.authorization(), throwsFormatException);
      expect(keys.signed, isEmpty);
    }
  });
  test('ordinary DAV does not create platform keys or registrations', () async {
    final keys = _Keys();
    final manager = DeviceAuthManager(
        keys: keys, client: MockClient((_) async => http.Response('', 404)));
    expect(
        await manager.prepare(
            Uri.parse('https://dav.example.org/dav/'), 'alice', 'secret'),
        false);
    expect(keys.count, 0);
    expect(manager.registrations, isEmpty);
  });
  test('device authorization QR is bound to the selected server and account',
      () async {
    final record = _registration();
    await ConfigProvider.instance
        .set(Settings.deviceAuthorizations, jsonEncode([record.toJson()]));
    final manager = DeviceAuthManager(
        keys: _Keys(),
        client: MockClient((_) async =>
            throw StateError('No network for mismatched request')));
    final forged =
        Uri(scheme: 'aid-device', host: 'authorize', queryParameters: {
      'v': '1',
      'request': base64UrlEncode(utf8.encode(jsonEncode({
        'server': 'https://another.example/dav/',
        'username': 'alice',
        'id': 'new-device',
        'publicKeySpki': '',
        'signature': ''
      })))
    }).toString();
    await expectLater(
        manager.authorize(manager.session(record.server, 'alice')!, forged),
        throwsFormatException);
  });
  test('registration and token issuance refuse remote cleartext endpoints',
      () async {
    final keys = _Keys();
    final manager = DeviceAuthManager(
        keys: keys,
        client:
            MockClient((_) async => _json({'protocol': 'aid-device-auth-v1'})));
    await expectLater(
        manager.prepare(
            Uri.parse('http://example.org/dav/'), 'alice', 'secret'),
        throwsStateError);
    expect(keys.count, 0);
  });

  test(
      'an offline SAS-approved public-key request persists and retries without copying login secrets',
      () async {
    final record = _registration();
    await ConfigProvider.instance
        .set(Settings.deviceAuthorizations, jsonEncode([record.toJson()]));
    final qr = Uri(scheme: 'aid-device', host: 'authorize', queryParameters: {
      'v': '1',
      'request': base64UrlEncode(utf8.encode(jsonEncode({
        'server': record.toJson()['server'],
        'username': 'alice',
        'id': 'new-device',
        'label': 'new phone',
        'publicKeySpki': base64Encode([7, 8]),
        'signature': base64Encode([9])
      })))
    }).toString();
    final offline = DeviceAuthManager(
        keys: _Keys(),
        client:
            MockClient((_) async => throw const SocketException('offline')));
    final generated =
        Uri.parse(await offline.authorizationRequest(record.server, 'alice'));
    final generatedBody = jsonDecode(utf8.decode(
        base64Url.decode(generated.queryParameters['request']!))) as Map;
    expect(generatedBody['server'], record.toJson()['server'],
        reason:
            'real authorization QR and persisted registration use the same canonical server');
    expect(
        await offline.queueAndAuthorize(
            offline.session(record.server, 'alice')!, qr),
        false);
    final stored = ConfigProvider.instance.get(Settings.pendingDeviceApprovals);
    expect((jsonDecode(stored) as List).single['request'], qr);
    expect(stored, isNot(contains('password')));
    expect(stored, isNot(contains('Bearer')));
    var authorized = 0;
    final online = DeviceAuthManager(
        keys: _Keys(),
        client: MockClient((request) async {
          if (request.url.path.endsWith('/challenge')) {
            return _json({
              'challenge': 'a' * 43,
              'message': base64Encode(utf8.encode(
                  'aid-device-token-v1\nalice\ndevice-a\n${record.fingerprint}\n${'a' * 43}'))
            });
          }
          if (request.url.path.endsWith('/token')) {
            return _json({
              'token': 'b' * 43,
              'expires': DateTime.now()
                      .add(const Duration(minutes: 15))
                      .millisecondsSinceEpoch ~/
                  1000
            });
          }
          expect(request.headers['Authorization'], 'Bearer ${'b' * 43}');
          expect(jsonDecode(request.body)['id'], 'new-device');
          authorized++;
          return _json({'authorized': true});
        }));
    expect(await online.flushApprovals(record.server, 'alice'), true);
    expect(authorized, 1);
    expect(
        jsonDecode(
            ConfigProvider.instance.get(Settings.pendingDeviceApprovals)),
        isEmpty);
  });
}
