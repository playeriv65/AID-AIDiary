// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_photos.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

/// A path's allowance. Personal storage is separate from the operator's cache.
class MediaAllowance {
  MediaAllowance(
      {required this.backend,
      required this.route,
      required this.maxFileBytes,
      required this.remainingBytes,
      this.maxObjectBytes = 1 << 62,
      this.maxManifestBytes = 256 * 1024,
      this.durable = false});
  final SyncBackend backend;
  final String route;
  final int maxFileBytes;
  int remainingBytes;
  final int maxObjectBytes;
  final int maxManifestBytes;
  final bool durable;
  bool take(int bytes) {
    if (bytes > remainingBytes) return false;
    remainingBytes -= bytes;
    return true;
  }
}

/// Ciphertext vault: both resumable transfers and trusted LAN peers use it.
class MediaVault implements SyncBackend {
  MediaVault(this.db);
  final Database db;
  @override
  Future<void> check() async {}
  @override
  Future<Map<String, String>> list(String folder) async => {
        for (final row
            in await db.query('sync_media_objects', columns: ['path']))
          if ((row['path'] as String).startsWith('$folder/') &&
              !(row['path'] as String)
                  .substring(folder.length + 1)
                  .contains('/'))
            row['path'] as String: '',
      };
  @override
  Future<Uint8List?> read(String path) async {
    final rows = await db.query('sync_media_objects',
        columns: ['bytes'], where: 'path = ?', whereArgs: [path]);
    return rows.isEmpty ? null : rows.single['bytes'] as Uint8List;
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    await db.insert('sync_media_objects', {'path': path, 'bytes': bytes},
        conflictAlgorithm: ConflictAlgorithm.replace);
    return null;
  }

  @override
  Future<void> delete(String path) async =>
      db.delete('sync_media_objects', where: 'path = ?', whereArgs: [path]);
}

class MediaTransferReport {
  const MediaTransferReport(
      {required this.pending,
      required this.completed,
      required this.waitingForPeer,
      required this.failures});
  final int pending;
  final int completed;
  final bool waitingForPeer;
  final int failures;
}

/// Immutable manifests bind each block's ciphertext and plaintext hashes.
/// Acknowledgements are per path, so switching transports loses no blocks.
class MediaTransfers {
  MediaTransfers(
      {required this.db,
      required this.photos,
      required this.backend,
      required this.chunkBytes,
      this.cipher,
      this.allowance,
      this.fallbackAllowance,
      this.stopped,
      this.onFailure});
  final Database db;
  final SyncPhotos photos;
  final SyncBackend backend;
  final int chunkBytes;
  final ItemCipher? cipher;
  final MediaAllowance Function()? allowance;
  final MediaAllowance? fallbackAllowance;
  final bool Function()? stopped;
  final void Function(Object error)? onFailure;
  late final vault = MediaVault(db);
  bool get _stopped => stopped?.call() ?? false;
  final Map<String, Set<String>> _remoteChunks = {};

  static String manifestPath(String id) => 'media/manifests/$id';
  static String chunkPath(String id, String hash) => 'media/chunks/$id/$hash';

  Future<void> queue(String id, String name,
      {required bool sending, DatabaseExecutor? transaction}) async {
    if (id.isEmpty ||
        id.length > 128 ||
        id.contains(RegExp(r'[^a-zA-Z0-9_-]')) ||
        name.isEmpty ||
        name.contains(RegExp(r'[<>:"/\\|?*\x00-\x1f]')) ||
        name.endsWith('.') ||
        name.endsWith(' ')) {
      throw const FormatException('Invalid attachment id or file name');
    }
    await (transaction ?? db).insert(
        'sync_media_tasks',
        {
          'id': id,
          'name': name,
          'sending': sending ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<MediaTransferReport> run() async {
    var completed = 0;
    var failures = 0;
    var waiting = false;
    final orphans = await db.rawQuery('''SELECT t.id FROM sync_media_tasks t
      LEFT JOIN $imagesTable i ON i.$syncIdColumn = t.id WHERE i.id IS NULL''');
    for (final row in orphans) {
      final id = row['id'] as String;
      for (final path in (await vault.list('media/chunks/$id')).keys) {
        await vault.delete(path);
      }
      await vault.delete(manifestPath(id));
      await db.delete('sync_media_tasks', where: 'id = ?', whereArgs: [id]);
    }
    // Newly written entries go first; a deferred large video cannot starve
    // any smaller file behind it.
    final tasks = await db.query('sync_media_tasks',
        where: 'completed = 0', orderBy: 'rowid DESC');
    final unlimited = MediaAllowance(
        backend: backend,
        route: 'personal',
        maxFileBytes: 1 << 62,
        remainingBytes: 1 << 62,
        durable: true);
    for (final task in tasks) {
      if (_stopped) break;
      final id = task['id'] as String;
      final name = task['name'] as String;
      final exists = await db.query(imagesTable,
          columns: ['id'],
          where: '$syncIdColumn = ?',
          whereArgs: [id],
          limit: 1);
      if (exists.isEmpty) {
        await db.delete('sync_media_tasks', where: 'id = ?', whereArgs: [id]);
        continue;
      }
      try {
        final sending = task['sending'] == 1;
        var manifest = task['manifest'] == null
            ? null
            : jsonDecode(task['manifest'] as String) as Map<String, dynamic>;
        if (sending && manifest == null) {
          manifest = await _prepare(id, name);
          if (manifest == null) {
            waiting = true;
            continue;
          }
        }
        var route = allowance?.call() ?? unlimited;
        if (!sending && manifest == null) {
          final local = await vault.read(manifestPath(id));
          final sealed = local ??
              await _download(manifestPath(id), route,
                  maximum: route.maxManifestBytes);
          if (sealed == null) {
            waiting = true;
            continue;
          }
          manifest = _parseManifest(await _open('manifest:$id', sealed));
          await vault.write(manifestPath(id), sealed);
          await _keepManifest(id, manifest);
        }
        manifest = _parseManifest(utf8.encode(jsonEncode(manifest)));
        final size = manifest['size'] as int;
        if (sending && size > route.maxFileBytes) {
          waiting = true;
          continue;
        }
        final chunks =
            (manifest['chunks'] as List).cast<Map<String, dynamic>>();
        var ready = true;
        for (var index = 0; index < chunks.length; index++) {
          if (_stopped) {
            ready = false;
            break;
          }
          route = allowance?.call() ?? unlimited;
          if (sending && size > route.maxFileBytes) {
            ready = false;
            break;
          }
          final chunk = chunks[index];
          final path = chunkPath(id, chunk['hash'] as String);
          final key = '${route.route}:${identityHashCode(route.backend)}:$id';
          if (sending) {
            final present = _remoteChunks[key] ??=
                (await route.backend.list('media/chunks/$id')).keys.toSet();
            if (present.contains(path)) continue;
            final bytes = await vault.read(path);
            if (bytes == null) {
              throw StateError('Missing staged attachment block');
            }
            if (bytes.length > route.maxObjectBytes ||
                !route.take(bytes.length)) {
              ready = false;
              break;
            }
            await route.backend.write(path, bytes);
            present.add(path);
          } else {
            if (await vault.read(path) != null) continue;
            // Reserve the manifest's authenticated ciphertext length first.
            final bytes = await _download(path, route,
                maximum: chunk['sealedSize'] as int, fileSize: size);
            if (bytes == null) {
              ready = false;
              break;
            }
            if (bytes.length != chunk['sealedSize'] ||
                sha256.convert(bytes).toString() != chunk['hash']) {
              throw const FormatException(
                  'Attachment ciphertext hash mismatch');
            }
            await vault.write(path, bytes);
          }
        }
        if (!ready) {
          waiting = true;
          continue;
        }
        if (sending) {
          // A manifest announces only blocks already present on that backend.
          // Recheck after a path switch rather than announcing missing data.
          route = allowance?.call() ?? unlimited;
          final present =
              (await route.backend.list('media/chunks/$id')).keys.toSet();
          if (chunks.any(
              (c) => !present.contains(chunkPath(id, c['hash'] as String)))) {
            waiting = true;
            continue;
          }
          final bytes = (await vault.read(manifestPath(id)))!;
          if (bytes.length > route.maxManifestBytes ||
              !route.take(bytes.length)) {
            waiting = true;
            continue;
          }
          await route.backend.write(manifestPath(id), bytes);
        } else {
          await _assemble(id, name, manifest);
        }
        await db.update('sync_media_tasks',
            {'completed': 1, 'durable': sending && route.durable ? 1 : 0},
            where: 'id = ?', whereArgs: [id]);
        completed++;
      } catch (error) {
        failures++;
        onFailure?.call(error);
      }
    }
    final pending = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM sync_media_tasks WHERE completed = 0'))!;
    return MediaTransferReport(
        pending: pending,
        completed: completed,
        waitingForPeer: waiting,
        failures: failures);
  }

  Future<Map<String, dynamic>?> _prepare(String id, String name) async {
    final previous = await vault.read(manifestPath(id));
    if (previous != null) {
      final manifest = _parseManifest(await _open('manifest:$id', previous));
      await _keepManifest(id, manifest);
      return manifest;
    }
    for (final path in (await vault.list('media/chunks/$id')).keys) {
      await vault.delete(path);
    }
    final streaming =
        photos is SyncPhotoFiles ? photos as SyncPhotoFiles : null;
    final file = await streaming?.file(name);
    final memory = file == null ? await photos.read(name) : null;
    if (file == null && memory == null) return null;
    final size = file == null ? memory!.length : await file.length();
    final chunks = <Map<String, dynamic>>[];
    final input = await file?.open();
    try {
      for (var offset = 0; offset < size; offset += chunkBytes) {
        final length = min(chunkBytes, size - offset);
        final plain = input == null
            ? Uint8List.sublistView(memory!, offset, offset + length)
            : await input.read(length);
        if (plain.length != length) {
          throw const FileSystemException('Attachment changed during transfer');
        }
        final sealed = await _seal('chunk:$id:${chunks.length}', plain);
        final hash = sha256.convert(sealed).toString();
        await vault.write(chunkPath(id, hash), sealed);
        chunks.add({
          'hash': hash,
          'sha256': sha256.convert(plain).toString(),
          'size': length,
          'sealedSize': sealed.length
        });
      }
    } finally {
      await input?.close();
    }
    final manifest = <String, dynamic>{
      'version': 1,
      'size': size,
      'chunkBytes': chunkBytes,
      'chunks': chunks
    };
    final sealed =
        await _seal('manifest:$id', utf8.encode(jsonEncode(manifest)));
    await vault.write(manifestPath(id), sealed);
    await _keepManifest(id, manifest);
    return manifest;
  }

  Future<Uint8List?> _download(String path, MediaAllowance primary,
      {required int maximum, int fileSize = 0}) async {
    for (final route in [
      primary,
      if (fallbackAllowance != null && !identical(primary, fallbackAllowance))
        fallbackAllowance!
    ]) {
      if (fileSize > route.maxFileBytes ||
          maximum > route.maxObjectBytes ||
          !route.take(maximum)) {
        continue;
      }
      final bytes = await route.backend.read(path);
      if (bytes == null) {
        route.remainingBytes += maximum;
        continue;
      }
      if (bytes.length > maximum) {
        throw const FormatException('Attachment object exceeds its allowance');
      }
      route.remainingBytes += maximum - bytes.length;
      return bytes;
    }
    return null;
  }

  Future<void> _assemble(
      String id, String name, Map<String, dynamic> manifest) async {
    final directory = await Directory.systemTemp.createTemp('aid-media-');
    final file = File('${directory.path}/attachment');
    final output = await file.open(mode: FileMode.write);
    var closed = false;
    try {
      final chunks = manifest['chunks'] as List;
      for (var index = 0; index < chunks.length; index++) {
        final c = chunks[index] as Map;
        final sealed = (await vault.read(chunkPath(id, c['hash'] as String)))!;
        if (sha256.convert(sealed).toString() != c['hash']) {
          throw const FormatException('Staged ciphertext hash mismatch');
        }
        final plain = await _open('chunk:$id:$index', sealed);
        if (plain.length != c['size'] ||
            sha256.convert(plain).toString() != c['sha256']) {
          throw const FormatException('Attachment plaintext hash mismatch');
        }
        await output.writeFrom(plain);
      }
      await output.flush();
      await output.close();
      closed = true;
      if (photos is SyncPhotoFiles) {
        await (photos as SyncPhotoFiles).importFile(name, file);
      } else {
        await photos.write(name, await file.readAsBytes());
      }
    } finally {
      if (!closed) await output.close();
      await directory.delete(recursive: true);
    }
  }

  Map<String, dynamic> _parseManifest(List<int> bytes) {
    final manifest = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final size = manifest['size'];
    final blockSize = manifest['chunkBytes'];
    final chunks = manifest['chunks'];
    if (manifest['version'] != 1 ||
        size is! int ||
        size < 0 ||
        blockSize is! int ||
        blockSize <= 0 ||
        blockSize > chunkBytes ||
        chunks is! List ||
        chunks.length != (size / blockSize).ceil()) {
      throw const FormatException('Invalid attachment manifest');
    }
    var total = 0;
    for (final (index, chunk) in chunks.indexed) {
      if (chunk is! Map ||
          chunk['size'] is! int ||
          chunk['size'] != min(blockSize, size - index * blockSize) ||
          chunk['sealedSize'] is! int ||
          chunk['sealedSize'] < chunk['size'] ||
          chunk['sealedSize'] > blockSize + 128 ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch('${chunk['hash']}') ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch('${chunk['sha256']}')) {
        throw const FormatException('Invalid attachment block');
      }
      total += chunk['size'] as int;
    }
    if (total != size) throw const FormatException('Invalid attachment length');
    return manifest;
  }

  Future<void> _keepManifest(String id, Map<String, dynamic> manifest) async =>
      db.update('sync_media_tasks', {'manifest': jsonEncode(manifest)},
          where: 'id = ?', whereArgs: [id]);
  Future<Uint8List> _seal(String id, List<int> plain) async => cipher == null
      ? Uint8List.fromList(plain)
      : await cipher!.seal(id, plain);
  Future<Uint8List> _open(String id, Uint8List sealed) async =>
      cipher == null ? sealed : await cipher!.open(id, sealed);
}
