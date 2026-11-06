// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/database_schema.dart' as schema;
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/storage/external_sync_health.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/local_file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/sync/builtin_ids.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  AppDatabase._init();

  static DatabaseExecutor executorOr(DatabaseExecutor? executor) =>
      executor ?? instance.database!;

  static const String databaseFileName = 'aid_diary.db';
  static const int currentVersion = schema.currentVersion;

  /// Makes a row that belongs to another go with it. Off while the schema is
  /// made or upgraded, which rebuilds tables that others point to; on for
  /// everything after.
  static Future<void> enforceForeignKeys(Database db) =>
      db.execute('PRAGMA foreign_keys = ON');

  static final Logger _logger = Logger('AppDatabase');

  final ExternalSyncHealth externalSyncHealth =
      ExternalSyncHealth('AppDatabase');

  static Database? _database;
  Database? get database => _database;

  @visibleForTesting
  set database(Database? database) => _database = database;

  String? _internalPath;

  FileStore get internalStore => LocalFileStore(dirname(_internalPath!));

  FileStore? get externalStore =>
      usingExternalLocation() ? FileStore.external(getExternalPath()) : null;

  Future<void> _externalOperation = Future.value();
  bool _externalWritesPaused = false;
  static const _externalWriteDebounce = 'update-remote-database';
  static const _sqliteSidecars = ['-wal', '-shm', '-journal'];

  Future<T> _withExternalDatabase<T>(Future<T> Function() operation) {
    final result = _externalOperation.then((_) => operation());
    _externalOperation = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// Opens the diary. A background task passes [background]: it must never
  /// create the database, so it gives up when there is none yet. With
  /// [firstScreen], the newest entries are read first and the rest follow in
  /// the background, see [EntryStore.load].
  Future<bool> init(
          {bool forceWithoutSync = false,
          bool background = false,
          int? firstScreen}) =>
      _withExternalDatabase(() async {
        _internalPath = await getInternalPath();
        _externalWritesPaused = forceWithoutSync;

        if (background && !await File(_internalPath!).exists()) {
          return false;
        }

        final external = forceWithoutSync ? null : externalStore;
        if (external != null) {
          if (await _canUseExternalStore(external)) {
            if (await external.exists(databaseFileName)) {
              if (await _isExternalDatabaseNewer(external)) {
                final outcome = await _loadExternalDatabase(external,
                    firstScreen: firstScreen);
                if (outcome.succeeded) return true;
                _externalWritesPaused = true;
              }
            } else if (await File(_internalPath!).exists()) {
              await open(firstScreen: firstScreen);
              final copied =
                  await _writeExternalSnapshot(external, create: true);
              _externalWritesPaused = !copied;
              return copied;
            }
          } else {
            _externalWritesPaused = true;
          }
        }

        await open(firstScreen: firstScreen);
        return external == null || !_externalWritesPaused;
      });

  Future<void> open({int? firstScreen}) => _open(firstScreen: firstScreen);

  Future<void> _open({int? firstScreen, bool purgeExpired = true}) async {
    await copyBeforeUpgrade(_internalPath!);
    _database = await openDatabase(_internalPath!,
        version: currentVersion,
        onCreate: _createDatabase,
        onUpgrade: _onUpgrade,
        onOpen: enforceForeignKeys);
    await _reload(firstScreen: firstScreen, purgeExpired: purgeExpired);
  }

  /// Reads everything the app keeps in memory from the database again, as
  /// after a write that went around the stores (`sql.execute`).
  Future<void> reload({int? firstScreen}) => _reload(firstScreen: firstScreen);

  Future<void> _reload({int? firstScreen, bool purgeExpired = true}) async {
    await EntriesProvider.instance
        .load(firstScreen: firstScreen, purgeExpired: purgeExpired);
    await EntryImagesProvider.instance.load();
    await TemplatesProvider.instance.load();
    await TagsProvider.instance.load();
    await LinksProvider.instance.load();
    await WeatherProvider.instance.load();
  }

  /// Folder beside the diary that keeps it as it was before upgrades.
  static const beforeUpgradeFolder = 'before-upgrade';

  /// Copies the diary at [path] aside when its schema is older than
  /// [currentVersion]: an upgrade, which a new build runs on its first
  /// start, cannot be undone. The newest [keep] copies stay.
  static Future<void> copyBeforeUpgrade(String path, {int keep = 2}) async {
    final file = File(path);
    if (!await file.exists()) return;
    final version = await _schemaVersion(file);
    if (version == 0 || version >= currentVersion) return;
    final folder = Directory(join(dirname(path), beforeUpgradeFolder));
    await folder.create(recursive: true);
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final copy = join(folder.path, 'v$version-$stamp-$databaseFileName');
    await file.copy(copy);
    for (final side in ['-wal', '-journal']) {
      final extra = File('$path$side');
      if (await extra.exists()) await extra.copy('$copy$side');
    }
    _logger.info('Kept the diary of schema $version before the upgrade');
    final copies = [
      for (final entity in await folder.list().toList())
        if (entity is File && entity.path.endsWith(databaseFileName)) entity
    ]..sort((a, b) => b.path.compareTo(a.path));
    for (final old in copies.skip(keep)) {
      for (final side in ['', '-wal', '-journal']) {
        final extra = File('${old.path}$side');
        if (await extra.exists()) await extra.delete();
      }
    }
  }

  /// SQLite's user_version, which sqflite keeps the schema version in: four
  /// big-endian bytes at offset 60 of the header. 0 for no database.
  static Future<int> _schemaVersion(File file) async {
    final header = await file.openRead(0, 64).expand((chunk) => chunk).toList();
    if (header.length < 64 ||
        String.fromCharCodes(header.sublist(0, 15)) != 'SQLite format 3') {
      return 0;
    }
    return ByteData.sublistView(Uint8List.fromList(header), 60, 64)
        .getUint32(0);
  }

  Future<void> close() async {
    final db = _database;
    _database = null;
    await db?.close();
  }

  Future<void> _verifySqliteDatabase(String path,
      {bool requireDiary = false}) async {
    final db = await openReadOnlyDatabase(path, singleInstance: false);
    try {
      final result = await db.rawQuery('PRAGMA integrity_check');
      if (result.length != 1 || result.single.values.single != 'ok') {
        throw const FormatException('SQLite integrity check failed');
      }
      if (requireDiary) {
        final version = await db.getVersion();
        if (version < 1 || version > currentVersion) {
          throw FormatException('Unsupported diary schema version $version');
        }
        final table = await db.query('sqlite_master',
            columns: ['name'],
            where: 'type = ? AND name = ?',
            whereArgs: ['table', entriesTable]);
        final columns = await db.rawQuery('PRAGMA table_info($entriesTable)');
        final names = {for (final column in columns) column['name']};
        if (table.isEmpty ||
            !names.containsAll(const [
              EntryFields.id,
              EntryFields.text,
              EntryFields.timeCreate,
              EntryFields.timeModified,
            ])) {
          throw const FormatException('Not an AID Diary database');
        }
      }
    } finally {
      await db.close();
    }
  }

  Future<void> _snapshot(Database db, String path,
      {bool requireDiary = false}) async {
    await db.execute('VACUUM INTO ?', [path]);
    await _verifySqliteDatabase(path, requireDiary: requireDiary);
  }

  Future<void> _removeStaging(Directory work) async {
    try {
      await work.delete(recursive: true);
    } on FileSystemException catch (error, stackTrace) {
      _logger.warning('Could not remove database staging', error, stackTrace);
    }
  }

  Future<bool> exportSnapshotTo(String path) async {
    final db = _database;
    if (db == null) return false;

    final target = File(path).absolute;
    Directory? work;
    var reserved = false;
    try {
      work = await target.parent.createTemp('.aid-snapshot-');
      final staged = File(join(work.path, databaseFileName));
      await _snapshot(db, staged.path);
      // A rename replaces its destination. Claim an unused path first.
      await target.create(exclusive: true);
      reserved = true;
      await staged.rename(target.path);
      return true;
    } catch (error, stackTrace) {
      _logger.severe('Database snapshot to $path failed', error, stackTrace);
      if (reserved && await target.exists()) await target.delete();
      return false;
    } finally {
      if (work != null) await _removeStaging(work);
    }
  }

  bool usingExternalLocation() {
    return ConfigProvider.instance.get(Settings.useExternalDb);
  }

  Future<String> getInternalPath() async {
    final basePath = await getApplicationSupportDirectory();
    if (!basePath.existsSync()) basePath.createSync(recursive: true);
    return join(basePath.path, databaseFileName);
  }

  String getExternalPath() {
    return ConfigProvider.instance.get(Settings.externalDbUri);
  }

  /// Return whether the app has permission to access the external location
  Future<bool> hasExternalLocationPermission() async {
    return await externalStore?.isAvailable() ?? false;
  }

  /// Lets the user pick the folder, then moves the diary there.
  Future<OperationOutcome> selectExternalLocation(
      Function(String) updateStatus) async {
    final PickedDirectory? selectedDirectory;
    try {
      selectedDirectory = await StoragePicker.pickDirectory();
    } catch (error, stackTrace) {
      _logger.severe(
          'Picking an external database location failed', error, stackTrace);
      return OperationOutcome.failed(error);
    }
    if (selectedDirectory == null) return const OperationOutcome.cancelled();
    return useExternalLocation(selectedDirectory.uri, updateStatus);
  }

  /// Selects an external diary only after it has opened successfully.
  Future<OperationOutcome> useExternalLocation(
          String uri, Function(String) updateStatus) =>
      _withExternalDatabase(() async {
        try {
          final external = FileStore.external(uri);
          if (!await _canUseExternalStore(external)) {
            return const OperationOutcome.failed();
          }
          if (await external.exists(databaseFileName)) {
            final outcome = await _loadExternalDatabase(external,
                afterOpen: () => _commitExternalLocation(uri));
            if (!outcome.succeeded) return outcome;
          } else {
            if (!await _writeExternalSnapshot(external, create: true)) {
              return const OperationOutcome.failed();
            }
            await _commitExternalLocation(uri);
          }
          _externalWritesPaused = false;
        } catch (error, stackTrace) {
          _logger.severe('Selecting an external database location failed',
              error, stackTrace);
          return OperationOutcome.failed(error);
        }

        try {
          if (ImageStorage.instance.usingExternalLocation() &&
              await ImageStorage.instance.hasExternalLocationPermission()) {
            await ImageStorage.instance
                .syncImageFolder(true, updateStatus: updateStatus);
          }
          return const OperationOutcome.succeeded();
        } catch (error, stackTrace) {
          _logger.severe(
              'Syncing images after the database location changed failed',
              error,
              stackTrace);
          return OperationOutcome.failed(error);
        }
      });

  Future<void> _commitExternalLocation(String uri) async {
    final config = ConfigProvider.instance;
    final previousUri = getExternalPath();
    final previouslyEnabled = usingExternalLocation();
    try {
      await config.set(Settings.externalDbUri, uri);
      await config.set(Settings.useExternalDb, true);
      await config.flushConfig();
    } catch (error, stackTrace) {
      await config.set(Settings.externalDbUri, previousUri);
      await config.set(Settings.useExternalDb, previouslyEnabled);
      try {
        await config.flushConfig();
      } catch (restoreError, restoreStack) {
        _logger.severe('Restoring external storage configuration failed',
            restoreError, restoreStack);
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> resetExternalLocation() => _withExternalDatabase(() async {
        EasyDebounce.cancel(_externalWriteDebounce);
        await ConfigProvider.instance.set(Settings.useExternalDb, false);
      });

  /// Overwrites the selected external copy with a verified SQLite snapshot.
  Future<void> updateExternalDatabase() async {
    if (!usingExternalLocation() || _externalWritesPaused) return;
    final location = getExternalPath();
    EasyDebounce.debounce(_externalWriteDebounce, const Duration(seconds: 1),
        () async {
      await _withExternalDatabase(() async {
        if (_externalWritesPaused || getExternalPath() != location) return;
        final external = externalStore;
        if (external == null) return;
        await _writeExternalSnapshot(external);
      });
    });
  }

  Future<bool> _canUseExternalStore(FileStore external) async {
    if (!await external.isAvailable()) return false;
    // An external snapshot must never target the live database itself.
    return external is! LocalFileStore ||
        !await FileSystemEntity.identical(
            dirname(_internalPath!), external.directoryPath);
  }

  Future<bool> _writeExternalSnapshot(FileStore external,
          {bool create = false}) =>
      externalSyncHealth.record('external database write', () async {
        final db = _database;
        if (db == null || !db.isOpen || !await _canUseExternalStore(external)) {
          return false;
        }
        final work =
            await Directory(dirname(_internalPath!)).createTemp('.aid-export-');
        try {
          final file = File(join(work.path, databaseFileName));
          await _snapshot(db, file.path);
          final bytes = await file.readAsBytes();
          if (create) {
            return await external.createNew(databaseFileName, bytes) ==
                CreateResult.created;
          }
          return await external.write(databaseFileName, bytes);
        } finally {
          await _removeStaging(work);
        }
      });

  Future<void> _stageExternalDatabase(
      FileStore external, File candidate) async {
    if (external is LocalFileStore) {
      // Let SQLite read the source, including commits still in its WAL.
      final source = await openReadOnlyDatabase(
          join(external.directoryPath, databaseFileName),
          singleInstance: false);
      try {
        await _snapshot(source, candidate.path, requireDiary: true);
      } finally {
        await source.close();
      }
      return;
    }

    // SAF exposes documents as byte streams. Require a standalone snapshot.
    for (final suffix in _sqliteSidecars) {
      if (await external.exists('$databaseFileName$suffix')) {
        throw const FormatException('External diary has SQLite sidecar files');
      }
    }
    final bytes = await external.read(databaseFileName);
    if (bytes == null) throw const FormatException('External diary is missing');
    await candidate.writeAsBytes(bytes, flush: true);
    await _verifySqliteDatabase(candidate.path, requireDiary: true);
  }

  Future<OperationOutcome> _loadExternalDatabase(FileStore external,
      {int? firstScreen, Future<void> Function()? afterOpen}) async {
    final local = File(_internalPath!);
    final work = await local.parent.createTemp('.aid-import-');
    final candidate = File(join(work.path, databaseFileName));
    final original = File(join(work.path, 'original.db'));
    final wasOpen = _database?.isOpen ?? false;
    var closing = false;
    var replacing = false;
    var installed = false;
    var keepRecovery = false;
    try {
      await _stageExternalDatabase(external, candidate);

      closing = true;
      await close();
      for (final suffix in _sqliteSidecars) {
        if (await File('${local.path}$suffix').exists()) {
          throw StateError('Cannot replace a diary with SQLite sidecar files');
        }
      }
      if (await local.exists()) await local.copy(original.path);
      replacing = true;
      await candidate.rename(local.path);
      installed = true;
      // Read all rows before committing the switch, including older entries.
      // Expiry cleanup can remove attachments and must wait until commit.
      await _open(purgeExpired: false);
      await afterOpen?.call();
    } catch (error, stackTrace) {
      _logger.warning('Reading the external diary failed', error, stackTrace);
      if (closing) {
        try {
          await close();
          if (installed) {
            // Any sidecars here were created while opening the candidate.
            for (final suffix in _sqliteSidecars) {
              final file = File('${local.path}$suffix');
              if (await file.exists()) await file.delete();
            }
          }
          if (replacing && await original.exists()) {
            await original.rename(local.path);
          } else if (installed && await local.exists()) {
            await local.delete();
          }
          if (wasOpen) {
            await _open(firstScreen: firstScreen, purgeExpired: false);
          }
        } catch (recoveryError, recoveryStack) {
          keepRecovery = true;
          _logger.severe('Recovering the local diary failed: ${work.path}',
              recoveryError, recoveryStack);
          rethrow;
        }
      }
      return OperationOutcome.failed(error);
    } finally {
      if (!keepRecovery) await _removeStaging(work);
    }
    try {
      await EntryStore.instance.purgeExpired();
    } catch (error, stackTrace) {
      _logger.warning('Expiring deleted entries failed after storage switch',
          error, stackTrace);
    }
    return const OperationOutcome.succeeded();
  }

  /// Return whether the external database is newer
  Future<bool> _isExternalDatabaseNewer(FileStore externalLocation) async {
    final internalModifiedTime =
        await internalStore.modifiedTime(databaseFileName) ?? DateTime.now();

    final externalModifiedTime =
        await externalLocation.modifiedTime(databaseFileName) ??
            internalModifiedTime;

    return externalModifiedTime.isAfter(internalModifiedTime);
  }

  Future<void> _createDatabase(Database db, int version) async {
    _database = db;
    await createSchema(db);
    await TemplatesProvider.instance.createDefaultTemplates();
    await _assignBuiltinIds(db);
  }

  Future<void> _assignBuiltinIds(DatabaseExecutor db) async {
    final l10n = await TemplatesProvider.defaultsLocalizations();
    await assignBuiltinIds(db,
        defaultTemplateNames: TemplatesProvider.defaultTemplateNames(l10n));
  }

  Future<void> createSchema(Database db) => schema.createSchema(db);

  /// The tables as they were before sync, for upgrade tests.
  @visibleForTesting
  Future<void> createVersion10Schema(Database db) =>
      schema.createVersion10Schema(db);

  @visibleForTesting
  Future<void> upgradeSchema(Database db, int oldVersion, int newVersion) =>
      _onUpgrade(db, oldVersion, newVersion);

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _database = db;
    await schema.upgradeSchema(
      db,
      oldVersion,
      newVersion,
      createDefaultTemplates: () =>
          TemplatesProvider.instance.createDefaultTemplates(),
      assignBuiltinIds: _assignBuiltinIds,
    );
  }
}
