// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';

/// What links entries: the entries each cites, the entries citing each
/// (its replies), and the passages kept from each. Whether an entry may
/// show (hidden, sealed, deleted) is for the caller.
class LinksProvider with ChangeNotifier {
  static final LinksProvider instance = LinksProvider._init();

  LinksProvider._init();

  Map<int, List<EntryRef>> _refs = const {};
  Map<int, List<int>> _replies = const {};
  List<KeptPassage> _passages = const [];
  Map<int, List<KeptPassage>> _passagesByEntry = const {};

  /// What [entryId] cites, in order.
  List<EntryRef> refsOf(int entryId) => _refs[entryId] ?? const [];

  /// The entries citing [entryId].
  List<int> repliesTo(int entryId) => _replies[entryId] ?? const [];

  /// Every kept passage, oldest first.
  List<KeptPassage> get passages => _passages;

  List<KeptPassage> passagesOf(int entryId) =>
      _passagesByEntry[entryId] ?? const [];

  Future<void> load() async {
    final db = AppDatabase.instance.database!;
    final rows = await db.rawQuery('''
SELECT r.*, e.id AS target_id FROM $entryRefsTable r
LEFT JOIN $entriesTable e ON e.$syncIdColumn = r.${EntryRefFields.target}
ORDER BY r.${EntryRefFields.rank}, r.id''');
    final refs = <int, List<EntryRef>>{};
    final replies = <int, List<int>>{};
    for (final row in rows) {
      final ref = EntryRef.fromJson(row);
      (refs[ref.entryId!] ??= []).add(ref);
      if (ref.targetId case final target?) {
        (replies[target] ??= []).add(ref.entryId!);
      }
    }
    _refs = refs;
    _replies = replies;
    _setPassages([
      for (final row in await db.query(passagesTable)) KeptPassage.fromJson(row)
    ]);
    notifyListeners();
  }

  void _setPassages(List<KeptPassage> passages) {
    _passages = [...passages]
      ..sort((a, b) => a.timeCreate.compareTo(b.timeCreate));
    final byEntry = <int, List<KeptPassage>>{};
    for (final passage in _passages) {
      (byEntry[passage.entryId] ??= []).add(passage);
    }
    _passagesByEntry = byEntry;
  }

  /// The sync id that names [entryId] to a citation.
  static Future<String> syncIdOf(int entryId) async =>
      (await AppDatabase.instance.database!.query(entriesTable,
              columns: [syncIdColumn], where: 'id = ?', whereArgs: [entryId]))
          .single[syncIdColumn] as String;

  /// Makes [entryId] cite exactly [refs], inside a save's transaction;
  /// whether anything changed.
  static Future<bool> writeRefs(
      DatabaseExecutor executor, int entryId, List<EntryRef> refs) async {
    final current = [
      for (final row in await executor.query(entryRefsTable,
          where: '${EntryRefFields.entryId} = ?',
          whereArgs: [entryId],
          orderBy: '${EntryRefFields.rank}, id'))
        EntryRef.fromJson(row),
    ];
    if (current.length == refs.length &&
        [for (var i = 0; i < refs.length; i++) current[i].sameAs(refs[i])]
            .every((same) => same)) {
      return false;
    }
    await executor.delete(entryRefsTable,
        where: '${EntryRefFields.entryId} = ?', whereArgs: [entryId]);
    for (final (rank, ref) in refs.indexed) {
      await executor.insert(
          entryRefsTable, ref.copy(entryId: entryId, rank: rank).toJson());
    }
    return true;
  }

  /// For an entry erased for good, inside its transaction: its citations
  /// and kept passages go. Citations of it stay, with their quotes.
  static Future<void> removeForEntry(int entryId,
      {required DatabaseExecutor executor}) async {
    await executor.delete(entryRefsTable,
        where: '${EntryRefFields.entryId} = ?', whereArgs: [entryId]);
    await executor.delete(passagesTable,
        where: '${PassageFields.entryId} = ?', whereArgs: [entryId]);
  }

  /// Forgets what [removeForEntry] took out of the database; citations of
  /// the entry stay, now naming one that is gone.
  void forgetEntries(Set<int> entryIds) {
    _refs = {
      for (final MapEntry(:key, :value) in _refs.entries)
        if (!entryIds.contains(key)) key: value,
    };
    _replies = {
      for (final MapEntry(:key, :value) in _replies.entries)
        key: [
          for (final id in value)
            if (!entryIds.contains(id)) id
        ],
    };
    _setPassages([
      for (final passage in _passages)
        if (!entryIds.contains(passage.entryId)) passage
    ]);
    notifyListeners();
  }

  Future<KeptPassage> keep(KeptPassage passage) async {
    final id = await AppDatabase.instance.database!
        .insert(passagesTable, passage.toJson());
    final kept = passage.copy(id: id);
    _setPassages([..._passages, kept]);
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return kept;
  }

  Future<void> forget(KeptPassage passage) async {
    await AppDatabase.instance.database!.delete(passagesTable,
        where: '${PassageFields.id} = ?', whereArgs: [passage.id]);
    _setPassages([
      for (final kept in _passages)
        if (kept.id != passage.id) kept
    ]);
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }
}
