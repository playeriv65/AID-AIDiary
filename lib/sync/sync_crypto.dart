// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:aid_diary/utils/crypto_utils.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

// End-to-end encryption for a sync space. Every space is encrypted:
//
// * Each device holds the user's master key (sync/identity.dart), never
//   stored anywhere else in the clear.
// * A space has its own random data key, sealed by the master key in the
//   space's description. The data key encrypts every item and photo with
//   AES-256-GCM, the item id as associated data, so a ciphertext cannot be
//   passed off as another item. A new master or data key later rewraps a
//   key, not the data.
// * A recovery code, random unless the user picks a password, seals the
//   master key a second time through Argon2id, for when every device is
//   lost. It opens nothing else, and changing it rewraps the master key
//   only.
// * The space holds only sealed keys and ciphertext. A wrong key fails the
//   AES-GCM tag, so no verifier is stored.

const int _keyLength = 32;
const int _nonceLength = 12;
const int _saltLength = 16;
const int _sealVersion = 1;

final AesGcm _aes = Platform.isAndroid || Platform.isIOS
    ? AesGcm.with256bits()
    : DartAesGcm.with256bits();

class WrongKeyException implements Exception {
  @override
  String toString() => 'The key or recovery code does not open this space';
}

class KdfParams {
  const KdfParams(
      {required this.memoryKiB,
      required this.iterations,
      this.parallelism = 1});

  final int memoryKiB;
  final int iterations;
  final int parallelism;

  Map<String, Object?> toJson() => {
        'algorithm': 'argon2id',
        'memoryKiB': memoryKiB,
        'iterations': iterations,
        'parallelism': parallelism,
      };

  factory KdfParams.fromJson(Map<String, Object?> json) {
    if (json['algorithm'] != 'argon2id') {
      throw FormatException('Unknown key derivation ${json['algorithm']}');
    }
    return KdfParams(
        memoryKiB: json['memoryKiB'] as int,
        iterations: json['iterations'] as int,
        parallelism: json['parallelism'] as int);
  }
}

/// A new random data key for a space.
Uint8List newDataKey() => secureRandomBytes(_keyLength);

/// [dataKey] sealed by [masterKey] for space [spaceId].
Future<Uint8List> sealDataKey(
        Uint8List masterKey, Uint8List dataKey, String spaceId) =>
    sealBytes(masterKey, dataKey, 'data-key:$spaceId');

/// The data key of space [spaceId], or [WrongKeyException] when
/// [masterKey] is not the one that sealed it.
Future<Uint8List> openDataKey(
        Uint8List masterKey, Uint8List sealed, String spaceId) =>
    openBytes(masterKey, sealed, 'data-key:$spaceId');

/// A new recovery code: [bytes] random bytes in base32, grouped by four.
String newRecoveryCode(int bytes) =>
    formatRecoveryKey(secureRandomBytes(bytes));

/// The master key sealed by a key drawn from the recovery code, kept in
/// the space for when every device is gone.
class RecoveryLock {
  const RecoveryLock(
      {required this.kdf,
      required this.salt,
      required this.sealedMasterKey,
      required this.generated});

  final KdfParams kdf;
  final Uint8List salt;
  final Uint8List sealedMasterKey;

  /// A code the app made rather than a password the user chose: it opens
  /// however it is typed, in any case and with or without its dashes.
  final bool generated;

  Map<String, Object?> toJson() => {
        'kdf': kdf.toJson(),
        'salt': base64.encode(salt),
        'masterKey': base64.encode(sealedMasterKey),
        'generated': generated,
      };

  factory RecoveryLock.fromJson(Map<String, Object?> json) => RecoveryLock(
      kdf: KdfParams.fromJson((json['kdf'] as Map).cast()),
      salt: base64.decode(json['salt'] as String),
      sealedMasterKey: base64.decode(json['masterKey'] as String),
      generated: json['generated'] as bool);

  /// [masterKey] of [userId] locked by [code], which the app made when
  /// [generated] and the user chose otherwise.
  static Future<RecoveryLock> lock(
      Uint8List masterKey, String userId, String code, KdfParams kdf,
      {required bool generated}) async {
    final salt = secureRandomBytes(_saltLength);
    return RecoveryLock(
        kdf: kdf,
        salt: salt,
        generated: generated,
        sealedMasterKey: await sealBytes(
            await _derive(_normal(code, generated), salt, kdf),
            masterKey,
            'master-key:$userId'));
  }

  /// The master key of [userId], or [WrongKeyException].
  Future<Uint8List> unlock(String userId, String code) async => openBytes(
      await _derive(_normal(code, generated), salt, kdf),
      sealedMasterKey,
      'master-key:$userId');

  static String _normal(String code, bool generated) => generated
      ? code.toUpperCase().replaceAll(RegExp(r'[\s-]'), '')
      : code.trim();
}

class ItemCipher {
  ItemCipher(this._key);

  final Uint8List _key;

  Future<Uint8List> seal(String id, List<int> plain) =>
      sealBytes(_key, plain, id);

  Future<Uint8List> open(String id, Uint8List sealed) =>
      openBytes(_key, sealed, id);
}

Future<Uint8List> _derive(String code, Uint8List salt, KdfParams kdf) =>
    // Argon2id is slow on purpose; keep it off the UI isolate.
    Isolate.run(() => deriveArgon2idKey(
        password: code,
        salt: salt,
        memoryKiB: kdf.memoryKiB,
        iterations: kdf.iterations,
        parallelism: kdf.parallelism,
        keyLength: _keyLength));

/// [plain] under [key] with AES-256-GCM, bound to [aad]: version byte,
/// nonce, ciphertext, tag.
Future<Uint8List> sealBytes(List<int> key, List<int> plain, String aad) async {
  final box = await _aes.encrypt(plain,
      secretKey: SecretKey(key),
      nonce: secureRandomBytes(_nonceLength),
      aad: utf8.encode(aad));
  return Uint8List.fromList(
      [_sealVersion, ...box.nonce, ...box.cipherText, ...box.mac.bytes]);
}

/// What [sealBytes] sealed, or [WrongKeyException] for another key or
/// [aad].
Future<Uint8List> openBytes(List<int> key, Uint8List sealed, String aad) async {
  if (sealed.length < 1 + _nonceLength + 16 || sealed[0] != _sealVersion) {
    throw const FormatException('Not an encrypted item');
  }
  final box = SecretBox(sealed.sublist(1 + _nonceLength, sealed.length - 16),
      nonce: sealed.sublist(1, 1 + _nonceLength),
      mac: Mac(sealed.sublist(sealed.length - 16)));
  try {
    return Uint8List.fromList(await _aes.decrypt(box,
        secretKey: SecretKey(key), aad: utf8.encode(aad)));
  } on SecretBoxAuthenticationError {
    throw WrongKeyException();
  }
}

const String _base32 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

/// Base32 in groups of four, easy to copy by hand.
String formatRecoveryKey(Uint8List bytes) {
  final buffer = StringBuffer();
  var bits = 0, value = 0;
  for (final byte in bytes) {
    value = (value << 8) | byte;
    bits += 8;
    while (bits >= 5) {
      buffer.write(_base32[(value >> (bits - 5)) & 31]);
      bits -= 5;
    }
  }
  if (bits > 0) buffer.write(_base32[(value << (5 - bits)) & 31]);
  final text = buffer.toString();
  return [
    for (var i = 0; i < text.length; i += 4)
      text.substring(i, i + 4 > text.length ? text.length : i + 4),
  ].join('-');
}
