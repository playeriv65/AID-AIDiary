// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:uuid/uuid.dart';

/// Somewhere a space's files live: a WebDAV folder, a cloud drive's app
/// folder or a sync server. Like Joplin's sync targets, it only stores files;
/// all of the syncing happens on the device.
abstract interface class SyncBackend {
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

/// Where a space keeps its parts.
abstract final class SpaceLayout {
  static const String info = 'space.json';
  static const String items = 'items';
  static const String blobs = 'blobs';

  static String item(String id) => '$items/$id';
  static String blob(String id) => '$blobs/$id';
}

/// A space's description file: its format, its id and, when it is end-to-end
/// encrypted, the wrapped space key.
class SpaceInfo {
  const SpaceInfo({required this.id, this.encryption, this.format = current});

  static const int current = 1;

  final int format;
  final String id;
  final SpaceEncryption? encryption;

  bool get encrypted => encryption != null;

  Uint8List toBytes() => Uint8List.fromList(utf8.encode(jsonEncode({
        'app': 'aid_diary',
        'format': format,
        'id': id,
        if (encryption != null) 'encryption': encryption!.toJson(),
      })));

  factory SpaceInfo.fromBytes(Uint8List bytes) {
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
    final format = json['format'] as int;
    if (format > current) {
      throw UnsupportedError(
          'This space was made by a newer version of the app (format $format)');
    }
    return SpaceInfo(
        id: json['id'] as String,
        format: format,
        encryption: switch (json['encryption']) {
          final Map encryption =>
            SpaceEncryption.fromJson(encryption.cast<String, Object?>()),
          _ => null,
        });
  }

  static SpaceInfo create({SpaceEncryption? encryption}) =>
      SpaceInfo(id: const Uuid().v4(), encryption: encryption);
}

/// A backend kept in memory, for tests.
class MemorySyncBackend implements SyncBackend {
  final Map<String, (Uint8List, String)> files = {};
  var _version = 0;

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
