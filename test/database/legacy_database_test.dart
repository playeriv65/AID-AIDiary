// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

void main() {
  late Directory dir;
  late String current;
  late String legacy;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('aid_diary_legacy_db');
    current = join(dir.path, AppDatabase.databaseFileName);
    legacy = join(dir.path, AppDatabase.legacyDatabaseFileName);
  });

  tearDown(() => dir.delete(recursive: true));

  test('a legacy database and its side files take the current name', () async {
    await File(legacy).writeAsString('db');
    await File('$legacy-wal').writeAsString('wal');

    await AppDatabase.renameLegacyDatabase(current);

    expect(await File(current).readAsString(), 'db');
    expect(await File('$current-wal').readAsString(), 'wal');
    expect(await File(legacy).exists(), isFalse);
    expect(await File('$legacy-wal').exists(), isFalse);
  });

  test('an existing current database is never replaced', () async {
    await File(current).writeAsString('new');
    await File(legacy).writeAsString('old');

    await AppDatabase.renameLegacyDatabase(current);

    expect(await File(current).readAsString(), 'new');
    expect(await File(legacy).exists(), isTrue);
  });
}
