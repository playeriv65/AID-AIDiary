@Tags(['integration'])
library;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:aid_diary/sync/identity.dart';
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

  test('normal first start creates the example once with its attachment',
      () async {
    expect(await database.createWelcomeForFirstStart(), isTrue);
    expect(EntryStore.instance.entries, hasLength(1));
    expect(EntryStore.instance.entries.single.text, isNotEmpty);
    expect(await database.database!.query(imagesTable), hasLength(1));
    expect(await database.createWelcomeForFirstStart(), isFalse);
    expect(EntryStore.instance.entries, hasLength(1));
  });

  test(
      'existing and recently deleted writing are never changed by initialization',
      () async {
    final entry = await EntryStore.instance.add(Entry(
        text: 'Already mine',
        timeCreate: DateTime(2026),
        timeModified: DateTime(2026)));
    expect(await database.createWelcomeForFirstStart(), isFalse);
    expect(EntryStore.instance.entries.single.text, 'Already mine');
    await EntryStore.instance.delete(entry);
    expect(await database.createWelcomeForFirstStart(), isFalse);
    expect((await database.database!.query(entriesTable)).single['text'],
        'Already mine');
  });

  test(
      'adopted identity, pending migration and completed onboarding stay empty',
      () async {
    final config = ConfigProvider.instance;
    await DiaryIdentity.create().keep();
    expect(await database.createWelcomeForFirstStart(), isFalse);
    await config.set(Settings.identity, '');
    await config.set(Settings.nearbyMigration, '{"pending":true}');
    expect(await database.createWelcomeForFirstStart(), isFalse);
    await config.set(Settings.nearbyMigration, '');
    await config.set(Settings.onboardingDone, true);
    expect(await database.createWelcomeForFirstStart(), isFalse);
    expect(await database.database!.query(entriesTable), isEmpty);
  });
}
