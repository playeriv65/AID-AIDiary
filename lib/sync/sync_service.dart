// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

/// How to reach a WebDAV space.
class WebDavLogin {
  const WebDavLogin(
      {required this.server, required this.username, required this.password});

  final Uri server;
  final String username;
  final String password;

  WebDavBackend backend() =>
      WebDavBackend(server: server, username: username, password: password);
}

/// Where this device syncs. Secrets are kept apart, in the platform's
/// secure storage.
class SyncTarget {
  const SyncTarget(
      {required this.server,
      required this.username,
      required this.spaceId,
      required this.encrypted});

  final Uri server;
  final String username;
  final String spaceId;
  final bool encrypted;

  Map<String, Object?> toJson() => {
        'type': 'webdav',
        'server': server.toString(),
        'username': username,
        'spaceId': spaceId,
        'encrypted': encrypted,
      };

  factory SyncTarget.fromJson(Map<String, Object?> json) => SyncTarget(
      server: Uri.parse(json['server'] as String),
      username: json['username'] as String,
      spaceId: json['spaceId'] as String,
      encrypted: json['encrypted'] as bool);
}

enum SyncState {
  /// Not set up on this device.
  off,
  idle,
  syncing,
  failed,

  /// The space was reset or the key is missing: join it again.
  locked,
}

/// Photos in the app's image folder, external folder included.
class ImageStoragePhotos implements SyncPhotos {
  const ImageStoragePhotos();

  @override
  Future<bool> exists(String name) => ImageStorage.instance.exists(name);

  @override
  Future<Uint8List?> read(String name) => ImageStorage.instance.getBytes(name);

  @override
  Future<void> write(String name, Uint8List bytes) async {
    if (!await ImageStorage.instance.store(name, bytes)) {
      throw StateError('Could not store the synced photo $name');
    }
  }

  @override
  Future<void> delete(String name) => ImageStorage.instance.delete(name);
}

/// Keeps this device's diary in step with its space: sets spaces up, runs
/// syncs one at a time, and starts them after changes, on resume and while
/// the app is open.
class SyncService with ChangeNotifier {
  SyncService._();

  static final SyncService instance = SyncService._();
  static final Logger _logger = Logger('SyncService');

  SyncState _state = SyncState.off;
  SyncState get state => _state;

  /// Why the last sync failed.
  Object? error;
  SyncReport? lastReport;

  /// Entries (local ids) still waiting to go up while syncing is failing or
  /// locked. Empty while it works: synced is the normal state and is not
  /// marked, and a change waiting a few seconds for its turn is not either.
  Set<int> unsyncedEntryIds = const {};

  Future<void>? _running;
  bool _again = false;
  bool _reloading = false;
  Timer? _soon;
  Timer? _periodic;
  AppLifecycleListener? _lifecycle;

  SyncTarget? get target =>
      switch (ConfigProvider.instance.get(Settings.syncTarget)) {
        '' => null,
        final String json =>
          SyncTarget.fromJson(jsonDecode(json) as Map<String, Object?>),
      };

  DateTime? get lastSync =>
      DateTime.tryParse(ConfigProvider.instance.get(Settings.lastSync));

  ({String password, Uint8List? key}) get _secrets {
    final stored = ConfigProvider.instance.get(Settings.syncSecrets);
    if (stored.isEmpty) return (password: '', key: null);
    final json = jsonDecode(stored) as Map<String, Object?>;
    return (
      password: json['password'] as String,
      key: switch (json['key']) {
        final String key => base64.decode(key),
        _ => null,
      },
    );
  }

  WebDavLogin? get _login {
    final target = this.target;
    if (target == null) return null;
    return WebDavLogin(
        server: target.server,
        username: target.username,
        password: _secrets.password);
  }

  /// Starts syncing when the diary is open: now, after changes, on resume
  /// and every so often.
  void start() {
    for (final provider in <ChangeNotifier>[
      EntriesProvider.instance,
      TagsProvider.instance,
      TemplatesProvider.instance,
    ]) {
      provider.addListener(_changed);
    }
    _lifecycle ??= AppLifecycleListener(onResume: () => syncSoon());
    _periodic ??=
        Timer.periodic(AppConfig.instance.syncWhileOpen, (_) => syncSoon());
    if (target != null) {
      _setState(SyncState.idle);
      syncSoon();
    }
  }

  void _changed() {
    if (_reloading || target == null) return;
    syncSoon(after: AppConfig.instance.syncAfterChange);
  }

  /// Syncs after [after], once, however often it is asked.
  void syncSoon({Duration after = Duration.zero}) {
    if (target == null) return;
    _soon?.cancel();
    _soon = Timer(after, () => unawaited(syncNow()));
  }

  /// Syncs now; one more round follows when asked again meanwhile.
  Future<void> syncNow() {
    final running = _running;
    if (running != null) {
      _again = true;
      return running;
    }
    return _running = _run().whenComplete(() {
      _running = null;
      if (_again) {
        _again = false;
        unawaited(syncNow());
      }
    });
  }

  Future<void> _run() async {
    final target = this.target;
    final login = _login;
    if (target == null || login == null) return;
    _setState(SyncState.syncing);
    try {
      final backend = login.backend();
      final info = await _readSpace(backend);
      final key = _secrets.key;
      if (info == null ||
          info.id != target.spaceId ||
          (info.encrypted && key == null)) {
        error = null;
        await _markUnsynced();
        _setState(SyncState.locked);
        return;
      }
      final report = await SyncEngine(
              db: AppDatabase.instance.database!,
              backend: backend,
              photos: const ImageStoragePhotos(),
              cipher: info.encrypted ? ItemCipher(key!) : null)
          .sync();
      lastReport = report;
      if (report.changedLocally) await _reload();
      await ConfigProvider.instance
          .set(Settings.lastSync, DateTime.now().toIso8601String());
      error = null;
      unsyncedEntryIds = const {};
      _setState(SyncState.idle);
    } catch (e, stackTrace) {
      _logger.warning('Sync failed', e, stackTrace);
      error = e;
      await _markUnsynced();
      _setState(SyncState.failed);
    }
  }

  /// Finds the entries whose changes have not gone up.
  Future<void> _markUnsynced() async {
    final db = AppDatabase.instance.database;
    if (db == null) return;
    unsyncedEntryIds = await pendingEntryIds(db);
  }

  Future<void> _reload() async {
    _reloading = true;
    try {
      await EntriesProvider.instance.load();
      await EntryImagesProvider.instance.load();
      await TagsProvider.instance.load();
      await TemplatesProvider.instance.load();
      await AppDatabase.instance.updateExternalDatabase();
    } finally {
      _reloading = false;
    }
  }

  /// Signs in and reads the space at [login]: null when there is none yet.
  Future<SpaceInfo?> probe(WebDavLogin login) async {
    final backend = login.backend();
    await backend.check();
    return _readSpace(backend);
  }

  Future<SpaceInfo?> _readSpace(SyncBackend backend) async {
    final bytes = await backend.read(SpaceLayout.info);
    return bytes == null ? null : SpaceInfo.fromBytes(bytes);
  }

  /// Makes a new space at [login] with this diary in it, end-to-end
  /// encrypted with [passphrase] when one is given. Returns the recovery
  /// key to show once.
  Future<String?> createSpace(WebDavLogin login, {String? passphrase}) async {
    final backend = login.backend();
    if (await _readSpace(backend) != null) {
      throw StateError('There is already a space here');
    }
    final keys =
        passphrase == null ? null : await SpaceEncryption.create(passphrase);
    final info = SpaceInfo.create(encryption: keys?.encryption);
    await backend.write(SpaceLayout.info, info.toBytes());
    await _connect(login, info, keys?.key);
    return keys?.recoveryKey;
  }

  /// Joins the space at [login], opening an encrypted one with
  /// [passphrase] or [recoveryKey]. This diary's entries join it too.
  Future<void> joinSpace(WebDavLogin login, SpaceInfo space,
      {String? passphrase, String? recoveryKey}) async {
    final encryption = space.encryption;
    Uint8List? key;
    if (encryption != null) {
      key = recoveryKey != null
          ? await encryption.unlockWithRecoveryKey(recoveryKey)
          : await encryption.unlockWithPassphrase(passphrase ?? '');
    }
    await _connect(login, space, key);
  }

  /// Opens this device's space again after it was reset elsewhere or its
  /// key went missing.
  Future<void> unlock({String? passphrase, String? recoveryKey}) async {
    final login = _login;
    if (login == null) return;
    final space = await probe(login);
    if (space == null) throw StateError('The space is gone');
    await joinSpace(login, space,
        passphrase: passphrase, recoveryKey: recoveryKey);
  }

  Future<void> _connect(
      WebDavLogin login, SpaceInfo space, Uint8List? key) async {
    final db = AppDatabase.instance.database!;
    await clearSyncState(db);
    await markAllChanged(db);
    await _save(
        SyncTarget(
            server: login.server,
            username: login.username,
            spaceId: space.id,
            encrypted: space.encrypted),
        login.password,
        key);
    _setState(SyncState.idle);
    await syncNow();
  }

  /// Stops syncing on this device; the space and the diary stay as they are.
  Future<void> disconnect() async {
    _soon?.cancel();
    await _running;
    await clearSyncState(AppDatabase.instance.database!);
    await ConfigProvider.instance.set(Settings.syncTarget, '');
    await ConfigProvider.instance.set(Settings.syncSecrets, '');
    await ConfigProvider.instance.set(Settings.lastSync, '');
    lastReport = null;
    error = null;
    unsyncedEntryIds = const {};
    _setState(SyncState.off);
  }

  /// Locks the space key under a new passphrase; data and other devices
  /// are untouched.
  Future<void> changePassphrase(String passphrase) async {
    final login = _login!;
    final key = _secrets.key!;
    final backend = login.backend();
    final space = (await _readSpace(backend))!;
    final changed = SpaceInfo(
        id: space.id,
        encryption: await space.encryption!.withPassphrase(key, passphrase));
    await backend.write(SpaceLayout.info, changed.toBytes());
  }

  /// Starts the space over from this device's diary under a new key, for a
  /// forgotten passphrase: the old encrypted copy is removed and other
  /// devices join again with the new passphrase. Returns the new recovery
  /// key.
  Future<String> resetEncryption(String passphrase) async {
    final login = _login!;
    final backend = login.backend();
    await _running;
    for (final folder in [SpaceLayout.items, SpaceLayout.blobs]) {
      for (final path in (await backend.list(folder)).keys) {
        await backend.delete(path);
      }
    }
    final keys = await SpaceEncryption.create(passphrase);
    final info = SpaceInfo.create(encryption: keys.encryption);
    await backend.write(SpaceLayout.info, info.toBytes());
    await _connect(login, info, keys.key);
    return keys.recoveryKey;
  }

  Future<void> _save(SyncTarget target, String password, Uint8List? key) async {
    await ConfigProvider.instance.set(
        Settings.syncSecrets,
        jsonEncode({
          'password': password,
          if (key != null) 'key': base64.encode(key)
        }));
    await ConfigProvider.instance
        .set(Settings.syncTarget, jsonEncode(target.toJson()));
  }

  void _setState(SyncState state) {
    _state = state;
    notifyListeners();
  }
}
