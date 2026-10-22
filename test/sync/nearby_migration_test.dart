// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/lan_transport.dart';
import 'package:aid_diary/sync/nearby_migration.dart';
import 'package:aid_diary/sync/nearby_adoption.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../support/sync_device.dart';

class _Discovery implements LanDiscovery {
  @override
  Stream<LanCandidate> get candidates => const Stream.empty();
  @override
  Future<void> start(LanAdvertisement local) async {}
  @override
  Future<void> close() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  setUpAll(sqfliteFfiInit);
  late Device oldDevice, newDevice;
  late Database staging;
  NearbyMigrationSource? source;
  late DiaryIdentity identity;
  setUp(() async {
    oldDevice = await Device.create();
    newDevice = await Device.create();
    identity = DiaryIdentity.create();
    staging = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(singleInstance: false));
  });
  tearDown(() async {
    await source?.close();
    source = null;
    await oldDevice.db.close();
    await newDevice.db.close();
    await staging.close();
  });
  Future<NearbyMigrationSource> prepare() async =>
      source = await NearbyMigrationSource.create(
          source: oldDevice.db,
          staging: staging,
          photos: FileStorePhotos(oldDevice.photos),
          identity: identity,
          deviceId: 'old-device',
          chunkBytes: 1024,
          packBytes: 4096,
          lifetime: const Duration(minutes: 1),
          bind: InternetAddress.loopbackIPv4,
          addresses: [InternetAddress.loopbackIPv4],
          discovery: _Discovery());

  test(
      'offline authenticated snapshot transfers metadata and multi-block media without changing source sync state',
      () async {
    final row = await oldDevice.write('offline diary');
    final bytes = Uint8List.fromList(List.generate(7000, (i) => i % 251));
    await oldDevice.photos.write('record.wav', bytes);
    await oldDevice.db.insert(imagesTable, {
      EntryImageFields.entryId: row,
      EntryImageFields.imgPath: 'record.wav',
      EntryImageFields.imgRank: 0
    });
    final changes = await oldDevice.db.query(syncChangesTable);
    final hosted = await prepare();
    // Media is encrypted only when requested, avoiding staging the full library
    // before the user can scan an invitation.
    expect(await staging.query('sync_media_tasks'), isEmpty);
    final report = await receiveNearbyMigration(
        db: newDevice.db,
        photos: FileStorePhotos(newDevice.photos),
        grant: hosted.grant,
        identity: identity);
    expect(report.received, greaterThan(0));
    expect(report.mediaCompleted, 1);
    expect(report.pendingMedia, 0);
    expect(report.mediaFailures, 0);
    expect(await newDevice.texts(), ['offline diary']);
    final received = (await newDevice.db.query(imagesTable)).single;
    expect(
        await newDevice.photos
            .read(received[EntryImageFields.imgPath] as String),
        bytes);
    expect(await oldDevice.db.query(syncChangesTable), changes);
    expect(await oldDevice.db.query('sync_media_objects'), isEmpty);
    final peer = await hosted.grant.connect(identity);
    await expectLater(
        peer.write('packs/pack-forged', Uint8List(1)), throwsA(anything));
    peer.close();
  });

  test(
      'interruption retains metadata and resumes attachments without duplicate rows',
      () async {
    final row = await oldDevice.write('resume');
    final bytes = Uint8List.fromList(List.generate(9000, (i) => i % 251));
    await oldDevice.photos.write('resume.wav', bytes);
    await oldDevice.db.insert(imagesTable, {
      EntryImageFields.entryId: row,
      EntryImageFields.imgPath: 'resume.wav',
      EntryImageFields.imgRank: 0
    });
    final hosted = await prepare();
    final peer = await hosted.grant.connect(identity);
    var stop = false;
    final first = await SyncEngine(
        db: newDevice.db,
        backend: peer,
        photos: FileStorePhotos(newDevice.photos),
        limits: testLimits,
        cipher: ItemCipher(hosted.grant.dataKey),
        receiveOnly: true,
        stopped: () => stop,
        onMetadata: () async {
          stop = true;
        }).sync();
    peer.close();
    expect(first.pendingMedia, 1);
    expect(await newDevice.texts(), ['resume']);
    final second = await receiveNearbyMigration(
        db: newDevice.db,
        photos: FileStorePhotos(newDevice.photos),
        grant: hosted.grant,
        identity: identity);
    expect(second.received, 0);
    expect(second.mediaCompleted, 1);
    expect(await newDevice.texts(), ['resume']);
    expect(await newDevice.photos.read('resume.wav'), bytes);
  });

  test(
      'source waits for a committed-identity receipt after persistence failure',
      () async {
    await oldDevice.write('commit before receipt');
    final hosted = await prepare();
    await receiveNearbyMigration(
        db: newDevice.db,
        photos: FileStorePhotos(newDevice.photos),
        grant: hosted.grant,
        identity: identity);
    expect(hosted.acknowledged, false);
    var localIdentity = 'original';
    await expectLater(
        nearbyAdoptionTransaction(
            db: newDevice.db,
            current: () => true,
            persist: (_) async {
              localIdentity = 'incoming';
              throw StateError('secure store failed');
            },
            restore: () async {
              localIdentity = 'original';
            }),
        throwsStateError);
    expect(localIdentity, 'original');
    expect(hosted.acknowledged, false);
    await nearbyAdoptionTransaction(
        db: newDevice.db,
        current: () => true,
        persist: (_) async {
          localIdentity = 'incoming';
        },
        restore: () async {
          localIdentity = 'original';
        });
    await acknowledgeNearbyMigration(hosted.grant, identity);
    expect(await hosted.finished, true);
    expect(localIdentity, 'incoming');
  });

  test('closing an uncompleted source explicitly reports failure', () async {
    final hosted = await prepare();
    await hosted.close();
    expect(await hosted.finished, false);
    await hosted.closed;
    expect(hosted.acknowledged, false);
  });

  test(
      'wrong identity cannot access the snapshot and cancelled source stops reads',
      () async {
    await oldDevice.write('private');
    final hosted = await prepare();
    await expectLater(
        hosted.grant.connect(DiaryIdentity.create()), throwsStateError);
    final peer = await hosted.grant.connect(identity);
    await hosted.close();
    await expectLater(peer.list('packs'), throwsA(anything));
    peer.close();
  });
}
