// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sync_device.dart';

/// Two devices syncing an end-to-end encrypted diary through a real
/// backend. [backend] gives a fresh one for the current test's space, and
/// [skip] is the reason the backend is not reachable, if any.
void liveSyncScenarios(SyncBackend Function() backend, {Object? skip}) {
  late Device phone;
  late Device laptop;
  const passphrase = 'correct horse battery staple';
  const kdf = KdfParams(memoryKiB: 1024, iterations: 1);

  setUp(() async {
    phone = await Device.create();
    laptop = await Device.create();
  });

  tearDown(() async {
    await phone.db.close();
    await laptop.db.close();
  });

  test('a new encrypted space is joined, synced and kept private', () async {
    final cloud = backend();
    await cloud.check();
    expect(await cloud.read(SpaceLayout.info), isNull);

    // The phone makes the space.
    final keys = await SpaceEncryption.create(passphrase, kdf: kdf);
    await cloud.write(SpaceLayout.info,
        SpaceInfo.create(encryption: keys.encryption).toBytes());
    final phoneCipher = ItemCipher(keys.key);
    final entry = await phone.write('rainy walk by the river');
    await phone.db.update(
        entriesTable,
        {
          EntryFields.diaryDate: '2026-10-19',
          EntryFields.utcOffset: 480,
        },
        where: 'id = ?',
        whereArgs: [entry]);
    await phone.photos.write('aid_diary_1.jpg', Uint8List.fromList([1, 2, 3]));
    await phone.db.insert(imagesTable, {
      EntryImageFields.entryId: entry,
      EntryImageFields.imgPath: 'aid_diary_1.jpg',
      EntryImageFields.imgRank: 0,
    });
    expect((await phone.sync(cloud, cipher: phoneCipher)).sent, greaterThan(0));

    // Nothing on the server reads as the diary.
    for (final file in [
      ...(await cloud.list(SpaceLayout.items)).keys,
      ...(await cloud.list(SpaceLayout.blobs)).keys,
    ]) {
      final bytes = await cloud.read(file);
      expect(latin1.decode(bytes!, allowInvalid: true),
          isNot(contains('rainy walk')),
          reason: file);
    }

    // The laptop joins with the recovery key the phone was shown.
    final space =
        SpaceInfo.fromBytes((await backend().read(SpaceLayout.info))!);
    final laptopKey =
        await space.encryption!.unlockWithRecoveryKey(keys.recoveryKey);
    await laptop.sync(backend(), cipher: ItemCipher(laptopKey));
    final received = (await laptop.db.query(entriesTable)).single;
    expect(received[EntryFields.text], 'rainy walk by the river');
    expect(received[EntryFields.diaryDate], '2026-10-19');
    expect(received[EntryFields.utcOffset], 480);
    final image = (await laptop.db.query(imagesTable)).single;
    expect(await laptop.photos.read(image[EntryImageFields.imgPath] as String),
        [1, 2, 3]);

    // A wrong passphrase opens nothing.
    expect(space.encryption!.unlockWithPassphrase('wrong'),
        throwsA(isA<WrongKeyException>()));
  }, skip: skip);

  test('edits, conflicts and deletions travel both ways', () async {
    final keys = await SpaceEncryption.create(passphrase, kdf: kdf);
    final cipher = ItemCipher(keys.key);
    final cloud = backend();
    await cloud.check();

    await phone.write('plan');
    await phone.sync(cloud, cipher: cipher);
    await laptop.sync(backend(), cipher: cipher);
    expect(await laptop.texts(), contains('plan'));

    // Both change it; the later edit wins and the other is kept.
    await laptop.edit('plan', 'plan from the laptop');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await phone.edit('plan', 'plan from the phone');
    await phone.sync(cloud, cipher: cipher);
    final report = await laptop.sync(backend(), cipher: cipher);
    expect(report.keptConflicts, 1);
    expect(await laptop.texts(), contains('plan from the phone'));
    expect(await laptop.texts(deleted: true), ['plan from the laptop']);

    await phone.db.delete(entriesTable,
        where: '${EntryFields.text} = ?', whereArgs: ['plan from the phone']);
    await phone.sync(cloud, cipher: cipher);
    await laptop.sync(backend(), cipher: cipher);
    expect(await laptop.texts(), isNot(contains('plan from the phone')));
  }, skip: skip);
}
