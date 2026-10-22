// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/storage/external_sync_health.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/local_file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/generated/tag_icon_registry.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/widgets.dart';
import 'package:aid_diary/sync/builtin_ids.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  AppDatabase._init();

  static DatabaseExecutor executorOr(DatabaseExecutor? executor) =>
      executor ?? instance.database!;

  static const String databaseFileName = 'aid_diary.db';

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
    _database = await openDatabase(_internalPath!,
        version: 13, onCreate: _createDatabase, onUpgrade: _onUpgrade);

    await EntriesProvider.instance.load(firstScreen: firstScreen);
    await EntryImagesProvider.instance.load();
    await TemplatesProvider.instance.load();
    await TagsProvider.instance.load();
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
    await TagsProvider.instance.createDefaultTags();
    await createWelcomeEntry();
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

  @visibleForTesting
  Future<void> createWelcomeEntry() async {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    Locale locale;
    if (AppLocalizations.delegate.isSupported(deviceLocale)) {
      locale = deviceLocale;
    } else {
      final langOnly = Locale(deviceLocale.languageCode);
      locale = AppLocalizations.delegate.isSupported(langOnly)
          ? langOnly
          : const Locale('en');
    }
    final l10n = await AppLocalizations.delegate.load(locale);
    final now = DateTime.now();

    final welcomeEntry = await EntriesProvider.instance.add(
      Entry(
        text: l10n.welcomeLogBodyText,
        mood: 1,
        timeCreate: now,
        timeModified: now,
      ),
      skipUpdate: true,
    );

    final imageBytes = await rootBundle.load('assets/$welcomeImageName');
    final imageName = await ImageStorage.instance.create(
      welcomeImageName,
      imageBytes.buffer.asUint8List(),
      currTime: now,
    );
    if (imageName != null) {
      await EntryImagesProvider.instance.add(
        EntryImage(
          entryId: welcomeEntry.id,
          imgPath: imageName,
          imgRank: 0,
          timeCreate: now,
        ),
        skipUpdate: true,
      );
    }

    final favoriteTag = TagsProvider.instance.tags
        .where((tag) => tag.icon == TagIconKey.favorite)
        .firstOrNull;
    if (favoriteTag != null) {
      await TagsProvider.instance.addEntryTag(EntryTag(
        entryId: welcomeEntry.id!,
        tagId: favoriteTag.id!,
        timeCreate: now,
      ));
    }

    final energyTag = TagsProvider.instance.tags
        .where((tag) => tag.icon == TagIconKey.batteryChargingFull)
        .firstOrNull;
    if (energyTag != null) {
      await TagsProvider.instance.addEntryTag(EntryTag(
        entryId: welcomeEntry.id!,
        tagId: energyTag.id!,
        value: '10',
        timeCreate: now,
      ));
    }
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
      await TagsProvider.instance.createDefaultTags();
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
