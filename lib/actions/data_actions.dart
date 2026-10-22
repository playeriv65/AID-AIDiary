// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/auto_backup_schedule.dart';
import 'package:aid_diary/utils/backup_restore_utils.dart';
import 'package:aid_diary/l10n/shown_language.dart';
import 'package:aid_diary/utils/export_utils.dart';
import 'package:aid_diary/utils/imports/import_registry.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/password_store.dart';

ConfigProvider get _config => ConfigProvider.instance;

/// A format's name as scripts write it: `dayOne` is `day_one`.
String _formatName(String name) => name.replaceAllMapped(
    RegExp('[A-Z]'), (letter) => '_${letter[0]!.toLowerCase()}');

T _byFormat<T>(String name, Iterable<T> options, String Function(T) nameOf) {
  for (final option in options) {
    if (_formatName(nameOf(option)) == name) return option;
  }
  throw ActionException('bad_args',
      'format must be one of ${options.map((o) => _formatName(nameOf(o))).join(', ')}');
}

/// The result of [outcome], or the reason it did not succeed.
OperationOutcome _succeeded(OperationOutcome outcome) {
  if (outcome.succeeded) return outcome;
  throw ActionException(
      'failed', outcome.error?.toString() ?? 'The operation did not finish');
}

Future<void> _existingFile(String path) async {
  if (!isContentUri(path) && !await File(path).exists()) {
    throw ActionException('not_found', 'There is no file $path');
  }
}

/// A folder to write into; made when it is a path that does not exist.
Future<PickedDirectory> _folder(String path) async {
  if (!isContentUri(path)) await Directory(path).create(recursive: true);
  return PickedDirectory(path);
}

Future<int> _entryCount() async {
  await EntryStore.instance.complete;
  return EntryStore.instance.entries.length;
}

const _pathParam = ActionParam(
    'path',
    ParamType.string,
    'A folder on this device, or on Android a content:// URI the app was '
        'given access to');

const _storageTargets = ['database', 'images'];

const _targetParam =
    ActionParam('target', ParamType.string, 'What to move: database or images');

String _target(ActionArgs args) {
  final target = args['target'] as String;
  if (!_storageTargets.contains(target)) {
    throw ActionException(
        'bad_args', 'target must be one of ${_storageTargets.join(', ')}');
  }
  return target;
}

Future<Map<String, Object?>> _storageStatus() async {
  final database = AppDatabase.instance;
  final images = ImageStorage.instance;
  return {
    'database': {
      'folder': await database.getInternalPath(),
      'external': database.usingExternalLocation(),
      if (database.usingExternalLocation()) ...{
        'externalFolder': database.getExternalPath(),
        'externalAvailable': await database.hasExternalLocationPermission(),
      },
    },
    'images': {
      'folder': await images.getInternalFolder(),
      'external': images.usingExternalLocation(),
      if (images.usingExternalLocation()) ...{
        'externalFolder': _config.get(Settings.externalImgUri),
        'externalAvailable': await images.hasExternalLocationPermission(),
      },
    },
    'imageQuality': _config.get(Settings.imageQualityLevel),
  };
}

Future<Map<String, Object?>> _backupStatus() async {
  final enabled = _config.get(Settings.autoBackupEnabled);
  final lastBackup = _config.get(Settings.lastBackup);
  final lastAuto = _config.get(Settings.lastAutoBackup);
  return {
    if (lastBackup.isNotEmpty) 'lastBackup': lastBackup,
    'encrypted': BackupPasswordStore.isEnabled,
    'autoBackup': {
      'supported': Platform.isAndroid,
      'enabled': enabled,
      'interval': _config.get(Settings.autoBackupInterval),
      'keep': _config.get(Settings.autoBackupMaxCount),
      'requireCharging': _config.get(Settings.autoBackupRequireCharging),
      if (_config.get(Settings.autoBackupLocationUri).isNotEmpty)
        'folder': StoragePicker.displayName(
            _config.get(Settings.autoBackupLocationUri)),
      if (lastAuto.isNotEmpty) 'last': lastAuto,
      if (enabled)
        'next': nextAutoBackupTimeFromConfig(_config).toIso8601String(),
    },
  };
}

final List<AppAction> dataActions = [
  AppAction(
    id: 'data.import',
    describe: 'Adds the entries of a file from another journal app, or of '
        "this app's JSON export, that the diary does not have yet.",
    risk: ActionRisk.write,
    params: [
      ActionParam(
          'format',
          ParamType.string,
          'The app the file comes from: ${[
            for (final option in ImportRegistry.instance.options)
              _formatName(option.format.name)
          ].join(', ')}'),
      const ActionParam('path', ParamType.string,
          'The export file or archive on this device'),
    ],
    run: (context, args) async {
      final option = _byFormat(args['format'] as String,
          ImportRegistry.instance.options, (option) => option.format.name);
      final path = args['path'] as String;
      await _existingFile(path);
      final before = await _entryCount();
      _succeeded(await option.run(
          PickedFile(path), shownLocalizations(), context.progress));
      final after = await _entryCount();
      return {
        'format': _formatName(option.format.name),
        'added': after - before,
        'entries': after,
      };
    },
  ),
  AppAction(
    id: 'data.export',
    describe: 'Writes all open entries to a file for another app. Sealed '
        'time capsules are excluded; a full backup preserves them.',
    risk: ActionRisk.write,
    params: [
      ActionParam(
          'format',
          ParamType.string,
          'The file format: ${[
            for (final option in ExportRegistry.instance.options)
              _formatName(option.format.name)
          ].join(', ')}'),
      _pathParam,
    ],
    run: (context, args) async {
      final option = _byFormat(args['format'] as String,
          ExportRegistry.instance.options, (option) => option.format.name);
      final folder = await _folder(args['path'] as String);
      await EntryStore.instance.complete;
      final outcome = _succeeded(await option.run(
          folder, shownLocalizations(), shownLocale(), context.progress));
      return {
        'format': _formatName(option.format.name),
        'file': outcome.output,
        'entries': EntryStore.instance.entries
            .where((entry) => !entry.isSealed)
            .length,
      };
    },
  ),
  AppAction(
    id: 'backup.create',
    describe: 'Backs up the diary and its photos to a ZIP file in a folder, '
        'encrypted with the backup password when one is set in the app.',
    risk: ActionRisk.write,
    params: const [_pathParam],
    run: (context, args) async {
      final encrypted = BackupPasswordStore.isEnabled;
      final folder = await _folder(args['path'] as String);
      final file = await BackupRestoreUtils.backupTo(folder);
      return {
        'file': file,
        'encrypted': encrypted,
        'lastBackup': _config.get(Settings.lastBackup),
      };
    },
  ),
  AppAction(
    id: 'backup.restore',
    describe: 'Replaces the diary and its photos with those of a backup '
        'file. What the diary holds now is lost.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('path', ParamType.string, 'The backup file on this device'),
      ActionParam(
          'password',
          ParamType.string,
          'The backup password of an encrypted backup the one set in the '
              'app does not open',
          required: false),
    ],
    run: (context, args) async {
      final path = args['path'] as String;
      await _existingFile(path);
      final password = args['password'] as String?;
      final outcome = await BackupRestoreUtils.restoreFromZip(
          PickedFile(path), shownLocalizations(), context.progress,
          askPassword: () async => password);
      if (outcome.status == OperationStatus.cancelled) {
        throw const ActionException('needs_password',
            'The backup is encrypted: give the password it was made with');
      }
      _succeeded(outcome);
      return {'entries': await _entryCount()};
    },
  ),
  AppAction(
    id: 'backup.status',
    describe: 'Shows when the last backup was made, whether backups are '
        'encrypted and how automatic backups are set up.',
    risk: ActionRisk.read,
    run: (context, args) async => _backupStatus(),
  ),
  AppAction(
    id: 'storage.status',
    describe: 'Shows where the diary and its photos are kept, and whether '
        'that is a folder of your own.',
    risk: ActionRisk.read,
    run: (context, args) async => _storageStatus(),
  ),
  AppAction(
    id: 'storage.set',
    describe: 'Keeps the diary or its photos in a folder of your own from '
        'now on. A diary already in the folder replaces this one; photos '
        'are copied across both ways.',
    risk: ActionRisk.destructive,
    params: const [_targetParam, _pathParam],
    run: (context, args) async {
      final target = _target(args);
      final path = args['path'] as String;
      if (!isContentUri(path) && !await Directory(path).exists()) {
        throw ActionException('not_found', 'There is no folder $path');
      }
      _succeeded(target == _storageTargets.first
          ? await AppDatabase.instance
              .useExternalLocation(path, context.progress)
          : await ImageStorage.instance
              .useExternalLocation(path, context.progress));
      return _storageStatus();
    },
  ),
  AppAction(
    id: 'storage.reset',
    describe: 'Goes back to keeping the diary or its photos on the device '
        'only; what is in the folder stays there.',
    risk: ActionRisk.write,
    params: const [_targetParam],
    run: (context, args) async {
      _target(args) == _storageTargets.first
          ? await AppDatabase.instance.resetExternalLocation()
          : await ImageStorage.instance.resetImageFolderLocation();
      return _storageStatus();
    },
  ),
];
