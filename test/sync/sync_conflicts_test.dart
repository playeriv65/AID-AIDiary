// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_conflicts.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/sync_device.dart';

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
    phone = await Device.create(name: 'Phone');
    laptop = await Device.create(name: 'Laptop');
    await phone.write('plan');
    await phone.sync(cloud);
    await laptop.sync(cloud);
  });

  tearDown(() async {
    await phone.db.close();
    await laptop.db.close();
  });

  Future<void> later() => Future.delayed(const Duration(milliseconds: 5));

  Future<void> syncAll() async {
    for (var round = 0; round < 2; round++) {
      await phone.sync(cloud);
      await laptop.sync(cloud);
    }
  }

  /// Both devices edit the entry before either edit syncs; the phone's goes
  /// up first, so the laptop finds the conflict.
  Future<void> editBoth() async {
    await later();
    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);
    await laptop.sync(cloud);
    await phone.sync(cloud);
  }

  Future<void> expectBoth(List<String> texts) async {
    for (final device in [phone, laptop]) {
      expect(await device.texts(), texts, reason: device.name);
      expect(await device.texts(deleted: true), isEmpty, reason: device.name);
      expect(await device.conflicts(), isEmpty, reason: device.name);
      expect(await device.db.query(syncConflictsTable), isEmpty,
          reason: device.name);
    }
  }

  Future<void> attach(Device device, String text, String file) async {
    await device.photos.write(file, Uint8List.fromList(utf8.encode(file)));
    await device.db.insert(imagesTable, {
      EntryImageFields.entryId: await device.rowOf(text),
      EntryImageFields.imgPath: file,
      EntryImageFields.imgRank: 0,
    });
  }

  Future<List<String>> files(Device device) async => [
        for (final row in await device.db
            .query(imagesTable, orderBy: EntryImageFields.imgPath))
          row[EntryImageFields.imgPath] as String,
      ];

  test('an edit on one side is taken in without asking', () async {
    await later();
    await laptop.edit('plan', 'plan from the laptop');
    await laptop.sync(cloud);
    await phone.sync(cloud);
    await later();
    await phone.edit('plan from the laptop', 'plan, then the phone');
    await syncAll();

    await expectBoth(['plan, then the phone']);
  });

  test('edits on both sides wait as one conflict on each device', () async {
    await editBoth();
    await syncAll();

    expect(await laptop.texts(), ['plan from the laptop']);
    expect(await phone.texts(), ['plan from the phone']);
    final onLaptop = (await laptop.conflicts()).single;
    expect(onLaptop.entry, await laptop.rowOf('plan from the laptop'));
    expect((onLaptop.mine.device, onLaptop.mine.snippet),
        ('Laptop', 'plan from the laptop'));
    expect((onLaptop.other.device, onLaptop.other.snippet),
        ('Phone', 'plan from the phone'));
    final onPhone = (await phone.conflicts()).single;
    expect((onPhone.mine.device, onPhone.mine.snippet),
        ('Phone', 'plan from the phone'));
    expect((onPhone.other.device, onPhone.other.snippet),
        ('Laptop', 'plan from the laptop'));
    for (final device in [phone, laptop]) {
      expect(await device.db.query(syncConflictsTable), hasLength(1));
    }
  });

  group('keeping', () {
    test("this device's version, where the conflict reached", () async {
      await editBoth();
      await phone.resolve('plan from the phone', ConflictKeep.mine);
      await syncAll();
      await expectBoth(['plan from the phone']);
    });

    test("this device's version, where it was found", () async {
      await editBoth();
      await laptop.resolve('plan from the laptop', ConflictKeep.mine);
      await syncAll();
      await expectBoth(['plan from the laptop']);
    });

    test('the other version, where the conflict reached', () async {
      await editBoth();
      await phone.resolve('plan from the phone', ConflictKeep.other);
      await syncAll();
      await expectBoth(['plan from the laptop']);
    });

    test('the other version, where it was found', () async {
      await editBoth();
      await laptop.resolve('plan from the laptop', ConflictKeep.other);
      await syncAll();
      await expectBoth(['plan from the phone']);
    });

    test('both makes a second entry on every device', () async {
      await editBoth();
      await phone.resolve('plan from the phone', ConflictKeep.both);
      await syncAll();
      await expectBoth(['plan from the laptop', 'plan from the phone']);
    });

    test('both, chosen on two devices, makes two entries in all', () async {
      await editBoth();
      await phone.resolve('plan from the phone', ConflictKeep.both);
      await laptop.resolve('plan from the laptop', ConflictKeep.both);
      await syncAll();
      await expectBoth(['plan from the laptop', 'plan from the phone']);
      for (final device in [phone, laptop]) {
        expect(await device.db.query(entriesTable), hasLength(2));
      }
    });
  });

  test('a device rejoining after edits on both sides gets a conflict',
      () async {
    // The laptop leaves the space; both edit while apart.
    await forgetSpace(laptop.db);
    await later();
    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);

    // Joining again, as pairing or the recovery code does.
    await forgetSpace(laptop.db);
    await markAllChanged(laptop.db);
    await laptop.sync(cloud);
    await phone.sync(cloud);

    expect(await laptop.texts(), ['plan from the laptop']);
    expect(await phone.texts(), ['plan from the phone']);
    expect(await laptop.conflicts(), hasLength(1));
    expect(await phone.conflicts(), hasLength(1));

    await laptop.resolve('plan from the laptop', ConflictKeep.both);
    await syncAll();
    await expectBoth(['plan from the laptop', 'plan from the phone']);
  });

  test('finding a conflict again, after a failed sync, keeps one', () async {
    await later();
    await laptop.edit('plan', 'plan from the laptop');
    await later();
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud);

    // A pack the laptop cannot write sits beside the phone's edit.
    final broken = SpaceLayout.pack('${SpaceLayout.packPrefix}broken');
    await cloud.write(
        broken,
        Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
          'records': [
            {'kind': 'entry', 'id': 'broken', 'modified': 1, 'data': {}},
          ],
        })))));
    for (var attempt = 0; attempt < 2; attempt++) {
      await expectLater(laptop.sync(cloud), throwsA(anything));
    }
    await cloud.delete(broken);
    for (var round = 0; round < 3; round++) {
      await syncAll();
    }

    for (final device in [phone, laptop]) {
      expect(await device.conflicts(), hasLength(1));
      expect(await device.db.query(syncConflictsTable), hasLength(1));
      expect(await device.db.query(entriesTable), hasLength(1));
    }
  });

  test('an edit made while the conflict waits goes into it', () async {
    await editBoth();
    await later();
    await laptop.edit('plan from the laptop', 'plan from the laptop, again');
    await syncAll();

    expect((await phone.conflicts()).single.other.snippet,
        'plan from the laptop, again');
    expect(await phone.texts(), ['plan from the phone']);
    await phone.resolve('plan from the phone', ConflictKeep.other);
    await syncAll();
    await expectBoth(['plan from the laptop, again']);
  });

  group('attachments', () {
    /// Each device edits the text and adds a photo of its own.
    Future<void> editBothWithPhotos() async {
      await later();
      await laptop.edit('plan', 'plan from the laptop');
      await attach(laptop, 'plan from the laptop', 'laptop.jpg');
      await later();
      await phone.edit('plan', 'plan from the phone');
      await attach(phone, 'plan from the phone', 'phone.jpg');
      await phone.sync(cloud);
      await laptop.sync(cloud);
      await phone.sync(cloud);
    }

    test('stay with each version while the conflict waits', () async {
      await editBothWithPhotos();
      await syncAll();
      expect(await files(laptop), ['laptop.jpg']);
      expect(await files(phone), ['phone.jpg']);
    });

    test('of the version kept follow it to the device without them', () async {
      await editBothWithPhotos();
      await phone.resolve('plan from the phone', ConflictKeep.other);
      await syncAll();

      await expectBoth(['plan from the laptop']);
      for (final device in [phone, laptop]) {
        expect(await files(device), ['laptop.jpg']);
        expect(
            await device.photos.read('laptop.jpg'), utf8.encode('laptop.jpg'));
        expect(await device.photos.exists('phone.jpg'), isFalse);
      }
    });

    test('of both versions stay with their entries when both are kept',
        () async {
      await editBothWithPhotos();
      await laptop.resolve('plan from the laptop', ConflictKeep.both);
      await syncAll();

      await expectBoth(['plan from the laptop', 'plan from the phone']);
      for (final device in [phone, laptop]) {
        final linked = {
          for (final row in await device.db.rawQuery('''
SELECT e.text AS text, i.${EntryImageFields.imgPath} AS file
FROM $imagesTable i JOIN $entriesTable e
  ON e.id = i.${EntryImageFields.entryId}''')) row['text']: row['file'],
        };
        expect(linked, {
          'plan from the laptop': 'laptop.jpg',
          'plan from the phone': 'phone.jpg',
        });
        for (final file in ['laptop.jpg', 'phone.jpg']) {
          expect(await device.photos.read(file), utf8.encode(file));
        }
      }
    });
  });
}
