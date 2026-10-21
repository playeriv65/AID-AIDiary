@Tags(['integration'])
library;

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('version 5 databases gain empty location, weather and activity',
      () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(() async {
      AppDatabase.instance.database = null;
      await db.close();
    });
    await db.execute('''
CREATE TABLE entries (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  text TEXT NOT NULL,
  mood INTEGER,
  time_create DATETIME NOT NULL DEFAULT (DATETIME('now')),
  time_modified DATETIME NOT NULL DEFAULT (DATETIME('now'))
)''');
    await db.insert('entries', {
      'text': 'old entry',
      'time_create': '2026-01-02T03:04:05.000',
      'time_modified': '2026-01-02T03:04:05.000',
    });
    AppDatabase.instance.database = db;
    // Backfilled days follow the default for when each was written.
    DiaryDay.startHour = 4;
    addTearDown(() => DiaryDay.startHour = 0);
    await AppDatabase.instance.upgradeSchema(db, 5, 10);

    final old = (await EntryDao.getAll()).single;
    expect(old.text, 'old entry');
    expect(old.location, isNull);
    expect(old.weather, isNull);
    expect(old.activity, isNull);
    // Where an old entry was written is unknown.
    expect(old.utcOffset, isNull);
    // Written at 3:04, so it belongs to the evening before.
    expect(old.day, DateTime(2026, 1, 1));
    expect(old.timeCreate, DateTime(2026, 1, 2, 3, 4, 5));
    await EntryDao.setDeleted(old.id!, DateTime(2026, 10, 20));
    expect(await EntryDao.getAll(), isEmpty);
    expect(
        (await EntryDao.getDeleted()).single.deletedAt, DateTime(2026, 10, 20));
    await EntryDao.setDeleted(old.id!, null);

    final placed = await EntryDao.add(Entry(
        text: 'new entry',
        timeCreate: DateTime(2026, 10, 19),
        timeModified: DateTime(2026, 10, 19),
        location: const EntryLocation(
            latitude: 31.23, longitude: 121.47, name: 'The Bund'),
        weather: const EntryWeather(code: 61, temperature: 14.5),
        activity: EntryActivity.walking));
    final read = await EntryDao.get(placed.id!);
    expect(
        read!.location,
        const EntryLocation(
            latitude: 31.23, longitude: 121.47, name: 'The Bund'));
    expect(read.weather, const EntryWeather(code: 61, temperature: 14.5));
    expect(read.activity, EntryActivity.walking);
    // A new entry was written here.
    expect(read.utcOffset, DateTime(2026, 10, 19).timeZoneOffset.inMinutes);
  });

  test('location label prefers the name over coordinates', () {
    expect(const EntryLocation(latitude: 1.5, longitude: 2.25).label,
        '1.5000, 2.2500');
    expect(const EntryLocation(latitude: 1, longitude: 2, name: 'Home').label,
        'Home');
    expect(const EntryLocation().isEmpty, isTrue);
  });

  test('reverse geocoding keeps the specific place and the city', () {
    expect(
        LocationService.shortName({
          'display_name': 'long',
          'address': {'road': 'Zhongshan Rd', 'city': 'Shanghai'}
        }),
        'Zhongshan Rd, Shanghai');
    expect(
        LocationService.shortName({'display_name': 'Somewhere', 'address': {}}),
        'Somewhere');
  });
}
