// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Light Argon2id settings keep the tests quick; the app uses the defaults.
  const fast = KdfParams(memoryKiB: 1024, iterations: 1);

  test('the passphrase and the recovery key both open the space', () async {
    final created = await SpaceEncryption.create('correct horse', kdf: fast);
    final stored = SpaceEncryption.fromJson(
        jsonDecode(jsonEncode(created.encryption.toJson())));

    expect(await stored.unlockWithPassphrase('correct horse'), created.key);
    expect(
        await stored.unlockWithRecoveryKey(created.recoveryKey), created.key);
  });

  test('a wrong passphrase or recovery key is refused', () async {
    final created = await SpaceEncryption.create('correct horse', kdf: fast);
    final other = await SpaceEncryption.create('x', kdf: fast);

    expect(created.encryption.unlockWithPassphrase('wrong horse'),
        throwsA(isA<WrongKeyException>()));
    expect(created.encryption.unlockWithRecoveryKey(other.recoveryKey),
        throwsA(isA<WrongKeyException>()));
    expect(created.encryption.unlockWithRecoveryKey('not-a-key'),
        throwsA(isA<WrongKeyException>()));
  });

  test('a new passphrase keeps the key and retires the old one', () async {
    final created = await SpaceEncryption.create('old', kdf: fast);

    final changed = await created.encryption.withPassphrase(created.key, 'new');

    expect(await changed.unlockWithPassphrase('new'), created.key);
    expect(
        await changed.unlockWithRecoveryKey(created.recoveryKey), created.key);
    expect(
        changed.unlockWithPassphrase('old'), throwsA(isA<WrongKeyException>()));
  });

  test('items open only under their own id', () async {
    final created = await SpaceEncryption.create('p', kdf: fast);
    final cipher = ItemCipher(created.key);
    final plain = utf8.encode('{"text":"雨天散步"}');

    final sealed = await cipher.seal('entry-1', plain);

    expect(sealed, isNot(containsAllInOrder(plain)));
    expect(await cipher.open('entry-1', sealed), plain);
    expect(cipher.open('entry-2', sealed), throwsA(isA<WrongKeyException>()));
  });

  test('recovery keys survive case, spaces and dashes', () {
    final bytes = Uint8List.fromList(List.generate(32, (i) => i * 7));
    final text = formatRecoveryKey(bytes);

    expect(text, matches(RegExp(r'^([A-Z2-7]{4}-)+[A-Z2-7]{1,4}$')));
    expect(parseRecoveryKey(text), bytes);
    expect(parseRecoveryKey(text.toLowerCase().replaceAll('-', ' ')), bytes);
  });
}
