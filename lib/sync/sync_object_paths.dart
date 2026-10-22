// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:crypto/crypto.dart';

/// The protocol's ciphertext namespace, shared by authenticated transports.
abstract final class SyncObjectPaths {
  static final _id = RegExp(r'^[A-Za-z0-9_-]{1,128}$');
  static final _hash = RegExp(r'^[a-f0-9]{64}$');
  static final _pack = RegExp(r'^(pack-|snapshot-)[A-Za-z0-9_-]{1,160}$');

  static bool validFolder(String folder) {
    final parts = folder.split('/');
    return folder == 'packs' ||
        folder == 'copies' ||
        folder == 'media/manifests' ||
        (parts.length == 3 &&
            parts[0] == 'media' &&
            parts[1] == 'chunks' &&
            _id.hasMatch(parts[2]));
  }

  static bool validFile(String path) {
    final parts = path.split('/');
    return path == 'space.json' ||
        (parts.length == 2 && parts[0] == 'copies' && _id.hasMatch(parts[1])) ||
        (parts.length == 2 &&
            parts[0] == 'packs' &&
            _pack.hasMatch(parts[1])) ||
        (parts.length == 3 &&
            parts[0] == 'media' &&
            parts[1] == 'manifests' &&
            _id.hasMatch(parts[2])) ||
        (parts.length == 4 &&
            parts[0] == 'media' &&
            parts[1] == 'chunks' &&
            _id.hasMatch(parts[2]) &&
            _hash.hasMatch(parts[3]));
  }

  static bool directChild(String folder, String path) =>
      validFile(path) &&
      path.startsWith('$folder/') &&
      !path.substring(folder.length + 1).contains('/');

  static void verifyChunk(String path, List<int> bytes) {
    if (path.startsWith('media/chunks/') &&
        sha256.convert(bytes).toString() != path.split('/').last) {
      throw const FormatException('Ciphertext hash mismatch');
    }
  }
}
