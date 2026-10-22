// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/connection_manager.dart';
import 'package:aid_diary/sync/internet_transport.dart';
import 'package:aid_diary/sync/lan_transport.dart';
import 'package:aid_diary/sync/relay_packets.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only numeric globally routable endpoints reach direct probes', () {
    for (final host in [
      '127.0.0.1',
      '::1',
      '10.2.3.4',
      '192.168.1.1',
      '172.16.0.1',
      '100.120.93.35',
      '169.254.1.2',
      'fd7a:115c:a1e0::1',
      'fe80::1',
      'ff02::1',
      '2001:db8::1',
      'example.com',
      '0.0.0.0'
    ]) {
      expect(isPublicSyncEndpoint(Uri(scheme: 'http', host: host, port: 1234)),
          isFalse,
          reason: host);
    }
    expect(
        isPublicSyncEndpoint(
            Uri.parse('http://[2607:fb90:9983:e961::1234]:1234')),
        isTrue);
    expect(isPublicSyncEndpoint(Uri.parse('http://8.8.8.8:1234')), isTrue);
    for (final raw in [
      'http://user@8.8.8.8:1234',
      'http://8.8.8.8:1234/v1/file',
      'https://8.8.8.8:1234',
      'http://8.8.8.8:1234/?secret=x'
    ]) {
      expect(isPublicSyncEndpoint(Uri.parse(raw)), isFalse, reason: raw);
    }
  });

  test(
      'relay fragments interoperate, bound memory and recover after malformed input',
      () async {
    final wire = <Uint8List>[];
    final sender = RelayPackets(
        write: (p) async => wire.add(p),
        fragmentBytes: 64,
        maxPacketBytes: 512);
    final receiver = RelayPackets(
        write: (_) async {}, fragmentBytes: 64, maxPacketBytes: 512);
    addTearDown(sender.close);
    addTearDown(receiver.close);
    final delivered = <Uint8List>[], errors = <Object>[];
    receiver.packets.listen(delivered.add, onError: errors.add);
    final bytes = Uint8List.fromList(List.generate(155, (i) => i));
    await sender.send(bytes);
    receiver.receive(wire[1]);
    for (final frame in wire) {
      receiver.receive(frame);
    }
    await Future<void>.delayed(Duration.zero);
    expect(errors, hasLength(1));
    expect(delivered.single, bytes);
    await expectLater(sender.send(Uint8List(513)), throwsFormatException);
  });

  test('real WebSocket relay authenticates peers and carries opaque object RPC',
      () async {
    final hub = await _Hub.start();
    addTearDown(hub.close);
    final aVault = MemorySyncBackend(), bVault = MemorySyncBackend();
    final aRoutes = StreamController<SyncRouteCandidate>.broadcast();
    final bRoutes = StreamController<SyncRouteCandidate>.broadcast();
    addTearDown(aRoutes.close);
    addTearDown(bRoutes.close);
    final key = Uint8List.fromList(List.generate(32, (i) => i));
    InternetTransport client(String id, MemorySyncBackend vault,
            StreamController<SyncRouteCandidate> routes) =>
        InternetTransport(
            endpoint: hub.uri,
            authorization: 'Basic test',
            deviceId: id,
            userId: 'user',
            spaceId: 'space',
            masterKey: key,
            vault: vault,
            localEndpoint: () => Uri.parse('http://[::]:1234'),
            stunUrls: const [],
            enableDirect: false,
            enableIce: false,
            onCandidate: (route) async => routes.add(route),
            onLost: (_) {});
    final a = client('a', aVault, aRoutes), b = client('b', bVault, bRoutes);
    addTearDown(() async {
      // End the fixture's membership before both clients begin closing; a
      // closing Dart WebSocket can still report readyState == open briefly.
      await hub.close();
      await a.close();
      await b.close();
    });
    final aReady = aRoutes.stream.first.timeout(const Duration(seconds: 8));
    final bReady = bRoutes.stream.first.timeout(const Duration(seconds: 8));
    await a.start();
    await b.start();
    final aRoute = await aReady.catchError((Object error) {
      throw StateError(
          'Network readiness: ${a.diagnostics()} ${b.diagnostics()}; frames: ${hub.frames.length}; $error');
    });
    await bReady;
    expect(aRoute.type, SyncRouteType.relay);
    final bytes = Uint8List.fromList(utf8
        .encode(List.filled(1500, 'opaque-test-private-diary-marker').join()));
    await aRoute.backend.write('packs/pack-test', bytes);
    expect(await bVault.read('packs/pack-test'), bytes);
    expect(await aRoute.backend.read('packs/pack-test'), bytes);
    expect(
        hub.frames.join(), isNot(contains('opaque-test-private-diary-marker')));
    expect(hub.frames.join(), isNot(contains('pack-test')));
    expect(a.relayRemainingBytes, lessThan(1 << 20));
    expect(a.diagnostics()['state'], 'online');
    expect(
        hub.frames
            .map((frame) => utf8.encode(frame).length)
            .reduce((a, b) => a > b ? a : b),
        lessThanOrEqualTo(16384));
    final noBudget = hub.clients['a']!;
    noBudget.add(jsonEncode({
      'type': 'budget',
      'relay': {'remainingBytes': 0}
    }));
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await expectLater(aRoute.backend.write('packs/pack-later', bytes),
        throwsA(isA<Exception>()));
    expect(await bVault.read('packs/pack-later'), isNull);
  });

  test('a remote signaling leave preserves an authenticated direct connection',
      () async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final hub = await _Hub.start();
      final key = Uint8List.fromList(List.generate(32, (index) => index));
      final vault = MemorySyncBackend();
      final host = LanMediaHost(
          vault: vault,
          deviceId: 'a',
          userId: 'user',
          spaceId: 'space',
          masterKey: key,
          discovery: _NoDiscovery());
      WebSocket? rawA;
      InternetTransport? b;
      StreamSubscription<dynamic>? subscription;
      try {
        final local =
            await host.start(bindAddress: InternetAddress.loopbackIPv4);
        final advertised =
            Uri(scheme: 'http', host: '8.8.8.8', port: local.port);
        final welcome = Completer<String>();
        final candidate = Completer<SyncRouteCandidate>();
        final routeReady = candidate.future.timeout(const Duration(seconds: 4));
        final leaveProcessed = Completer<void>();
        final lost = <String>[];
        final socket = rawA = await WebSocket.connect(
            hub.uri.replace(
                queryParameters: {'space': 'test', 'device': 'a'}).toString(),
            headers: {'Authorization': 'Basic test'});
        const nonceA = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        final signalKey = Hmac(sha256, key)
            .convert(utf8.encode('aid-network-signal-v1\nuser\nspace'))
            .bytes;
        var replies = 0;
        Future<void> stubTail = Future.value();
        subscription = socket.listen((raw) {
          stubTail = stubTail.then((_) async {
            final frame = jsonDecode(raw as String) as Map<String, dynamic>;
            if (frame['type'] == 'welcome') {
              welcome.complete(frame['session'] as String);
              return;
            }
            if (frame['type'] != 'signal' || replies > 0) return;
            final bytes = base64Decode(frame['payload'] as String);
            final nonceB = bytes
                .sublist(8, 24)
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join();
            final sessionA = await welcome.future;
            final sessionB = frame['session'] as String;
            final sequence = ByteData.sublistView(bytes).getUint64(0);
            final message = jsonDecode(utf8.decode(await openBytes(
                signalKey,
                Uint8List.sublistView(bytes, 24),
                'signal:$sessionB:$sessionA:$nonceB:$sequence'))) as Map;
            if (message['type'] != 'hello') return;
            expect(message['nonce'], nonceB);
            final sealed = await sealBytes(
                signalKey,
                utf8.encode(jsonEncode({
                  'type': 'hello',
                  'nonce': nonceA,
                  'echo': nonceB,
                  'endpoints': [advertised.toString()],
                })),
                'signal:$sessionA:$sessionB:$nonceA:${++replies}');
            final packet = Uint8List(24 + sealed.length);
            ByteData.sublistView(packet).setUint64(0, replies);
            for (var index = 0; index < 16; index++) {
              packet[8 + index] = int.parse(
                  nonceA.substring(index * 2, index * 2 + 2),
                  radix: 16);
            }
            packet.setRange(24, packet.length, sealed);
            socket.add(jsonEncode({
              'type': 'signal',
              'to': 'b',
              'session': sessionB,
              'payload': base64Encode(packet)
            }));
          }).catchError((Object error, StackTrace stack) {
            if (!candidate.isCompleted) candidate.completeError(error, stack);
          });
        });
        await welcome.future.timeout(const Duration(seconds: 4));
        final client = b = InternetTransport(
            endpoint: hub.uri,
            authorization: 'Basic test',
            deviceId: 'b',
            userId: 'user',
            spaceId: 'space',
            masterKey: key,
            vault: MemorySyncBackend(),
            localEndpoint: () => Uri.parse('http://127.0.0.1:1234'),
            stunUrls: const [],
            enableDirect: true,
            enableIce: false,
            enableRelay: false,
            onCandidate: (route) async {
              if (!candidate.isCompleted) candidate.complete(route);
            },
            onLost: (id) {
              lost.add(id);
              if (id.startsWith('relay:a:') && !leaveProcessed.isCompleted) {
                leaveProcessed.complete();
              }
            });
        await client.start();
        final route = await routeReady;
        expect(route.type, SyncRouteType.direct);
        await route.backend.check();
        await route.backend.write('packs/pack-before', Uint8List.fromList([1]));

        await socket.close();
        await leaveProcessed.future.timeout(const Duration(seconds: 4));
        expect(lost, isNot(contains(route.id)));
        expect(client.diagnostics()['peers'], isEmpty,
            reason: 'the signaling leave was actually processed');
        await route.backend.check();
        final bytes = Uint8List.fromList([4, 8, 15, 16]);
        await route.backend.write('packs/pack-after', bytes);
        expect(await route.backend.read('packs/pack-after'), bytes);
        expect(await vault.read('packs/pack-after'), bytes);
        await client.close();
        expect(lost, contains(route.id),
            reason: 'final shutdown still retires the preserved route');
        await stubTail;
      } finally {
        await hub.close();
        await b?.close();
        await subscription?.cancel();
        await rawA?.close();
        await host.close();
      }
    }, _DirectHintOverrides());
  }, timeout: const Timeout(Duration(seconds: 5)));
}

class _Hub {
  _Hub(this.server);
  final HttpServer server;
  final clients = <String, WebSocket>{}, sessions = <String, String>{};
  final frames = <String>[];
  int _nextSession = 0;
  Future<void>? _closing;
  Uri get uri => Uri.parse('ws://127.0.0.1:${server.port}/api/sync/network');
  static Future<_Hub> start() async {
    final hub = _Hub(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
    hub.server.listen((request) async {
      if (hub._closing != null) {
        request.response.statusCode = 503;
        await request.response.close();
        return;
      }
      if (request.headers.value('authorization') != 'Basic test') {
        request.response.statusCode = 401;
        await request.response.close();
        return;
      }
      final id = request.uri.queryParameters['device']!;
      final socket = await WebSocketTransformer.upgrade(request);
      if (hub._closing != null) {
        await socket.close();
        return;
      }
      final peers = [
        for (final entry in hub.sessions.entries)
          {'device': entry.key, 'session': entry.value}
      ];
      final session = (++hub._nextSession).toRadixString(16).padLeft(32, '0');
      socket.add(jsonEncode({
        'type': 'welcome',
        'session': session,
        'peers': peers,
        'relay': {'remainingBytes': 1 << 20, 'maxFrameBytes': 16384}
      }));
      for (final other in hub.clients.values) {
        if (other.readyState == WebSocket.open) {
          other.add(
              jsonEncode({'type': 'join', 'device': id, 'session': session}));
        }
      }
      hub.clients[id] = socket;
      hub.sessions[id] = session;
      socket.listen((raw) {
        hub.frames.add(raw as String);
        final data = jsonDecode(raw) as Map;
        final to = data['to'] as String;
        final target = hub.clients[to];
        if (hub.sessions[to] == data['session'] &&
            target?.readyState == WebSocket.open) {
          target!.add(jsonEncode({
            'type': data['type'],
            'from': id,
            'session': session,
            'payload': data['payload']
          }));
        }
      }, onDone: () {
        if (!identical(hub.clients[id], socket) ||
            hub.sessions[id] != session) {
          return;
        }
        hub.clients.remove(id);
        hub.sessions.remove(id);
        for (final other in hub.clients.values.toList()) {
          if (other.readyState == WebSocket.open) {
            other.add(jsonEncode(
                {'type': 'leave', 'device': id, 'session': session}));
          }
        }
      });
    });
    return hub;
  }

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    final sockets = clients.values.toList();
    // These callbacks no longer own directory membership. Their onDone cannot
    // broadcast leave messages to another socket whose sink is already closing.
    clients.clear();
    sessions.clear();
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
  }
}

class _DirectHintOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.connectionFactory = (uri, _, __) => Socket.startConnect(
        uri.host == '8.8.8.8' ? InternetAddress.loopbackIPv4 : uri.host,
        uri.port);
    client.findProxy = (_) => 'DIRECT';
    return client;
  }
}

class _NoDiscovery implements LanDiscovery {
  @override
  Stream<LanCandidate> get candidates => const Stream.empty();
  @override
  Future<void> start(LanAdvertisement local) async {}
  @override
  Future<void> close() async {}
}
