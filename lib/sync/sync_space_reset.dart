// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_backend.dart';
import 'package:crypto/crypto.dart';

class SpaceResetPublicationException implements Exception {
  const SpaceResetPublicationException(this.archivePath);

  final String archivePath;

  @override
  String toString() => 'Could not confirm the sync space replacement. '
      'The staged descriptors are in $archivePath.';
}

/// Leaves the old object tree in place and publishes a descriptor whose
/// objects will be written to a separate generation. A backend may commit a
/// write even when the response is lost, so read back the active descriptor.
Future<void> publishSpaceReset(
    SyncBackend backend, SpaceInfo replacement) async {
  if (replacement.format != SpaceInfo.current) {
    throw ArgumentError('A reset must use isolated storage');
  }
  final archivePath = SpaceLayout.generation(replacement.id);
  final staged = replacement.storageFor(backend);
  final previous = await backend.read(SpaceLayout.info);
  final next = replacement.toBytes();
  if (previous != null) {
    await _stage(staged, 'previous-space.json', previous);
  }
  // Retaining the full replacement would leave an extra password envelope
  // for the active generation after its recovery code changes.
  final replacementRecord =
      jsonDecode(utf8.decode(next)) as Map<String, dynamic>
        ..remove('recovery')
        ..['descriptorSha256'] = sha256.convert(next).toString();
  await _stage(staged, 'replacement.json',
      Uint8List.fromList(utf8.encode(jsonEncode(replacementRecord))));

  // This detects changes during staging. Backends do not share a conditional
  // write API, so another writer may still race the final publication.
  if (!_sameBytes(await backend.read(SpaceLayout.info), previous)) {
    throw StateError('The sync space changed during reset');
  }
  try {
    await backend.write(SpaceLayout.info, next);
  } catch (_) {
    // The server may have written the entire descriptor before disconnecting.
  }
  Uint8List? active;
  try {
    active = await backend.read(SpaceLayout.info);
  } catch (_) {
    throw SpaceResetPublicationException(archivePath);
  }
  if (!_sameBytes(active, next)) {
    throw SpaceResetPublicationException(archivePath);
  }
}

Future<void> _stage(SyncBackend backend, String path, Uint8List bytes) async {
  await backend.write(path, bytes);
  if (!_sameBytes(await backend.read(path), bytes)) {
    throw StateError('Could not verify the staged sync descriptor');
  }
}

bool _sameBytes(Uint8List? first, Uint8List? second) {
  if (identical(first, second)) return true;
  if (first == null || second == null || first.length != second.length) {
    return false;
  }
  for (var i = 0; i < first.length; i++) {
    if (first[i] != second[i]) return false;
  }
  return true;
}
