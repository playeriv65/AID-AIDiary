// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_engine.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/sync_device.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late MemorySyncBackend cloud;
  late Device phone;
  late Device laptop;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  });

  setUp(() async {
    cloud = MemorySyncBackend();
    phone = await Device.create();
    laptop = await Device.create();
  });

  tearDown(() async {
    await phone.db.close();
    await laptop.db.close();
  });

  Future<void> later() => Future.delayed(const Duration(milliseconds: 5));

  test('an entry written on one device reaches the other', () async {
    await phone.write('rainy walk');

    expect((await phone.sync(cloud)).sent, 1);
    final report = await laptop.sync(cloud);

    expect(report.received, 1);
    expect(await laptop.texts(), ['rainy walk']);
    // Nothing left to do on either side.
    expect((await phone.sync(cloud)).received, 0);
    expect((await laptop.sync(cloud)).sent, 0);
  });

  test('a hidden entry arrives hidden, and showing it again travels too',
      () async {
    await phone.write('private walk');
    await phone.db.update(entriesTable, {EntryFields.isHidden: 1});
    await phone.sync(cloud);
    await laptop.sync(cloud);

    Future<Object?> hidden(Device device) async =>
        (await device.db.query(entriesTable)).single[EntryFields.isHidden];
    expect(await laptop.texts(), ['private walk']);
    expect(await hidden(laptop), 1);

    await later();
    await laptop.db.update(entriesTable, {EntryFields.isHidden: 0});
    await laptop.sync(cloud);
    await phone.sync(cloud);
    expect(await hidden(phone), 0);
  });

  test('edits and deletions travel both ways', () async {
    await phone.write('draft');
    await phone.sync(cloud);
    await laptop.sync(cloud);

    await laptop.edit('draft', 'final');
    await laptop.sync(cloud);
    await phone.sync(cloud);
    expect(await phone.texts(), ['final']);

    await phone.db.delete(entriesTable);
    await phone.sync(cloud);
    await laptop.sync(cloud);
    expect(await laptop.texts(), isEmpty);
  });

  test('photos travel with their entry and leave with it', () async {
    final entry = await phone.write('beach');
    await phone.photos.write('aid_diary_1.jpg', Uint8List.fromList([1, 2, 3]));
    await phone.db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: 'aid_diary_1.jpg',
      EntryImageFields.imgRank: 0,
    });
    // The laptop already has another photo by that name.
    await laptop.photos.write('aid_diary_1.jpg', Uint8List.fromList([9]));

    await phone.sync(cloud);
    await laptop.sync(cloud);

    final image = (await laptop.db.query(imagesTable)).single;
    final file = image[EntryImageFields.imgPath] as String;
    expect(file, isNot('aid_diary_1.jpg'));
    expect(await laptop.photos.read(file), [1, 2, 3]);
    expect(await laptop.photos.read('aid_diary_1.jpg'), [9]);

    await phone.db.delete(imagesTable);
    await phone.sync(cloud);
    await laptop.sync(cloud);
    expect(await laptop.db.query(imagesTable), isEmpty);
    expect(await laptop.photos.exists(file), isFalse);
  });

  test('tags keep their category and their values on entries', () async {
    final category = await phone.db
        .insert(tagCategoriesTable, {TagCategoryFields.name: 'Feelings'});
    final tag = await phone.db.insert(tagsTable, {
      TagFields.name: 'Energy',
      TagFields.tagType: TagType.tracker.toInt(),
      TagFields.categoryId: category,
    });
    final entry = await phone.write('long run');
    await phone.db.insert(entryTagsTable, {
      EntryTagFields.entryId: entry,
      EntryTagFields.tagId: tag,
      EntryTagFields.value: '7',
    });

    await phone.sync(cloud);
    await laptop.sync(cloud);

    final linked = await laptop.db.rawQuery('''
SELECT t.${TagFields.name} AS tag, c.${TagCategoryFields.name} AS category,
       l.${EntryTagFields.value} AS value, e.${EntryFields.text} AS entry
FROM $entryTagsTable l
JOIN $tagsTable t ON t.id = l.${EntryTagFields.tagId}
JOIN $tagCategoriesTable c ON c.id = t.${TagFields.categoryId}
JOIN $entriesTable e ON e.id = l.${EntryTagFields.entryId}''');
    expect(linked, [
      {
        'tag': 'Energy',
        'category': 'Feelings',
        'value': '7',
        'entry': 'long run'
      }
    ]);
  });

  test('of two edits the newer wins and the other is kept', () async {
    await phone.write('plan');
    await phone.sync(cloud);
    await laptop.sync(cloud);

    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);

    final report = await laptop.sync(cloud);

    expect(report.keptConflicts, 1);
    expect(await laptop.texts(), ['plan from the phone']);
    expect(await laptop.texts(deleted: true), ['plan from the laptop']);
    // The kept version reaches the phone too.
    await phone.sync(cloud);
    expect(await phone.texts(deleted: true), ['plan from the laptop']);
  });

  test('a newer local edit is sent instead of taking the remote one', () async {
    await phone.write('plan');
    await phone.sync(cloud);
    await laptop.sync(cloud);

    await phone.edit('plan', 'older');
    await phone.sync(cloud);
    await later();
    await laptop.edit('plan', 'newer');

    final report = await laptop.sync(cloud);
    await phone.sync(cloud);

    expect(report.keptConflicts, 0);
    expect(await laptop.texts(), ['newer']);
    expect(await phone.texts(), ['newer']);
  });

  test('an encrypted space holds no readable text', () async {
    final keys = newDataKey();
    final cipher = ItemCipher(keys);
    await phone.write('secret diary');

    await phone.sync(cloud, cipher: cipher);

    for (final (bytes, _) in cloud.files.values) {
      expect(latin1.decode(bytes, allowInvalid: true),
          isNot(contains('secret diary')));
    }
    await laptop.sync(cloud, cipher: ItemCipher(keys));
    expect(await laptop.texts(), ['secret diary']);

    final stranger = await Device.create();
    addTearDown(stranger.db.close);
    final wrong = newDataKey();
    expect(stranger.sync(cloud, cipher: ItemCipher(wrong)),
        throwsA(isA<WrongKeyException>()));
  });

  test('a device joining with its own diary merges both ways', () async {
    await phone.write('from the phone');
    await phone.sync(cloud);
    await laptop.write('from the laptop');
    await laptop.db.delete(syncChangesTable);

    // Joining marks everything the laptop already had.
    await markAllChanged(laptop.db);
    await laptop.sync(cloud);
    await phone.sync(cloud);

    expect(await laptop.texts(), ['from the laptop', 'from the phone']);
    expect(await phone.texts(), ['from the laptop', 'from the phone']);
  });

  test('built-in tags made on each device stay one tag', () async {
    for (final device in [phone, laptop]) {
      await device.db.insert(tagsTable, {
        syncIdColumn: 'builtin-tag-favorite',
        TagFields.name: 'Favorite',
        TagFields.tagType: TagType.label.toInt(),
      });
    }
    await phone.sync(cloud);
    await markAllChanged(laptop.db);
    await laptop.sync(cloud);
    await phone.sync(cloud);

    expect(await phone.db.query(tagsTable), hasLength(1));
    expect(await laptop.db.query(tagsTable), hasLength(1));
  });

  /// One pack per item, so tests can stop and compact between them.
  const onePerPack = SyncLimits(packBytes: 1, compactAfter: 1000, parallel: 3);

  SyncEngine engineFor(Device device,
          {SyncLimits limits = testLimits,
          void Function(SyncProgress)? onProgress,
          bool Function()? stopped}) =>
      SyncEngine(
          db: device.db,
          backend: cloud,
          photos: FileStorePhotos(device.photos),
          limits: limits,
          onProgress: onProgress,
          stopped: stopped);

  List<String> filesIn(String folder) => [
        for (final path in cloud.files.keys)
          if (path.startsWith('$folder/')) path.substring(folder.length + 1),
      ];

  test('many changes go up together in one pack', () async {
    for (var i = 0; i < 50; i++) {
      await phone.write('entry $i');
    }

    expect((await phone.sync(cloud)).sent, 50);
    expect(filesIn(SpaceLayout.packs), hasLength(1));
    expect((await laptop.sync(cloud)).received, 50);
    expect(await laptop.texts(), hasLength(50));
  });

  test('changes beyond a pack size go into further packs', () async {
    for (var i = 0; i < 20; i++) {
      await phone.write('entry $i');
    }

    await phone.sync(cloud,
        limits:
            const SyncLimits(packBytes: 2000, compactAfter: 1000, parallel: 3));

    expect(filesIn(SpaceLayout.packs).length, inInclusiveRange(2, 19));
    await laptop.sync(cloud);
    expect(await laptop.texts(), hasLength(20));
  });

  test('a long sync tells how far it is, file by file', () async {
    for (var i = 0; i < 3; i++) {
      await phone.write('entry $i');
    }
    final sending = <SyncProgress>[];
    await engineFor(phone, limits: onePerPack, onProgress: sending.add).sync();
    final receiving = <SyncProgress>[];
    await engineFor(laptop, onProgress: receiving.add).sync();

    expect(sending, [
      for (var i = 0; i < 3; i++) (sending: true, done: i, total: 3),
    ]);
    expect(receiving.map((progress) => progress.done), [0, 1, 2]);
    expect(receiving.map((progress) => progress.total), everyElement(3));
  });

  test('a stopped sync keeps what it sent and sends the rest next time',
      () async {
    for (var i = 0; i < 4; i++) {
      await phone.write('entry $i');
    }
    var files = 0;
    final report = await engineFor(phone,
        limits: onePerPack,
        onProgress: (_) => files++,
        stopped: () => files >= 2).sync();

    expect(report.sent, 2);
    await laptop.sync(cloud);
    expect(await laptop.texts(), hasLength(2));
    expect((await phone.sync(cloud)).sent, 2);
    await laptop.sync(cloud);
    expect(await laptop.texts(), hasLength(4));
  });

  test('a sync stopped while receiving sends nothing over unseen changes',
      () async {
    for (var i = 0; i < 3; i++) {
      await phone.write('entry $i');
    }
    await phone.sync(cloud, limits: onePerPack);
    await laptop.write('mine');
    var files = 0;
    final report = await engineFor(laptop,
        onProgress: (_) => files++, stopped: () => files >= 2).sync();

    expect(report.sent, 0);
    expect(await laptop.texts(), ['mine']);
    expect((await laptop.sync(cloud)).sent, 1);
    expect(await laptop.texts(), hasLength(4));
  });

  test('packs read in any order settle on the newest edit', () async {
    final tablet = await Device.create();
    addTearDown(tablet.db.close);
    await phone.write('plan');
    await phone.sync(cloud);
    await laptop.sync(cloud);

    // The tablet reads both edits at once, the newer one in the older pack.
    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);
    await laptop.sync(cloud);
    await tablet.sync(cloud);

    expect(await tablet.texts(), ['plan from the phone']);
    expect(await tablet.texts(deleted: true), ['plan from the laptop']);
  });

  test('a snapshot folds the packs and still carries deletions', () async {
    const compacting =
        SyncLimits(packBytes: 1 << 20, compactAfter: 2, parallel: 3);
    await phone.write('kept');
    await phone.write('dropped');
    await phone.sync(cloud, limits: compacting);
    await laptop.sync(cloud);

    // The laptop is away while the phone deletes, edits and compacts.
    await phone.db.delete(entriesTable,
        where: '${EntryFields.text} = ?', whereArgs: ['dropped']);
    await phone.sync(cloud, limits: compacting);
    await phone.edit('kept', 'kept and edited');
    await phone.sync(cloud, limits: compacting);

    final files = filesIn(SpaceLayout.packs);
    expect(files, hasLength(1));
    expect(files.single, startsWith(SpaceLayout.snapshotPrefix));

    await laptop.sync(cloud);
    expect(await laptop.texts(), ['kept and edited']);
    final tablet = await Device.create();
    addTearDown(tablet.db.close);
    await tablet.sync(cloud);
    expect(await tablet.texts(), ['kept and edited']);
  });

  test('missing media waits without delaying entries in its pack', () async {
    final entry = await phone.write('beach');
    await phone.photos.write('aid_diary_1.jpg', Uint8List.fromList([1, 2]));
    await phone.db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: 'aid_diary_1.jpg',
      EntryImageFields.imgRank: 0,
    });
    await phone.write('plain');
    await phone.sync(cloud);
    final blob =
        cloud.files.keys.firstWhere((path) => path.startsWith('media/chunks/'));
    final held = cloud.files.remove(blob)!;

    final report = await laptop.sync(cloud);
    expect(await laptop.texts(), ['beach', 'plain']);
    expect(report.pendingMedia, 1);
    expect(await laptop.photos.exists('aid_diary_1.jpg'), isFalse);

    cloud.files[blob] = held;
    await laptop.sync(cloud);
    expect(await laptop.texts(), ['beach', 'plain']);
    expect(await laptop.db.query(imagesTable), hasLength(1));
  });
}
