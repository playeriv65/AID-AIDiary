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

// End-to-end encryption for a sync space, as password managers and E2EE
// note apps do it:
//
// * A random 256-bit space key encrypts every item and photo with AES-GCM.
//   The item id is the associated data, so a ciphertext cannot be passed off
//   as another item.
// * The passphrase never encrypts data itself: Argon2id turns it into a key
//   that wraps the space key. Changing it rewraps the space key only.
// * A random recovery key wraps the space key a second time, for when the
//   passphrase is forgotten. It is shown once for the user to keep.
// * The space only ever holds wrapped keys and ciphertext. A wrong
//   passphrase fails the AES-GCM tag, so no verifier is stored.

const int _keyLength = 32;
const int _nonceLength = 12;
const int _saltLength = 16;
const int _sealVersion = 1;

final AesGcm _aes = Platform.isAndroid || Platform.isIOS
    ? AesGcm.with256bits()
    : DartAesGcm.with256bits();

class WrongKeyException implements Exception {
  @override
  String toString() =>
      'The passphrase or recovery key does not open this space';
}

/// Argon2id settings, kept with the space so they can grow later.
class KdfParams {
  const KdfParams(
      {this.memoryKiB = defaultArgon2MemoryKiB,
      this.iterations = defaultArgon2Iterations,
      this.parallelism = defaultArgon2Parallelism});

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

/// What a space stores about its encryption: the space key wrapped by the
/// passphrase and by the recovery key.
class SpaceEncryption {
  const SpaceEncryption(
      {required this.kdf,
      required this.salt,
      required this.byPassphrase,
      required this.byRecoveryKey});

  final KdfParams kdf;
  final Uint8List salt;
  final Uint8List byPassphrase;
  final Uint8List byRecoveryKey;

  Map<String, Object?> toJson() => {
        'kdf': kdf.toJson(),
        'salt': base64.encode(salt),
        'byPassphrase': base64.encode(byPassphrase),
        'byRecoveryKey': base64.encode(byRecoveryKey),
      };

  factory SpaceEncryption.fromJson(Map<String, Object?> json) =>
      SpaceEncryption(
          kdf: KdfParams.fromJson((json['kdf'] as Map).cast()),
          salt: base64.decode(json['salt'] as String),
          byPassphrase: base64.decode(json['byPassphrase'] as String),
          byRecoveryKey: base64.decode(json['byRecoveryKey'] as String));

  /// A new space key, wrapped by [passphrase] and by a new recovery key.
  static Future<
          ({SpaceEncryption encryption, Uint8List key, String recoveryKey})>
      create(String passphrase, {KdfParams kdf = const KdfParams()}) async {
    final key = secureRandomBytes(_keyLength);
    final recovery = secureRandomBytes(_keyLength);
    final salt = secureRandomBytes(_saltLength);
    final passphraseKey = await _derive(passphrase, salt, kdf);
    return (
      encryption: SpaceEncryption(
          kdf: kdf,
          salt: salt,
          byPassphrase: await _seal(passphraseKey, key, _wrapLabel),
          byRecoveryKey: await _seal(recovery, key, _wrapLabel)),
      key: key,
      recoveryKey: formatRecoveryKey(recovery),
    );
  }

  /// The space key, or [WrongKeyException].
  Future<Uint8List> unlockWithPassphrase(String passphrase) async =>
      _open(await _derive(passphrase, salt, kdf), byPassphrase, _wrapLabel);

  Future<Uint8List> unlockWithRecoveryKey(String recoveryKey) async =>
      _open(parseRecoveryKey(recoveryKey), byRecoveryKey, _wrapLabel);

  /// The same space key under a new passphrase; data stays as it is.
  Future<SpaceEncryption> withPassphrase(
      Uint8List key, String passphrase) async {
    final newSalt = secureRandomBytes(_saltLength);
    return SpaceEncryption(
        kdf: kdf,
        salt: newSalt,
        byPassphrase: await _seal(
            await _derive(passphrase, newSalt, kdf), key, _wrapLabel),
        byRecoveryKey: byRecoveryKey);
  }
}

const String _wrapLabel = 'space-key';

/// Encrypts and decrypts items with a space key.
class ItemCipher {
  ItemCipher(this._key);

  final Uint8List _key;

  Future<Uint8List> seal(String id, List<int> plain) => _seal(_key, plain, id);

  Future<Uint8List> open(String id, Uint8List sealed) =>
      _open(_key, sealed, id);
}

Future<Uint8List> _derive(String passphrase, Uint8List salt, KdfParams kdf) =>
    // Argon2id is slow on purpose; keep it off the UI isolate.
    Isolate.run(() => deriveArgon2idKey(
        password: passphrase,
        salt: salt,
        memoryKiB: kdf.memoryKiB,
        iterations: kdf.iterations,
        parallelism: kdf.parallelism,
        keyLength: _keyLength));

/// version byte, nonce, ciphertext, tag.
Future<Uint8List> _seal(List<int> key, List<int> plain, String aad) async {
  final box = await _aes.encrypt(plain,
      secretKey: SecretKey(key),
      nonce: secureRandomBytes(_nonceLength),
      aad: utf8.encode(aad));
  return Uint8List.fromList(
      [_sealVersion, ...box.nonce, ...box.cipherText, ...box.mac.bytes]);
}

Future<Uint8List> _open(List<int> key, Uint8List sealed, String aad) async {
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

/// Reads a recovery key typed with any case, spaces or dashes.
Uint8List parseRecoveryKey(String text) {
  final clean = text.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
  final out = <int>[];
  var bits = 0, value = 0;
  for (final char in clean.split('')) {
    final digit = _base32.indexOf(char);
    if (digit < 0) throw WrongKeyException();
    value = (value << 5) | digit;
    bits += 5;
    if (bits >= 8) {
      out.add((value >> (bits - 8)) & 0xff);
      bits -= 8;
    }
  }
  if (out.length != _keyLength) throw WrongKeyException();
  return Uint8List.fromList(out);
}
