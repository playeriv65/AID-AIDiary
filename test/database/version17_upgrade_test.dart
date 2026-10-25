// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    AppDatabase.instance.database = db;
    // A diary as version 16 left it.
    await AppDatabase.instance.createVersion10Schema(db);
    await AppDatabase.instance.upgradeSchema(db, 10, 16);
  });

  tearDown(() async {
    AppDatabase.instance.database = null;
    await db.close();
  });

  Future<int> addEntry(String text,
          {String? activity,
          int? weatherCode,
          double? temperature,
          double? latitude,
          double? longitude}) =>
      db.insert(entriesTable, {
        EntryFields.text: text,
        EntryFields.timeCreate: '2026-10-20T09:00:00.000',
        EntryFields.timeModified: '2026-10-20T09:00:00.000',
        EntryFields.diaryDate: '2026-10-20',
        // Columns version 17 no longer has, given only before the upgrade.
        if (activity != null) EntryFields.activity: activity,
        if (weatherCode != null) EntryFields.weatherCode: weatherCode,
        if (temperature != null) EntryFields.temperature: temperature,
        EntryFields.latitude: latitude,
        EntryFields.longitude: longitude,
      });

  Future<Set<String>> columnsOf(String table) async => {
        for (final column in await db.rawQuery('PRAGMA table_info($table)'))
          column['name'] as String,
      };

  test('titles, weather and activities leave the entry text and columns',
      () async {
    final walk = await addEntry('# 周末\n去了公园，看见湖。',
        activity: 'walking',
        weatherCode: 61,
        temperature: 14.5,
        latitude: 31.23,
        longitude: 121.47);
    final imported = await addEntry('Day One 的日记',
        weatherCode: 3, temperature: 20, latitude: 48.85, longitude: 2.35);
    await db.insert('import_sources', {
      'source_format': 'day_one',
      'source_id': 'A',
      'source_hash': 'h',
      'entry_id': imported,
      'source_json': '{}',
    });
    final walkId = (await db.query(entriesTable,
            columns: [syncIdColumn], where: 'id = ?', whereArgs: [walk]))
        .single[syncIdColumn];
    // Both point at 看见湖, after the title line of 5 characters.
    await db.insert(passagesTable, {
      PassageFields.entryId: walk,
      PassageFields.quote: '看见湖',
      PassageFields.quoteStart: 10,
      PassageFields.timeCreate: '2026-10-21T08:00:00.000',
    });
    await db.insert(entryRefsTable, {
      EntryRefFields.entryId: imported,
      EntryRefFields.target: walkId,
      EntryRefFields.quote: '周末',
      EntryRefFields.quoteStart: 2,
      EntryRefFields.timeCreate: '2026-10-21T08:00:00.000',
    });
    await db.delete(syncChangesTable);

    await AppDatabase.instance.upgradeSchema(db, 16, 17);

    expect(await columnsOf(entriesTable),
        containsAll([EntryFields.title, EntryFields.locationSource]));
    expect(
        (await columnsOf(entriesTable)).intersection({
          EntryFields.activity,
          EntryFields.weatherCode,
          EntryFields.temperature,
        }),
        isEmpty);

    final entries = {
      for (final row in await db.query(entriesTable))
        row['id']: Entry.fromJson(row)
    };
    expect((entries[walk]!.title, entries[walk]!.text), ('周末', '去了公园，看见湖。'));
    expect(entries[imported]!.title, isEmpty);
    expect(entries[imported]!.location!.source, LocationSource.imported);
    expect(entries[walk]!.location!.source, isNull);

    final passage = (await db.query(passagesTable)).single;
    expect(passage[PassageFields.quoteStart], 5);
    expect(entries[walk]!.text.substring(5, 8), '看见湖');
    // The cited words were the title: no place in the text any more.
    expect((await db.query(entryRefsTable)).single[EntryRefFields.quoteStart],
        isNull);

    await WeatherProvider.instance.load();
    final walkWeather = WeatherProvider.instance
        .of(DateTime(2026, 10, 20), entries[walk]!.location)!;
    expect(
        walkWeather.weather, const EntryWeather(code: 61, temperature: 14.5));
    expect(walkWeather.source, WeatherSource.queried);
    expect(
        WeatherProvider.instance
            .of(DateTime(2026, 10, 20), entries[imported]!.location)!
            .source,
        WeatherSource.imported);

    final tag = (await db.query(tagsTable)).single;
    expect(tag[TagFields.name], isNotEmpty);
    expect(
        (await db.query(entryTagsTable)).single[EntryTagFields.entryId], walk);

    // Every device makes the same changes, so none wait to be sent.
    expect(await db.query(syncChangesTable), isEmpty);
  });

  test('rebuilt tables keep ids and record changes again', () async {
    final first = await addEntry('first');
    final second = await addEntry('second');
    await db.delete(entriesTable, where: 'id = ?', whereArgs: [second]);

    await AppDatabase.instance.upgradeSchema(db, 16, 17);
    await db.delete(syncChangesTable);

    expect((await db.query(entriesTable)).single['id'], first);
    // An id once used is not handed out again.
    final next = await addEntry('third');
    expect(next, greaterThan(second));
    final added =
        (await db.query(entriesTable, where: 'id = ?', whereArgs: [next]))
            .single;
    expect(added[syncIdColumn], matches(RegExp(r'^[0-9a-f]{32}$')));
    expect((await db.query(syncChangesTable)).single[syncIdColumn],
        added[syncIdColumn]);
  });

  test('rows that belong to a deleted entry go with it', () async {
    final entry = await addEntry('with things');
    final orphan = await addEntry('gone');
    await db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: 'a.jpg',
      EntryImageFields.imgRank: 0,
    });
    // Left behind by an older version that forgot to clean up.
    await db.insert(imagesTable, {
      EntryImageFields.entryId: 999,
      EntryImageFields.imgPath: 'lost.jpg',
      EntryImageFields.imgRank: 0,
    });
    await db.insert(passagesTable, {
      PassageFields.entryId: entry,
      PassageFields.quote: 'things',
      PassageFields.timeCreate: '2026-10-21T08:00:00.000',
    });
    await db.delete(entriesTable, where: 'id = ?', whereArgs: [orphan]);

    await AppDatabase.instance.upgradeSchema(db, 16, 17);
    await AppDatabase.enforceForeignKeys(db);

    expect((await db.query(imagesTable)).single[EntryImageFields.imgPath],
        'a.jpg');
    await db.delete(entriesTable, where: 'id = ?', whereArgs: [entry]);
    expect(await db.query(imagesTable), isEmpty);
    expect(await db.query(passagesTable), isEmpty);
    await expectLater(
        db.insert(imagesTable, {
          EntryImageFields.entryId: 12345,
          EntryImageFields.imgPath: 'b.jpg',
          EntryImageFields.imgRank: 0,
        }),
        throwsA(isA<DatabaseException>()));
  });

  test('a new diary has the same shape as an upgraded one', () async {
    final fresh = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(singleInstance: false));
    addTearDown(fresh.close);
    await AppDatabase.instance.createSchema(fresh);
    await AppDatabase.instance.upgradeSchema(db, 16, 17);
    AppDatabase.instance.database = db;

    Future<List<String>> schema(Database of) async => [
          for (final row
              in await of.rawQuery("SELECT type, name, sql FROM sqlite_master "
                  "WHERE name NOT LIKE 'sqlite_%' ORDER BY type, name"))
            '${row['type']} ${row['name']}: ${row['sql']}'
                .replaceAll(RegExp(r'\s+'), ' '),
        ];
    expect(await schema(db), await schema(fresh));
  });
}
