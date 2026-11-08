// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_photos.dart';
import 'package:aid_diary/sync/sync_records.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/local_time.dart';
import 'package:aid_diary/utils/sync_ids.dart';
import 'package:sqflite/sqflite.dart';

/// The device a sync runs on: its stable id (`LocalDevice.id`) and its name.
typedef SyncDevice = ({String id, String name});

/// An entry edited on two devices before either edit synced
/// (docs/ARCHITECTURE.md, "Conflicts"). The device that finds it keeps its
/// own version in the entry and holds it back from the space; every other
/// device keeps the space's version. The conflict, with both versions,
/// syncs like any item until the user picks on one device, which removes it
/// everywhere.
class StoredConflict {
  const StoredConflict(
      {required this.id,
      required this.entry,
      required this.heldBy,
      required this.held,
      required this.synced});

  factory StoredConflict.fromRow(Map<String, Object?> row) => StoredConflict(
      id: row[syncIdColumn] as String,
      entry: row['entry'] as String,
      heldBy: row['held_by'] as String,
      held: _record(row['held'] as String),
      synced: _record(row['synced'] as String));

  static SyncRecord _record(String json) =>
      SyncRecord.fromJson(jsonDecode(json) as Map<String, Object?>);

  /// The conflict's sync id ([conflictSyncId]).
  final String id;

  /// The entry's sync id.
  final String entry;

  /// The device id ([SyncDevice.id]) that found the conflict and holds its
  /// version back.
  final String heldBy;

  /// The version held back.
  final SyncRecord held;

  /// The version the space has.
  final SyncRecord synced;

  bool heldOn(SyncDevice? device) => heldBy == device?.id;

  /// The version this device's entry does not show.
  SyncRecord otherOn(SyncDevice? device) => heldOn(device) ? synced : held;
}

/// Which version of a conflicted entry stays.
enum ConflictKeep {
  /// The one this device's entry shows, written again as a new change.
  mine('this'),

  /// The other one, written into the entry as a new change.
  other('other'),

  /// Both: the entry gets the space's version and a second entry
  /// ([conflictBothSyncId]) the held-back one, whichever device picks.
  both('both');

  const ConflictKeep(this.arg);

  /// How actions name it.
  final String arg;

  static ConflictKeep parse(String arg) =>
      values.firstWhere((keep) => keep.arg == arg,
          orElse: () => throw FormatException('keep is this, other or both'));
}

/// One version as people see it.
class ConflictVersion {
  const ConflictVersion(
      {this.device,
      this.modified,
      required this.title,
      required this.snippet,
      this.opensAt});

  factory ConflictVersion.of(Map<String, Object?> data, String? device) {
    String? text(String field) => data[field] as String?;
    DateTime? time(String field) =>
        text(field) == null ? null : parseLocalTime(text(field)!);
    final opensAt = time(EntryFields.openAt);
    final sealed = opensAt != null && opensAt.isAfter(DateTime.now());
    return ConflictVersion(
        device: device,
        modified: time(EntryFields.timeModified),
        title: sealed ? '' : (text(EntryFields.title) ?? '').trim(),
        snippet: sealed ? '' : entrySnippet(text(EntryFields.text) ?? ''),
        opensAt: sealed ? opensAt : null);
  }

  /// The name of the device that made it, when known.
  final String? device;

  /// When it was last saved.
  final DateTime? modified;
  final String title;
  final String snippet;

  /// For a sealed time capsule, when it opens; its words stay hidden.
  final DateTime? opensAt;

  Map<String, Object?> toJson() => {
        if (device != null) 'device': device,
        if (modified != null) 'modified': modified!.toIso8601String(),
        if (opensAt != null)
          'sealedUntil': opensAt!.toIso8601String()
        else ...{
          if (title.isNotEmpty) 'title': title,
          'text': snippet,
        },
      };

  factory ConflictVersion.fromJson(Map<String, Object?> json) =>
      ConflictVersion(
          device: json['device'] as String?,
          modified: DateTime.tryParse(json['modified'] as String? ?? ''),
          title: json['title'] as String? ?? '',
          snippet: json['text'] as String? ?? '',
          opensAt: DateTime.tryParse(json['sealedUntil'] as String? ?? ''));
}

/// A conflict as this device shows it.
class SyncConflict {
  const SyncConflict(
      {required this.entry, required this.mine, required this.other});

  /// The entry's local id.
  final int entry;

  /// The version this device's entry shows.
  final ConflictVersion mine;
  final ConflictVersion other;

  Map<String, Object?> toJson() =>
      {'entry': entry, 'this': mine.toJson(), 'other': other.toJson()};

  /// What `sync.conflicts` returns, read back.
  factory SyncConflict.fromJson(Map<String, Object?> json) => SyncConflict(
      entry: json['entry'] as int,
      mine: ConflictVersion.fromJson(
          (json['this'] as Map).cast<String, Object?>()),
      other: ConflictVersion.fromJson(
          (json['other'] as Map).cast<String, Object?>()));
}

/// The conflicts this device holds, by entry sync id.
Future<Map<String, StoredConflict>> heldConflicts(
        DatabaseExecutor db, SyncDevice? device) async =>
    {
      for (final conflict in await storedConflicts(db))
        if (conflict.heldOn(device)) conflict.entry: conflict,
    };

Future<List<StoredConflict>> storedConflicts(DatabaseExecutor db) async => [
      for (final row in await db.query(syncConflictsTable, orderBy: 'id'))
        StoredConflict.fromRow(row),
    ];

/// Records a conflict between [mine], this device's edit not sent yet, and
/// [theirs], the space's newer version, or updates the one already held for
/// the entry. Runs while writes are not recorded, so it records its own.
Future<void> holdConflict(DatabaseExecutor db,
    {required SyncDevice device,
    required SyncRecord mine,
    required SyncRecord theirs,
    StoredConflict? held}) async {
  final id =
      held?.id ?? conflictSyncId(mine.id, mine.modified, theirs.modified);
  final values = {
    'entry': mine.id,
    'held_by': device.id,
    'held': jsonEncode(mine.toJson()),
    'synced': jsonEncode(theirs.toJson()),
  };
  if (await db.update(syncConflictsTable, values,
          where: '$syncIdColumn = ?', whereArgs: [id]) ==
      0) {
    await db.insert(syncConflictsTable, {...values, syncIdColumn: id});
  }
  await recordChange(db, SyncKind.conflict, id);
}

/// Removes [conflict], also on other devices, while writes are not recorded.
Future<void> dropConflict(DatabaseExecutor db, StoredConflict conflict) async {
  await db.delete(syncConflictsTable,
      where: '$syncIdColumn = ?', whereArgs: [conflict.id]);
  await recordChange(db, SyncKind.conflict, conflict.id);
}

/// The conflicts of entries this device has, oldest first.
Future<List<SyncConflict>> listConflicts(
    DatabaseExecutor db, SyncDevice device) async {
  final conflicts = <SyncConflict>[];
  for (final conflict in await storedConflicts(db)) {
    final local = (await db.query(entriesTable,
            where: '$syncIdColumn = ?', whereArgs: [conflict.entry]))
        .firstOrNull;
    if (local == null) continue;
    final other = conflict.otherOn(device);
    conflicts.add(SyncConflict(
        entry: local['id'] as int,
        mine: ConflictVersion.of(
            local,
            conflict.heldOn(device)
                ? conflict.held.device ?? device.name
                : conflict.synced.device),
        other: ConflictVersion.of(other.data!, other.device)));
  }
  return conflicts;
}

/// Keeps [keep] of the oldest conflict of the entry with local id [entry],
/// as new changes the next sync sends, and removes the conflict. Attachments
/// of the version kept that this device lacks are fetched by the next sync.
Future<void> resolveEntryConflict(Database db,
    {required SyncPhotos photos,
    required SyncDevice device,
    required int entry,
    required ConflictKeep keep}) async {
  final unused = await db.transaction((txn) async {
    final rows = await txn.query(entriesTable,
        columns: [syncIdColumn], where: 'id = ?', whereArgs: [entry]);
    final entryId = rows.firstOrNull?[syncIdColumn] as String?;
    final conflict = [
      for (final conflict in await storedConflicts(txn))
        if (conflict.entry == entryId) conflict,
    ].firstOrNull;
    if (entryId == null || conflict == null) {
      throw StateError('Entry $entry has no conflict');
    }
    final holder = conflict.heldOn(device);
    final names = <String, String>{};
    final writer = RecordWriter(txn, fileOf: (id) => names[id]!);
    Future<void> write(String id, Map<String, Object?> data) async {
      final record = SyncRecord(SyncKind.entry, id, 0, data);
      for (final photo in record.photos) {
        if (names.containsKey(photo.id) || await _hasPhoto(txn, photo.id)) {
          continue;
        }
        final taken =
            names.containsValue(photo.file) || await photos.exists(photo.file);
        final name = localNameFor(photo.id, photo.file, taken);
        names[photo.id] = name;
        await queueMedia(txn, photo.id, name, sending: false);
      }
      await writer.apply(record);
    }

    switch (keep) {
      case ConflictKeep.mine:
        break;
      case ConflictKeep.other:
        await write(entryId, conflict.otherOn(device).data!);
      case ConflictKeep.both:
        // The held-back version moves to the second entry first, so its
        // attachments go with it.
        await write(
            conflictBothSyncId(entryId, conflict.held.modified),
            holder
                ? (await exportRecord(txn, SyncKind.entry, entryId, 0)).data!
                : conflict.held.data!);
        if (holder) await write(entryId, conflict.synced.data!);
    }
    await txn.delete(syncConflictsTable,
        where: '$syncIdColumn = ?', whereArgs: [conflict.id]);
    // The version kept must be newer than either side to win everywhere.
    final known = (await txn.query(syncItemsTable,
            columns: ['modified'],
            where: 'kind = ? AND $syncIdColumn = ?',
            whereArgs: [SyncKind.entry.name, entryId]))
        .firstOrNull?['modified'] as int?;
    final stamp = [
      DateTime.now().millisecondsSinceEpoch,
      (known ?? 0) + 1,
      conflict.held.modified + 1,
      conflict.synced.modified + 1,
    ].reduce((a, b) => a > b ? a : b);
    await txn.insert(
        syncChangesTable,
        {
          'kind': SyncKind.entry.name,
          syncIdColumn: entryId,
          'changed_at': stamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    return writer.unusedFiles();
  });
  for (final file in unused) {
    await photos.delete(file);
  }
}

Future<bool> _hasPhoto(DatabaseExecutor db, String id) async =>
    (await db.query(imagesTable,
            columns: ['id'],
            where: '$syncIdColumn = ?',
            whereArgs: [id],
            limit: 1))
        .isNotEmpty;
