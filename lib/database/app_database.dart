// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/database_schema.dart' as schema;
import 'package:aid_diary/database/image_storage.dart';
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

  /// Opens the diary. A background task passes [background]: it must never
  /// create the database, so it gives up when there is none yet. With
  /// [firstScreen], the newest entries are read first and the rest follow in
  /// the background, see [EntryStore.load].
  Future<bool> init(
      {bool forceWithoutSync = false,
      bool background = false,
      int? firstScreen}) async {
    _internalPath = await getInternalPath();
    bool success = true;

    if (background && !await File(_internalPath!).exists()) {
      return false;
    }

    if (usingExternalLocation() && !forceWithoutSync) {
      if (await hasExternalLocationPermission()) {
        await _syncWithExternalDatabase();
      } else {
        success = false;
      }
    }

    await AppDatabase.instance.open(firstScreen: firstScreen);
    return success;
  }

  Future<void> open({int? firstScreen}) async {
    await copyBeforeUpgrade(_internalPath!);
    _database = await openDatabase(_internalPath!,
        version: currentVersion,
        onCreate: _createDatabase,
        onUpgrade: _onUpgrade,
        onOpen: enforceForeignKeys);
    await reload(firstScreen: firstScreen);
  }

  /// Reads everything the app keeps in memory from the database again, as
  /// after a write that went around the stores (`sql.execute`).
  Future<void> reload({int? firstScreen}) async {
    await EntriesProvider.instance.load(firstScreen: firstScreen);
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

  Future<bool> _validateSqliteDatabase(String path) async {
    try {
      final db = await openDatabase(path, readOnly: true);
      final result = await db.rawQuery("PRAGMA integrity_check;");
      await db.close();

      return result.first.values.first == "ok";
    } catch (error, stackTrace) {
      _logger.warning(
          'Database integrity check failed for $path', error, stackTrace);
      return false;
    }
  }

  Future<bool> exportSnapshotTo(String path) async {
    final db = _database;
    if (db == null) return false;

    try {
      await db.execute("VACUUM INTO '$path'");
      if (await _validateSqliteDatabase(path)) return true;
    } catch (error, stackTrace) {
      _logger.severe('Database snapshot to $path failed', error, stackTrace);
    }

    if (await File(path).exists()) await File(path).delete();
    return false;
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

  /// Keeps the diary in the folder at [uri] from now on: the folder's copy
  /// replaces this device's, and the old setting returns when that fails.
  Future<OperationOutcome> useExternalLocation(
      String uri, Function(String) updateStatus) async {
    bool databaseUpdated = false;
    var outcome = const OperationOutcome.succeeded();

    // Save old external path
    var oldExternalPath = getExternalPath();
    var oldUseExternalPath = usingExternalLocation();
    await _database!.close();

    try {
      await ConfigProvider.instance.set(Settings.externalDbUri, uri);
      await ConfigProvider.instance.set(Settings.useExternalDb, true);

      // Sync with external folder
      databaseUpdated = await _syncWithExternalDatabase(forceOverwrite: true);
      if (!databaseUpdated) outcome = const OperationOutcome.failed();
    } catch (error, stackTrace) {
      _logger.severe(
          'Selecting an external database location failed', error, stackTrace);
      outcome = OperationOutcome.failed(error);
    }

    // Cleanup
    await open();
    if (!databaseUpdated) {
      // Restore state after failure
      await ConfigProvider.instance
          .set(Settings.externalDbUri, oldExternalPath);
      await ConfigProvider.instance
          .set(Settings.useExternalDb, oldUseExternalPath);
    } else {
      try {
        if (ImageStorage.instance.usingExternalLocation() &&
            await ImageStorage.instance.hasExternalLocationPermission()) {
          await ImageStorage.instance
              .syncImageFolder(true, updateStatus: updateStatus);
        }
      } catch (error, stackTrace) {
        _logger.severe(
            'Syncing images after the database location changed failed',
            error,
            stackTrace);
        outcome = OperationOutcome.failed(error);
      }
    }
    return outcome;
  }

  Future<void> resetExternalLocation() async {
    await ConfigProvider.instance.set(Settings.useExternalDb, false);
  }

  /// Overwrite the external database with local changes
  /// If an external database is not in use, no action is taken
  Future<void> updateExternalDatabase() async {
    if (!usingExternalLocation()) return;

    EasyDebounce.debounce("update-remote-database", Duration(seconds: 1),
        () async {
      final externalLocation = externalStore;
      if (externalLocation == null) return;

      final exportName =
          "$databaseFileName.export_${DateTime.now().millisecondsSinceEpoch}";
      final exportPath = join(dirname(_internalPath!), exportName);

      await externalSyncHealth.record("external database write", () async {
        try {
          if (!await exportSnapshotTo(exportPath)) return false;

          final bytes = await internalStore.read(exportName);
          if (bytes == null) return false;

          return await externalLocation.write(databaseFileName, bytes);
        } finally {
          await internalStore.delete(exportName);
        }
      });
    });
  }

  /// Pull in remote changes if the external database is newer or if forceOverwrite is set
  Future<bool> _syncWithExternalDatabase({bool forceOverwrite = false}) async {
    final externalLocation = externalStore;
    if (externalLocation == null) return false;

    if (!await externalLocation.exists(databaseFileName)) {
      final bytes = await internalStore.read(databaseFileName);
      if (bytes == null) return false;

      return externalSyncHealth.record("external database write",
          () => externalLocation.write(databaseFileName, bytes));
    }

    if (forceOverwrite || await _isExternalDatabaseNewer(externalLocation)) {
      // Overwrite internal DB
      final externalBytes = await externalLocation.read(databaseFileName);
      if (externalBytes == null) return false;

      final temporaryName =
          "$databaseFileName.${DateTime.now().millisecondsSinceEpoch}.tmp";
      await internalStore.write(temporaryName, externalBytes);

      final temporaryPath = join(dirname(_internalPath!), temporaryName);
      if (await _validateSqliteDatabase(temporaryPath)) {
        return internalStore.rename(temporaryName, databaseFileName);
      }

      await internalStore.delete(temporaryName);
      return false;
    }
    return true;
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
