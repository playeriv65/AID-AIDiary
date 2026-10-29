// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/utils/activity_tags.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:crypto/crypto.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/external_sync_health.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/local_file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/widgets.dart';
import 'package:aid_diary/sync/builtin_ids.dart';
import 'package:aid_diary/sync/sync_schema.dart';
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
  static const int currentVersion = 17;

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

  // SQLite Database Actions

  Future _createDatabase(Database db, int version) async {
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

  Future<void> createSchema(Database db) async {
    await createVersion10Schema(db);
    await addSyncSchema(db);
    await _addHiddenAndImportSchema(db);
    await _addLinksSchema(db);
    await _upgradeToVersion17(db);
  }

  /// The tables as they were before sync, for upgrade tests.
  @visibleForTesting
  Future<void> createVersion10Schema(Database db) async {
    await db.execute('''
CREATE TABLE $entriesTable (
  ${EntryFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${EntryFields.text} TEXT NOT NULL,
  ${EntryFields.mood} INTEGER,
  ${EntryFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${EntryFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${EntryFields.latitude} REAL,
  ${EntryFields.longitude} REAL,
  ${EntryFields.locationName} TEXT,
  ${EntryFields.weatherCode} INTEGER,
  ${EntryFields.temperature} REAL,
  ${EntryFields.activity} TEXT,
  ${EntryFields.openAt} DATETIME,
  ${EntryFields.deletedAt} DATETIME,
  ${EntryFields.utcOffset} INTEGER,
  ${EntryFields.diaryDate} TEXT
)
''');
    await db.execute('''
CREATE TABLE $templatesTable (
  ${TemplatesFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${TemplatesFields.name} TEXT NOT NULL,
  ${TemplatesFields.text} TEXT,
  ${TemplatesFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${TemplatesFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now'))
)
''');
    await db.execute('''
CREATE TABLE $imagesTable (
    ${EntryImageFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${EntryImageFields.entryId} INTEGER NOT NULL,
    ${EntryImageFields.imgPath} TEXT NOT NULL,
    ${EntryImageFields.imgRank} INTEGER NOT NULL,
    ${EntryImageFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    FOREIGN KEY (${EntryImageFields.entryId}) REFERENCES $entriesTable (id)
)
''');

    await _createTagTables(db);
    await _createTemplateTagTable(db);
  }

  Future<void> _createTagTables(Database db) async {
    await db.execute('''
CREATE TABLE $tagCategoriesTable (
    ${TagCategoryFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${TagCategoryFields.icon} TEXT,
    ${TagCategoryFields.iconType} INTEGER NOT NULL DEFAULT 0,
    ${TagCategoryFields.name} TEXT NOT NULL,
    ${TagCategoryFields.color} INTEGER,
    ${TagCategoryFields.sortOrder} INTEGER NOT NULL DEFAULT 0,
    ${TagCategoryFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    ${TagCategoryFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now'))
)
''');

    await db.execute('''
CREATE TABLE $tagsTable (
    ${TagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${TagFields.categoryId} INTEGER,
    ${TagFields.icon} TEXT,
    ${TagFields.iconType} INTEGER NOT NULL DEFAULT 0,
    ${TagFields.name} TEXT NOT NULL,
    ${TagFields.tagType} INTEGER NOT NULL,
    ${TagFields.color} INTEGER,
    ${TagFields.sortOrder} INTEGER NOT NULL DEFAULT 0,
    ${TagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    ${TagFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    FOREIGN KEY (${TagFields.categoryId}) REFERENCES $tagCategoriesTable (id)
)
''');

    await db.execute('''
CREATE TABLE $entryTagsTable (
    ${EntryTagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${EntryTagFields.entryId} INTEGER NOT NULL,
    ${EntryTagFields.tagId} INTEGER NOT NULL,
    ${EntryTagFields.value} TEXT,
    ${EntryTagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    FOREIGN KEY (${EntryTagFields.entryId}) REFERENCES $entriesTable (id),
    FOREIGN KEY (${EntryTagFields.tagId}) REFERENCES $tagsTable (id)
)
''');
  }

  Future<void> _createTemplateTagTable(Database db) async {
    await db.execute('''
CREATE TABLE $templateTagsTable (
    ${TemplateTagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${TemplateTagFields.templateId} INTEGER NOT NULL,
    ${TemplateTagFields.tagId} INTEGER NOT NULL,
    ${TemplateTagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    FOREIGN KEY (${TemplateTagFields.templateId}) REFERENCES $templatesTable (id),
    FOREIGN KEY (${TemplateTagFields.tagId}) REFERENCES $tagsTable (id)
)
''');
  }

  @visibleForTesting
  Future<void> upgradeSchema(Database db, int oldVersion, int newVersion) =>
      _onUpgrade(db, oldVersion, newVersion);

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _database = db;
    // In this case, oldVersion is 1, newVersion is 2
    if (oldVersion == 1) {
      await db.execute('''
CREATE TABLE $templatesTable (
  ${TemplatesFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${TemplatesFields.name} TEXT NOT NULL,
  ${TemplatesFields.text} TEXT,
  ${TemplatesFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${TemplatesFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now'))
)
''');

      await TemplatesProvider.instance.createDefaultTemplates();
    }
    if (oldVersion <= 2) {
      await db.execute('''
CREATE TABLE $imagesTable (
    ${EntryImageFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ${EntryImageFields.entryId} INTEGER NOT NULL,
    ${EntryImageFields.imgPath} TEXT NOT NULL,
    ${EntryImageFields.imgRank} INTEGER NOT NULL,
    ${EntryImageFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
    FOREIGN KEY (${EntryImageFields.entryId}) REFERENCES $entriesTable (id)
)
''');
      await db.transaction((txn) async {
        await txn.execute('''
-- Step 1: Insert the non-null imgPath entries into the imagesTable
INSERT INTO $imagesTable (${EntryImageFields.entryId}, ${EntryImageFields.imgPath}, ${EntryImageFields.imgRank}, ${EntryImageFields.timeCreate})
SELECT ${EntryFields.id}, $deprecatedImgPath, 0, ${EntryFields.timeCreate}
FROM $entriesTable
WHERE $deprecatedImgPath IS NOT NULL;
    ''');

        await txn.execute('''
-- Step 2: Rename the old entries table
ALTER TABLE $entriesTable RENAME TO old_entries;
    ''');

        await txn.execute('''
-- Step 3: Create a new entries table without the imgPath field
CREATE TABLE $entriesTable (
  ${EntryFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${EntryFields.text} TEXT NOT NULL,
  ${EntryFields.mood} INTEGER,
  ${EntryFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${EntryFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now'))
);
    ''');

        await txn.execute('''
-- Step 4: Copy data from the old entries table to the new one
INSERT INTO $entriesTable (${EntryFields.id}, ${EntryFields.text}, ${EntryFields.mood}, ${EntryFields.timeCreate}, ${EntryFields.timeModified})
SELECT ${EntryFields.id}, ${EntryFields.text}, ${EntryFields.mood}, ${EntryFields.timeCreate}, ${EntryFields.timeModified}
FROM old_entries;
    ''');

        await txn.execute('''
-- Step 5: Drop the old entries table
DROP TABLE old_entries;
    ''');
      });
    }
    if (oldVersion <= 3) {
      await _createTagTables(db);
    }
    if (oldVersion <= 4) {
      await _createTemplateTagTable(db);
    }
    if (oldVersion <= 5) {
      await _addEntryLocationColumns(db);
    }
    if (oldVersion <= 6) {
      for (final column in [
        '${EntryFields.weatherCode} INTEGER',
        '${EntryFields.temperature} REAL',
        '${EntryFields.activity} TEXT',
      ]) {
        await db.execute('ALTER TABLE $entriesTable ADD COLUMN $column');
      }
    }
    if (oldVersion <= 7) {
      for (final column in [EntryFields.openAt, EntryFields.deletedAt]) {
        await db
            .execute('ALTER TABLE $entriesTable ADD COLUMN $column DATETIME');
      }
    }
    if (oldVersion <= 8) {
      // Older entries keep a null offset: where they were written is not
      // known, so they read as written in the device's time zone.
      await db.execute(
          'ALTER TABLE $entriesTable ADD COLUMN ${EntryFields.utcOffset} INTEGER');
    }
    if (oldVersion <= 9) {
      await db.execute(
          'ALTER TABLE $entriesTable ADD COLUMN ${EntryFields.diaryDate} TEXT');
      // Earlier entries never chose a day: give each the default for when
      // it was written, as a new one would get.
      final rows = await db.query(entriesTable,
          columns: [EntryFields.id, EntryFields.timeCreate]);
      final batch = db.batch();
      for (final row in rows) {
        final written = parseLocalTime(row[EntryFields.timeCreate] as String);
        batch.update(
            entriesTable,
            {
              EntryFields.diaryDate:
                  DiaryDay.format(DiaryDay.defaultFor(written))
            },
            where: '${EntryFields.id} = ?',
            whereArgs: [row[EntryFields.id]]);
      }
      await batch.commit(noResult: true);
    }
    if (oldVersion <= 10 && newVersion >= 11) {
      await addSyncSchema(db);
      await _assignBuiltinIds(db);
      // Nothing has synced yet; joining a space marks everything.
      await db.delete(syncChangesTable);
    } else if (oldVersion == 11 && newVersion >= 12) {
      // Spaces now hold packs; what was read of the old item files is moot.
      await addSyncItemsTable(db);
      await db.delete(syncSeenTable);
    }
    if (oldVersion >= 11 && oldVersion < 13 && newVersion >= 13) {
      await addSyncMediaSchema(db);
    }
    if (oldVersion < 14 && newVersion >= 14) {
      await _addHiddenAndImportSchema(db);
    }
    if (oldVersion >= 11 && oldVersion < 15 && newVersion >= 15) {
      await _removeUnusedStarterTags(db);
    }
    if (oldVersion < 16 && newVersion >= 16) {
      await _addLinksSchema(db);
    }
    if (oldVersion < 17 && newVersion >= 17) {
      await _upgradeToVersion17(db);
    }
  }

  /// Database version 17: an entry's title is a column of its own, weather
  /// belongs to a day and a place, activities become tags, a place says how
  /// it was set, and rows that belong to another go with it. Every device
  /// makes the same changes to its own copy, so none are recorded for sync;
  /// the items they make have the same ids everywhere.
  Future<void> _upgradeToVersion17(Database db) async {
    await db.execute('UPDATE $syncGuardTable SET active = 1');
    await _activitiesToTags(db);
    await db.execute('''
CREATE TABLE $dayWeatherTable (
  ${DayWeatherFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  $syncIdColumn TEXT,
  ${DayWeatherFields.day} TEXT NOT NULL,
  ${DayWeatherFields.place} TEXT NOT NULL,
  ${DayWeatherFields.source} TEXT NOT NULL,
  ${DayWeatherFields.code} INTEGER NOT NULL,
  ${DayWeatherFields.temperature} REAL NOT NULL,
  ${DayWeatherFields.timeModified} TEXT NOT NULL,
  UNIQUE (${DayWeatherFields.day}, ${DayWeatherFields.place}, ${DayWeatherFields.source})
)''');
    await addItemTableSync(db, SyncKind.weather);
    await _weatherToDays(db);

    // Old Android SQLite cannot drop columns or add foreign keys, so the
    // tables are made anew.
    await db.execute('PRAGMA legacy_alter_table = ON');
    await _rebuildTable(db, entriesTable, '''
  ${EntryFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  $syncIdColumn TEXT,
  ${EntryFields.title} TEXT NOT NULL DEFAULT '',
  ${EntryFields.text} TEXT NOT NULL,
  ${EntryFields.mood} INTEGER,
  ${EntryFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${EntryFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${EntryFields.utcOffset} INTEGER,
  ${EntryFields.diaryDate} TEXT,
  ${EntryFields.latitude} REAL,
  ${EntryFields.longitude} REAL,
  ${EntryFields.locationName} TEXT,
  ${EntryFields.locationSource} TEXT,
  ${EntryFields.openAt} DATETIME,
  ${EntryFields.deletedAt} DATETIME,
  ${EntryFields.isHidden} INTEGER NOT NULL DEFAULT 0
    CHECK (${EntryFields.isHidden} IN (0, 1))''');
    await _rebuildTable(db, tagsTable, '''
  ${TagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  $syncIdColumn TEXT,
  ${TagFields.categoryId} INTEGER
    REFERENCES $tagCategoriesTable (id) ON DELETE SET NULL,
  ${TagFields.icon} TEXT,
  ${TagFields.iconType} INTEGER NOT NULL DEFAULT 0,
  ${TagFields.name} TEXT NOT NULL,
  ${TagFields.tagType} INTEGER NOT NULL,
  ${TagFields.color} INTEGER,
  ${TagFields.sortOrder} INTEGER NOT NULL DEFAULT 0,
  ${TagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now')),
  ${TagFields.timeModified} DATETIME NOT NULL DEFAULT (DATETIME('now'))''',
        parents: {TagFields.categoryId: tagCategoriesTable});
    await _rebuildTable(db, imagesTable, '''
  ${EntryImageFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  $syncIdColumn TEXT,
  ${EntryImageFields.entryId} INTEGER NOT NULL
    REFERENCES $entriesTable (id) ON DELETE CASCADE,
  ${EntryImageFields.imgPath} TEXT NOT NULL,
  ${EntryImageFields.imgRank} INTEGER NOT NULL,
  ${EntryImageFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now'))''',
        parents: {EntryImageFields.entryId: entriesTable});
    await _rebuildTable(db, entryTagsTable, '''
  ${EntryTagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${EntryTagFields.entryId} INTEGER NOT NULL
    REFERENCES $entriesTable (id) ON DELETE CASCADE,
  ${EntryTagFields.tagId} INTEGER NOT NULL
    REFERENCES $tagsTable (id) ON DELETE CASCADE,
  ${EntryTagFields.value} TEXT,
  ${EntryTagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now'))''',
        parents: {
          EntryTagFields.entryId: entriesTable,
          EntryTagFields.tagId: tagsTable,
        });
    await _rebuildTable(db, templateTagsTable, '''
  ${TemplateTagFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${TemplateTagFields.templateId} INTEGER NOT NULL
    REFERENCES $templatesTable (id) ON DELETE CASCADE,
  ${TemplateTagFields.tagId} INTEGER NOT NULL
    REFERENCES $tagsTable (id) ON DELETE CASCADE,
  ${TemplateTagFields.timeCreate} DATETIME NOT NULL DEFAULT (DATETIME('now'))''',
        parents: {
          TemplateTagFields.templateId: templatesTable,
          TemplateTagFields.tagId: tagsTable,
        });
    await _rebuildTable(db, entryRefsTable, '''
  ${EntryRefFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${EntryRefFields.entryId} INTEGER NOT NULL
    REFERENCES $entriesTable (id) ON DELETE CASCADE,
  ${EntryRefFields.target} TEXT NOT NULL,
  ${EntryRefFields.quote} TEXT,
  ${EntryRefFields.quoteStart} INTEGER,
  ${EntryRefFields.rank} INTEGER NOT NULL DEFAULT 0,
  ${EntryRefFields.timeCreate} TEXT NOT NULL''',
        parents: {EntryRefFields.entryId: entriesTable});
    await _rebuildTable(db, passagesTable, '''
  ${PassageFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${PassageFields.entryId} INTEGER NOT NULL
    REFERENCES $entriesTable (id) ON DELETE CASCADE,
  ${PassageFields.quote} TEXT NOT NULL,
  ${PassageFields.quoteStart} INTEGER,
  ${PassageFields.timeCreate} TEXT NOT NULL,
  $syncIdColumn TEXT''', parents: {PassageFields.entryId: entriesTable});
    await db.execute('PRAGMA legacy_alter_table = OFF');

    await _titlesOutOfText(db);
    await db.execute('''
UPDATE $entriesTable SET ${EntryFields.locationSource} = '${LocationSource.imported.name}'
WHERE (${EntryFields.latitude} IS NOT NULL OR ${EntryFields.locationName} IS NOT NULL)
  AND id IN (SELECT entry_id FROM import_sources)''');
    await db.execute('UPDATE $syncGuardTable SET active = 0');
  }

  /// Makes [table] anew with [columns], keeping its rows, ids, indexes and
  /// triggers. Columns it no longer has go; new ones take their default.
  /// Rows whose parent in [parents] (column: table) is gone go too.
  Future<void> _rebuildTable(Database db, String table, String columns,
      {Map<String, String> parents = const {}}) async {
    final kept = await db.rawQuery(
        "SELECT sql FROM sqlite_master WHERE tbl_name = ? "
        "AND type IN ('index', 'trigger') AND sql IS NOT NULL",
        [table]);
    final old = {
      for (final column in await db.rawQuery('PRAGMA table_info($table)'))
        column['name'] as String,
    };
    final sequence = (await db.rawQuery(
            'SELECT seq FROM sqlite_sequence WHERE name = ?', [table]))
        .firstOrNull?['seq'] as int?;
    final rebuilt = '${table}_rebuilt';
    await db.execute('CREATE TABLE $rebuilt (\n$columns\n)');
    final shared = [
      for (final column in await db.rawQuery('PRAGMA table_info($rebuilt)'))
        if (old.contains(column['name'])) column['name'] as String,
    ].join(', ');
    final orphans = [
      for (final MapEntry(key: column, value: parent) in parents.entries)
        '$column IS NULL OR $column IN (SELECT id FROM $parent)',
    ].map((condition) => '($condition)').join(' AND ');
    await db.execute('INSERT INTO $rebuilt ($shared) SELECT $shared FROM $table'
        '${orphans.isEmpty ? '' : ' WHERE $orphans'}');
    await db.execute('DROP TABLE $table');
    await db.execute('ALTER TABLE $rebuilt RENAME TO $table');
    if (sequence != null) {
      await db.execute(
          'UPDATE sqlite_sequence SET seq = MAX(seq, ?) WHERE name = ?',
          [sequence, table]);
    }
    for (final row in kept) {
      await db.execute(row['sql'] as String);
    }
  }

  /// Activities recorded with entries before version 17 become tags of the
  /// same name in every diary, with the same ids.
  Future<void> _activitiesToTags(Database db) async {
    final columns = {
      for (final column
          in await db.rawQuery('PRAGMA table_info($entriesTable)'))
        column['name'] as String,
    };
    if (!columns.contains(EntryFields.activity)) return;
    final rows = await db.query(entriesTable,
        columns: [EntryFields.id, EntryFields.activity, EntryFields.timeCreate],
        where: '${EntryFields.activity} IS NOT NULL');
    if (rows.isEmpty) return;
    final l10n = await TemplatesProvider.defaultsLocalizations();
    final tagIds = <ActivityTag, int>{};
    for (final row in rows) {
      final activity = ActivityTag.byName(row[EntryFields.activity] as String);
      if (activity == null) continue;
      final tagId = tagIds[activity] ??= await _activityTag(db, activity, l10n);
      await db.insert(entryTagsTable, {
        EntryTagFields.entryId: row[EntryFields.id],
        EntryTagFields.tagId: tagId,
        EntryTagFields.timeCreate: row[EntryFields.timeCreate],
      });
    }
  }

  Future<int> _activityTag(
      Database db, ActivityTag activity, AppLocalizations l10n) async {
    final name = activity.label(l10n);
    final same = await db.query(tagsTable,
        columns: ['id'],
        where: 'lower(${TagFields.name}) = ?',
        whereArgs: [name.toLowerCase()]);
    if (same.isNotEmpty) return same.first['id'] as int;
    final last = (await db.rawQuery(
            'SELECT MAX(${TagFields.sortOrder}) AS last FROM $tagsTable'))
        .single['last'] as int?;
    return db.insert(tagsTable, {
      TagFields.name: name,
      TagFields.tagType: TagType.label.toInt(),
      TagFields.sortOrder: (last ?? -1) + 1,
      syncIdColumn:
          md5.convert(utf8.encode('activity|${activity.name}')).toString(),
    });
  }

  /// Weather recorded with each entry before version 17 becomes the weather
  /// of its day at its place, imported where the entry was.
  Future<void> _weatherToDays(Database db) async {
    final rows = await db.rawQuery('''
SELECT e.*, EXISTS (SELECT 1 FROM import_sources s WHERE s.entry_id = e.id)
  AS imported
FROM $entriesTable e
WHERE ${EntryFields.weatherCode} IS NOT NULL
  AND ${EntryFields.temperature} IS NOT NULL
ORDER BY ${EntryFields.timeCreate}''');
    for (final row in rows) {
      final entry = Entry.fromJson(row);
      await WeatherProvider.write(
          db,
          entry.day,
          weatherPlaceOf(entry.location),
          EntryWeather(
              code: row[EntryFields.weatherCode] as int,
              temperature: (row[EntryFields.temperature] as num).toDouble()),
          row['imported'] == 1
              ? WeatherSource.imported
              : WeatherSource.queried);
    }
  }

  /// A first line written as a top-level heading becomes the entry's title.
  /// Citations and kept passages point into the text, so they move up.
  Future<void> _titlesOutOfText(Database db) async {
    final rows = await db.query(entriesTable,
        columns: [EntryFields.id, syncIdColumn, EntryFields.text],
        where: "${EntryFields.text} LIKE '#%'");
    for (final row in rows) {
      final text = row[EntryFields.text] as String;
      final (:title, :body) = splitEntryTitle(text);
      if (title.isEmpty) continue;
      await db.update(
          entriesTable, {EntryFields.title: title, EntryFields.text: body},
          where: 'id = ?', whereArgs: [row['id']]);
      final shift = text.length - body.length;
      const moved = 'CASE WHEN quote_start >= ? THEN quote_start - ? END';
      await db.rawUpdate(
          'UPDATE $passagesTable SET ${PassageFields.quoteStart} = '
          '${moved.replaceAll('quote_start', PassageFields.quoteStart)} '
          'WHERE ${PassageFields.entryId} = ?',
          [shift, shift, row['id']]);
      await db.rawUpdate(
          'UPDATE $entryRefsTable SET ${EntryRefFields.quoteStart} = '
          '${moved.replaceAll('quote_start', EntryRefFields.quoteStart)} '
          'WHERE ${EntryRefFields.target} = ?',
          [shift, shift, row[syncIdColumn]]);
    }
  }

  /// Citations between entries and kept passages (database version 16).
  Future<void> _addLinksSchema(Database db) async {
    await db.execute('''
CREATE TABLE $entryRefsTable (
  ${EntryRefFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${EntryRefFields.entryId} INTEGER NOT NULL,
  ${EntryRefFields.target} TEXT NOT NULL,
  ${EntryRefFields.quote} TEXT,
  ${EntryRefFields.quoteStart} INTEGER,
  ${EntryRefFields.rank} INTEGER NOT NULL DEFAULT 0,
  ${EntryRefFields.timeCreate} TEXT NOT NULL
)''');
    await db.execute('CREATE INDEX ${entryRefsTable}_entry '
        'ON $entryRefsTable (${EntryRefFields.entryId})');
    await db.execute('CREATE INDEX ${entryRefsTable}_target '
        'ON $entryRefsTable (${EntryRefFields.target})');
    await db.execute('''
CREATE TABLE $passagesTable (
  ${PassageFields.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ${PassageFields.entryId} INTEGER NOT NULL,
  ${PassageFields.quote} TEXT NOT NULL,
  ${PassageFields.quoteStart} INTEGER,
  ${PassageFields.timeCreate} TEXT NOT NULL,
  $syncIdColumn TEXT
)''');
    await addLinksSyncSchema(db);
  }

  /// Installs used to start with tags (favorite, energy, emotions and
  /// activities); a new diary now starts with none. Those no entry or
  /// template uses go, and their categories once nothing is left in them.
  /// Deleting them syncs like any deletion.
  Future<void> _removeUnusedStarterTags(Database db) async {
    await db.delete(tagsTable,
        where: "$syncIdColumn LIKE 'builtin-tag-%' "
            'AND id NOT IN (SELECT ${EntryTagFields.tagId} FROM $entryTagsTable) '
            'AND id NOT IN (SELECT ${TemplateTagFields.tagId} FROM $templateTagsTable)');
    await db.delete(tagCategoriesTable,
        where: "$syncIdColumn LIKE 'builtin-category-%' "
            'AND id NOT IN (SELECT ${TagFields.categoryId} FROM $tagsTable '
            'WHERE ${TagFields.categoryId} IS NOT NULL)');
  }

  Future<void> _addHiddenAndImportSchema(Database db) async {
    await db.execute('ALTER TABLE $entriesTable ADD COLUMN '
        '${EntryFields.isHidden} INTEGER NOT NULL DEFAULT 0 '
        'CHECK (${EntryFields.isHidden} IN (0, 1))');
    await db.execute('''
CREATE TABLE import_sources (
  source_format TEXT NOT NULL,
  source_id TEXT NOT NULL,
  source_hash TEXT NOT NULL,
  entry_id INTEGER NOT NULL REFERENCES $entriesTable(id) ON DELETE CASCADE,
  source_json TEXT NOT NULL,
  PRIMARY KEY (source_format, source_id, source_hash)
)''');
  }

  Future<void> _addEntryLocationColumns(Database db) async {
    for (final column in [
      '${EntryFields.latitude} REAL',
      '${EntryFields.longitude} REAL',
      '${EntryFields.locationName} TEXT',
    ]) {
      await db.execute('ALTER TABLE $entriesTable ADD COLUMN $column');
    }
  }
}
