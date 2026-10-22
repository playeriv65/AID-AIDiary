// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite and native secure settings have no shared transaction. Keep diary
/// writers blocked while checking and persisting, then compensate secure-store
/// writes before rolling back SQLite if cancellation or persistence fails.
Future<void> nearbyAdoptionTransaction(
    {required Database db,
    required bool Function() current,
    required Future<void> Function(DatabaseExecutor) persist,
    required Future<void> Function() restore,
    bool Function()? afterPersist,
    bool requireEmpty = false}) async {
  var touched = false;
  var restored = false;
  try {
    await db.transaction((txn) async {
      if (!current()) throw StateError('Nearby operation cancelled');
      if (requireEmpty &&
          (await txn.query(entriesTable, columns: ['id'], limit: 1))
              .isNotEmpty) {
        throw StateError('Nearby destination is not empty');
      }
      if (!current()) throw StateError('Nearby operation cancelled');
      try {
        // A write may update its in-memory setting before native persistence fails.
        touched = true;
        await persist(txn);
        if (!(afterPersist?.call() ?? current())) {
          throw StateError('Nearby operation cancelled');
        }
      } catch (_) {
        restored = true;
        await restore();
        rethrow;
      }
    });
  } catch (_) {
    // Also compensate an SQLite commit failure after the callback completed.
    if (touched && !restored) await restore();
    rethrow;
  }
}
