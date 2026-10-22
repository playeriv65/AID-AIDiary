// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_backend.dart';

/// One encrypted change log across storage and verified peers. Local copies
/// are an outbox and an offline index, never a remote acknowledgement.
class RoutedSyncBackend implements SyncBackend {
  RoutedSyncBackend(
      {required this.local,
      required this.storage,
      required this.peers,
      this.storageAvailable,
      this.onStorageFailure,
      this.timeoutFor,
      this.timeout = const Duration(seconds: 4)});
  final SyncBackend local;
  final SyncBackend storage;
  final Iterable<SyncBackend> Function() peers;
  final Duration timeout;
  final bool Function()? storageAvailable;
  final void Function()? onStorageFailure;
  final Duration Function(SyncBackend)? timeoutFor;
  Duration _timeout(SyncBackend route) => timeoutFor?.call(route) ?? timeout;
  final Set<SyncBackend> _snapshotAcknowledged = {};
  List<SyncBackend> get _routes =>
      [...peers(), if (storageAvailable?.call() ?? true) storage];

  @override
  Future<void> check() async {
    await _first<void>([
      for (final route in _routes) () => route.check().timeout(_timeout(route))
    ]);
  }

  @override
  Future<Map<String, String>> list(String folder) async {
    final files = await local.list(folder);
    final results = await Future.wait([
      for (final route in _routes)
        () async {
          try {
            return await route.list(folder).timeout(_timeout(route));
          } catch (_) {
            if (identical(route, storage)) onStorageFailure?.call();
            return <String, String>{};
          }
        }()
    ]);
    for (final result in results) {
      files.addAll(result);
    }
    return files;
  }

  @override
  Future<Uint8List?> read(String path) async {
    Uint8List? bytes;
    try {
      bytes = await _first<Uint8List>([
        for (final route in _routes)
          () async {
            Uint8List? value;
            try {
              value = await route.read(path).timeout(_timeout(route));
            } catch (_) {
              if (identical(route, storage)) onStorageFailure?.call();
              rethrow;
            }
            if (value == null) throw StateError('Object absent on route');
            return value;
          }
      ]);
    } catch (_) {
      return local.read(path);
    }
    await local.write(path, bytes);
    return bytes;
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    // Return on the first remote acknowledgement. Other paths remain an
    // outbox drain; they cannot hold up a reachable LAN peer.
    final version = await _first<String?>([
      for (final route in _routes)
        () async {
          String? result;
          try {
            result = await route.write(path, bytes).timeout(_timeout(route));
          } catch (_) {
            if (identical(route, storage)) onStorageFailure?.call();
            rethrow;
          }
          if (SpaceLayout.isSnapshot(path)) _snapshotAcknowledged.add(route);
          return result;
        }
    ]);
    // A write that reached no other device stays a local database change.
    // It must not reappear as an incoming pack and acknowledge itself.
    await local.write(path, bytes);
    return version;
  }

  @override
  Future<void> delete(String path) async {
    await local.delete(path);
    await Future.wait([
      for (final route in _routes)
        () async {
          if (path.startsWith('${SpaceLayout.packs}/') &&
              !_snapshotAcknowledged.contains(route)) {
            return;
          }
          try {
            await route.delete(path).timeout(_timeout(route));
          } catch (_) {/* Retry via snapshots. */}
        }()
    ]);
  }

  /// Pushes packs received through a different route while this one was away.
  /// Metadata is immutable, so no route has its own version semantics.
  Future<void> drain() async {
    final packs = await local.list(SpaceLayout.packs);
    await Future.wait([
      for (final route in _routes)
        () async {
          try {
            final present =
                await route.list(SpaceLayout.packs).timeout(_timeout(route));
            for (final path in packs.keys) {
              if (present.containsKey(path)) continue;
              final bytes = await local.read(path);
              if (bytes != null) {
                await route.write(path, bytes).timeout(_timeout(route));
              }
            }
          } catch (_) {
            if (identical(route, storage)) onStorageFailure?.call();
            // The durable outbox is tried on the next sync.
          }
        }()
    ]);
  }

  Future<T> _first<T>(List<Future<T> Function()> attempts) {
    final result = Completer<T>();
    var left = attempts.length;
    if (left == 0) return Future.error(StateError('No route available'));
    for (final attempt in attempts) {
      Future<T>.sync(attempt).then((value) {
        if (!result.isCompleted) result.complete(value);
      }, onError: (Object error, StackTrace stack) {
        if (--left == 0 && !result.isCompleted) {
          result.completeError(error, stack);
        }
      });
    }
    return result.future;
  }
}

/// Reachability chooses a path; availability chooses the source for each
/// object. An online device missing a video must not hide another copy.
class PeerSyncBackend implements SyncBackend {
  PeerSyncBackend(
      {required this.current,
      required this.sources,
      this.timeout = const Duration(seconds: 4)});
  final SyncBackend? Function() current;
  final Iterable<SyncBackend> Function() sources;
  final Duration timeout;
  SyncBackend get _current => current() ?? (throw StateError('No direct peer'));
  @override
  Future<void> check() => _current.check();
  @override
  Future<Map<String, String>> list(String folder) => _current.list(folder);
  @override
  Future<String?> write(String path, Uint8List bytes) =>
      _current.write(path, bytes);
  @override
  Future<void> delete(String path) => _current.delete(path);
  @override
  Future<Uint8List?> read(String path) async {
    // All these routes are direct and authenticated. Cloud requests are kept
    // outside the pool so a zero cloud budget cannot be bypassed by probing.
    final result = Completer<Uint8List?>();
    final routes = sources().toSet();
    var left = routes.length;
    if (left == 0) return null;
    for (final route in routes) {
      route.read(path).timeout(timeout).then((bytes) {
        if (bytes != null && !result.isCompleted) result.complete(bytes);
        if (--left == 0 && !result.isCompleted) result.complete(null);
      }, onError: (Object _) {
        if (--left == 0 && !result.isCompleted) result.complete(null);
      });
    }
    return result.future;
  }
}
