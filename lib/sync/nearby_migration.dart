// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/lan_transport.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_records.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/database/hidden_entry_policy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// A short-lived, private capability. It belongs in the encrypted QR grant and
/// secure settings, never the public QR, logs, or network diagnostics.
class NearbyMigrationGrant {
  NearbyMigrationGrant(
      {required this.spaceId,
      required this.deviceId,
      required this.dataKey,
      required this.expires,
      required this.endpoints}) {
    if (!RegExp(r'^[a-f0-9-]{36}$').hasMatch(spaceId) ||
        deviceId.isEmpty ||
        deviceId.length > 128 ||
        dataKey.length != 32 ||
        endpoints.isEmpty ||
        endpoints.length > 8 ||
        endpoints.any((e) =>
            e.scheme != 'http' ||
            InternetAddress.tryParse(e.host) == null ||
            e.userInfo.isNotEmpty ||
            e.port < 1 ||
            e.port > 65535 ||
            (e.path.isNotEmpty && e.path != '/') ||
            e.hasQuery ||
            e.hasFragment)) {
      throw const FormatException('Invalid nearby transfer');
    }
  }
  final String spaceId;
  final String deviceId;
  final Uint8List dataKey;
  final DateTime expires;
  final List<Uri> endpoints;
  Map<String, Object?> toJson() => {
        'spaceId': spaceId,
        'deviceId': deviceId,
        'dataKey': base64Encode(dataKey),
        'expires': expires.millisecondsSinceEpoch,
        'endpoints': endpoints.map((e) => e.toString()).toList()
      };
  factory NearbyMigrationGrant.fromJson(Map<String, Object?> json) =>
      NearbyMigrationGrant(
          spaceId: json['spaceId'] as String,
          deviceId: json['deviceId'] as String,
          dataKey: base64Decode(json['dataKey'] as String),
          expires: DateTime.fromMillisecondsSinceEpoch(json['expires'] as int),
          endpoints: (json['endpoints'] as List)
              .map((e) => Uri.parse(e as String))
              .toList());

  Future<LanMediaBackend> connect(DiaryIdentity identity) async {
    if (!DateTime.now().isBefore(expires)) {
      throw StateError('Nearby transfer expired');
    }
    for (final endpoint in endpoints) {
      try {
        final peer = await LanMediaBackend.connect(
            endpoint: endpoint,
            userId: identity.userId,
            spaceId: spaceId,
            masterKey: identity.masterKey);
        if (peer.id != deviceId) {
          peer.backend.close();
          continue;
        }
        return peer.backend;
      } catch (_) {
        // The QR may include interfaces unreachable from this particular device.
      }
    }
    throw StateError('Nearby transfer is unreachable');
  }
}

/// Immutable metadata snapshot with lazily prepared, encrypted attachment chunks.
/// All staging uses a separate database, leaving the owner's cloud queue intact.
class NearbyMigrationSource implements SyncBackend {
  NearbyMigrationSource._(this.vault, this._media);
  final MediaVault vault;
  final MediaTransfers _media;
  final _photos = <String, String>{};
  final _preparing = <String, Future<bool>>{};
  LanMediaHost? _host;
  Timer? _expiry;
  bool _closed = false;
  late final NearbyMigrationGrant grant;
  final _finished = Completer<bool>();
  bool acknowledged = false;
  final _closedSignal = Completer<void>();
  Future<bool> get finished => _finished.future;
  Future<void> get closed => _closedSignal.future;
  Future<void>? _closing;

  static Future<NearbyMigrationSource> create(
      {required Database source,
      required Database staging,
      required SyncPhotos photos,
      required DiaryIdentity identity,
      required String deviceId,
      required int chunkBytes,
      required int packBytes,
      required Duration lifetime,
      InternetAddress? bind,
      List<InternetAddress>? addresses,
      LanDiscovery? discovery}) async {
    if (packBytes < 1024 ||
        packBytes > 8 * 1024 * 1024 ||
        chunkBytes < 1024 ||
        chunkBytes > 2 * 1024 * 1024 ||
        lifetime <= Duration.zero) {
      throw ArgumentError('Invalid nearby transfer limits');
    }
    await addSyncMediaSchema(staging);
    final key = newDataKey();
    final cipher = ItemCipher(key);
    final space = const Uuid().v4();
    late NearbyMigrationSource result;
    result = NearbyMigrationSource._(
        MediaVault(staging),
        MediaTransfers(
            db: staging,
            photos: photos,
            backend: MemorySyncBackend(),
            chunkBytes: chunkBytes,
            stopped: () => result._closed,
            cipher: cipher));
    try {
      var index = 0;
      var batch = <SyncRecord>[];
      var bytes = 0;
      Future<void> flush() async {
        if (batch.isEmpty) return;
        final path = 'packs/pack-$space-${index++}';
        final payload = gzip.encode(utf8.encode(
            jsonEncode({'records': batch.map((r) => r.toJson()).toList()})));
        await result.vault.write(path, await cipher.seal(path, payload));
        batch = [];
        bytes = 0;
      }

      // A read transaction fixes all rows and references at one snapshot.
      await source.transaction((txn) async {
        await requireHiddenCompatibleSync(txn);
        final versions = <String, int>{};
        for (final table in [syncItemsTable, syncChangesTable]) {
          final column = table == syncItemsTable ? 'modified' : 'changed_at';
          for (final row in await txn.query(table)) {
            final id = '${row['kind']}:${row[syncIdColumn]}';
            final value = row[column] as int;
            if (value > (versions[id] ?? -1)) versions[id] = value;
          }
        }
        final now = DateTime.now().millisecondsSinceEpoch;
        for (final kind in SyncKind.values) {
          for (final row
              in await txn.query(kind.table, columns: [syncIdColumn])) {
            final id = row[syncIdColumn] as String;
            final record = await exportRecord(
                txn, kind, id, versions['${kind.name}:$id'] ?? now);
            final length = utf8.encode(jsonEncode(record.toJson())).length;
            if (length > 8 * 1024 * 1024) {
              throw StateError('Nearby diary item too large');
            }
            if (bytes + length > packBytes) await flush();
            batch.add(record);
            bytes += length;
            for (final photo in record.photos) {
              result._photos[photo.id] = photo.file;
            }
          }
        }
        await flush();
      });
      result._host = LanMediaHost(
          vault: result,
          deviceId: deviceId,
          userId: identity.userId,
          spaceId: space,
          masterKey: identity.masterKey,
          discovery: discovery);
      final endpoint = await result._host!.start(bindAddress: bind);
      final available = addresses ??
          [
            for (final i
                in await NetworkInterface.list(includeLinkLocal: false))
              for (final a in i.addresses)
                if (!a.isLoopback) a
          ];
      result.grant = NearbyMigrationGrant(
          spaceId: space,
          deviceId: deviceId,
          dataKey: key,
          expires: DateTime.now().add(lifetime),
          endpoints: [
            for (final a in available.take(8))
              Uri(scheme: 'http', host: a.address, port: endpoint.port)
          ]);
      result._expiry = Timer(lifetime, () => unawaited(result.close()));
      return result;
    } catch (_) {
      await result.close();
      rethrow;
    }
  }

  @override
  Future<void> check() async {
    if (_closed) throw StateError('Nearby transfer closed');
  }

  @override
  Future<Map<String, String>> list(String folder) async {
    await check();
    return vault.list(folder);
  }

  @override
  Future<Uint8List?> read(String path) async {
    await check();
    final parts = path.split('/');
    if (parts.length >= 3 &&
        parts[0] == 'media' &&
        (parts[1] == 'manifests' || parts[1] == 'chunks')) {
      final id = parts[2];
      final name = _photos[id];
      if (name == null) return null;
      final preparing = _preparing[id] ??= _media.stage(id, name);
      try {
        if (!await preparing) {
          _preparing.remove(id);
          return null;
        }
      } catch (_) {
        _preparing.remove(id);
        rethrow;
      }
    }
    return vault.read(path);
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    await check();
    // The temporary space has no space.json. Its only accepted write is an
    // encrypted completion receipt; no snapshot or source diary data is changed.
    if (path != SpaceLayout.info ||
        bytes.length > 256 ||
        utf8.decode(await ItemCipher(grant.dataKey)
                .open('nearby-complete:${grant.spaceId}', bytes)) !=
            'complete') {
      throw StateError('Nearby snapshot is read-only');
    }
    acknowledged = true;
    if (!_finished.isCompleted) _finished.complete(true);
    return null;
  }

  @override
  Future<void> delete(String path) =>
      Future.error(StateError('Nearby snapshot is read-only'));
  Future<void> close() => _closing ??= _close();
  Future<void> _close() async {
    _closed = true;
    _expiry?.cancel();
    try {
      await _host?.close();
    } finally {
      await Future.wait(_preparing.values
          .map((f) => f.then<void>((_) {}, onError: (Object _) {})));
      if (!_finished.isCompleted) _finished.complete(false);
      if (!_closedSignal.isCompleted) _closedSignal.complete();
    }
  }
}

/// The same authenticated chunks and persistent queue used by ordinary sync.
/// Repeating this operation resumes missing blocks without reapplying records.
Future<SyncReport> receiveNearbyMigration(
    {required Database db,
    required SyncPhotos photos,
    required NearbyMigrationGrant grant,
    required DiaryIdentity identity,
    bool Function()? stopped,
    void Function(SyncProgress)? onProgress}) async {
  final backend = await grant.connect(identity);
  try {
    final report = await SyncEngine(
            db: db,
            backend: backend,
            photos: photos,
            limits: const SyncLimits(
                packBytes: 1024 * 1024, compactAfter: 1 << 30, parallel: 3),
            cipher: ItemCipher(grant.dataKey),
            receiveOnly: true,
            stopped: stopped,
            onProgress: onProgress)
        .sync();
    return report;
  } finally {
    backend.close();
  }
}

/// Sent only after content and identity have both committed on the recipient.
Future<void> acknowledgeNearbyMigration(
    NearbyMigrationGrant grant, DiaryIdentity identity) async {
  final backend = await grant.connect(identity);
  try {
    await backend.write(
        SpaceLayout.info,
        await ItemCipher(grant.dataKey)
            .seal('nearby-complete:${grant.spaceId}', utf8.encode('complete')));
  } finally {
    backend.close();
  }
}
