import 'dart:io';

import 'package:aid_diary/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  late Directory folder;
  late String path;

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('aid_before_upgrade');
    path = p.join(folder.path, AppDatabase.databaseFileName);
  });
  tearDown(() => folder.delete(recursive: true));

  Future<void> diaryOfSchema(int version) async {
    final db = await databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: version,
            onCreate: (db, _) =>
                db.execute('CREATE TABLE entries (id INTEGER)')));
    await db.close();
  }

  List<String> copies() {
    final kept =
        Directory(p.join(folder.path, AppDatabase.beforeUpgradeFolder));
    if (!kept.existsSync()) return [];
    return [for (final file in kept.listSync()) p.basename(file.path)]..sort();
  }

  test('an older schema is copied aside before the upgrade', () async {
    await diaryOfSchema(AppDatabase.currentVersion - 1);
    await AppDatabase.copyBeforeUpgrade(path);
    expect(copies(), hasLength(1));
    expect(copies().single, startsWith('v${AppDatabase.currentVersion - 1}-'));
  });

  test('the current schema and no diary are left alone', () async {
    await AppDatabase.copyBeforeUpgrade(path);
    await diaryOfSchema(AppDatabase.currentVersion);
    await AppDatabase.copyBeforeUpgrade(path);
    expect(copies(), isEmpty);
  });

  test('only the newest copies stay', () async {
    await diaryOfSchema(AppDatabase.currentVersion - 1);
    for (var i = 0; i < 3; i++) {
      await AppDatabase.copyBeforeUpgrade(path, keep: 2);
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(copies(), hasLength(2));
  });
}
