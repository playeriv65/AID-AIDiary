// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_records.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// The photo files on this device, as sync uses them.
abstract interface class SyncPhotos {
  Future<bool> exists(String name);

  /// Null when there is no such file.
  Future<Uint8List?> read(String name);

  /// Throws when the file could not be written.
  Future<void> write(String name, Uint8List bytes);

  Future<void> delete(String name);
}

/// Photos kept in a [FileStore].
class FileStorePhotos implements SyncPhotos {
  const FileStorePhotos(this.store);

  final FileStore store;

  @override
  Future<bool> exists(String name) => store.exists(name);

  @override
  Future<Uint8List?> read(String name) => store.read(name);

  @override
  Future<void> write(String name, Uint8List bytes) async {
    if (!await store.write(name, bytes)) {
      throw FileSystemException('Could not write the photo', name);
    }
  }

  @override
  Future<void> delete(String name) => store.delete(name);
}

/// What one sync did.
class SyncReport {
  const SyncReport({this.received = 0, this.sent = 0, this.keptConflicts = 0});

  /// Remote items written into the diary.
  final int received;

  /// Local items sent to the space.
  final int sent;

  /// Local entries that lost to a newer remote version and were kept in
  /// Recently deleted.
  final int keptConflicts;

  /// Whether the diary on this device changed.
  bool get changedLocally => received > 0 || keptConflicts > 0;
}

/// How far a sync is: [done] of [total] items received, or sent.
typedef SyncProgress = ({bool sending, int done, int total});

/// Brings a diary and a space up to date with each other.
///
/// Items are compared by the time they last changed: the newer side wins,
/// and a local entry that loses is kept in Recently deleted rather than
/// dropped. Photos travel as separate blobs, fetched before the items that
/// use them are written.
class SyncEngine {
  SyncEngine(
      {required this.db,
      required this.backend,
      required this.photos,
      this.cipher,
      this.onProgress,
      this.stopped,
      DateTime Function()? now})
      : _now = now ?? DateTime.now;

  /// Asked between items; when it says so, the sync ends early with what
  /// is done so far, and the rest follows next time.
  final bool Function()? stopped;
  bool get _stopped => stopped?.call() ?? false;

  final Database db;
  final SyncBackend backend;

  /// Told after each item, so a long first sync can show how far it is.
  final void Function(SyncProgress progress)? onProgress;

  /// Where photo files live on this device.
  final SyncPhotos photos;

  /// Null for a space that is not end-to-end encrypted.
  final ItemCipher? cipher;
  final DateTime Function() _now;

  Future<SyncReport> sync() async {
    final seen = {
      for (final row in await db.query(syncSeenTable))
        row['path'] as String: row['version'] as String,
    };
    final remote = await backend.list(SpaceLayout.items);
    final pending = await _pending();

    // What other devices changed since the last sync.
    final incoming = <SyncRecord>[];
    final versions = <String, String>{};
    final changed = [
      for (final MapEntry(key: path, value: version) in remote.entries)
        if (seen[path] != version) (path, version),
    ];
    for (final (index, (path, version)) in changed.indexed) {
      if (_stopped) break;
      onProgress?.call((sending: false, done: index, total: changed.length));
      final bytes = await backend.read(path);
      if (bytes == null) continue;
      incoming.add(await _decode(path.split('/').last, bytes));
      versions[path] = version;
    }

    // The newer side wins; a local entry that loses is kept.
    final toApply = <SyncRecord>[];
    final superseded = <_Pending>[];
    final losers = <SyncRecord>[];
    for (final record in incoming) {
      final local = pending[record.id];
      if (local == null) {
        toApply.add(record);
      } else if (record.modified >= local.changedAt) {
        toApply.add(record);
        superseded.add(local);
        if (record.kind == SyncKind.entry) {
          final mine =
              await exportRecord(db, local.kind, record.id, local.changedAt);
          if (!mine.deleted && !_sameEntry(mine, record)) losers.add(mine);
        }
      }
    }
    for (final loser in losers) {
      await db.transaction((txn) => keepLosingEntry(
          txn, loser, const Uuid().v4().replaceAll('-', ''), _now()));
    }

    // Photos first, so entries never point at missing files. An entry whose
    // photo is not in the space yet waits for the next sync.
    final photoFiles = <String, String>{};
    final ready = <SyncRecord>[];
    for (final record in toApply) {
      if (await _fetchPhotos(record, photoFiles)) {
        ready.add(record);
      } else {
        versions.remove(SpaceLayout.item(record.id));
      }
    }
    ready.sort((a, b) => a.kind.index.compareTo(b.kind.index));
    final unused = await withoutRecording(db, (txn) async {
      final writer = RecordWriter(txn, fileOf: (id) => photoFiles[id]!);
      for (final record in ready) {
        await writer.apply(record);
      }
      for (final local in superseded) {
        await _clearChange(txn, local);
      }
      for (final MapEntry(key: path, value: version) in versions.entries) {
        await _see(txn, path, version);
      }
      return writer.unusedFiles();
    });
    for (final file in unused) {
      await photos.delete(file);
    }

    // A sync stopped before it read every remote change sends nothing: a
    // local edit must not go over a newer one it has not seen.
    final sent = _stopped ? 0 : await _push();
    return SyncReport(
        received: ready.length, sent: sent, keptConflicts: losers.length);
  }

  /// Sends every local change, photos before the entries that use them.
  Future<int> _push() async {
    final pending = await _pending();
    if (pending.isEmpty) return 0;
    final blobs = await backend.list(SpaceLayout.blobs);
    final unknownVersion = <String>[];
    var sent = 0;
    for (final local in pending.values) {
      if (_stopped) break;
      onProgress?.call((sending: true, done: sent, total: pending.length));
      final record =
          await exportRecord(db, local.kind, local.id, local.changedAt);
      for (final photo in record.photos) {
        final path = SpaceLayout.blob(photo.id);
        if (blobs.containsKey(path)) continue;
        final bytes = await photos.read(photo.file);
        if (bytes == null) continue;
        await backend.write(path, await _seal(photo.id, bytes));
      }
      final path = SpaceLayout.item(local.id);
      final version = await backend.write(path,
          await _seal(local.id, utf8.encode(jsonEncode(record.toJson()))));
      await db.transaction((txn) async {
        if (version != null) {
          await _see(txn, path, version);
        } else {
          unknownVersion.add(path);
        }
        await _clearChange(txn, local);
      });
      sent++;
    }
    if (unknownVersion.isNotEmpty) {
      final listed = await backend.list(SpaceLayout.items);
      await db.transaction((txn) async {
        for (final path in unknownVersion) {
          if (listed[path] case final version?) await _see(txn, path, version);
        }
      });
    }
    return sent;
  }

  Future<bool> _fetchPhotos(
      SyncRecord record, Map<String, String> photoFiles) async {
    for (final photo in record.photos) {
      final known = await db.query(imagesTable,
          columns: ['id'],
          where: '$syncIdColumn = ?',
          whereArgs: [photo.id],
          limit: 1);
      if (known.isNotEmpty) continue;
      final sealed = await backend.read(SpaceLayout.blob(photo.id));
      if (sealed == null) return false;
      final name =
          localNameFor(photo.id, photo.file, await photos.exists(photo.file));
      await photos.write(name, await _open(photo.id, sealed));
      photoFiles[photo.id] = name;
    }
    return true;
  }

  Future<Map<String, _Pending>> _pending() async => {
        for (final row in await db.query(syncChangesTable))
          row[syncIdColumn] as String: _Pending(
              SyncKind.byName(row['kind'] as String),
              row[syncIdColumn] as String,
              row['changed_at'] as int),
      };

  /// Forgets a change unless the item changed again meanwhile.
  Future<void> _clearChange(DatabaseExecutor txn, _Pending local) =>
      txn.delete(syncChangesTable,
          where: 'kind = ? AND $syncIdColumn = ? AND changed_at = ?',
          whereArgs: [local.kind.name, local.id, local.changedAt]);

  Future<void> _see(DatabaseExecutor txn, String path, String version) =>
      txn.insert(syncSeenTable, {'path': path, 'version': version},
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<SyncRecord> _decode(String id, Uint8List bytes) async {
    final plain = await _open(id, bytes);
    final record = SyncRecord.fromJson(
        jsonDecode(utf8.decode(plain)) as Map<String, Object?>);
    if (record.id != id) {
      throw FormatException('Item $id holds the record of ${record.id}');
    }
    return record;
  }

  Future<Uint8List> _seal(String id, List<int> plain) async {
    final cipher = this.cipher;
    return cipher == null
        ? Uint8List.fromList(plain)
        : await cipher.seal(id, plain);
  }

  Future<Uint8List> _open(String id, Uint8List bytes) async {
    final cipher = this.cipher;
    return cipher == null ? bytes : await cipher.open(id, bytes);
  }

  /// Whether two versions of an entry say the same; photos count by id, as
  /// their file names differ from device to device.
  static bool _sameEntry(SyncRecord a, SyncRecord b) {
    String content(SyncRecord record) => jsonEncode(_sortedKeys({
          ...?record.data,
          'images': [for (final photo in record.photos) photo.id],
        }));
    return content(a) == content(b);
  }

  static Object? _sortedKeys(Object? value) => switch (value) {
        final Map map => {
            for (final key in map.keys.map((key) => '$key').toList()..sort())
              key: _sortedKeys(map[key]),
          },
        final List list => [for (final item in list) _sortedKeys(item)],
        _ => value,
      };
}

class _Pending {
  const _Pending(this.kind, this.id, this.changedAt);

  final SyncKind kind;
  final String id;
  final int changedAt;
}
