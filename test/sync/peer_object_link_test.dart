// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/peer_object_link.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = Uint8List.fromList(List.generate(32, (index) => index));

void main() {
  final pairs = <_Pair>[];
  _Pair pair({
    SyncBackend? aVault,
    SyncBackend? bVault,
    Uint8List? bKey,
    String bUser = 'user',
    String bSpace = 'space',
    String bTransport = 'ice',
    String bSession = 'session-b',
    int maxBytes = 16 * 1024 * 1024 + 64 * 1024,
    int maxPacketBytes = 24 * 1024 * 1024,
    int aConcurrent = 4,
    int bConcurrent = 4,
    int maxListEntries = 4096,
    Duration aTimeout = const Duration(seconds: 2),
    Duration bTimeout = const Duration(seconds: 2),
  }) {
    final value = _Pair(
        aVault: aVault,
        bVault: bVault,
        bKey: bKey,
        bUser: bUser,
        bSpace: bSpace,
        bTransport: bTransport,
        bSession: bSession,
        maxBytes: maxBytes,
        maxPacketBytes: maxPacketBytes,
        aConcurrent: aConcurrent,
        bConcurrent: bConcurrent,
        maxListEntries: maxListEntries,
        aTimeout: aTimeout,
        bTimeout: bTimeout);
    pairs.add(value);
    return value;
  }

  tearDown(() async {
    for (final value in pairs) {
      await value.close();
    }
    pairs.clear();
  });

  test('does not probe automatically and supports simultaneous check both ways',
      () async {
    final links = pair();
    expect(links.sentA, isEmpty);
    expect(links.sentB, isEmpty);
    await Future.wait([links.a.backend.check(), links.b.backend.check()]);
    expect(links.sentA, hasLength(2));
    expect(links.sentB, hasLength(2));
    expect(links.a.isClosed, isFalse);
    expect(links.b.isClosed, isFalse);
  });

  test('exchanges encrypted metadata and chunks with independent vaults',
      () async {
    final first = MemorySyncBackend();
    final second = MemorySyncBackend();
    final links = pair(aVault: first, bVault: second);
    final bytes = Uint8List.fromList([19, 28, 99]);
    final path = 'media/chunks/photo/${sha256.convert(bytes)}';
    await links.a.backend.write(path, bytes);
    expect(await links.a.backend.read(path), bytes);
    expect(await links.a.backend.list('media/chunks/photo'), {path: 'v1'});
    await links.b.backend.write('packs/pack-test', bytes);
    expect(await links.b.backend.read('packs/pack-test'), bytes);
    expect(first.files.keys, ['packs/pack-test']);
    expect(second.files.keys, [path]);
    final packetText = utf8.decode(links.sentA.first, allowMalformed: true);
    expect(packetText, isNot(contains(path)));
    expect(packetText, isNot(contains('"op"')));
    await links.a.backend.delete(path);
    expect(await links.a.backend.read(path), isNull);
  });

  test('serializes encryption and sends during concurrent full-duplex work',
      () async {
    final links = pair();
    final operations = <Future<void>>[];
    for (var index = 0; index < 4; index++) {
      final bytes = Uint8List.fromList([index]);
      operations.add(links.a.backend.write('packs/pack-a$index', bytes));
      operations.add(links.b.backend.write('packs/pack-b$index', bytes));
    }
    await Future.wait(operations);
    for (final packets in [links.sentA, links.sentB]) {
      expect(packets.map((packet) => ByteData.sublistView(packet).getUint64(1)),
          orderedEquals(List.generate(8, (index) => index + 1)));
    }
  });

  test('default packet budget carries a full configured metadata pack',
      () async {
    final vault = MemorySyncBackend();
    final links = pair(
        bVault: vault,
        aTimeout: const Duration(seconds: 15),
        bTimeout: const Duration(seconds: 15));
    final bytes = Uint8List(16 * 1024 * 1024 + 29);
    await links.a.backend.write('packs/pack-full', bytes);
    expect((await vault.read('packs/pack-full'))?.length, bytes.length);
    expect(links.sentA.single.length, lessThan(24 * 1024 * 1024));
  });

  test('rejects wrong master keys, identities, spaces and transport bindings',
      () async {
    final invalid = [
      pair(bKey: Uint8List(32), aTimeout: const Duration(milliseconds: 80)),
      pair(bUser: 'other-user', aTimeout: const Duration(milliseconds: 80)),
      pair(bSpace: 'other-space', aTimeout: const Duration(milliseconds: 80)),
      pair(bTransport: 'relay', aTimeout: const Duration(milliseconds: 80)),
    ];
    await Future.wait([
      for (final links in invalid)
        expectLater(links.a.backend.check(), throwsA(isA<TimeoutException>()))
    ]);
    for (final links in invalid) {
      await _until(() => links.b.isClosed);
      expect(links.b.isClosed, isTrue);
    }
  });

  test('fresh endpoint sessions reject an otherwise valid stale link packet',
      () async {
    final links = pair(
        bSession: 'other-session', aTimeout: const Duration(milliseconds: 80));
    await expectLater(
        links.a.backend.check(), throwsA(isA<TimeoutException>()));
    await _until(() => links.b.isClosed);
    expect(links.b.isClosed, isTrue);
  });

  test('replayed authenticated writes never reach the vault twice', () async {
    final vault = _CountingVault();
    final links = pair(bVault: vault);
    await links.a.backend.write('packs/pack-once', Uint8List.fromList([1]));
    links.incomingB.add(links.sentA.first);
    await _until(() => links.b.isClosed);
    expect(vault.writes, 1);
    expect(links.b.isClosed, isTrue);
  });

  test('reflection and unauthenticated sequence edits fail the entire link',
      () async {
    final reflected = pair();
    await reflected.a.backend.check();
    reflected.incomingA.add(reflected.sentA.first);
    await _until(() => reflected.a.isClosed);
    expect(reflected.a.isClosed, isTrue);

    final edited = pair();
    edited.transformA = (packet) async {
      ByteData.sublistView(packet).setUint64(1, 2);
      return packet;
    };
    final request = edited.a.backend.check();
    final failure = expectLater(request, throwsA(isA<PeerObjectException>()));
    await _until(() => edited.b.isClosed);
    await edited.a.close();
    await failure;
  });

  test('client rejects unrelated paths, traversal and wrong ciphertext hashes',
      () async {
    final links = pair();
    for (final path in [
      'identity.json',
      '../space.json',
      'packs/not-a-pack',
      'media/manifests/../space.json',
      r'media/manifests/a\b',
      'media/chunks/photo/not-a-hash',
    ]) {
      await expectLater(links.a.backend.read(path), throwsArgumentError);
      await expectLater(links.a.backend.delete(path), throwsArgumentError);
    }
    final path = 'media/chunks/photo/${'0' * 64}';
    await expectLater(links.a.backend.write(path, Uint8List.fromList([1])),
        throwsFormatException);
    expect(links.sentA, isEmpty);
  });

  test('host validates paths even from a key-holding malformed client',
      () async {
    final vault = _CountingVault();
    final links = pair(bVault: vault);
    links.transformA = (packet) => _alter(packet, (message) {
          message['path'] = '../identity.json';
        });
    await expectLater(
        links.a.backend.write('packs/pack-ok', Uint8List.fromList([1])),
        _peerError('forbidden_path'));
    expect(vault.writes, 0);
  });

  test('host verifies ciphertext hashes before storing a modified block',
      () async {
    final vault = _CountingVault();
    final links = pair(bVault: vault);
    links.transformA = (packet) => _alter(packet, (message) {
          message['bytes'] = base64.encode([9]);
        });
    final bytes = Uint8List.fromList([1]);
    final path = 'media/chunks/photo/${sha256.convert(bytes)}';
    await expectLater(
        links.a.backend.write(path, bytes), _peerError('hash_mismatch'));
    expect(vault.writes, 0);
  });

  test('bounds objects on both ends, including malicious base64 bodies',
      () async {
    final vault = MemorySyncBackend();
    final links = pair(bVault: vault, maxBytes: 32);
    await expectLater(links.a.backend.write('space.json', Uint8List(33)),
        throwsArgumentError);
    await vault.write('space.json', Uint8List(33));
    await expectLater(
        links.a.backend.read('space.json'), _peerError('object_too_large'));
    links.transformA = (packet) => _alter(packet, (message) {
          message['bytes'] = base64.encode(Uint8List(33));
        });
    await expectLater(links.a.backend.write('packs/pack-large', Uint8List(1)),
        _peerError('object_too_large'));
    expect(vault.files.keys, ['space.json']);
  });

  test('bounds listings and filters files outside the ciphertext namespace',
      () async {
    final vault = MemorySyncBackend();
    final links = pair(bVault: vault, maxListEntries: 2);
    await vault.write('packs/not-a-pack', Uint8List(1));
    await vault.write('packs/pack-one', Uint8List(1));
    expect(await links.a.backend.list('packs'), {'packs/pack-one': 'v2'});
    await vault.write('packs/pack-two', Uint8List(1));
    await expectLater(
        links.a.backend.list('packs'), _peerError('listing_too_large'));
  });

  test('remote storage exceptions are sanitized rather than reflecting secrets',
      () async {
    final links = pair(bVault: _ThrowingVault());
    await expectLater(
        links.a.backend.check(),
        throwsA(isA<PeerObjectException>()
            .having((error) => error.code, 'code', 'storage_failure')
            .having(
                (error) => '$error', 'message', isNot(contains('secret')))));
  });

  test('oversized incoming packets close the link without handling requests',
      () async {
    final links = pair(maxPacketBytes: 256);
    links.incomingB.add(Uint8List(257));
    await _until(() => links.b.isClosed);
    expect(links.b.isClosed, isTrue);
    expect(links.sentB, isEmpty);
  });

  test(
      'times out pending RPCs and keeps their late replies from confusing new work',
      () async {
    final vault = _DelayedVault();
    final links = pair(
        bVault: vault,
        aConcurrent: 1,
        aTimeout: const Duration(milliseconds: 150));
    await expectLater(
        links.a.backend.read('space.json'), throwsA(isA<TimeoutException>()));
    await links.a.backend.check();
    vault.readGate.complete(Uint8List.fromList([7]));
    await _until(() => links.sentB.length >= 2);
    await links.a.backend.check();
    expect(links.a.isClosed, isFalse);
  });

  test(
      'concurrency bounds exclude excess local work and remote hung operations',
      () async {
    final vault = _DelayedVault();
    final links = pair(bVault: vault, aConcurrent: 2, bConcurrent: 1);
    final slow = links.a.backend.read('space.json');
    final pending = expectLater(slow, throwsA(isA<PeerObjectException>()));
    await _until(() => vault.reads == 1);
    await expectLater(links.a.backend.check(), _peerError('busy'));
    final otherSlow = links.a.backend.read('space.json');
    final otherFailure = expectLater(otherSlow, _peerError('busy'));
    await expectLater(links.a.backend.check(), _peerError('busy'));
    await otherFailure;
    await links.a.close();
    await pending;
    expect(vault.reads, 1);
    vault.readGate.complete(null);
  });

  test('host deadlines do not release slots held by uncancellable storage',
      () async {
    final vault = _DelayedVault();
    final links = pair(
        bVault: vault,
        bConcurrent: 1,
        bTimeout: const Duration(milliseconds: 30));
    await expectLater(
        links.a.backend.read('space.json'), _peerError('timeout'));
    await expectLater(links.a.backend.check(), _peerError('busy'));
    expect(vault.reads, 1);
    vault.readGate.complete(null);
    await links.a.backend.check();
    expect(links.a.isClosed, isFalse);
  });

  test('close settles pending work, ignores late packets and is idempotent',
      () async {
    final links = pair();
    links.dropA = true;
    final pending = expectLater(links.a.backend.check(), _peerError('closed'));
    await links.a.close();
    await pending;
    await links.a.close();
    links.incomingA.add(Uint8List(1));
    await expectLater(links.a.backend.check(), _peerError('closed'));
  });

  test('transport end closes pending RPCs with a bounded generic error',
      () async {
    final links = pair();
    links.dropA = true;
    final pending =
        expectLater(links.a.backend.check(), _peerError('transport_closed'));
    await links.incomingA.close();
    await pending;
  });
}

Matcher _peerError(String code) => throwsA(
    isA<PeerObjectException>().having((error) => error.code, 'code', code));

Future<void> _until(bool Function() condition) async {
  for (var count = 0; count < 200 && !condition(); count++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  expect(condition(), isTrue);
}

Future<Uint8List> _alter(
    Uint8List packet, void Function(Map<String, dynamic>) alter) async {
  final header = ByteData.sublistView(packet);
  final fromLength = header.getUint16(9);
  final offset = 13 + fromLength + header.getUint16(11);
  final from = utf8.decode(packet.sublist(13, 13 + fromLength));
  final to = utf8.decode(packet.sublist(13 + fromLength, offset));
  final aad = jsonEncode([
    'aid-peer-object-v1',
    'user',
    'space',
    'ice',
    from,
    to,
    header.getUint64(1)
  ]);
  final key = Hmac(sha256, _key)
      .convert(utf8.encode('aid-peer-object-v1\nuser\nspace\nice'))
      .bytes;
  final body = jsonDecode(utf8.decode(
          await openBytes(key, Uint8List.sublistView(packet, offset), aad)))
      as Map<String, dynamic>;
  alter(body);
  final sealed = await sealBytes(key, utf8.encode(jsonEncode(body)), aad);
  return Uint8List.fromList([...packet.sublist(0, offset), ...sealed]);
}

class _Pair {
  _Pair(
      {SyncBackend? aVault,
      SyncBackend? bVault,
      Uint8List? bKey,
      required String bUser,
      required String bSpace,
      required String bTransport,
      required String bSession,
      required int maxBytes,
      required int maxPacketBytes,
      required int aConcurrent,
      required int bConcurrent,
      required int maxListEntries,
      required Duration aTimeout,
      required Duration bTimeout}) {
    a = PeerObjectLink(
        vault: aVault ?? MemorySyncBackend(),
        masterKey: _key,
        userId: 'user',
        spaceId: 'space',
        localSession: 'session-a',
        remoteSession: 'session-b',
        transport: 'ice',
        packets: incomingA.stream,
        maxBytes: maxBytes,
        maxPacketBytes: maxPacketBytes,
        maxConcurrent: aConcurrent,
        maxListEntries: maxListEntries,
        timeout: aTimeout,
        send: (packet) async {
          sentA.add(Uint8List.fromList(packet));
          if (!dropA) {
            incomingB
                .add(await (transformA?.call(packet) ?? Future.value(packet)));
          }
        });
    b = PeerObjectLink(
        vault: bVault ?? MemorySyncBackend(),
        masterKey: bKey ?? _key,
        userId: bUser,
        spaceId: bSpace,
        localSession: bSession,
        remoteSession: 'session-a',
        transport: bTransport,
        packets: incomingB.stream,
        maxBytes: maxBytes,
        maxPacketBytes: maxPacketBytes,
        maxConcurrent: bConcurrent,
        maxListEntries: maxListEntries,
        timeout: bTimeout,
        send: (packet) async {
          sentB.add(Uint8List.fromList(packet));
          incomingA.add(packet);
        });
  }
  final incomingA = StreamController<Uint8List>();
  final incomingB = StreamController<Uint8List>();
  final sentA = <Uint8List>[];
  final sentB = <Uint8List>[];
  Future<Uint8List> Function(Uint8List)? transformA;
  bool dropA = false;
  late final PeerObjectLink a;
  late final PeerObjectLink b;

  Future<void> close() async {
    await a.close();
    await b.close();
    await incomingA.close();
    await incomingB.close();
  }
}

class _CountingVault extends MemorySyncBackend {
  int writes = 0;
  @override
  Future<String?> write(String path, Uint8List bytes) {
    writes++;
    return super.write(path, bytes);
  }
}

class _ThrowingVault extends MemorySyncBackend {
  @override
  Future<void> check() async => throw StateError('secret storage credential');
}

class _DelayedVault extends MemorySyncBackend {
  final readGate = Completer<Uint8List?>();
  int reads = 0;
  @override
  Future<Uint8List?> read(String path) {
    reads++;
    return readGate.future;
  }
}
