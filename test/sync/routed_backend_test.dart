// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';
import 'package:aid_diary/sync/routed_backend.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:flutter_test/flutter_test.dart';

class _OfflineStorage extends MemorySyncBackend {
  bool offline = true;
  @override
  Future<String?> write(String path, Uint8List bytes) {
    if (offline) throw StateError('upload unavailable');
    return super.write(path, bytes);
  }
}

class _UnavailableStorage extends MemorySyncBackend {
  int listings = 0;
  @override
  Future<Map<String, String>> list(String folder) async {
    listings++;
    throw StateError('cloud offline');
  }
}

void main() {
  test('an unavailable cache is skipped while the peer keeps working',
      () async {
    final storage = _UnavailableStorage();
    final peer = MemorySyncBackend();
    await peer.write('packs/pack-local', Uint8List(1));
    var available = true;
    final routed = RoutedSyncBackend(
        local: MemorySyncBackend(),
        storage: storage,
        peers: () => [peer],
        storageAvailable: () => available,
        onStorageFailure: () => available = false);
    expect(await routed.list('packs'), contains('packs/pack-local'));
    expect(await routed.list('packs'), contains('packs/pack-local'));
    expect(storage.listings, 1);
  });
  test('a peer acknowledgement cannot delete the clouds only packs', () async {
    final storage = _OfflineStorage();
    final peer = MemorySyncBackend();
    final local = MemorySyncBackend();
    final bytes = Uint8List.fromList([1, 2]);
    storage.offline = false;
    await storage.write('packs/pack-old', bytes);
    await peer.write('packs/pack-old', bytes);
    storage.offline = true;
    final routed =
        RoutedSyncBackend(local: local, storage: storage, peers: () => [peer]);
    await routed.write('packs/snapshot-new', bytes);
    await routed.delete('packs/pack-old');
    expect(await storage.read('packs/pack-old'), bytes);
    expect(await storage.read('packs/snapshot-new'), isNull);
    expect(await peer.read('packs/pack-old'), isNull);
    storage.offline = false;
    await routed.drain();
    expect(await storage.read('packs/snapshot-new'), bytes);
  });

  test('a write with no remote acknowledgement cannot acknowledge itself',
      () async {
    final local = MemorySyncBackend();
    final routed = RoutedSyncBackend(
        local: local, storage: _OfflineStorage(), peers: () => []);
    await expectLater(
        routed.write('packs/pack-one', Uint8List(1)), throwsStateError);
    expect(await local.list('packs'), isEmpty);
    expect(await routed.list('packs'), isEmpty);
  });

  test('a missing object on the chosen peer is found on another trusted peer',
      () async {
    final empty = MemorySyncBackend();
    final holder = MemorySyncBackend();
    final bytes = Uint8List.fromList([1, 2, 3]);
    await holder.write('media/manifests/photo', bytes);
    final pool =
        PeerSyncBackend(current: () => empty, sources: () => [empty, holder]);
    expect(await pool.read('media/manifests/photo'), bytes);
    expect(await pool.read('media/manifests/absent'), isNull);
  });

  test('metadata arriving by peer drains to storage when it returns', () async {
    final storage = _OfflineStorage();
    final local = MemorySyncBackend();
    final peer = MemorySyncBackend();
    final bytes = Uint8List.fromList([4, 5]);
    final routed =
        RoutedSyncBackend(local: local, storage: storage, peers: () => [peer]);
    await routed.write('packs/pack-offline', bytes);
    expect(await peer.read('packs/pack-offline'), bytes);
    expect(await local.read('packs/pack-offline'), bytes);
    storage.offline = false;
    await routed.drain();
    expect(await storage.read('packs/pack-offline'), bytes);
  });
}
