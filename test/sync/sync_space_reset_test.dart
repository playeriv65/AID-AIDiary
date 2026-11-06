// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_space_reset.dart';
import 'package:flutter_test/flutter_test.dart';

class _ResetBackend extends MemorySyncBackend {
  Future<String?> Function(String, Uint8List)? onWrite;
  bool rootUnavailable = false;

  @override
  Future<Uint8List?> read(String path) async {
    if (rootUnavailable && path == SpaceLayout.info) {
      throw StateError('active descriptor unavailable');
    }
    return super.read(path);
  }

  @override
  Future<String?> write(String path, Uint8List bytes) =>
      onWrite?.call(path, bytes) ?? store(path, bytes);

  Future<String?> store(String path, Uint8List bytes) =>
      super.write(path, bytes);
}

void main() {
  late _ResetBackend backend;
  late SpaceInfo previous;
  late SpaceInfo replacement;
  late String generation;
  final oldContent = {
    'packs/pack-old': Uint8List.fromList([1, 2, 3]),
    'blobs/old': Uint8List.fromList([4, 5, 6]),
    'media/manifests/old': Uint8List.fromList([7, 8, 9]),
    'media/chunks/old/chunk': Uint8List.fromList([10, 11, 12]),
    'copies/device': Uint8List.fromList([13, 14, 15]),
  };

  setUp(() async {
    backend = _ResetBackend();
    final identity = DiaryIdentity.create();
    const kdf = KdfParams(memoryKiB: 64, iterations: 1);
    previous = await SpaceInfo.create(identity,
        recoveryCode: 'previous', generated: false, kdf: kdf);
    replacement = await SpaceInfo.create(identity,
        recoveryCode: 'replacement',
        generated: false,
        kdf: kdf,
        isolatedStorage: true);
    generation = SpaceLayout.generation(replacement.id);
    await backend.store(SpaceLayout.info, previous.toBytes());
    for (final entry in oldContent.entries) {
      await backend.store(entry.key, entry.value);
    }
  });

  Future<void> expectOldContent() async {
    for (final entry in oldContent.entries) {
      expect(await backend.read(entry.key), entry.value, reason: entry.key);
    }
  }

  test('failed staging leaves the active descriptor and objects untouched',
      () async {
    backend.onWrite = (path, bytes) {
      if (path == '$generation/replacement.json') {
        return Future.error(StateError('staging failed'));
      }
      return backend.store(path, bytes);
    };
    await expectLater(
        publishSpaceReset(backend, replacement), throwsStateError);
    expect(await backend.read(SpaceLayout.info), previous.toBytes());
    await expectOldContent();
  });

  test('a concurrent change during staging prevents publication', () async {
    final concurrent = Uint8List.fromList([9, 9, 9]);
    backend.onWrite = (path, bytes) async {
      if (path == '$generation/replacement.json') {
        await backend.store(SpaceLayout.info, concurrent);
      }
      return backend.store(path, bytes);
    };
    await expectLater(
        publishSpaceReset(backend, replacement), throwsStateError);
    expect(await backend.read(SpaceLayout.info), concurrent);
    await expectOldContent();
  });

  for (final partial in [false, true]) {
    test(
        partial
            ? 'a partial publication retains both staged descriptors'
            : 'a refused publication retains the active and staged descriptors',
        () async {
      backend.onWrite = (path, bytes) async {
        if (path == SpaceLayout.info) {
          if (partial) await backend.store(path, bytes.sublist(0, 10));
          throw StateError('publication failed');
        }
        return backend.store(path, bytes);
      };
      await expectLater(
          publishSpaceReset(backend, replacement),
          throwsA(isA<SpaceResetPublicationException>()
              .having((e) => e.archivePath, 'archive', generation)));
      expect(await backend.read(SpaceLayout.info),
          partial ? replacement.toBytes().sublist(0, 10) : previous.toBytes());
      expect(await backend.read('$generation/previous-space.json'),
          previous.toBytes());
      final stagedReplacement = jsonDecode(utf8.decode(
          (await backend.read('$generation/replacement.json'))!)) as Map;
      expect(stagedReplacement['id'], replacement.id);
      expect(stagedReplacement.containsKey('recovery'), isFalse);
      await expectOldContent();
    });
  }

  test('a lost acknowledgement is resolved by reading the active descriptor',
      () async {
    backend.onWrite = (path, bytes) async {
      final version = await backend.store(path, bytes);
      if (path == SpaceLayout.info) throw StateError('response lost');
      return version;
    };
    await publishSpaceReset(backend, replacement);
    expect(await backend.read(SpaceLayout.info), replacement.toBytes());
    expect(await backend.read('$generation/previous-space.json'),
        previous.toBytes());
    await expectOldContent();
  });

  test('an unavailable readback does not overwrite a possible commit',
      () async {
    backend.onWrite = (path, bytes) async {
      final version = await backend.store(path, bytes);
      if (path == SpaceLayout.info) backend.rootUnavailable = true;
      return version;
    };
    await expectLater(publishSpaceReset(backend, replacement),
        throwsA(isA<SpaceResetPublicationException>()));
    backend.rootUnavailable = false;
    expect(await backend.read(SpaceLayout.info), replacement.toBytes());
    expect(await backend.read('$generation/previous-space.json'),
        previous.toBytes());
    await expectOldContent();
  });

  test('legacy paths stay unchanged and reset paths stay inside the generation',
      () async {
    expect(previous.format, SpaceInfo.legacy);
    expect(previous.storageFor(backend), same(backend));
    final scoped = replacement.storageFor(backend);
    final newPack = Uint8List.fromList([16, 17, 18]);
    await scoped.write('packs/pack-old', newPack);
    expect(await scoped.list('packs'), contains('packs/pack-old'));
    expect(await scoped.read('packs/pack-old'), newPack);
    expect(await backend.read('$generation/packs/pack-old'), newPack);
    expect(() => scoped.delete('../packs/pack-old'), throwsFormatException);
    await expectOldContent();
  });

  test('format 5 refuses a descriptor with a non-UUID generation ID', () {
    final descriptor = jsonDecode(utf8.decode(replacement.toBytes())) as Map;
    descriptor['id'] = '../packs';
    expect(
        () => SpaceInfo.fromBytes(
            Uint8List.fromList(utf8.encode(jsonEncode(descriptor)))),
        throwsFormatException);
  });
}
