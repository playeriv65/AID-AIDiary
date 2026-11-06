// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:uuid/uuid.dart';

/// Somewhere a space's files live: a WebDAV folder, a cloud drive's app
/// folder or a sync server. Like Joplin's sync targets, it only stores files;
/// all of the syncing happens on the device.
abstract interface class SyncBackend {
  /// Signs in and makes sure the space folder exists, so a wrong address or
  /// password shows up at once.
  Future<void> check();

  /// The files directly in [folder] (paths relative to the space root, `/`
  /// separated), each with a version that changes whenever its content
  /// does. Empty when the folder does not exist yet.
  Future<Map<String, String>> list(String folder);

  /// Null when there is no such file.
  Future<Uint8List?> read(String path);

  /// Writes [bytes], creating folders as needed, and returns the file's new
  /// version when the backend reports it.
  Future<String?> write(String path, Uint8List bytes);

  Future<void> delete(String path);
}

/// Where a space keeps its parts: changes travel in packs, many items to a
/// file, and photos and recordings as blobs of their own.
abstract final class SpaceLayout {
  static const String info = 'space.json';
  static const String packs = 'packs';
  static const String blobs = 'blobs';

  /// A device's changes from one sync.
  static const String packPrefix = 'pack-';

  /// Every item as of the packs it replaces.
  static const String snapshotPrefix = 'snapshot-';

  static String pack(String name) => '$packs/$name';
  static String blob(String id) => '$blobs/$id';

  static bool isSnapshot(String path) =>
      path.split('/').last.startsWith(snapshotPrefix);

  static final _uuid4 = RegExp(
      r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$');

  static String generation(String spaceId) {
    if (spaceId.length != 36 || !_uuid4.hasMatch(spaceId)) {
      throw const FormatException('Invalid isolated sync space ID');
    }
    return 'generations/$spaceId';
  }
}

/// A space's description file: its format, its id and, when it is end-to-end
/// encrypted, the wrapped space key.
/// A space's description (`space.json`): whose it is and its keys, sealed.
/// Every space is end-to-end encrypted (sync/sync_crypto.dart).
class SpaceInfo {
  const SpaceInfo(
      {required this.id,
      required this.userId,
      required this.sealedDataKey,
      required this.recovery,
      this.format = legacy});

  /// Format 4 retains the original storage paths. Format 5 binds a reset
  /// space to new storage paths without moving or deleting the old content.
  static const int legacy = 4;
  static const int current = 5;

  final int format;
  final String id;

  /// The user whose devices hold the master key that opens it.
  final String userId;

  /// The data key, sealed by the master key.
  final Uint8List sealedDataKey;

  /// The master key, sealed by the recovery code.
  final RecoveryLock recovery;

  /// The data key, or [WrongKeyException] for another user's master key.
  Future<Uint8List> dataKey(Uint8List masterKey) =>
      openDataKey(masterKey, sealedDataKey, id);

  /// Physical cloud paths differ by generation. The local vault, peer
  /// transports and encryption continue to use the logical object paths.
  SyncBackend storageFor(SyncBackend backend) => format == current
      ? _GenerationBackend(backend, SpaceLayout.generation(id))
      : backend;

  SpaceInfo withRecovery(RecoveryLock recovery) => SpaceInfo(
      id: id,
      userId: userId,
      sealedDataKey: sealedDataKey,
      recovery: recovery,
      format: format);

  Uint8List toBytes() => Uint8List.fromList(utf8.encode(jsonEncode({
        'app': 'aid_diary',
        'format': format,
        'id': id,
        'user': userId,
        'dataKey': base64.encode(sealedDataKey),
        'recovery': recovery.toJson(),
      })));

  factory SpaceInfo.fromBytes(Uint8List bytes) {
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
    final format = json['format'] as int;
    if (format != legacy && format != current) {
      throw UnsupportedError(format > current
          ? 'This space was made by a newer version of the app (format $format)'
          : 'This space uses an older sync format ($format); start a new space');
    }
    final id = json['id'] as String;
    if (format == current) SpaceLayout.generation(id);
    return SpaceInfo(
        id: id,
        format: format,
        userId: json['user'] as String,
        sealedDataKey: base64.decode(json['dataKey'] as String),
        recovery: RecoveryLock.fromJson(
            (json['recovery'] as Map).cast<String, Object?>()));
  }

  /// A new space of [identity] with a new data key, and its recovery
  /// locked by [recoveryCode] ([generated] by the app or chosen).
  static Future<SpaceInfo> create(DiaryIdentity identity,
      {required String recoveryCode,
      required bool generated,
      required KdfParams kdf,
      bool isolatedStorage = false}) async {
    final id = const Uuid().v4();
    return SpaceInfo(
        id: id,
        format: isolatedStorage ? current : legacy,
        userId: identity.userId,
        sealedDataKey: await sealDataKey(identity.masterKey, newDataKey(), id),
        recovery: await RecoveryLock.lock(
            identity.masterKey, identity.userId, recoveryCode, kdf,
            generated: generated));
  }
}

class _GenerationBackend implements SyncBackend {
  const _GenerationBackend(this.backend, this.prefix);

  final SyncBackend backend;
  final String prefix;

  static final _invalidSegment = RegExp(r'[^A-Za-z0-9_.-]');

  String _path(String path) {
    if (path.isEmpty) return prefix;
    if (path.split('/').any((part) =>
        part.isEmpty ||
        part == '.' ||
        part == '..' ||
        _invalidSegment.hasMatch(part))) {
      throw const FormatException('Invalid sync object path');
    }
    return '$prefix/$path';
  }

  @override
  Future<void> check() => backend.check();

  @override
  Future<Map<String, String>> list(String folder) async {
    final files = await backend.list(_path(folder));
    return {
      for (final entry in files.entries)
        if (entry.key.startsWith('$prefix/'))
          entry.key.substring(prefix.length + 1): entry.value,
    };
  }

  @override
  Future<Uint8List?> read(String path) => backend.read(_path(path));

  @override
  Future<String?> write(String path, Uint8List bytes) =>
      backend.write(_path(path), bytes);

  @override
  Future<void> delete(String path) => backend.delete(_path(path));
}

/// A backend kept in memory, for tests.
class MemorySyncBackend implements SyncBackend {
  final Map<String, (Uint8List, String)> files = {};
  var _version = 0;

  @override
  Future<void> check() async {}

  @override
  Future<Map<String, String>> list(String folder) async => {
        for (final MapEntry(key: path, value: (_, version)) in files.entries)
          if (path.startsWith('$folder/') &&
              !path.substring(folder.length + 1).contains('/'))
            path: version,
      };

  @override
  Future<Uint8List?> read(String path) async => files[path]?.$1;

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    final version = 'v${++_version}';
    files[path] = (Uint8List.fromList(bytes), version);
    return version;
  }

  @override
  Future<void> delete(String path) async => files.remove(path);
}
