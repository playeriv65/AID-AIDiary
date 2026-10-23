@Tags(['integration'])
library;

import 'package:aid_diary/config/app_config.dart';

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';

import 'package:aid_diary/storage/in_memory_file_store.dart';

import 'package:aid_diary/sync/nearby_adoption.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/app_folders_harness.dart';
import '../support/config_provider_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryAppFolders();
  useTemporaryConfig();
  final database = AppDatabase.instance;
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await AppConfig.load();
  });
  setUp(() async {
    ImageStorage.instance
        .overrideStores(InMemoryFileStore(), InMemoryFileStore());
    expect(await database.init(forceWithoutSync: true), isTrue);
  });
  tearDown(() async {
    ImageStorage.instance.clearStoreOverrides();
    await database.close();
  });

  test('a newly opened database remains eligible for nearby receive', () async {
    expect(await database.database!.query(entriesTable), isEmpty);
    var prepared = false;
    await nearbyAdoptionTransaction(
        db: database.database!,
        requireEmpty: true,
        current: () => true,
        persist: (_) async {
          prepared = true;
        },
        restore: () async {});
    expect(prepared, isTrue);
    expect(EntryStore.instance.entries, isEmpty);
    await database.close();
    await database.init(forceWithoutSync: true);
    expect(await database.database!.query(entriesTable), isEmpty);
  });

  test('opening a diary preserves saved and recently deleted writing',
      () async {
    final saved = await EntryStore.instance.add(Entry(
        text: 'My own writing',
        timeCreate: DateTime(2026),
        timeModified: DateTime(2026)));
    final deleted = await EntryStore.instance.add(Entry(
        text: 'Keep this recoverable',
        timeCreate: DateTime(2026),
        timeModified: DateTime(2026)));
    await EntryStore.instance.delete(deleted);
    final before = await database.database!.query(entriesTable, orderBy: 'id');
    await database.close();
    await database.init(forceWithoutSync: true);
    expect(await database.database!.query(entriesTable, orderBy: 'id'), before);
    expect(
        EntryStore.instance.entries
            .where((entry) => entry.id == saved.id)
            .single
            .text,
        'My own writing');
  });
}
