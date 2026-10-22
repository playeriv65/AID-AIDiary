// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/storage/secret_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

/// The folder a development build keeps everything in when started with
/// `AID_DATA_DIR` set: the database, pictures, settings, the secrets that
/// otherwise go to the platform's key store (the user's master key among
/// them) and the agent API's port and token. A tool run such as the
/// frame-rate check, or several copies of the app paired with each other,
/// so leaves the diary on this computer alone. Null in a normal start.
String? scratchFolder;

/// Moves every app folder and store into `AID_DATA_DIR`, when set; call
/// before anything opens a file.
void useScratchFolders() {
  final folder = Platform.environment['AID_DATA_DIR'];
  if (folder == null || folder.isEmpty) return;
  Directory(folder).createSync(recursive: true);
  scratchFolder = folder;
  PathProviderPlatform.instance = _ScratchFolders(folder);
  // The preference and key stores of the platform are one per user, not
  // per folder: in plain files here instead, as scratch data is a test's.
  SharedPreferencesStorePlatform.instance =
      _FilePreferences(File(p.join(folder, 'preferences.json')));
  SecretStore.instance = _FileSecretStore(File(p.join(folder, 'secrets.json')));
}

class _ScratchFolders extends PathProviderPlatform {
  _ScratchFolders(this.root);

  final String root;

  @override
  Future<String?> getApplicationSupportPath() async => root;
  @override
  Future<String?> getApplicationDocumentsPath() async => root;
  @override
  Future<String?> getApplicationCachePath() async => root;
  @override
  Future<String?> getTemporaryPath() async => root;
  @override
  Future<String?> getDownloadsPath() async => root;
}

Map<String, Object?> _readJson(File file) => file.existsSync()
    ? (jsonDecode(file.readAsStringSync()) as Map).cast<String, Object?>()
    : {};

/// Preferences in [file], kept as the in-memory store keeps them and
/// written after every change.
class _FilePreferences extends InMemorySharedPreferencesStore {
  _FilePreferences(this.file)
      : super.withData({
          for (final MapEntry(:key, :value) in _readJson(file).entries)
            key: value is List ? value.cast<String>() : value!,
        });

  final File file;

  Future<bool> _save(bool changed) async {
    final all = await getAllWithParameters(
        GetAllParameters(filter: PreferencesFilter(prefix: '')));
    await file.writeAsString(jsonEncode(all));
    return changed;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async =>
      _save(await super.setValue(valueType, key, value));

  @override
  Future<bool> remove(String key) async => _save(await super.remove(key));

  @override
  Future<bool> clearWithParameters(ClearParameters parameters) async =>
      _save(await super.clearWithParameters(parameters));
}

/// Secrets in [file], in the clear: only a scratch run's.
class _FileSecretStore implements SecretStore {
  _FileSecretStore(this.file);

  final File file;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<String?> read(String key) async => _readJson(file)[key] as String?;

  @override
  Future<void> write(String key, String value) =>
      file.writeAsString(jsonEncode({..._readJson(file), key: value}));

  @override
  Future<void> delete(String key) async =>
      file.writeAsString(jsonEncode(_readJson(file)..remove(key)));
}
