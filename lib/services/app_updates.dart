// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitType, Locale;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A build newer than the running one, as the release manifest lists it.
class AppUpdate {
  const AppUpdate({
    required this.version,
    required this.build,
    required this.notes,
    required this.url,
    required this.sha256,
    required this.size,
  });

  final String version;
  final int build;

  /// What changed since the build before it, one line each, by language
  /// (`en`, `zh`, `zh_Hant`, ...): CHANGES.json's entries.
  final Map<String, List<String>> notes;
  final Uri url;
  final String sha256;
  final int size;

  /// How the user sees it: every nightly shares a version name, so the
  /// build number tells them apart.
  String get label => '$version ($build)';

  /// Whether the user chose to skip this build when it was offered.
  bool get skipped =>
      build == ConfigProvider.instance.get(Settings.skippedUpdate);

  /// The notes in [locale]'s language: with its script or region when the
  /// manifest has them, else the language, else English.
  List<String> notesFor(Locale locale) {
    final language = locale.languageCode;
    for (final key in [
      if (locale.scriptCode case final script?) '${language}_$script',
      if (locale.countryCode case final country?) '${language}_$country',
      language,
      'en',
    ]) {
      if (notes[key] case final lines?) return lines;
    }
    return const [];
  }

  /// Notes as the manifest or settings hold them: by language, or, from a
  /// manifest or an app before languages, one English list.
  static Map<String, List<String>> _notes(Object? byLanguage, Object? english) {
    if (byLanguage == null) {
      return {'en': english == null ? [] : _noteLines(english)};
    }
    if (byLanguage is! Map<String, dynamic>) {
      throw const FormatException('Localized notes must be an object');
    }
    return {
      for (final MapEntry(:key, :value) in byLanguage.entries)
        key: _noteLines(value),
    };
  }

  static List<String> _noteLines(Object? lines) {
    if (lines is! List || lines.any((line) => line is! String)) {
      throw const FormatException('Release notes must be a list of strings');
    }
    return List<String>.from(lines);
  }

  /// The entry for [package] in the manifest found at [source], newer than
  /// [installed]; null when it has none or none newer. Files are named
  /// beside the manifest, so a mirror serves the same manifest.
  static AppUpdate? from(Map<String, dynamic> manifest,
      {required Uri source, required String package, required int installed}) {
    final build = manifest['build'];
    final version = manifest['version'];
    final files = manifest['files'];
    if (build is! int ||
        build <= 0 ||
        version is! String ||
        version.trim().isEmpty ||
        files is! Map<String, dynamic>) {
      throw const FormatException('Invalid release manifest');
    }
    final notes = _notes(manifest['notesByLanguage'], manifest['notes']);
    if (!files.containsKey(package)) return null;
    final file = files[package];
    if (file is! Map<String, dynamic>) {
      throw const FormatException('Invalid package entry in the manifest');
    }
    final name = file['name'];
    if (name is! String ||
        name.isEmpty ||
        name == '.' ||
        name == '..' ||
        RegExp(r'[^A-Za-z0-9._-]').hasMatch(name)) {
      throw const UpdateException('corrupt', 'Bad file name in the manifest');
    }
    final hash = file['sha256'];
    final size = file['size'];
    if (hash is! String ||
        hash.length != 64 ||
        RegExp(r'[^A-Fa-f0-9]').hasMatch(hash) ||
        size is! int ||
        size <= 0) {
      throw const FormatException(
          'Invalid package hash or size in the manifest');
    }
    if (build <= installed) return null;
    return AppUpdate(
      version: version,
      build: build,
      notes: notes,
      url: source.resolve(name),
      sha256: hash.toLowerCase(),
      size: size,
    );
  }

  Map<String, Object?> toJson() => {
        'version': version,
        'build': build,
        'notes': notes,
        'url': '$url',
        'sha256': sha256,
        'size': size,
      };

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        version: json['version'] as String,
        build: json['build'] as int,
        notes:
            _notes(json['notes'] is Map ? json['notes'] : null, json['notes']),
        url: Uri.parse(json['url'] as String),
        sha256: json['sha256'] as String,
        size: json['size'] as int,
      );
}

/// What came of handing a package to the system installer.
enum UpdateInstall {
  /// Installing; the app is replaced and restarts.
  started,

  /// The system shows its own confirmation first.
  confirming,

  /// The user has not let this app install apps yet; its settings page is
  /// open.
  needsPermission,
}

/// The package of [update], while it downloads and once it is verified.
class UpdateDownload {
  const UpdateDownload(this.update, {this.received = 0, this.file});

  final AppUpdate update;

  /// Bytes on disk so far.
  final int received;

  /// The verified package; null while it downloads.
  final File? file;

  bool get ready => file != null;

  /// 0 to 1.
  double get progress => received / update.size;

  Map<String, Object?> toJson() => {
        'build': update.build,
        'state': ready ? 'ready' : 'downloading',
        'received': received,
        'size': update.size,
      };
}

/// Why an update did not download or install; [code] is stable for scripts.
class UpdateException implements Exception {
  const UpdateException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => '$code: $message';
}

/// Finds, fetches and installs newer builds from the release manifest
/// (docs/UPDATES.md): on Android and in the installed Windows app.
class AppUpdates {
  AppUpdates({http.Client? client, this.channel = _channel, String? os})
      : _client = client ?? http.Client(),
        os = os ?? Platform.operatingSystem;

  /// The app's one instance; widget tests put one with a fake network and
  /// platform in its place.
  static AppUpdates instance = AppUpdates();
  static const _channel = MethodChannel('$appNamespace/updates');
  static final _logger = Logger('AppUpdates');

  final http.Client _client;
  final MethodChannel channel;

  /// [Platform.operatingSystem], unless a test says otherwise.
  final String os;

  /// Whether this build can install an update itself: Android, but not the
  /// F-Droid build, which F-Droid's client updates; Windows when the
  /// installer put the app there, not a copy from the ZIP or a build folder.
  Future<bool> enabled() async => switch (os) {
        'android' => await channel.invokeMethod<bool>('enabled') ?? false,
        'windows' => File(p.join(p.dirname(Platform.resolvedExecutable),
                AppConfig.instance.updateWindowsUninstaller))
            .existsSync(),
        _ => false,
      };

  /// The manifest's name for this app's package: the Windows installer, or
  /// on Android the release app or the development one.
  String packageKey(String packageName) => os == 'windows'
      ? 'windows'
      : packageName.endsWith('.beta')
          ? 'android-dev'
          : 'android';

  /// The update for this app, or null when it is the newest. Asks each
  /// manifest address in turn until one returns a valid manifest.
  Future<AppUpdate?> check() async {
    final config = AppConfig.instance;
    final info = DeviceInfoService().appInfo;
    if (info == null) throw StateError('App info is not loaded');
    final package = packageKey(info.packageName);
    final installed = int.parse(info.buildNumber);
    final failures = <String>[];
    for (final source in config.updateManifestUrls) {
      final AppUpdate? update;
      try {
        final response =
            await _client.get(source).timeout(config.updateTimeout);
        if (response.statusCode != 200) {
          failures.add('${source.host}: HTTP ${response.statusCode}');
          continue;
        }
        final manifest = jsonDecode(utf8.decode(response.bodyBytes));
        if (manifest is! Map<String, dynamic>) {
          throw const FormatException('Update manifest must be a JSON object');
        }
        update = AppUpdate.from(manifest,
            source: source, package: package, installed: installed);
      } on Exception catch (error) {
        failures.add('${source.host}: $error');
        continue;
      }
      await ConfigProvider.instance
          .set(Settings.lastUpdateCheck, DateTime.now().toIso8601String());
      // The manifest offers nothing newer, as after a rollback: a package
      // downloaded for an earlier answer is no longer wanted.
      if (update == null) await discard();
      return update;
    }
    throw UpdateException('unavailable', failures.join('; '));
  }

  /// [check], when checks are on, the last one is long enough ago, and the
  /// user has not skipped what it finds. Errors are logged, not shown: the
  /// next opening tries again.
  Future<AppUpdate?> due({DateTime? now}) async {
    final settings = ConfigProvider.instance;
    if (!settings.get(Settings.updateChecks) || !await enabled()) return null;
    final last = DateTime.tryParse(settings.get(Settings.lastUpdateCheck));
    final at = now ?? DateTime.now();
    if (last != null &&
        at.difference(last) < AppConfig.instance.updateCheckInterval) {
      return null;
    }
    try {
      final update = await check();
      return update == null || update.skipped ? null : update;
    } catch (error, stackTrace) {
      _logger.info('Update check failed', error, stackTrace);
      return null;
    }
  }

  /// The package of the update found last, while it downloads and once it
  /// is verified; null when there is none. One package at a time.
  final downloadState = ValueNotifier<UpdateDownload?>(null);

  /// The update whose package the cache folder holds or is filling.
  AppUpdate? _pending;
  Future<void>? _loaded;
  _Download? _running;

  static const _record = 'update.json';

  /// The app's own cache: Android's cache directory, which the native
  /// installer accepts packages from, and on Windows
  /// `%LOCALAPPDATA%\<app id>`.
  Future<Directory> _folder() async =>
      Directory(p.join((await getApplicationCacheDirectory()).path, 'updates'));

  File _package(Directory folder, AppUpdate update) => File(p.join(folder.path,
      'update-${update.build}${p.url.extension(update.url.path)}'));

  int get _installed =>
      int.tryParse(DeviceInfoService().appInfo?.buildNumber ?? '') ?? 0;

  /// The update an earlier run found and downloaded, or began to: newer
  /// than this app and not skipped. Everything else in the folder, such
  /// as the package this app was installed from, is removed.
  Future<AppUpdate?> pending() async {
    await (_loaded ??= _load());
    return _pending;
  }

  Future<void> _load() async {
    final folder = await _folder();
    AppUpdate? update;
    try {
      update = AppUpdate.fromJson(
          jsonDecode(await File(p.join(folder.path, _record)).readAsString())
              as Map<String, dynamic>);
    } on Exception {
      // No record, or an unreadable one: nothing to resume.
    }
    if (update == null || update.build <= _installed || update.skipped) {
      await _clear(folder);
      return;
    }
    final package = _package(folder, update);
    final keep = {_record, p.basename(package.path), _partName(package)};
    await for (final entity in folder.list()) {
      if (!keep.contains(p.basename(entity.path))) await _delete(entity);
    }
    _pending = update;
    if (!await package.exists()) return;
    if (await _matches(package, update)) {
      downloadState.value =
          UpdateDownload(update, received: update.size, file: package);
    } else {
      await _delete(package);
    }
  }

  /// Downloads [update] into the app's cache, or continues the download
  /// already under way or left by an earlier run, and checks the package's
  /// size and SHA-256 against the manifest. A verified package is returned
  /// at once. A download of another build stops and its files go:
  /// whichever build the caller asks for replaces it. [progress] gets 0
  /// to 1.
  Future<File> download(AppUpdate update,
      {void Function(double done)? progress}) async {
    // Under way from the start, for whoever looks at once.
    if (downloadState.value?.update.build != update.build) {
      downloadState.value = UpdateDownload(update);
    }
    await pending();
    final running = _running;
    if (running != null && running.update.build != update.build) {
      await _stop();
    }
    final current = downloadState.value;
    if (current != null &&
        current.update.build == update.build &&
        current.file != null) {
      if (await current.file!.exists()) return current.file!;
      downloadState.value = null;
    }
    final job = _running ??= _Download(update)..start(_fetch);
    if (progress == null) return job.done;
    void report() {
      final state = downloadState.value;
      if (state != null && state.update.build == update.build) {
        progress(state.progress);
      }
    }

    downloadState.addListener(report);
    try {
      report();
      return await job.done;
    } finally {
      downloadState.removeListener(report);
    }
  }

  /// [download] in the background, as the app does once it finds an
  /// update: not on a metered network, where Android apps leave large
  /// downloads to the user. The verified package, or null when the network
  /// is metered or the download failed. A failure is logged, not shown:
  /// the next check tries again.
  Future<File?> prefetch(AppUpdate update) async {
    if (await metered()) return null;
    try {
      return await download(update);
    } on Exception catch (error, stackTrace) {
      _logger.info('Background update download failed', error, stackTrace);
      return null;
    }
  }

  /// Whether the network costs the user per byte: Android's metered
  /// networks, and none at all. Windows counts as unmetered.
  Future<bool> metered() async =>
      os == 'android' && (await channel.invokeMethod<bool>('metered') ?? true);

  /// Stops any download and removes its files: the user skipped the
  /// build, or the manifest no longer offers one.
  Future<void> discard() async {
    await pending();
    await _stop();
    _pending = null;
    downloadState.value = null;
    await _clear(await _folder());
  }

  Future<void> _stop() async {
    final running = _running;
    if (running == null) return;
    running.cancel();
    try {
      await running.done;
    } on Exception {
      // Stopped on purpose.
    }
  }

  /// Fills [job]'s package, from where an earlier attempt stopped when the
  /// server can serve the rest (an HTTP range request).
  Future<File> _fetch(_Download job) async {
    final update = job.update;
    final folder = await _folder();
    try {
      if (_pending?.build != update.build) {
        await _clear(folder);
        await folder.create(recursive: true);
        await File(p.join(folder.path, _record))
            .writeAsString(jsonEncode(update.toJson()));
        _pending = update;
      }
      final package = _package(folder, update);
      final part = File(p.join(folder.path, _partName(package)));
      var offset = await part.exists() ? await part.length() : 0;
      if (offset > update.size) {
        await _delete(part);
        offset = 0;
      }
      _report(update, offset);
      if (offset < update.size) {
        offset = await _transfer(job, part, offset);
      }
      if (offset != update.size || !await _matches(part, update)) {
        await _delete(part);
        throw const UpdateException(
            'corrupt', 'Download does not match the release manifest');
      }
      final file = await part.rename(package.path);
      downloadState.value =
          UpdateDownload(update, received: update.size, file: file);
      return file;
    } catch (_) {
      if (downloadState.value?.update.build == update.build) {
        downloadState.value = null;
      }
      rethrow;
    } finally {
      if (_running == job) _running = null;
    }
  }

  /// Appends the rest of [job]'s package to [part], which holds [offset]
  /// bytes; returns the size it reached.
  Future<int> _transfer(_Download job, File part, int offset) async {
    final update = job.update;
    final config = AppConfig.instance;
    final request = http.Request('GET', update.url);
    if (offset > 0) request.headers['Range'] = 'bytes=$offset-';
    final response = await _client.send(request).timeout(config.updateTimeout);
    if (job.cancelled) throw _Download.stopped;
    var received = offset;
    if (response.statusCode == 200) {
      received = 0;
    } else if (response.statusCode != 206 ||
        !(response.headers['content-range'] ?? '')
            .startsWith('bytes $offset-')) {
      if (response.statusCode == 206) await _delete(part);
      throw UpdateException(
          'unavailable', 'Download: HTTP ${response.statusCode}');
    }
    final sink =
        part.openWrite(mode: received == 0 ? FileMode.write : FileMode.append);
    final finished = Completer<void>();
    late final StreamSubscription<List<int>> subscription;
    void fail(Object error, [StackTrace? stackTrace]) {
      if (finished.isCompleted) return;
      subscription.cancel();
      finished.completeError(error, stackTrace);
    }

    subscription = response.stream.timeout(config.updateDownloadTimeout).listen(
        (chunk) {
          received += chunk.length;
          if (received > update.size) {
            fail(const UpdateException('corrupt', 'Download is too large'));
            return;
          }
          sink.add(chunk);
          _report(update, received);
        },
        onError: fail,
        onDone: () {
          if (!finished.isCompleted) finished.complete();
        },
        cancelOnError: true);
    job.abort = () => fail(_Download.stopped);
    try {
      await finished.future;
    } finally {
      job.abort = null;
      await sink.close();
    }
    return received;
  }

  /// Notes [received] bytes of [update], when the whole percent changes.
  void _report(AppUpdate update, int received) {
    final state = downloadState.value;
    if (state != null &&
        state.update.build == update.build &&
        state.received * 100 ~/ update.size == received * 100 ~/ update.size) {
      return;
    }
    downloadState.value = UpdateDownload(update, received: received);
  }

  static String _partName(File package) => '${p.basename(package.path)}.part';

  static Future<bool> _matches(File file, AppUpdate update) async =>
      await file.length() == update.size &&
      '${await sha256.bind(file.openRead()).first}' == update.sha256;

  Future<void> _clear(Directory folder) async {
    if (!await folder.exists()) return;
    await for (final entity in folder.list()) {
      await _delete(entity);
    }
  }

  /// Deletes [entity]; one still open, such as the Windows installer while
  /// it finishes, goes on a later start.
  Future<void> _delete(FileSystemEntity entity) async {
    try {
      await entity.delete(recursive: true);
    } on FileSystemException catch (error) {
      _logger.info('Could not remove ${entity.path}', error);
    }
  }

  /// Whether this device can ever install updates without asking: Android
  /// 12 or later, and not HyperOS or MIUI, which always ask. Windows asks
  /// each time: a desktop app is not paused when the user leaves it.
  Future<bool> silentSupported() async =>
      os == 'android' &&
      (await channel.invokeMethod<bool>('silentSupported') ?? false);

  /// Whether Android lets this app replace itself without asking: it
  /// installed itself before and may install apps.
  Future<bool> canInstallSilently() async =>
      os == 'android' &&
      (await channel.invokeMethod<bool>('canInstallSilently') ?? false);

  /// Hands [file] of [update] to the system installer, after the native side
  /// has checked it is this app, signed with this app's key, and newer. On
  /// Windows, runs the installer instead.
  Future<UpdateInstall> install(AppUpdate update, File file) async {
    if (os == 'windows') return _runSetup(update, file);
    final String? result;
    try {
      result =
          await channel.invokeMethod<String>('install', {'path': file.path});
    } on PlatformException catch (error) {
      throw UpdateException(error.code, error.message ?? 'Install failed');
    }
    final outcome = UpdateInstall.values.byName(result!);
    if (outcome != UpdateInstall.needsPermission) {
      await ConfigProvider.instance
          .set(Settings.installingUpdate, jsonEncode(update.toJson()));
    }
    return outcome;
  }

  /// Starts the downloaded Windows installer silently and closes the app;
  /// the installer replaces it in place and opens it again
  /// (windows/installer/aid_diary.iss).
  Future<UpdateInstall> _runSetup(AppUpdate update, File file) async {
    final config = AppConfig.instance;
    final settings = ConfigProvider.instance;
    await settings.set(Settings.installingUpdate, jsonEncode(update.toJson()));
    try {
      await Process.start(file.path, config.updateWindowsSetupArguments,
          mode: ProcessStartMode.detached);
    } on ProcessException catch (error) {
      await settings.set(Settings.installingUpdate, '');
      throw UpdateException('install_failed', error.message);
    }
    // Restart Manager closes the app too if it is still open when the
    // installer replaces its files.
    Timer(config.updateWindowsExitDelay,
        () => ServicesBinding.instance.exitApplication(AppExitType.required));
    return UpdateInstall.started;
  }

  /// The update installed since the last run, once: what it said, for the
  /// "updated" note. Null when the app was not updated by itself.
  Future<AppUpdate?> justInstalled() async {
    final settings = ConfigProvider.instance;
    final stored = settings.get(Settings.installingUpdate);
    if (stored.isEmpty) return null;
    final update =
        AppUpdate.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    final running =
        int.tryParse(DeviceInfoService().appInfo?.buildNumber ?? '');
    if (running == null || running < update.build) return null;
    await settings.set(Settings.installingUpdate, '');
    return update;
  }
}

/// One package download, which a download of another build stops.
class _Download {
  _Download(this.update);

  static const stopped = UpdateException(
      'superseded', 'A download of another build replaced this one');

  final AppUpdate update;
  late final Future<File> done;
  bool cancelled = false;

  /// Ends the transfer under way.
  void Function()? abort;

  void start(Future<File> Function(_Download job) run) => done = run(this);

  void cancel() {
    cancelled = true;
    abort?.call();
  }
}
