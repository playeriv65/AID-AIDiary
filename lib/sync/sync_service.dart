// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

/// The kinds of place a space can live in.
enum SyncProvider { webdav, googleDrive }

/// How to reach a space and sign in there.
abstract interface class SyncLogin {
  SyncProvider get provider;

  /// The WebDAV server; null for a cloud drive.
  Uri? get server;

  /// Who is signed in: a username or an email address.
  String get username;

  /// What is kept secretly to sign in again: a password or a token.
  String get credential;

  SyncBackend backend();
}

class WebDavLogin implements SyncLogin {
  const WebDavLogin(
      {required Uri this.server,
      required this.username,
      required this.password});

  @override
  SyncProvider get provider => SyncProvider.webdav;
  @override
  final Uri? server;
  @override
  final String username;
  final String password;

  @override
  String get credential => password;

  @override
  WebDavBackend backend() =>
      WebDavBackend(server: server!, username: username, password: password);
}

class GoogleDriveLogin implements SyncLogin {
  GoogleDriveLogin({required this.username, required this.auth});

  @override
  SyncProvider get provider => SyncProvider.googleDrive;
  @override
  Uri? get server => null;
  @override
  final String username;
  final GoogleAuth auth;

  @override
  String get credential => auth.credential;

  @override
  GoogleDriveBackend backend() {
    final config = AppConfig.instance.googleDrive;
    return GoogleDriveBackend(
        api: config.apiUrl, upload: config.uploadUrl, token: auth.token);
  }
}

/// Where this device syncs. Secrets are kept apart, in the platform's
/// secure storage.
class SyncTarget {
  const SyncTarget(
      {required this.provider,
      this.server,
      required this.username,
      required this.spaceId});

  final SyncProvider provider;
  final Uri? server;
  final String username;
  final String spaceId;

  Map<String, Object?> toJson() => {
        'type': provider.name,
        if (server != null) 'server': server.toString(),
        'username': username,
        'spaceId': spaceId,
      };

  factory SyncTarget.fromJson(Map<String, Object?> json) => SyncTarget(
      provider: SyncProvider.values.byName(json['type'] as String),
      server: switch (json['server']) {
        final String server => Uri.parse(server),
        _ => null,
      },
      username: json['username'] as String,
      spaceId: json['spaceId'] as String);
}

/// The space belongs to another user's devices: this one joins by pairing
/// with one of them (sync/pairing.dart) or with the recovery code.
class NeedsKeyException implements Exception {
  @override
  String toString() =>
      'This space belongs to other devices: pair with one, or use the '
      'recovery code';
}

enum PairingStage { waiting, paired, failed }

/// The pairing this device last offered or took part in.
class PairingStatus {
  const PairingStatus(
      {required this.stage,
      this.code,
      this.otherDevice,
      this.failure,
      this.error,
      this.joined = false});

  final PairingStage stage;

  /// The code this device shows, when it offered.
  final PairingCode? code;
  final String? otherDevice;
  final PairingFailure? failure;

  /// What went wrong other than the pairing itself, such as the storage.
  final Object? error;

  /// Whether this device received the key and joined the space.
  final bool joined;
}

/// A chosen recovery password shorter than the app accepts.
class WeakRecoveryCodeException implements Exception {
  const WeakRecoveryCodeException(this.minLength);

  final int minLength;

  @override
  String toString() =>
      'A recovery password needs at least $minLength characters';
}

enum SyncState {
  /// Not set up on this device.
  off,
  idle,
  syncing,
  failed,

  /// The space was reset or belongs to another user's devices now: join it
  /// again by pairing or with the recovery code.
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

  /// How far the running sync is, once it has taken long enough to say;
  /// null otherwise.
  SyncProgress? progress;
  DateTime _started = DateTime(0);
  DateTime _progressShown = DateTime(0);
  static const _progressEvery = Duration(milliseconds: 250);

  /// Entries (local ids) still waiting to go up while syncing is failing or
  /// locked. Empty while it works: synced is the normal state and is not
  /// marked, and a change waiting a few seconds for its turn is not either.
  Set<int> unsyncedEntryIds = const {};

  Future<void>? _running;
  bool _again = false;
  bool _stopping = false;
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

  /// The login's password or token.
  String get _credential {
    final stored = ConfigProvider.instance.get(Settings.syncSecrets);
    if (stored.isEmpty) return '';
    return (jsonDecode(stored) as Map<String, Object?>)['password'] as String;
  }

  /// The login for the current target, kept so a cloud drive's tokens are
  /// reused between syncs.
  SyncLogin? _cachedLogin;

  SyncLogin? get _login {
    final target = this.target;
    if (target == null) return _cachedLogin = null;
    final cached = _cachedLogin;
    if (cached != null &&
        cached.provider == target.provider &&
        cached.username == target.username &&
        cached.server == target.server) {
      return cached;
    }
    final credential = _credential;
    return _cachedLogin = switch (target.provider) {
      SyncProvider.webdav => WebDavLogin(
          server: target.server!,
          username: target.username,
          password: credential),
      SyncProvider.googleDrive => GoogleDriveLogin(
          username: target.username,
          auth: GoogleAuth.forPlatform(credential: credential)),
    };
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
    _started = DateTime.now();
    _setState(SyncState.syncing);
    try {
      final backend = login.backend();
      final info = await _readSpace(backend);
      final dataKey = info == null || info.id != target.spaceId
          ? null
          : await _dataKey(info);
      if (info == null || dataKey == null) {
        // Another device's keys hold the space now: pairing with one of
        // them brings them here.
        if (info != null) _pendingJoin = (login: login, space: info);
        error = null;
        await _markUnsynced();
        _setState(SyncState.locked);
        return;
      }
      final report = await SyncEngine(
          db: AppDatabase.instance.database!,
          backend: backend,
          photos: const ImageStoragePhotos(),
          limits: SyncLimits(
              packBytes: AppConfig.instance.syncPackBytes,
              compactAfter: AppConfig.instance.syncCompactAfterPacks,
              parallel: AppConfig.instance.syncParallelTransfers),
          cipher: ItemCipher(dataKey),
          onProgress: _progressed,
          stopped: () => _stopping).sync();
      progress = null;
      lastReport = report;
      if (report.changedLocally) await _reload();
      await ConfigProvider.instance
          .set(Settings.lastSync, DateTime.now().toIso8601String());
      error = null;
      unsyncedEntryIds = const {};
      _setState(SyncState.idle);
    } catch (e, stackTrace) {
      _logger.warning('Sync failed', e, stackTrace);
      progress = null;
      error = e;
      await _markUnsynced();
      _setState(SyncState.failed);
    }
  }

  /// Passes on how far a slow sync is, a few times a second at most.
  void _progressed(SyncProgress progress) {
    final now = DateTime.now();
    if (now.difference(_started) < AppConfig.instance.syncProgressAfter) {
      return;
    }
    if (this.progress?.sending == progress.sending &&
        now.difference(_progressShown) < _progressEvery) {
      return;
    }
    _progressShown = now;
    this.progress = progress;
    notifyListeners();
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
  Future<SpaceInfo?> probe(SyncLogin login) async {
    final backend = login.backend();
    await backend.check();
    return _readSpace(backend);
  }

  Future<SpaceInfo?> _readSpace(SyncBackend backend) async {
    final bytes = await backend.read(SpaceLayout.info);
    return bytes == null ? null : SpaceInfo.fromBytes(bytes);
  }

  /// The data key of [space] from this device's master key; null when the
  /// space is another user's.
  Future<Uint8List?> _dataKey(SpaceInfo space) async {
    final identity = await DiaryIdentity.current();
    if (identity.userId != space.userId) return null;
    try {
      return await space.dataKey(identity.masterKey);
    } on WrongKeyException {
      return null;
    }
  }

  /// Whether this device holds the keys of [space].
  Future<bool> holdsKey(SpaceInfo space) async => await _dataKey(space) != null;

  static KdfParams get _recoveryKdf => KdfParams(
      memoryKiB: AppConfig.instance.recoveryArgon2MemoryKiB,
      iterations: AppConfig.instance.recoveryArgon2Iterations);

  /// [chosen], when it is long enough, or a new code; and whether the app
  /// made it.
  static ({String code, bool generated}) _recoveryCode(String? chosen) {
    if (chosen == null) {
      return (
        code: newRecoveryCode(AppConfig.instance.recoveryCodeBytes),
        generated: true
      );
    }
    final min = AppConfig.instance.recoveryMinPasswordLength;
    if (chosen.trim().length < min) throw WeakRecoveryCodeException(min);
    return (code: chosen, generated: false);
  }

  /// Makes a new space at [login] with this diary in it, locked by this
  /// device's master key. Returns the recovery code to show once: [chosen]
  /// when given, else a new random one.
  Future<String> createSpace(SyncLogin login, {String? chosen}) async {
    final backend = login.backend();
    if (await _readSpace(backend) != null) {
      throw StateError('There is already a space here');
    }
    final recovery = _recoveryCode(chosen);
    final info = await SpaceInfo.create(await DiaryIdentity.current(),
        recoveryCode: recovery.code,
        generated: recovery.generated,
        kdf: _recoveryKdf);
    await backend.write(SpaceLayout.info, info.toBytes());
    await _connect(login, info);
    return recovery.code;
  }

  /// Joins the space at [login], which this device's master key opens. One
  /// that belongs to other devices throws [NeedsKeyException] and waits as
  /// [pendingSpace]: pair with one of them or [recover]. This diary's
  /// entries join the space too.
  Future<void> joinSpace(SyncLogin login, SpaceInfo space) async {
    if (!await holdsKey(space)) {
      _pendingJoin = (login: login, space: space);
      notifyListeners();
      throw NeedsKeyException();
    }
    await _connect(login, space);
  }

  ({SyncLogin login, SpaceInfo space})? _pendingJoin;

  /// A space this device signed in to but cannot open yet: pairing brings
  /// its key.
  SpaceInfo? get pendingSpace => _pendingJoin?.space;

  /// The pairing this device last offered or took part in.
  PairingStatus? pairing;
  bool _pairingCancelled = false;

  String get _deviceName => DeviceInfoService().model ?? Platform.localHostname;

  /// A pairing of this device: as the one with the key when it syncs a
  /// space, else as the one waiting to join [pendingSpace].
  Future<({Pairing pairing, SyncLogin? joining})> _newPairing() async {
    final identity = await DiaryIdentity.current();
    final config = AppConfig.instance;
    Pairing pairing(SyncBackend backend, SpaceInfo space, bool holdsKey) =>
        Pairing(
            backend: backend,
            space: space,
            identity: identity,
            holdsKey: holdsKey,
            deviceName: _deviceName,
            poll: config.pairingPoll,
            timeout: config.pairingTimeout);
    final current = await currentSpace();
    if (current != null && await holdsKey(current.space)) {
      return (
        pairing: pairing(current.backend, current.space, true),
        joining: null
      );
    }
    if (_pendingJoin case (:final login, :final space)) {
      return (
        pairing: pairing(login.backend(), space, await holdsKey(space)),
        joining: login
      );
    }
    throw StateError('Sync is not set up on this device');
  }

  /// Shows a pairing code for the other device to type or scan; the
  /// pairing goes on in [pairing].
  Future<PairingCode> offerPairing() async {
    final (:pairing, :joining) = await _newPairing();
    _pairingCancelled = false;
    final code = await pairing.offer(AppConfig.instance.pairingCodeDigits);
    _setPairing(PairingStatus(stage: PairingStage.waiting, code: code));
    unawaited(_finishPairing(
        () => pairing.finishOffer(code, cancelled: () => _pairingCancelled),
        pairing.space,
        joining));
    return code;
  }

  /// Pairs with the device showing [code], typed or scanned; a
  /// [FormatException] when it is not a code.
  Future<PairingStatus> acceptPairing(String code) async {
    final parsed =
        PairingCode.parse(code, AppConfig.instance.pairingCodeDigits) ??
            (throw const FormatException('Not a pairing code'));
    final (:pairing, :joining) = await _newPairing();
    _pairingCancelled = false;
    _setPairing(const PairingStatus(stage: PairingStage.waiting));
    return _finishPairing(
        () => pairing.accept(parsed, cancelled: () => _pairingCancelled),
        pairing.space,
        joining);
  }

  /// Stops the pairing that waits for the other device.
  void cancelPairing() => _pairingCancelled = true;

  Future<PairingStatus> _finishPairing(Future<PairingResult> Function() run,
      SpaceInfo space, SyncLogin? joining) async {
    final offered = pairing?.code;
    PairingStatus status;
    try {
      final result = await run();
      if (result.received case final identity?) {
        await joinAs(joining!, space, identity);
      }
      status = PairingStatus(
          stage: PairingStage.paired,
          code: offered,
          otherDevice: result.otherDevice,
          joined: result.received != null);
    } on PairingException catch (e) {
      status = PairingStatus(
          stage: PairingStage.failed, code: offered, failure: e.failure);
    } catch (e, stackTrace) {
      _logger.warning('Pairing failed', e, stackTrace);
      status =
          PairingStatus(stage: PairingStage.failed, code: offered, error: e);
    }
    _setPairing(status);
    return status;
  }

  void _setPairing(PairingStatus status) {
    pairing = status;
    notifyListeners();
  }

  /// Joins [space] with [identity], the user's from another device or the
  /// recovery code: it becomes this device's own.
  Future<void> joinAs(
      SyncLogin login, SpaceInfo space, DiaryIdentity identity) async {
    if (identity.userId != space.userId) throw WrongKeyException();
    await space.dataKey(identity.masterKey);
    await identity.keep();
    await _connect(login, space);
  }

  /// Joins [space] with its recovery [code], restoring the user's master
  /// key on this device; [WrongKeyException] for a wrong code.
  Future<void> recover(SyncLogin login, SpaceInfo space, String code) async {
    final masterKey = await space.recovery.unlock(space.userId, code);
    await joinAs(login, space,
        DiaryIdentity(userId: space.userId, masterKey: masterKey));
  }

  /// Opens this device's space again after it went to other devices or
  /// was started over, with its recovery [code].
  Future<void> unlock(String code) async {
    final login = _login;
    if (login == null) return;
    final space = await probe(login);
    if (space == null) throw StateError('The space is gone');
    await recover(login, space, code);
  }

  /// The space this device syncs and its backend, for pairing another
  /// device; null when it syncs none.
  Future<({SyncBackend backend, SpaceInfo space})?> currentSpace() async {
    final login = _login;
    if (login == null) return null;
    final backend = login.backend();
    final space = await _readSpace(backend);
    if (space == null || space.id != target?.spaceId) return null;
    return (backend: backend, space: space);
  }

  Future<void> _connect(SyncLogin login, SpaceInfo space) async {
    _pendingJoin = null;
    final db = AppDatabase.instance.database!;
    await clearSyncState(db);
    await markAllChanged(db);
    _cachedLogin = login;
    await _save(
        SyncTarget(
            provider: login.provider,
            server: login.server,
            username: login.username,
            spaceId: space.id),
        login.credential);
    _setState(SyncState.idle);
    // A first sync may take long; it goes on while the page shows how far
    // it is.
    unawaited(syncNow());
  }

  /// Stops the running sync after the item in hand and waits for it.
  Future<void> _stop() async {
    _soon?.cancel();
    _stopping = true;
    try {
      await _running;
    } finally {
      _stopping = false;
    }
  }

  /// Signs in to the cloud drive again after Google asked for it, keeping
  /// the space and its key.
  Future<void> signInAgain({required String doneMessage}) async {
    final login = _login;
    if (login is! GoogleDriveLogin) return;
    await login.auth.signIn(doneMessage: doneMessage);
    await _save(target!, login.credential);
    await syncNow();
  }

  /// Stops syncing on this device; the space and the diary stay as they are.
  Future<void> disconnect() async {
    await _stop();
    await clearSyncState(AppDatabase.instance.database!);
    await ConfigProvider.instance.set(Settings.syncTarget, '');
    await ConfigProvider.instance.set(Settings.syncSecrets, '');
    await ConfigProvider.instance.set(Settings.lastSync, '');
    _cachedLogin = null;
    lastReport = null;
    error = null;
    unsyncedEntryIds = const {};
    _setState(SyncState.off);
  }

  /// Locks the master key in the space under a new recovery code: [chosen]
  /// when given, else a new random one, which is returned to show once.
  /// Data, keys and other devices are untouched.
  Future<String> changeRecoveryCode({String? chosen}) async {
    final current = await currentSpace();
    if (current == null || !await holdsKey(current.space)) {
      throw NeedsKeyException();
    }
    final recovery = _recoveryCode(chosen);
    final identity = await DiaryIdentity.current();
    final lock = await RecoveryLock.lock(
        identity.masterKey, identity.userId, recovery.code, _recoveryKdf,
        generated: recovery.generated);
    await current.backend
        .write(SpaceLayout.info, current.space.withRecovery(lock).toBytes());
    return recovery.code;
  }

  /// Starts the space over from this device's diary, as this device's
  /// user, when no device and no recovery code opens it any more: the old
  /// encrypted copy is removed and other devices join again by pairing.
  /// Returns the new recovery code.
  Future<String> resetSpace({String? chosen}) async {
    final login = _login!;
    final backend = login.backend();
    await _stop();
    for (final folder in [SpaceLayout.packs, SpaceLayout.blobs]) {
      for (final path in (await backend.list(folder)).keys) {
        await backend.delete(path);
      }
    }
    final recovery = _recoveryCode(chosen);
    final info = await SpaceInfo.create(await DiaryIdentity.current(),
        recoveryCode: recovery.code,
        generated: recovery.generated,
        kdf: _recoveryKdf);
    await backend.write(SpaceLayout.info, info.toBytes());
    await _connect(login, info);
    return recovery.code;
  }

  Future<void> _save(SyncTarget target, String credential) async {
    await ConfigProvider.instance
        .set(Settings.syncSecrets, jsonEncode({'password': credential}));
    await ConfigProvider.instance
        .set(Settings.syncTarget, jsonEncode(target.toJson()));
  }

  void _setState(SyncState state) {
    _state = state;
    notifyListeners();
  }
}
