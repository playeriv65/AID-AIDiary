// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/lan_transport.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = Uint8List.fromList(List.generate(32, (i) => i));
int _sequence = 0;

void main() {
  late MemorySyncBackend vault;
  late _Discovery discovery;
  late LanMediaHost host;
  late Uri endpoint;
  late LanMediaBackend backend;

  setUp(() async {
    vault = MemorySyncBackend();
    discovery = _Discovery();
    host = LanMediaHost(
        vault: vault,
        deviceId: 'device-a',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: discovery,
        maxBytes: 1024);
    endpoint = await host.start(bindAddress: InternetAddress.loopbackIPv4);
    backend = (await LanMediaBackend.connect(
            endpoint: endpoint,
            userId: 'user',
            spaceId: 'space',
            masterKey: _key))
        .backend;
  });

  tearDown(() async {
    backend.close();
    await host.close();
  });

  test('verified peers exchange only media and retain ciphertext hashes',
      () async {
    final bytes = Uint8List.fromList([42, 88, 93]);
    final chunk = 'media/chunks/photo/${sha256.convert(bytes)}';
    await backend.write(chunk, bytes);
    await backend.write('media/manifests/photo', Uint8List.fromList([4, 5]));
    expect(await backend.read(chunk), bytes);
    expect(await backend.list('media/manifests'),
        {'media/manifests/photo': isA<String>()});
    expect(await backend.list('media/chunks/photo'), {chunk: isA<String>()});
    await backend.delete(chunk);
    expect(await backend.read(chunk), isNull);
    expect(vault.files.keys, ['media/manifests/photo']);
  });

  test('authenticated peers exchange encrypted copy confirmations', () async {
    final bytes = Uint8List.fromList([3, 7, 9]);
    await backend.write('copies/tablet', bytes);
    expect(await backend.list('copies'), {'copies/tablet': isA<String>()});
    expect(await backend.read('copies/tablet'), bytes);
  });

  test('wrong keys and space bindings cannot pass probe', () async {
    for (final (key, space) in [
      (Uint8List(32), 'space'),
      (_key, 'another-space'),
    ]) {
      await expectLater(
          LanMediaBackend.connect(
              endpoint: endpoint,
              userId: 'user',
              spaceId: space,
              masterKey: key),
          throwsFormatException);
    }
  });

  test('client refuses unrelated paths, traversal and malformed hashes',
      () async {
    for (final path in [
      'identity.json',
      'packs/not-a-pack',
      'media/manifests/../space.json',
      r'media/manifests/a\b',
      'media/chunks/photo/not-a-hash'
    ]) {
      await expectLater(backend.read(path), throwsArgumentError);
    }
  });

  test('sealed space info and encrypted packs support offline diary sync',
      () async {
    final ciphertext = Uint8List.fromList([8, 4, 9]);
    for (final path in [
      'space.json',
      'packs/pack-000123-abcdef',
      'packs/snapshot-000124-abcdef'
    ]) {
      await backend.write(path, ciphertext);
      expect(await backend.read(path), ciphertext);
    }
    expect((await backend.list('packs')).keys,
        ['packs/pack-000123-abcdef', 'packs/snapshot-000124-abcdef']);
  });

  test('server independently rejects authenticated traversal', () async {
    final uri = endpoint.replace(
        path: '/v1/file',
        queryParameters: {'path': 'media/manifests/../space.json'});
    expect(await _signedRequest(uri), 400);
    expect(vault.files, isEmpty);
  });

  test('server rejects replayed and expired signed requests', () async {
    final uri = endpoint.replace(path: '/v1/probe');
    const nonce = '00112233445566778899aabbccddeeff';
    final now = DateTime.now().millisecondsSinceEpoch;
    expect(await _signedRequest(uri, nonce: nonce, time: now), 200);
    expect(await _signedRequest(uri, nonce: nonce, time: now), 401);
    expect(await _signedRequest(uri, time: now - 180000), 401);
  });

  test('a captured request cannot be replayed to another host session',
      () async {
    late String firstAudience;
    await _signedRequest(endpoint.replace(path: '/v1/probe'),
        onResponse: (bytes) {
      firstAudience =
          (jsonDecode(utf8.decode(bytes)) as Map)['audience'] as String;
    });
    final second = LanMediaHost(
        vault: MemorySyncBackend(),
        deviceId: 'device-b',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: _Discovery());
    addTearDown(second.close);
    final address =
        await second.start(bindAddress: InternetAddress.loopbackIPv4);
    final uri = address.replace(
        path: '/v1/file', queryParameters: {'path': 'media/manifests/photo'});
    expect(await _signedRequest(uri, audienceOverride: firstAudience), 401);
    expect(await _signedRequest(uri), 404);
  });

  test('IPv6 uses the same authenticated object protocol', () async {
    final ipv6 = LanMediaHost(
        vault: vault,
        deviceId: 'device-v6',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: _Discovery());
    addTearDown(ipv6.close);
    final address = await ipv6.start(bindAddress: InternetAddress.loopbackIPv6);
    final peer = await LanMediaBackend.connect(
        endpoint: address, userId: 'user', spaceId: 'space', masterKey: _key);
    addTearDown(peer.backend.close);
    await peer.backend.write('media/manifests/photo', Uint8List.fromList([6]));
    expect(await backend.read('media/manifests/photo'), [6]);
  });

  test('body tampering is rejected before the vault is modified', () async {
    final uri = endpoint.replace(
        path: '/v1/file', queryParameters: {'path': 'media/manifests/photo'});
    expect(
        await _signedRequest(uri,
            method: 'PUT',
            signedBody: Uint8List.fromList([1]),
            sentBody: Uint8List.fromList([2])),
        401);
    expect(vault.files, isEmpty);
  });

  test('bounded requests and responses reject large data', () async {
    await expectLater(backend.write('media/manifests/large', Uint8List(1025)),
        throwsA(isA<Exception>()));
    expect(vault.files, isEmpty);
    await vault.write('media/manifests/large', Uint8List(1025));
    await expectLater(
        backend.read('media/manifests/large'), throwsA(isA<Exception>()));
  });

  test('invalid chunk digest does not enter the vault', () async {
    await expectLater(
        backend.write(
            'media/chunks/photo/${'0' * 64}', Uint8List.fromList([1])),
        throwsFormatException);
    expect(vault.files, isEmpty);
  });

  test('a corrupt peer chunk fails ciphertext verification', () async {
    final path = 'media/chunks/photo/${'0' * 64}';
    await vault.write(path, Uint8List.fromList([1]));
    await expectLater(backend.read(path), throwsFormatException);
  });

  test('discovery hint becomes a peer only after authenticated probe',
      () async {
    final secondDiscovery = _Discovery();
    final second = LanMediaHost(
        vault: MemorySyncBackend(),
        deviceId: 'device-b',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: secondDiscovery);
    addTearDown(second.close);
    await second.start(bindAddress: InternetAddress.loopbackIPv4);
    final peer = second.peers.first;
    secondDiscovery.controller
        .add(LanCandidate(endpoint, secondDiscovery.local!.tag));
    final verified = await peer.timeout(const Duration(seconds: 2));
    expect(verified.id, 'device-a');
    expect(verified.userId, 'user');
    expect(verified.spaceId, 'space');
    await verified.backend.check();
  });

  test('responses without a valid signature cannot impersonate a peer',
      () async {
    final fake = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => fake.close(force: true));
    fake.listen((request) async {
      request.response.write(
          jsonEncode({'id': 'attacker', 'userId': 'user', 'spaceId': 'space'}));
      await request.response.close();
    });
    await expectLater(
        LanMediaBackend.connect(
            endpoint: Uri.parse('http://127.0.0.1:${fake.port}'),
            userId: 'user',
            spaceId: 'space',
            masterKey: _key),
        throwsFormatException);
  });

  test('a second verified address does not close a healthy alternate',
      () async {
    final observerDiscovery = _Discovery();
    final observer = LanMediaHost(
        vault: MemorySyncBackend(),
        deviceId: 'observer',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: observerDiscovery);
    addTearDown(observer.close);
    await observer.start(bindAddress: InternetAddress.loopbackIPv4);
    final first = observer.peers.first;
    observerDiscovery.controller
        .add(LanCandidate(endpoint, observerDiscovery.local!.tag));
    final firstPeer = await first;

    final alternate = LanMediaHost(
        vault: vault,
        deviceId: 'device-a',
        userId: 'user',
        spaceId: 'space',
        masterKey: _key,
        discovery: _Discovery());
    addTearDown(alternate.close);
    final alternateAddress =
        await alternate.start(bindAddress: InternetAddress.loopbackIPv6);
    final second = observer.peers.first;
    observerDiscovery.controller
        .add(LanCandidate(alternateAddress, observerDiscovery.local!.tag));
    final secondPeer = await second;
    await secondPeer.backend.check();
    await firstPeer.backend.check();
    expect(secondPeer.id, firstPeer.id);
  });
}

class _Discovery implements LanDiscovery {
  final controller = StreamController<LanCandidate>.broadcast();
  LanAdvertisement? local;
  @override
  Stream<LanCandidate> get candidates => controller.stream;
  @override
  Future<void> start(LanAdvertisement local) async => this.local = local;
  @override
  Future<void> close() => controller.close();
}

Future<int> _signedRequest(Uri uri,
    {String method = 'GET',
    String nonce = 'ffeeddccbbaa99887766554433221100',
    int? time,
    String? audienceOverride,
    void Function(List<int>)? onResponse,
    Uint8List? signedBody,
    Uint8List? sentBody}) async {
  var audience = audienceOverride ?? '';
  if (uri.path != '/v1/probe' && audienceOverride == null) {
    await _signedRequest(uri.replace(path: '/v1/probe', query: ''),
        nonce: (++_sequence).toRadixString(16).padLeft(32, '0'),
        onResponse: (bytes) {
      audience = (jsonDecode(utf8.decode(bytes)) as Map)['audience'] as String;
    });
  }
  final body = signedBody ?? Uint8List(0);
  final timestamp = time ?? DateTime.now().millisecondsSinceEpoch;
  final key = Hmac(sha256, _key)
      .convert(utf8.encode('aid-lan-media-v1\nuser\nspace'))
      .bytes;
  final canonical = 'request\n$method\n${uri.path}'
      '${uri.hasQuery ? '?${uri.query}' : ''}'
      '\n$timestamp\n$nonce\n${sha256.convert(body)}\n$audience';
  final signature = Hmac(sha256, key).convert(utf8.encode(canonical));
  final client = HttpClient()..findProxy = (_) => 'DIRECT';
  try {
    final request = await client.openUrl(method, uri);
    request.headers.set('x-aid-time', timestamp.toString());
    request.headers.set('x-aid-nonce', nonce);
    request.headers.set('x-aid-audience', audience);
    request.headers.set('x-aid-signature', signature.toString());
    request.add(sentBody ?? body);
    final response = await request.close();
    final bytes = await response.expand((part) => part).toList();
    onResponse?.call(bytes);
    return response.statusCode;
  } finally {
    client.close(force: true);
  }
}
