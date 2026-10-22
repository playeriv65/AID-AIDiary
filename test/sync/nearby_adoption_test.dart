// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/sync/nearby_adoption.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../support/sync_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(sqfliteFfiInit);
  late Device device;
  setUp(() async {
    device = await Device.create();
  });
  tearDown(() async {
    await device.db.close();
  });
  test('used destination rejects adoption before any identity or resume write',
      () async {
    await device.write('already mine');
    var writes = 0, restores = 0;
    await expectLater(
        nearbyAdoptionTransaction(
            db: device.db,
            current: () => true,
            requireEmpty: true,
            persist: (_) async {
              writes++;
            },
            restore: () async {
              restores++;
            }),
        throwsStateError);
    expect(writes, 0);
    expect(restores, 0);
    expect(await device.texts(), ['already mine']);
  });
  test('cancelled request rejects before modifying secure settings', () async {
    var writes = 0;
    await expectLater(
        nearbyAdoptionTransaction(
            db: device.db,
            current: () => false,
            requireEmpty: true,
            persist: (_) async {
              writes++;
            },
            restore: () async {
              writes++;
            }),
        throwsStateError);
    expect(writes, 0);
  });
  test(
      'cancellation during persistence rolls back resume, identity and database writes',
      () async {
    var active = true;
    var identity = 'original', resume = '';
    await expectLater(
        nearbyAdoptionTransaction(
            db: device.db,
            current: () => active,
            requireEmpty: true,
            persist: (txn) async {
              identity = 'incoming';
              resume = 'capability';
              await txn.insert(entriesTable, {
                EntryFields.text: 'partial',
                EntryFields.timeCreate: '2026-10-22T00:00:00.000',
                EntryFields.timeModified: '2026-10-22T00:00:00.000'
              });
              active = false;
            },
            restore: () async {
              identity = 'original';
              resume = '';
            }),
        throwsStateError);
    expect(identity, 'original');
    expect(resume, isEmpty);
    expect(await device.texts(), isEmpty);
  });
  test(
      'native secret persistence failure is compensated before SQLite rollback',
      () async {
    var identity = 'original';
    var restored = false;
    await expectLater(
        nearbyAdoptionTransaction(
            db: device.db,
            current: () => true,
            persist: (_) async {
              identity = 'incoming';
              throw StateError('native store unavailable');
            },
            restore: () async {
              identity = 'original';
              restored = true;
            }),
        throwsStateError);
    expect(identity, 'original');
    expect(restored, true);
  });
  test('successful identity adoption can use a distinct final generation guard',
      () async {
    var identity = 'original';
    await nearbyAdoptionTransaction(
        db: device.db,
        current: () => identity == 'original',
        afterPersist: () => identity == 'incoming',
        persist: (_) async {
          identity = 'incoming';
        },
        restore: () async {
          identity = 'original';
        });
    expect(identity, 'incoming');
  });
}
