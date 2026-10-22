@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/copy_status.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../support/sync_device.dart';

void main() {
  late Device a, b;
  late MemorySyncBackend backend;
  final key = Uint8List.fromList(List.generate(32, (i) => i));
  CopyStatusStore store(Device device, {String space = 'space'}) =>
      CopyStatusStore(
          db: device.db,
          photos: FileStorePhotos(device.photos),
          cipher: ItemCipher(key),
          spaceId: space);
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });
  setUp(() async {
    a = await Device.create();
    b = await Device.create();
    backend = MemorySyncBackend();
  });
  tearDown(() async {
    await a.db.close();
    await b.db.close();
  });

  test('converged diaries share a revision; missing originals stay partial',
      () async {
    final entry = await a.write('A diary with a photo');
    await a.db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: 'photo.jpg',
      EntryImageFields.imgRank: 0,
      EntryImageFields.timeCreate: '2026-10-22T12:00:00.000'
    });
    await a.photos.write('photo.jpg', Uint8List.fromList([1, 2, 3]));
    await a.sync(backend, cipher: ItemCipher(key));
    await b.sync(backend, cipher: ItemCipher(key));
    final source = await store(a).local('a', 'My phone');
    final receiver = await store(b).local('b', 'My tablet');
    expect(receiver.revision, source.revision);
    expect(receiver.complete, isTrue);
    await b.photos.delete('photo.jpg');
    final missing = await store(b).local('b', 'My tablet');
    expect(missing.revision, source.revision);
    expect(missing.present, 0);
    expect(missing.total, 1);
    expect(missing.complete, isFalse);
    await b.write('A new unsynced entry');
    expect((await store(b).local('b', 'My tablet')).revision,
        isNot(source.revision));
  });

  test('names are encrypted and receipts bind both path and space', () async {
    final copy = await store(a).local('a', 'Private tablet name');
    await store(a).publish(backend, copy);
    final sealed = (await backend.read('copies/a'))!;
    expect(
        utf8.decode(sealed, allowMalformed: true), isNot(contains(copy.name)));
    expect((await store(b).read(backend)).single.name, copy.name);
    expect(await store(b, space: 'other-space').read(backend), isEmpty);
    await backend.write('copies/b', sealed);
    expect((await store(b).read(backend)).map((r) => r.id), ['a']);
    await backend.write(
        'copies/a', Uint8List.fromList([...sealed]..[sealed.length - 1] ^= 1));
    expect(await store(b).read(backend), isEmpty);
  });

  test(
      'a newer partial confirmation overrides an old complete copy on another route',
      () async {
    final old = MemorySyncBackend(), fresh = MemorySyncBackend();
    final initial = await store(a).local('a', 'Old name');
    await store(a).publish(
        old,
        DeviceCopy(
            id: initial.id,
            name: initial.name,
            revision: initial.revision,
            total: 2,
            present: 2,
            checkedAt: DateTime.now().subtract(const Duration(days: 1))));
    await store(a).publish(
        fresh,
        DeviceCopy(
            id: initial.id,
            name: 'My tablet',
            revision: initial.revision,
            total: 2,
            present: 1,
            checkedAt: DateTime.now()));
    final copies = await store(b).readLatest([fresh, old]);
    expect(copies.single.name, 'My tablet');
    expect(copies.single.complete, isFalse);
  });
}
