// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/nearby_migration.dart';

/// A dropped receipt never turns a fully committed local diary into a failure.
class NearbyReceiptQueue {
  NearbyReceiptQueue(
      {Future<void> Function(NearbyMigrationGrant, DiaryIdentity)? send,
      this.retryDelay})
      : _send = send ?? acknowledgeNearbyMigration;
  static final instance = NearbyReceiptQueue();
  final Future<void> Function(NearbyMigrationGrant, DiaryIdentity) _send;
  final Duration? retryDelay;
  Timer? _retry;
  Future<bool>? _running;
  String? _acknowledged;
  Future<bool> flush() =>
      _running ??= _flush().whenComplete(() => _running = null);
  Future<bool> _flush() async {
    _retry?.cancel();
    final config = ConfigProvider.instance;
    final stored = config.get(Settings.nearbyMigration);
    if (stored.isEmpty) return true;
    final pending = jsonDecode(stored) as Map;
    if (pending['phase'] != 'receipt') return false;
    final identity = DiaryIdentity.fromJson(
        (pending['identity'] as Map).cast<String, Object?>());
    if (config.get(Settings.identity) != jsonEncode(identity.toJson())) {
      return false;
    }
    final grant = NearbyMigrationGrant.fromJson(
        (pending['transfer'] as Map).cast<String, Object?>());
    if (_acknowledged != stored && DateTime.now().isBefore(grant.expires)) {
      try {
        await _send(grant, identity);
        _acknowledged = stored;
      } catch (_) {
        _schedule();
        return false;
      }
    }
    if (config.get(Settings.nearbyMigration) == stored) {
      try {
        await config.set(Settings.nearbyMigration, '');
      } catch (_) {
        // The setter updates its cache before native persistence. Restore that
        // receipt in memory too, so a failed native clear cannot lose the retry.
        try {
          await config.set(Settings.nearbyMigration, stored);
        } catch (_) {}
        _schedule();
        return false;
      }
    }
    _acknowledged = null;
    return true;
  }

  void _schedule() {
    final delay = retryDelay ??
        Duration(
            seconds:
                AppConfig.instance.syncTransfer['retryBaseSeconds'] as int);
    _retry = Timer(delay, () => unawaited(flush()));
  }

  void dispose() {
    _retry?.cancel();
  }
}
