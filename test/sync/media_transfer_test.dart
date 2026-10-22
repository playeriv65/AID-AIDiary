// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:typed_data';

import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/media_transfer.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/sync_device.dart';

class _UnstableBackend extends MemorySyncBackend {
  int writes = 0;
  int mediaReads = 0;
  @override
  Future<Uint8List?> read(String path) {
    if (path.startsWith('media/')) mediaReads++;
    return super.read(path);
  }

  int? stopAfter;
  @override
  Future<String?> write(String path, Uint8List bytes) {
    if (path.startsWith('media/chunks/')) {
      if (stopAfter != null && writes >= stopAfter!) {
        throw StateError('network changed');
      }
      writes++;
    }
    return super.write(path, bytes);
  }
}

void main() {
  late Device phone;
  late Device laptop;
  late _UnstableBackend cloud;
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });
  setUp(() async {
    phone = await Device.create();
    laptop = await Device.create();
    cloud = _UnstableBackend();
  });
  tearDown(() async {
    await phone.db.close();
    await laptop.db.close();
  });

  Future<void> attach(Device device, String name, List<int> bytes) async {
    final entry = await device.write(name);
    await device.photos.write(name, Uint8List.fromList(bytes));
    await device.db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: name,
      EntryImageFields.imgRank: 0,
    });
  }

  Future<SyncReport> sync(Device device,
          {MediaAllowance Function()? route,
          ItemCipher? cipher,
          int chunkBytes = 4}) =>
      SyncEngine(
              db: device.db,
              backend: cloud,
              photos: FileStorePhotos(device.photos),
              limits: testLimits,
              mediaChunkBytes: chunkBytes,
              mediaAllowance: route,
              cipher: cipher)
          .sync();

  test('a limited route syncs text while a large attachment waits', () async {
    await attach(phone, 'video.mp4', List.generate(12, (i) => i));
    final allowance = MediaAllowance(
        backend: cloud, route: 'cache', maxFileBytes: 8, remainingBytes: 10000);
    final report = await sync(phone, route: () => allowance);
    expect(report.sent, 1);
    expect(report.pendingMedia, 1);
    expect(cloud.writes, 0);
    final received = await sync(laptop);
    expect(received.received, 1);
    expect(received.pendingMedia, 1);
    expect(await laptop.texts(), ['video.mp4']);
    expect(await laptop.photos.read('video.mp4'), isNull);
  });

  test('an interrupted upload reuses persisted ciphertext blocks on restart',
      () async {
    await attach(phone, 'photo.jpg', List.generate(12, (i) => i));
    final cipher = ItemCipher(Uint8List(32));
    cloud.stopAfter = 2;
    final first = await sync(phone, cipher: cipher);
    expect(first.sent, 1);
    expect(first.mediaFailures, 1);
    final saved = Map.of(cloud.files);
    expect(cloud.writes, 2);
    cloud.stopAfter = null;
    // A fresh engine reconstructs the task solely from the database.
    final second = await sync(phone, cipher: cipher);
    expect(second.pendingMedia, 0);
    expect(cloud.writes, 3);
    for (final path in saved.keys.where((p) => p.startsWith('media/chunks/'))) {
      expect(cloud.files[path]!.$1, saved[path]!.$1);
    }
    final downloaded = await sync(laptop, cipher: cipher);
    expect(downloaded.pendingMedia, 0);
    expect(await laptop.photos.read('photo.jpg'), List.generate(12, (i) => i));
  });

  test('daily budget is shared by files and small work is not starved',
      () async {
    await attach(phone, 'large.mp4', List.filled(12, 1));
    await attach(phone, 'small.jpg', [9]);
    final allowance = MediaAllowance(
        backend: cloud, route: 'cache', maxFileBytes: 5, remainingBytes: 1000);
    final report = await sync(phone, route: () => allowance);
    expect(report.pendingMedia, 1);
    expect(report.mediaCompleted, 1);
    expect(allowance.remainingBytes, lessThan(1000));
    expect(await laptop.sync(cloud).then((r) => r.received), 2);
  });

  test('a budget pause resumes without another metadata change', () async {
    await attach(phone, 'photo.jpg', List.generate(12, (i) => i));
    final first = MediaAllowance(
        backend: cloud, route: 'cache', maxFileBytes: 100, remainingBytes: 4);
    expect((await sync(phone, route: () => first)).pendingMedia, 1);
    expect(cloud.writes, 1);
    final second = MediaAllowance(
        backend: cloud, route: 'lan', maxFileBytes: 100, remainingBytes: 1000);
    final report = await sync(phone, route: () => second);
    expect(report.sent, 0);
    expect(report.pendingMedia, 0);
    expect(cloud.writes, 3);
  });

  test('corrupted media never replaces the local attachment', () async {
    await attach(phone, 'photo.jpg', [1, 2, 3]);
    await sync(phone);
    final path =
        cloud.files.keys.firstWhere((p) => p.startsWith('media/chunks/'));
    cloud.files[path] = (Uint8List.fromList([9, 9, 9]), 'corrupt');
    final report = await sync(laptop);
    expect(report.received, 1);
    expect(report.mediaFailures, 1);
    expect(report.pendingMedia, 1);
    expect(await laptop.photos.read('photo.jpg'), isNull);
    expect(await laptop.texts(), ['photo.jpg']);
  });

  test('blocks already delivered by a peer assemble with no active route',
      () async {
    await attach(phone, 'photo.jpg', [1, 2, 3, 4, 5, 6]);
    await sync(phone);
    final vault = MediaVault(laptop.db);
    for (final row in await phone.db.query('sync_media_objects')) {
      await vault.write(row['path'] as String, row['bytes'] as Uint8List);
    }
    final budget = MediaAllowance(
        backend: cloud, route: 'cache', maxFileBytes: 0, remainingBytes: 0);
    final report = await sync(laptop, route: () => budget);
    expect(report.pendingMedia, 0);
    expect(await laptop.photos.read('photo.jpg'), [1, 2, 3, 4, 5, 6]);
    expect(cloud.mediaReads, 0);
  });

  test('zero cloud budget makes no media request', () async {
    await attach(phone, 'photo.jpg', [1, 2, 3]);
    await sync(phone);
    final budget = MediaAllowance(
        backend: cloud, route: 'cache', maxFileBytes: 100, remainingBytes: 0);
    final report = await sync(laptop, route: () => budget);
    expect(report.received, 1);
    expect(report.pendingMedia, 1);
    expect(cloud.mediaReads, 0);
  });

  test('a resumed download reuses verified blocks despite remote eviction',
      () async {
    final original = List.generate(12, (i) => i);
    await attach(phone, 'photo.jpg', original);
    await sync(phone);
    final manifest = cloud.files.entries
        .firstWhere((e) => e.key.startsWith('media/manifests/'));
    final budget = MediaAllowance(
        backend: cloud,
        route: 'cache',
        maxFileBytes: 100,
        remainingBytes: 256 * 1024);
    // Reserve room for the bounded manifest read, then exactly one block.
    budget.remainingBytes = 256 * 1024;
    final report = await sync(laptop, route: () {
      if (cloud.mediaReads > 0 && budget.remainingBytes > 4) {
        budget.remainingBytes = 4;
      }
      return budget;
    });
    expect(report.pendingMedia, 1);
    expect(manifest.value.$1, isNotEmpty);
    final first =
        cloud.files.keys.firstWhere((p) => p.startsWith('media/chunks/'));
    cloud.files.remove(first);
    final resumed = await sync(laptop);
    expect(resumed.pendingMedia, 0);
    expect(await laptop.photos.read('photo.jpg'), original);
  });

  test('an operator object limit defers oversized blocks without an error',
      () async {
    await attach(phone, 'photo.jpg', [1, 2, 3, 4]);
    final budget = MediaAllowance(
        backend: cloud,
        route: 'cache',
        maxFileBytes: 100,
        maxObjectBytes: 3,
        remainingBytes: 1000);
    final report = await sync(phone, route: () => budget);
    expect(report.sent, 1);
    expect(report.pendingMedia, 1);
    expect(report.mediaFailures, 0);
    expect(cloud.writes, 0);
  });

  test('cache eviction leaves diary metadata available and media pending',
      () async {
    await attach(phone, 'photo.jpg', [1, 2, 3]);
    await sync(phone);
    cloud.files.removeWhere((path, _) => path.startsWith('media/chunks/'));
    final report = await sync(laptop);
    expect(report.received, 1);
    expect(report.pendingMedia, 1);
    expect(report.waitingForPeer, isTrue);
    expect(report.mediaFailures, 0);
  });
}
