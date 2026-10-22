// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/nearby_adoption.dart';
import 'package:aid_diary/sync/device_auth.dart';
import 'package:aid_diary/sync/nearby_receipt.dart';
import 'package:aid_diary/sync/nearby_migration.dart';
import 'package:aid_diary/sync/offline_pairing.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

enum NearbyState {
  idle,
  preparing,
  offering,
  comparing,
  waiting,
  transferring,
  pending,
  complete,
  failed
}

class NearbyDestinationNotEmpty implements Exception {}

/// Offline migration is separate from cloud credentials and the daily sync loop.
/// A persisted secret capability permits retry after partial metadata/media work.
class NearbyService extends ChangeNotifier {
  NearbyService._();
  static final instance = NearbyService._();
  NearbyState state = NearbyState.idle;
  bool destinationNotEmpty = false;
  OfflinePairingInvite? invitation;
  OfflinePairingHost? _offer;
  OfflinePairingClient? _receiver;
  NearbyMigrationSource? _source;
  Database? _staging;
  Directory? _folder;
  SyncReport? report;
  SyncProgress? progress;
  int _generation = 0;
  bool _running = false;
  String? get sas => _offer?.sas ?? _receiver?.sas;
  bool get sending => _source != null;
  bool get canResume =>
      ConfigProvider.instance.get(Settings.nearbyMigration).isNotEmpty;
  void _set(NearbyState value) {
    state = value;
    notifyListeners();
  }

  Future<void> offer() async {
    if (_running) throw StateError('Nearby operation in progress');
    _running = true;
    final generation = ++_generation;
    destinationNotEmpty = false;
    _set(NearbyState.preparing);
    try {
      await _reset();
      if (generation != _generation) {
        throw StateError('Nearby operation cancelled');
      }
      final config = AppConfig.instance.syncTransfer;
      final identity = await DiaryIdentity.current();
      _folder = await Directory.systemTemp.createTemp('aid-nearby-');
      _staging = await openDatabase(p.join(_folder!.path, 'ciphertext.db'),
          singleInstance: false);
      _source = await NearbyMigrationSource.create(
          source: AppDatabase.instance.database!,
          staging: _staging!,
          photos: ImageStoragePhotos(),
          identity: identity,
          deviceId: const Uuid().v4(),
          chunkBytes: (config['chunkKiB'] as int) * 1024,
          packBytes: (config['nearbyPackKiB'] as int) * 1024,
          lifetime: Duration(seconds: config['nearbySessionSeconds'] as int));
      if (generation != _generation) {
        throw StateError('Nearby operation cancelled');
      }
      final source = _source!;
      unawaited(source.finished.then((complete) {
        if (generation == _generation && identical(_source, source)) {
          _set(complete ? NearbyState.complete : NearbyState.failed);
        }
      }));
      unawaited(source.closed.then((_) async {
        if (generation == _generation && identical(_source, source)) {
          await _closeSource();
        }
      }));
      final target = SyncService.instance.target;
      final account = target?.provider == SyncProvider.webdav &&
              DeviceAuthManager.instance
                      .session(target!.server!, target.username) !=
                  null
          ? <String, Object?>{
              'server': target.server.toString(),
              'username': target.username,
              'spaceId': target.spaceId
            }
          : null;
      if (account != null) {
        final spaceInfo = await MediaVault(AppDatabase.instance.database!)
            .read(SpaceLayout.info);
        if (spaceInfo != null) account['spaceInfo'] = base64Encode(spaceInfo);
      }
      _offer = OfflinePairingHost(
          identity: identity,
          transfer: _source!.grant.toJson(),
          account: account,
          authorizeDevice: account == null
              ? null
              : (request) => DeviceAuthManager.instance.queueAndAuthorize(
                  DeviceAuthManager.instance
                      .session(target!.server!, target.username)!,
                  request),
          lifetime:
              Duration(seconds: config['nearbyInvitationSeconds'] as int));
      _offer!.addListener(_offered);
      invitation = await _offer!.start();
      if (generation != _generation) {
        throw StateError('Nearby operation cancelled');
      }
      _set(NearbyState.offering);
    } catch (_) {
      await _closeSource();
      if (generation == _generation) _set(NearbyState.failed);
      rethrow;
    } finally {
      _running = false;
    }
  }

  void _offered() {
    if (_offer?.stage == OfflinePairingStage.comparing) {
      _set(NearbyState.comparing);
    } else if (_offer?.stage == OfflinePairingStage.approved ||
        _offer?.stage == OfflinePairingStage.transferred) {
      _set(NearbyState.waiting);
    } else if (_offer?.stage == OfflinePairingStage.cancelled) {
      _set(NearbyState.failed);
    }
  }

  Future<void> accept(String qr) async {
    if (_running) throw StateError('Nearby operation in progress');
    _running = true;
    final generation = ++_generation;
    _set(NearbyState.preparing);
    try {
      await _reset();
      await _assertEmpty();
      if (generation != _generation) {
        throw StateError('Nearby operation cancelled');
      }
      _receiver = OfflinePairingClient(OfflinePairingInvite.parse(qr));
      await _receiver!.start();
      if (generation != _generation) {
        throw StateError('Nearby operation cancelled');
      }
      _set(NearbyState.comparing);
    } catch (_) {
      _receiver?.close();
      _receiver = null;
      if (generation == _generation) _set(NearbyState.failed);
      rethrow;
    } finally {
      _running = false;
    }
  }

  Future<void> _assertEmpty() async {
    final db = AppDatabase.instance.database!;
    if (ConfigProvider.instance.get(Settings.syncTarget).isNotEmpty ||
        canResume ||
        (await db.query(entriesTable, columns: ['id'], limit: 1)).isNotEmpty) {
      destinationNotEmpty = true;
      _set(NearbyState.failed);
      throw NearbyDestinationNotEmpty();
    }
    destinationNotEmpty = false;
  }

  Future<void> confirm() async {
    if (_running || state != NearbyState.comparing) {
      throw StateError('No code to confirm');
    }
    if (_offer case final offer?) {
      await offer.confirm(offer.sas!);
      return;
    }
    final receiver = _receiver!;
    receiver.confirm(receiver.sas!);
    final generation = _generation;
    _running = true;
    _set(NearbyState.waiting);
    try {
      Map<String, dynamic>? received;
      // Explicitly bounded by the two-minute invitation and cancelled by closing
      // the HTTP client. This is the foreground authorization handshake only.
      while (generation == _generation && received == null) {
        received = await receiver.receiveGrant();
        if (received == null) {
          await Future<void>.delayed(const Duration(seconds: 1));
        }
      }
      if (generation != _generation || received == null) return;
      await _assertEmpty();
      final identity = DiaryIdentity.fromJson(
          (received['identity'] as Map).cast<String, Object?>());
      final grant = NearbyMigrationGrant.fromJson(
          (received['transfer'] as Map).cast<String, Object?>());
      final account = (received['account'] as Map?)?.cast<String, Object?>();
      final config = ConfigProvider.instance;
      final previousResume = config.get(Settings.nearbyMigration);
      final originalIdentity = config.get(Settings.identity);
      // Stage an authorized capability only after the empty/cancel checks.
      // The device identity is adopted after all requested data is received.
      await nearbyAdoptionTransaction(
          db: AppDatabase.instance.database!,
          requireEmpty: true,
          current: () =>
              generation == _generation &&
              config.get(Settings.syncTarget).isEmpty &&
              config.get(Settings.identity) == originalIdentity,
          persist: (txn) async {
            await config.set(
                Settings.nearbyMigration,
                jsonEncode({
                  'identity': identity.toJson(),
                  'transfer': grant.toJson(),
                  'originalIdentity': originalIdentity,
                  if (account != null) 'account': account
                }));
            if (generation != _generation) {
              throw StateError('Nearby operation cancelled');
            }
            await clearSyncState(txn);
          },
          restore: () => config.set(Settings.nearbyMigration, previousResume));
      if (account != null && generation == _generation) {
        try {
          final request = await DeviceAuthManager.instance.authorizationRequest(
              Uri.parse(account['server'] as String),
              account['username'] as String);
          if (generation == _generation) {
            await receiver.authorizeDevice(request);
          }
        } catch (_) {
          // Cloud reachability cannot block the trusted local data transfer.
        }
      }
      if (generation != _generation) return;
      await receiver.acknowledge();
      _receiver = null;
      await _receive(identity, grant, generation, originalIdentity);
    } catch (_) {
      if (generation == _generation) _set(NearbyState.failed);
      rethrow;
    } finally {
      _running = false;
    }
  }

  Future<void> resume() async {
    if (_running) throw StateError('Nearby operation in progress');
    final stored = ConfigProvider.instance.get(Settings.nearbyMigration);
    if (stored.isEmpty) {
      throw StateError('No nearby transfer to resume');
    }
    final data = jsonDecode(stored) as Map;
    if (data['phase'] == 'receipt') {
      await NearbyReceiptQueue.instance.flush();
      _set(NearbyState.complete);
      return;
    }
    if (ConfigProvider.instance.get(Settings.syncTarget).isNotEmpty) {
      throw StateError('Nearby destination changed');
    }
    final identity = DiaryIdentity.fromJson(
        (data['identity'] as Map).cast<String, Object?>());
    final String originalIdentity = data['originalIdentity'] as String? ??
        ConfigProvider.instance.get<String>(Settings.identity);
    if (ConfigProvider.instance.get(Settings.identity) != originalIdentity) {
      throw StateError('Nearby identity changed');
    }
    final grant = NearbyMigrationGrant.fromJson(
        (data['transfer'] as Map).cast<String, Object?>());
    final generation = _generation;
    _running = true;
    try {
      await _receive(identity, grant, generation, originalIdentity);
    } catch (_) {
      if (generation == _generation) _set(NearbyState.failed);
      rethrow;
    } finally {
      _running = false;
    }
  }

  Future<void> _receive(DiaryIdentity identity, NearbyMigrationGrant grant,
      int generation, String originalIdentity) async {
    final config = ConfigProvider.instance;
    bool current() =>
        generation == _generation &&
        config.get(Settings.syncTarget).isEmpty &&
        config.get(Settings.identity) == originalIdentity;
    if (!current()) throw StateError('Nearby identity or destination changed');
    _set(NearbyState.transferring);
    report = await receiveNearbyMigration(
        db: AppDatabase.instance.database!,
        photos: ImageStoragePhotos(),
        grant: grant,
        identity: identity,
        stopped: () => !current(),
        onProgress: (value) {
          progress = value;
          notifyListeners();
        });
    await SyncService.instance.reloadAfterMigration();
    if (generation != _generation) return;
    if (report!.pendingMedia == 0 && report!.mediaFailures == 0) {
      final previousResume = config.get(Settings.nearbyMigration);
      final resumed = jsonDecode(previousResume) as Map;
      await nearbyAdoptionTransaction(
          db: AppDatabase.instance.database!,
          current: current,
          afterPersist: () =>
              generation == _generation &&
              config.get(Settings.syncTarget).isEmpty &&
              config.get(Settings.identity) == jsonEncode(identity.toJson()),
          persist: (txn) async {
            await identity.keep();
            if (generation != _generation) {
              throw StateError('Nearby operation cancelled');
            }
            await clearSyncState(txn);
            await markAllChanged(txn);
            await config.set(
                Settings.nearbyMigration,
                jsonEncode({
                  ...resumed,
                  'phase': 'receipt',
                  'originalIdentity': jsonEncode(identity.toJson())
                }));
            // The final check uses the newly committed identity, not the original.
          },
          restore: () async {
            await config.set(Settings.identity, originalIdentity);
            await config.set(Settings.nearbyMigration, previousResume);
          });
      _set(NearbyState.complete);
      unawaited(NearbyReceiptQueue.instance.flush());
      if (resumed['account'] case final Map account) {
        try {
          await SyncService.instance
              .connectAuthorizedNearbyAccount(account.cast<String, Object?>());
        } catch (_) {
          // Cloud reconnection cannot undo a completed local migration.
        }
      }
    } else {
      _set(NearbyState.pending);
    }
  }

  Future<void> cancel({bool retainCompletion = false}) async {
    final completed = retainCompletion && state == NearbyState.complete;
    _generation++;
    await _reset();
    if (!completed) _set(NearbyState.idle);
  }

  Future<void> _reset() async {
    _receiver?.close();
    _receiver = null;
    await _closeSource();
    invitation = null;
    progress = null;
  }

  Future<void> _closeSource() async {
    final offer = _offer;
    _offer = null;
    final source = _source;
    _source = null;
    final staging = _staging;
    _staging = null;
    final folder = _folder;
    _folder = null;
    offer?.removeListener(_offered);
    await offer?.close();
    offer?.dispose();
    await source?.close();
    await staging?.close();
    if (folder != null && await folder.exists()) {
      await folder.delete(recursive: true);
    }
  }

  static const _nearby = MethodChannel('aid.nearby');
  Future<void> openWifiSettings() =>
      _nearby.invokeMethod<void>('openWifiSettings');
  Future<void> openHotspotSettings() =>
      _nearby.invokeMethod<void>('openHotspotSettings');
}
