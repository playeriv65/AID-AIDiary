import 'dart:convert';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_object_paths.dart';
import 'package:aid_diary/sync/sync_photos.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

/// Last-confirmed device inventories, encrypted with the space's data key.
/// Matching revisions are necessary before another device is called complete.
class DeviceCopy {
  const DeviceCopy(
      {required this.id,
      required this.name,
      required this.revision,
      required this.total,
      required this.present,
      required this.checkedAt});
  final String id, name, revision;
  final int total, present;
  final DateTime checkedAt;
  bool get complete => total == present;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'revision': revision,
        'total': total,
        'present': present,
        'checkedAt': checkedAt.toUtc().toIso8601String(),
      };

  static DeviceCopy? parse(Object? value, String id) {
    if (value is! Map ||
        value['id'] != id ||
        value['name'] is! String ||
        !LocalDevice.validName(value['name'] as String) ||
        value['revision'] is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(value['revision'] as String) ||
        value['total'] is! int ||
        value['present'] is! int) {
      return null;
    }
    final total = value['total'] as int, present = value['present'] as int;
    final at = value['checkedAt'];
    final date = at is String && at.length <= 40 ? DateTime.tryParse(at) : null;
    if (total < 0 ||
        present < 0 ||
        present > total ||
        date == null ||
        date.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return null;
    }
    return DeviceCopy(
        id: id,
        name: value['name'] as String,
        revision: value['revision'] as String,
        total: total,
        present: present,
        checkedAt: date);
  }
}

class CopyStatusStore {
  CopyStatusStore(
      {required this.db,
      required this.photos,
      required this.cipher,
      required this.spaceId});
  final Database db;
  final SyncPhotos photos;
  final ItemCipher cipher;
  final String spaceId;

  Future<DeviceCopy> local(String id, String name) async {
    final (versions, changes, attachments) =
        await db.transaction((txn) async => (
              await txn.query('sync_items', orderBy: 'kind, uuid'),
              await txn.query('sync_changes', orderBy: 'kind, uuid'),
              await txn.query(imagesTable,
                  columns: ['uuid', EntryImageFields.imgPath], orderBy: 'uuid'),
            ));
    final revision = sha256
        .convert(utf8.encode(jsonEncode([
          versions,
          changes,
          attachments.map((row) => row['uuid']).toList(),
        ])))
        .toString();
    var present = 0;
    for (final row in attachments) {
      if (await photos.exists(row[EntryImageFields.imgPath] as String)) {
        present++;
      }
    }
    return DeviceCopy(
        id: id,
        name: name,
        revision: revision,
        total: attachments.length,
        present: present,
        checkedAt: DateTime.now());
  }

  Future<void> publish(SyncBackend backend, DeviceCopy copy) async {
    final path = 'copies/${copy.id}';
    if (!SyncObjectPaths.validFile(path)) {
      throw const FormatException('Invalid copy path');
    }
    await backend.write(
        path,
        await cipher.seal(
            '$spaceId/$path', utf8.encode(jsonEncode(copy.toJson()))));
  }

  Future<List<DeviceCopy>> read(SyncBackend backend) async {
    final deadline = DateTime.now().add(const Duration(seconds: 4));
    final paths =
        (await backend.list('copies').timeout(const Duration(seconds: 4)))
            .keys
            .where((path) => SyncObjectPaths.directChild('copies', path))
            .take(64)
            .toList();
    final result = <DeviceCopy>[];
    var next = 0;
    Future<void> worker() async {
      while (next < paths.length) {
        final remaining = deadline.difference(DateTime.now());
        if (remaining <= Duration.zero) return;
        final path = paths[next++];
        try {
          final bytes = await backend.read(path).timeout(remaining);
          if (bytes == null || bytes.length > 4096) continue;
          final value = jsonDecode(
              utf8.decode(await cipher.open('$spaceId/$path', bytes)));
          final copy = DeviceCopy.parse(value, path.substring(7));
          if (copy != null) result.add(copy);
        } catch (_) {
          // A missing, old or malformed receipt cannot prove a complete copy.
        }
      }
    }

    await Future.wait(List.generate(4, (_) => worker()));
    return result;
  }

  Future<List<DeviceCopy>> readLatest(Iterable<SyncBackend> sources) async {
    final reports = await Future.wait(sources.map((source) async {
      try {
        return await read(source);
      } catch (_) {
        return <DeviceCopy>[];
      }
    }));
    final latest = <String, DeviceCopy>{};
    for (final copy in reports.expand((report) => report)) {
      final previous = latest[copy.id];
      if (previous == null || copy.checkedAt.isAfter(previous.checkedAt)) {
        latest[copy.id] = copy;
      }
    }
    return latest.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}
