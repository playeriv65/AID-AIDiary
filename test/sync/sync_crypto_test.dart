// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Light Argon2id settings keep the tests quick; the app's are in
  // app_config.json.
  const fast = KdfParams(memoryKiB: 1024, iterations: 1);
  final owner = DiaryIdentity.create();

  test("a space's data key opens with its user's master key only", () async {
    final space = SpaceInfo.fromBytes((await SpaceInfo.create(owner,
            recoveryCode: 'ABCD-EFGH', generated: true, kdf: fast))
        .toBytes());

    expect(space.userId, owner.userId);
    expect(await space.dataKey(owner.masterKey), hasLength(32));
    expect(space.dataKey(DiaryIdentity.create().masterKey),
        throwsA(isA<WrongKeyException>()));
  });

  test('a sealed data key belongs to its own space', () async {
    final dataKey = newDataKey();
    final sealed = await sealDataKey(owner.masterKey, dataKey, 'space-1');

    expect(await openDataKey(owner.masterKey, sealed, 'space-1'), dataKey);
    expect(openDataKey(owner.masterKey, sealed, 'space-2'),
        throwsA(isA<WrongKeyException>()));
  });

  test('a generated recovery code opens however it is typed', () async {
    final code = newRecoveryCode(20);
    expect(code, matches(RegExp(r'^([A-Z2-7]{4}-){7}[A-Z2-7]{4}$')));
    final lock = RecoveryLock.fromJson(jsonDecode(jsonEncode(
        (await RecoveryLock.lock(owner.masterKey, owner.userId, code, fast,
                generated: true))
            .toJson())));

    for (final typed in [
      code,
      code.toLowerCase(),
      code.replaceAll('-', ' '),
      ' ${code.replaceAll('-', '')} ',
    ]) {
      expect(await lock.unlock(owner.userId, typed), owner.masterKey,
          reason: typed);
    }
    expect(lock.unlock(owner.userId, newRecoveryCode(20)),
        throwsA(isA<WrongKeyException>()));
    expect(
        lock.unlock('another user', code), throwsA(isA<WrongKeyException>()));
  });

  test('a chosen recovery password opens only as chosen', () async {
    final lock = await RecoveryLock.lock(
        owner.masterKey, owner.userId, 'Correct Horse Battery', fast,
        generated: false);

    expect(await lock.unlock(owner.userId, ' Correct Horse Battery '),
        owner.masterKey);
    expect(lock.unlock(owner.userId, 'correct horse battery'),
        throwsA(isA<WrongKeyException>()));
  });

  test('items open only under their own id', () async {
    final cipher = ItemCipher(newDataKey());
    final plain = utf8.encode('{"text":"雨天散步"}');

    final sealed = await cipher.seal('entry-1', plain);

    expect(sealed, isNot(containsAllInOrder(plain)));
    expect(await cipher.open('entry-1', sealed), plain);
    expect(cipher.open('entry-2', sealed), throwsA(isA<WrongKeyException>()));
  });

  test('recovery codes are base32 in groups of four', () {
    final text = formatRecoveryKey(Uint8List.fromList(List.filled(20, 0xff)));
    expect(text, '7777-7777-7777-7777-7777-7777-7777-7777');
  });

  test('a space of an earlier format asks to start a new one', () {
    final old = utf8.encode(jsonEncode({'app': 'aid_diary', 'format': 2}));
    expect(() => SpaceInfo.fromBytes(Uint8List.fromList(old)),
        throwsA(isA<UnsupportedError>()));
  });
}
