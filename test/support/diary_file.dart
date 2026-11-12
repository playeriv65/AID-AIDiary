// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/database_schema.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A diary database file at [path] with the current schema and [entries]
/// (columns of `entries`; `time_create` and `time_modified` default to a
/// fixed day), for tests of what reads the file directly.
Future<void> writeDiaryFile(String path,
    {List<Map<String, Object?>> entries = const []}) async {
  sqfliteFfiInit();
  final db = await databaseFactoryFfi.openDatabase(path);
  try {
    await createSchema(db);
    for (final entry in entries) {
      await db.insert('entries', {
        'time_create': '2026-01-02T08:00:00.000',
        'time_modified': '2026-01-02T08:00:00.000',
        ...entry,
      });
    }
  } finally {
    await db.close();
  }
}
