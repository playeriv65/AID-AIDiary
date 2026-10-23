// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';

/// Local provenance survives full backups. Reimporting a source revision never
/// overwrites edits to the imported entry, or revives one the owner deleted.
class ImportSourceDao {
  static Future<bool> contains(String format, String id, String hash) async {
    final rows = await AppDatabase.instance.database!.rawQuery('''
SELECT 1 FROM import_sources AS source
JOIN entries AS entry ON entry.id = source.entry_id
WHERE source.source_format = ? AND source.source_id = ? AND source.source_hash = ?
LIMIT 1''', [format, id, hash]);
    return rows.isNotEmpty;
  }

  static Future<void> add(
      {required String format,
      required String id,
      required String hash,
      required int entryId,
      required String json}) async {
    await AppDatabase.instance.database!.insert('import_sources', {
      'source_format': format,
      'source_id': id,
      'source_hash': hash,
      'entry_id': entryId,
      'source_json': json,
    });
  }
}
