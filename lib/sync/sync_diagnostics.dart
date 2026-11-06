// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/sync/connection_manager.dart';
import 'package:aid_diary/sync/copy_status.dart';
import 'package:aid_diary/sync/internet_transport.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/webdav_backend.dart';

typedef SyncNetworkState = ({
  SyncBackend? storage,
  SyncConnectionManager? connections,
  InternetTransport? internet,
  DateTime? retryAt,
});

/// Builds copy, network and cloud-usage reports from the live sync session.
/// SyncService owns the storage and route lifetimes.
class SyncDiagnostics {
  SyncDiagnostics({
    required Future<CopyStatusStore?> Function() copyStore,
    required Future<String> Function() copyDeviceId,
    required Iterable<SyncBackend> Function() copySources,
    required (String? provider, String? host) Function() storageLocation,
    required SyncNetworkState Function() network,
  })  : _copyStore = copyStore,
        _copyDeviceId = copyDeviceId,
        _copySources = copySources,
        _storageLocation = storageLocation,
        _network = network;

  final Future<CopyStatusStore?> Function() _copyStore;
  final Future<String> Function() _copyDeviceId;
  final Iterable<SyncBackend> Function() _copySources;
  final (String? provider, String? host) Function() _storageLocation;
  final SyncNetworkState Function() _network;

  bool get temporaryMediaCache {
    final storage = _network().storage;
    return storage is WebDavBackend && storage.boundedMedia;
  }

  /// User-requested copy details. Receipts name devices, never network paths.
  Future<Map<String, Object?>> copyStatus() async {
    final store = await _copyStore();
    if (store == null) return {'name': LocalDevice.name, 'devices': <Object>[]};
    final local = await store.local(await _copyDeviceId(), LocalDevice.name);
    final vault = MediaVault(store.db);
    final copies = await store.readLatest({vault, ..._copySources()});
    for (final copy in copies) {
      await store.publish(vault, copy);
    }
    final network = await networkStatus();
    final (provider, host) = _storageLocation();
    return {
      'name': LocalDevice.name,
      'local': local.toJson(),
      'devices': [
        for (final copy in copies)
          if (copy.id != local.id)
            {...copy.toJson(), 'current': copy.revision == local.revision}
      ],
      'temporaryStorage': temporaryMediaCache,
      'storage': provider,
      'storageHost': host,
      'storedMedia': network['durableRemoteMedia'],
      'temporaryMedia': network['temporaryOrUnconfirmedRemoteMedia'],
    };
  }

  /// Operational details stay out of the everyday status label. A successful
  /// cache upload is explicitly distinct from durable remote storage.
  Future<Map<String, Object?>> networkStatus() async {
    final db = AppDatabase.instance.database;
    final tasks = db == null
        ? <Map<String, Object?>>[]
        : await db.query('sync_media_tasks',
            columns: ['sending', 'completed', 'durable']);
    final (:storage, :connections, :internet, :retryAt) = _network();
    return {
      if (storage is WebDavBackend && storage.cachedCloudTraffic != null)
        'cloudTraffic': storage.cachedCloudTraffic,
      'route': connections?.current?.type.name,
      if (internet != null) 'internet': internet.diagnostics(),
      'availableRoutes': [
        for (final route
            in connections?.healthyRoutes ?? <SyncRouteCandidate>[])
          {
            'type': route.type.name,
            'stability': route.stability,
            'throughput': route.throughput,
            'cost': route.cost
          }
      ],
      'pendingMedia': tasks.where((task) => task['completed'] == 0).length,
      'durableRemoteMedia': tasks
          .where((task) =>
              task['completed'] == 1 &&
              task['sending'] == 1 &&
              task['durable'] == 1)
          .length,
      'temporaryOrUnconfirmedRemoteMedia': tasks
          .where((task) =>
              task['completed'] == 1 &&
              task['sending'] == 1 &&
              task['durable'] == 0)
          .length,
      if (retryAt != null) 'retryAt': retryAt.toIso8601String(),
    };
  }

  /// Fetches only the operator's public quota fields for the current account.
  Future<Map<String, Object?>?> cloudTraffic() async {
    final backend = _network().storage;
    if (backend is! WebDavBackend) return null;
    await backend.mediaPolicy();
    final value = backend.cachedCloudTraffic;
    if (value == null) return null;
    return {
      for (final key in [
        'monthlyLimitBytes',
        'monthlyUsedBytes',
        'monthlyRemainingBytes'
      ])
        if (value[key] is int && (value[key] as int) >= 0) key: value[key],
      if (value['resetsAt'] is String &&
          DateTime.tryParse(value['resetsAt'] as String) != null)
        'resetsAt': value['resetsAt'],
    };
  }
}
