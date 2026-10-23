// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:sqflite/sqflite.dart';

/// Includes Recently deleted: hiding must survive deletion and restoration.
Future<bool> hasHiddenEntries(DatabaseExecutor db) async {
  final columns = await db.rawQuery('PRAGMA table_info($entriesTable)');
  if (!columns.any((column) => column['name'] == EntryFields.isHidden)) {
    return false;
  }
  return (await db.query(entriesTable,
          columns: [EntryFields.id],
          where: '${EntryFields.isHidden} = 1',
          limit: 1))
      .isNotEmpty;
}

/// Older sync clients ignore unfamiliar fields, so cannot safely hide a row.
Future<void> requireHiddenCompatibleSync(DatabaseExecutor db) async {
  if (await hasHiddenEntries(db)) {
    throw UnsupportedError('Hidden entries are local only. Sync is paused '
        'because older devices cannot preserve their privacy. Encrypted '
        'backups retain them; existing copies on other devices are unchanged.');
  }
}
