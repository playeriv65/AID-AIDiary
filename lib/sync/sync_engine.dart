// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_records.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/sync/sync_photos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

export 'sync_photos.dart';

/// What one sync did.
class SyncReport {
  const SyncReport(
      {this.received = 0,
      this.sent = 0,
      this.keptConflicts = 0,
      this.pendingMedia = 0,
      this.mediaCompleted = 0,
      this.mediaFailures = 0,
      this.waitingForPeer = false});
  final int pendingMedia;
  final int mediaCompleted;
  final int mediaFailures;
  final bool waitingForPeer;

  /// Remote items written into the diary.
  final int received;

  /// Local items sent to the space.
  final int sent;

  /// Local entries that lost to a newer remote version and were kept in
  /// Recently deleted.
  final int keptConflicts;

  /// Whether the diary on this device changed.
  bool get changedLocally =>
      received > 0 || keptConflicts > 0 || mediaCompleted > 0;
}

/// How far a sync is: [done] of [total] files received, or sent.
typedef SyncProgress = ({bool sending, int done, int total});

/// How a sync batches its work.
class SyncLimits {
  const SyncLimits(
      {required this.packBytes,
      required this.compactAfter,
      required this.parallel});

  /// A pack holds changes up to about this many bytes of JSON before it is
  /// compressed; more changes go into further packs.
  final int packBytes;

  /// Packs in a space beyond which a device folds them into a snapshot.
  final int compactAfter;

  /// Files moved at the same time.
  final int parallel;
}

/// Brings a diary and a space up to date with each other.
///
/// A sync reads the packs and snapshots it has not read yet, takes in what
/// is newer than what the diary has, and sends its own changes as one new
/// pack. Items are compared by the time they last changed: the newer side
/// wins, whatever order packs arrive in, and a local entry that loses is kept
/// in Recently deleted rather than dropped. Attachment rows travel with the
/// diary; their independently encrypted blocks follow through a persistent
/// queue according to the current route and its transfer allowance.
class SyncEngine {
  SyncEngine(
      {required this.db,
      required this.backend,
      required this.photos,
      required this.limits,
      this.cipher,
      this.mediaAllowance,
      this.mediaFallback,
      this.onMediaFailure,
      this.onMetadata,
      this.mediaChunkBytes = 1024 * 1024,
      this.receiveOnly = false,
      this.onProgress,
      this.stopped,
      DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final Database db;
  final SyncBackend backend;

  /// Where photo files live on this device.
  final SyncPhotos photos;

  final SyncLimits limits;

  /// Null for a space that is not end-to-end encrypted.
  final ItemCipher? cipher;
  final MediaAllowance Function()? mediaAllowance;
  final MediaAllowance? mediaFallback;
  final void Function(Object error)? onMediaFailure;
  final Future<void> Function()? onMetadata;
  final int mediaChunkBytes;

  /// Nearby migration consumes an immutable snapshot without publishing edits.
  final bool receiveOnly;
  late final _media = MediaTransfers(
      db: db,
      photos: photos,
      backend: backend,
      chunkBytes: mediaChunkBytes,
      cipher: cipher,
      allowance: mediaAllowance,
      fallbackAllowance: mediaFallback,
      stopped: stopped,
      onFailure: onMediaFailure);

  /// Told before each file, so a long sync can show how far it is.
  final void Function(SyncProgress progress)? onProgress;

  /// Asked between files; when it says so, the sync ends early with what is
  /// done so far, and the rest follows next time.
  final bool Function()? stopped;
  bool get _stopped => stopped?.call() ?? false;

  final DateTime Function() _now;

  Future<SyncReport> sync() async {
    final received = await _receive();
    // Sending over changes not yet taken in could put an older edit over a
    // newer one; that waits for a sync that reads everything.
    if (received == null) return const SyncReport();
    final sent = receiveOnly ? 0 : await _push();
    if (received.applied > 0 || received.kept > 0) await onMetadata?.call();
    if (!_stopped && !receiveOnly) await _compact();
    final media = await _media.run();
    return SyncReport(
        received: received.applied,
        sent: sent,
        keptConflicts: received.kept,
        pendingMedia: media.pending,
        mediaCompleted: media.completed,
        mediaFailures: media.failures,
        waitingForPeer: media.waitingForPeer);
  }

  /// Takes in the packs and snapshots not read yet; null when it could not
  /// read or apply all of them.
  Future<({int applied, int kept})?> _receive() async {
    final seen = await _seen();
    final unread = [
      for (final path in (await backend.list(SpaceLayout.packs)).keys)
        if (!seen.contains(path)) path,
    ];
    // Snapshots first, newest first: the packs they cover need no reading.
    final snapshots = unread.where(SpaceLayout.isSnapshot).toList()
      ..sort((a, b) => b.compareTo(a));
    final packs = unread.where((path) => !SpaceLayout.isSnapshot(path)).toList()
      ..sort();

    final incoming = <String, SyncRecord>{};
    final covered = <String>{};
    final read = <String>[];
    var done = 0;
    void take(String path, _Pack pack) {
      covered.addAll(pack.covers);
      for (final record in pack.records) {
        final key = _key(record.kind, record.id);
        final known = incoming[key];
        if (known == null || _newer(record, known)) incoming[key] = record;
      }
      read.add(path);
    }

    for (final path in snapshots) {
      if (_stopped) return null;
      onProgress?.call((sending: false, done: done++, total: unread.length));
      if (covered.contains(path)) {
        read.add(path);
        continue;
      }
      final pack = await _readPack(path);
      if (pack != null) take(path, pack);
    }
    read.addAll(packs.where(covered.contains));
    await _parallel(packs.where((path) => !covered.contains(path)),
        (path) async {
      if (_stopped) return;
      onProgress?.call((sending: false, done: done++, total: unread.length));
      final pack = await _readPack(path);
      if (pack != null) take(path, pack);
    });
    if (_stopped) return null;

    // The newer side wins; a local entry that loses is kept.
    final known = {
      for (final row in await db.query(syncItemsTable))
        _key(SyncKind.byName(row['kind'] as String),
            row[syncIdColumn] as String): row['modified'] as int,
    };
    final pending = await _pending();
    final toApply = <SyncRecord>[];
    for (final record in incoming.values) {
      final key = _key(record.kind, record.id);
      if (record.modified <= (known[key] ?? -1)) continue;
      final local = pending[key];
      if (local != null && local.changedAt > record.modified) continue;
      toApply.add(record);
    }

    // Attachment rows describe the diary even while their bytes are absent.
    // Their transfer queue survives receiving packs and changing connections.
    final photoFiles = <String, String>{};
    final names = <String>{};
    final fetches = <({String id, String name})>[];
    for (final record in toApply) {
      for (final photo in record.photos) {
        if (photoFiles.containsKey(photo.id) ||
            await _hasPhoto(photo.id) ||
            fetches.any((fetch) => fetch.id == photo.id)) {
          continue;
        }
        final taken =
            names.contains(photo.file) || await photos.exists(photo.file);
        final name = localNameFor(photo.id, photo.file, taken);
        names.add(name);
        fetches.add((
          id: photo.id,
          name: name,
        ));
      }
    }
    for (final fetch in fetches) {
      photoFiles[fetch.id] = fetch.name;
    }
    final ready = toApply..sort((a, b) => a.kind.index.compareTo(b.kind.index));

    final losers = <SyncRecord>[];
    for (final record in ready) {
      final local = pending[_key(record.kind, record.id)];
      if (local == null || record.kind != SyncKind.entry) continue;
      final mine =
          await exportRecord(db, local.kind, record.id, local.changedAt);
      if (!mine.deleted && !_sameEntry(mine, record)) losers.add(mine);
    }
    for (final loser in losers) {
      await db.transaction((txn) => keepLosingEntry(
          txn, loser, const Uuid().v4().replaceAll('-', ''), _now()));
    }
    final unused = await withoutRecording(db, (txn) async {
      final writer = RecordWriter(txn, fileOf: (id) => photoFiles[id]!);
      for (final fetch in fetches) {
        await _media.queue(fetch.id, fetch.name,
            sending: false, transaction: txn);
      }
      for (final record in ready) {
        await writer.apply(record);
        await _know(txn, record);
        if (pending[_key(record.kind, record.id)] case final local?) {
          await _clearChange(txn, local);
        }
      }
      for (final path in read) {
        await _see(txn, path);
      }
      return writer.unusedFiles();
    });
    for (final file in unused) {
      await photos.delete(file);
    }
    return (applied: ready.length, kept: losers.length);
  }

  /// Publishes diary changes before any potentially expensive media transfer.
  Future<int> _push() async {
    final pending = (await _pending()).values.toList();
    if (pending.isEmpty || _stopped) return 0;
    final changes = <_Change>[
      for (final local in pending)
        (
          local: local,
          record: await exportRecord(db, local.kind, local.id, local.changedAt)
        ),
    ];
    for (final change in changes) {
      for (final photo in change.record.photos) {
        await _media.queue(photo.id, photo.file, sending: true);
      }
    }
    final packs = _chunks(changes);
    final total = packs.length;
    var done = 0;

    var sent = 0;
    for (final pack in packs) {
      if (_stopped) break;
      onProgress?.call((sending: true, done: done++, total: total));
      final path = SpaceLayout.pack(_newName(SpaceLayout.packPrefix));
      await backend.write(
          path,
          await _sealPack(
              path, [for (final change in pack) change.record], const []));
      await db.transaction((txn) async {
        for (final change in pack) {
          await _know(txn, change.record);
          await _clearChange(txn, change.local);
        }
        await _see(txn, path);
      });
      sent += pack.length;
    }
    return sent;
  }

  /// Splits [changes] into packs of about [SyncLimits.packBytes] each.
  List<List<_Change>> _chunks(List<_Change> changes) {
    final packs = <List<_Change>>[];
    var size = limits.packBytes;
    for (final change in changes) {
      final bytes = jsonEncode(change.record.toJson()).length;
      if (size + bytes > limits.packBytes && size > 0) {
        packs.add([]);
        size = 0;
      }
      packs.last.add(change);
      size += bytes;
    }
    return packs;
  }

  /// Folds the packs this device has read into one snapshot, once there
  /// are more than [SyncLimits.compactAfter], and removes them. Packs it has
  /// not read yet stay for the next device.
  Future<void> _compact() async {
    final listed = (await backend.list(SpaceLayout.packs)).keys;
    if (listed.where((path) => !SpaceLayout.isSnapshot(path)).length <=
        limits.compactAfter) {
      return;
    }
    // Every item's version must be in a pack before it can be folded.
    if ((await _pending()).isNotEmpty) return;
    final seen = await _seen();
    final covers = [
      for (final path in listed)
        if (seen.contains(path)) path,
    ];
    final items = [
      for (final row in await db.query(syncItemsTable))
        await exportRecord(db, SyncKind.byName(row['kind'] as String),
            row[syncIdColumn] as String, row['modified'] as int),
    ];
    final path = SpaceLayout.pack(_newName(SpaceLayout.snapshotPrefix));
    await backend.write(path, await _sealPack(path, items, covers));
    await db.transaction((txn) => _see(txn, path));
    await _parallel(covers, (old) async {
      await backend.delete(old);
      await db.delete(syncSeenTable, where: 'path = ?', whereArgs: [old]);
    });
  }

  /// Runs [task] on each of [items], [SyncLimits.parallel] at a time.
  Future<void> _parallel<T>(
      Iterable<T> items, Future<void> Function(T item) task) async {
    final queue = items.iterator;
    Future<void> worker() async {
      while (queue.moveNext()) {
        final item = queue.current;
        await task(item);
      }
    }

    await Future.wait([for (var i = 0; i < limits.parallel; i++) worker()]);
  }

  static String _key(SyncKind kind, String id) => '${kind.name}/$id';

  /// Whether [a] wins over [b], a version of the same item: the later
  /// change, and on a tie the same pick on every device.
  static bool _newer(SyncRecord a, SyncRecord b) => a.modified != b.modified
      ? a.modified > b.modified
      : jsonEncode(a.toJson()).compareTo(jsonEncode(b.toJson())) > 0;

  static final Random _random = Random.secure();

  /// A file name that sorts by time and never meets another device's.
  String _newName(String prefix) =>
      '$prefix${_now().millisecondsSinceEpoch.toString().padLeft(14, '0')}-'
      '${List.generate(4, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';

  Future<bool> _hasPhoto(String id) async => (await db.query(imagesTable,
          columns: ['id'],
          where: '$syncIdColumn = ?',
          whereArgs: [id],
          limit: 1))
      .isNotEmpty;

  Future<Set<String>> _seen() async => {
        for (final row in await db.query(syncSeenTable)) row['path'] as String,
      };

  Future<Map<String, _Pending>> _pending() async => {
        for (final row in await db.query(syncChangesTable))
          _key(SyncKind.byName(row['kind'] as String),
                  row[syncIdColumn] as String):
              _Pending(SyncKind.byName(row['kind'] as String),
                  row[syncIdColumn] as String, row['changed_at'] as int),
      };

  /// Forgets a change unless the item changed again meanwhile.
  Future<void> _clearChange(DatabaseExecutor txn, _Pending local) =>
      txn.delete(syncChangesTable,
          where: 'kind = ? AND $syncIdColumn = ? AND changed_at = ?',
          whereArgs: [local.kind.name, local.id, local.changedAt]);

  /// Keeps the newest version of an item this device has.
  Future<void> _know(DatabaseExecutor txn, SyncRecord record) => txn.rawInsert(
          'INSERT OR REPLACE INTO $syncItemsTable (kind, $syncIdColumn, modified) '
          'VALUES (?, ?, MAX(?, COALESCE((SELECT modified FROM $syncItemsTable '
          'WHERE kind = ? AND $syncIdColumn = ?), 0)))',
          [
            record.kind.name,
            record.id,
            record.modified,
            record.kind.name,
            record.id,
          ]);

  Future<void> _see(DatabaseExecutor txn, String path) =>
      txn.insert(syncSeenTable, {'path': path, 'version': ''},
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<Uint8List> _sealPack(
      String path, List<SyncRecord> records, List<String> covers) async {
    final json = jsonEncode({
      'records': [for (final record in records) record.toJson()],
      if (covers.isNotEmpty) 'covers': covers,
    });
    return _seal(path, gzip.encode(utf8.encode(json)));
  }

  Future<_Pack?> _readPack(String path) async {
    final bytes = await backend.read(path);
    if (bytes == null) return null;
    final json = jsonDecode(utf8.decode(gzip.decode(await _open(path, bytes))))
        as Map<String, Object?>;
    return _Pack(
      [
        for (final record in json['records'] as List)
          SyncRecord.fromJson((record as Map).cast<String, Object?>()),
      ],
      (json['covers'] as List? ?? const []).cast<String>(),
    );
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

typedef _Change = ({_Pending local, SyncRecord record});

class _Pack {
  const _Pack(this.records, this.covers);

  final List<SyncRecord> records;

  /// For a snapshot, the packs and snapshots it replaces.
  final List<String> covers;
}
