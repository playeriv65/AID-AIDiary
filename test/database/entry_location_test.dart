import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/database/entry_dao.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('version 5 databases gain empty location columns', () async {
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
    await AppDatabase.instance.upgradeSchema(db, 5, 6);

    final old = (await EntryDao.getAll()).single;
    expect(old.text, 'old entry');
    expect(old.location, isNull);

    final placed = await EntryDao.add(Entry(
        text: 'new entry',
        timeCreate: DateTime(2026, 10, 19),
        timeModified: DateTime(2026, 10, 19),
        location: const EntryLocation(
            latitude: 31.23, longitude: 121.47, name: 'The Bund')));
    final read = await EntryDao.get(placed.id!);
    expect(
        read!.location,
        const EntryLocation(
            latitude: 31.23, longitude: 121.47, name: 'The Bund'));
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
