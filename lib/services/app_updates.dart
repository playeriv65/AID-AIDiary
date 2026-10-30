// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:crypto/crypto.dart';
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
  static Map<String, List<String>> _notes(
          Object? byLanguage, Object? english) =>
      byLanguage is Map
          ? {
              for (final MapEntry(:key, :value) in byLanguage.entries)
                '$key': [for (final line in value as List) '$line'],
            }
          : {
              'en': [for (final line in english as List? ?? []) '$line'],
            };

  /// The entry for [package] in the manifest found at [source], newer than
  /// [installed]; null when it has none or none newer. Files are named
  /// beside the manifest, so a mirror serves the same manifest.
  static AppUpdate? from(Map<String, dynamic> manifest,
      {required Uri source, required String package, required int installed}) {
    final build = manifest['build'];
    final file = (manifest['files'] as Map?)?[package];
    if (build is! int || build <= installed || file is! Map) return null;
    final name = file['name'] as String;
    if (!RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(name)) {
      throw UpdateException('corrupt', 'Bad file name in the manifest: $name');
    }
    return AppUpdate(
      version: manifest['version'] as String,
      build: build,
      notes: _notes(manifest['notesByLanguage'], manifest['notes']),
      url: source.resolve(name),
      sha256: file['sha256'] as String,
      size: file['size'] as int,
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
        notes: _notes(json['notes'], json['notes']),
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

/// Why an update did not download or install; [code] is stable for scripts.
class UpdateException implements Exception {
  const UpdateException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => '$code: $message';
}

/// Finds, fetches and installs newer builds from the release manifest
/// (docs/UPDATES.md). Only Android can install one today.
class AppUpdates {
  AppUpdates({http.Client? client, this.channel = _channel})
      : _client = client ?? http.Client();

  static final instance = AppUpdates();
  static const _channel = MethodChannel('aid.updates');
  static final _logger = Logger('AppUpdates');

  final http.Client _client;
  final MethodChannel channel;

  /// Whether this build can install an update itself: Android, but not the
  /// F-Droid build, which F-Droid's client updates.
  Future<bool> enabled() async =>
      Platform.isAndroid &&
      (await channel.invokeMethod<bool>('enabled') ?? false);

  /// The manifest's name for this app's package: the release app or the
  /// development one.
  static String packageKey(String packageName) =>
      packageName.endsWith('.beta') ? 'android-dev' : 'android';

  /// The update for this app, or null when it is the newest. Asks each
  /// manifest address in turn until one answers.
  Future<AppUpdate?> check() async {
    final config = AppConfig.instance;
    final info = DeviceInfoService().appInfo;
    if (info == null) throw StateError('App info is not loaded');
    final failures = <String>[];
    for (final source in config.updateManifestUrls) {
      final Map<String, dynamic> manifest;
      try {
        final response =
            await _client.get(source).timeout(config.updateTimeout);
        if (response.statusCode != 200) {
          failures.add('${source.host}: HTTP ${response.statusCode}');
          continue;
        }
        manifest =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } on Exception catch (error) {
        failures.add('${source.host}: $error');
        continue;
      }
      await ConfigProvider.instance
          .set(Settings.lastUpdateCheck, DateTime.now().toIso8601String());
      return AppUpdate.from(manifest,
          source: source,
          package: packageKey(info.packageName),
          installed: int.parse(info.buildNumber));
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
      if (update == null ||
          update.build == settings.get(Settings.skippedUpdate)) {
        return null;
      }
      return update;
    } catch (error, stackTrace) {
      _logger.info('Update check failed', error, stackTrace);
      return null;
    }
  }

  /// Downloads [update] into the cache and checks its size and SHA-256;
  /// [progress] gets 0 to 1.
  Future<File> download(AppUpdate update,
      {void Function(double done)? progress}) async {
    final folder =
        Directory(p.join((await getTemporaryDirectory()).path, 'updates'));
    if (await folder.exists()) await folder.delete(recursive: true);
    await folder.create(recursive: true);
    final file = File(p.join(folder.path, 'update-${update.build}.apk'));
    final response = await _client
        .send(http.Request('GET', update.url))
        .timeout(AppConfig.instance.updateTimeout);
    if (response.statusCode != 200) {
      throw UpdateException(
          'unavailable', 'Download: HTTP ${response.statusCode}');
    }
    final sink = file.openWrite();
    final digest = _DigestSink();
    final hasher = sha256.startChunkedConversion(digest);
    var received = 0;
    try {
      await for (final chunk in response.stream
          .timeout(AppConfig.instance.updateDownloadTimeout)) {
        received += chunk.length;
        if (received > update.size) {
          throw const UpdateException('corrupt', 'Download is too large');
        }
        sink.add(chunk);
        hasher.add(chunk);
        progress?.call(received / update.size);
      }
    } finally {
      await sink.close();
    }
    hasher.close();
    if (received != update.size || '${digest.value}' != update.sha256) {
      await file.delete();
      throw const UpdateException(
          'corrupt', 'Download does not match the release manifest');
    }
    return file;
  }

  /// Whether this device can ever install updates without asking: Android
  /// 12 or later, and not HyperOS or MIUI, which always ask.
  Future<bool> silentSupported() async =>
      await channel.invokeMethod<bool>('silentSupported') ?? false;

  /// Whether Android lets this app replace itself without asking: it
  /// installed itself before and may install apps.
  Future<bool> canInstallSilently() async =>
      await channel.invokeMethod<bool>('canInstallSilently') ?? false;

  /// Hands [file] of [update] to the system installer, after the native side
  /// has checked it is this app, signed with this app's key, and newer.
  Future<UpdateInstall> install(AppUpdate update, File file) async {
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

class _DigestSink implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}
