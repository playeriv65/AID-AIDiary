// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/utils/crypto_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:pointycastle/ecc/curves/secp256r1.dart';
import 'package:pointycastle/ecc/ecc_fp.dart' as fp;
import 'package:pointycastle/export.dart' show ECPoint;

/// SPAKE2 of RFC 9382 with the P256-SHA256-HKDF-HMAC suite: two parties
/// who share a short password agree on a strong key, and an attacker who
/// sits between them (a storage provider, a server) gets one guess at the
/// password per run and learns nothing to guess with offline.
///
/// The party that offered the password is [Spake2Role.a], the one that
/// typed or scanned it [Spake2Role.b]; what either side then sends is up
/// to the protocol on top.
enum Spake2Role { a, b }

final _curve = ECCurve_secp256r1();
final BigInt _order = _curve.n;

// RFC 9382 section 6, P-256.
final ECPoint _m = _point(
    '02886e2f97ace46e55ba9dd7242579f2993b64e16ef3dcab95afd497333d8fa12f');
final ECPoint _n = _point(
    '03d8bbd6c639c62937b04d997f38c3770719c629d7014d49a24b4f98baa1292b49');

ECPoint _point(String hex) => _curve.curve.decodePoint(_hex(hex))!;

Uint8List _hex(String hex) => Uint8List.fromList([
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ]);

BigInt _bigInt(List<int> bytes) =>
    bytes.fold(BigInt.zero, (value, byte) => (value << 8) | BigInt.from(byte));

Uint8List _bytes(BigInt value, int length) {
  final out = Uint8List(length);
  for (var i = length - 1; i >= 0; i--) {
    out[i] = (value & BigInt.from(0xff)).toInt();
    value >>= 8;
  }
  return out;
}

/// [bytes] with its length first, as eight bytes little-endian.
List<int> _withLength(List<int> bytes) => [
      for (var i = 0; i < 8; i++) (bytes.length >> (8 * i)) & 0xff,
      ...bytes,
    ];

Uint8List _hkdf(List<int> ikm, List<int> info, int length) {
  // Extract with no salt (zeros), then expand.
  final prk = Hmac(sha256, Uint8List(32)).convert(ikm).bytes;
  final out = <int>[];
  var block = <int>[];
  for (var i = 1; out.length < length; i++) {
    block = Hmac(sha256, prk).convert([...block, ...info, i]).bytes;
    out.addAll(block);
  }
  return Uint8List.fromList(out.sublist(0, length));
}

/// The password as the scalar w: a hash 64 bits longer than the group
/// order, reduced, so the reduction adds no bias (RFC 9382 section 3.2).
/// A plain hash, not a memory-hard one: an attacker gets no transcript to
/// guess against offline, only one online guess per run.
BigInt passwordScalar(String password) =>
    _bigInt(
        _hkdf(utf8.encode(password), utf8.encode('aid-diary spake2 w'), 40)) %
    _order;

/// The shared keys once both messages are known.
class Spake2Keys {
  Spake2Keys._(this.role, this.sharedKey, this._confirmA, this._confirmB,
      this._transcript);

  final Spake2Role role;

  /// Ke: the key to use from here, once the confirmations agree.
  final Uint8List sharedKey;

  final Uint8List _confirmA;
  final Uint8List _confirmB;
  final List<int> _transcript;

  /// What this side sends to show it holds the same keys.
  Uint8List get confirmation =>
      _mac(role == Spake2Role.a ? _confirmA : _confirmB, _transcript);

  /// Whether the other side's [confirmation] matches: false means a wrong
  /// password or someone in between.
  bool verify(List<int> confirmation) => _equal(confirmation,
      _mac(role == Spake2Role.a ? _confirmB : _confirmA, _transcript));
}

Uint8List _mac(List<int> key, List<int> data) =>
    Uint8List.fromList(Hmac(sha256, key).convert(data).bytes);

/// Equal in time that does not depend on where they differ.
bool _equal(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference |= a[i] ^ b[i];
  }
  return difference == 0;
}

class Spake2 {
  /// One side of a run with [password]; [idA] and [idB] name the parties
  /// and [aad] binds what else both agree on, such as a protocol version.
  factory Spake2(Spake2Role role, String password,
          {String idA = '', String idB = '', String aad = ''}) =>
      Spake2.withSecrets(role,
          w: passwordScalar(password),
          scalar: _bigInt(secureRandomBytes(40)) % _order,
          idA: idA,
          idB: idB,
          aad: aad);

  /// With w and the random scalar given, for the RFC's test vectors.
  @visibleForTesting
  Spake2.withSecrets(this.role,
      {required BigInt w,
      required BigInt scalar,
      String idA = '',
      String idB = '',
      String aad = ''})
      : _w = w,
        _scalar = scalar,
        _idA = utf8.encode(idA),
        _idB = utf8.encode(idB),
        _aad = utf8.encode(aad),
        message = ((role == Spake2Role.a ? _m : _n) * w)!
            .add(_curve.G * scalar)
            .getEncoded(false);

  final Spake2Role role;
  final BigInt _w;
  final BigInt _scalar;
  final List<int> _idA;
  final List<int> _idB;
  final List<int> _aad;

  /// pA or pB: the point to send, uncompressed.
  final Uint8List message;

  /// The keys from the other side's message; a [FormatException] when it
  /// is not a point of the curve, as an attacker's might be.
  Spake2Keys finish(List<int> peerMessage) {
    final peer = _validPoint(peerMessage);
    final peerBlind = role == Spake2Role.a ? _n : _m;
    // h is 1 on P-256.
    final k = peer.add(-(peerBlind * _w)!) * _scalar;
    if (k == null || k.isInfinity) {
      throw const FormatException('The other side sent a degenerate point');
    }
    final (pA, pB) = role == Spake2Role.a
        ? (message, Uint8List.fromList(peerMessage))
        : (Uint8List.fromList(peerMessage), message);
    final transcript = [
      ..._withLength(_idA),
      ..._withLength(_idB),
      ..._withLength(pA),
      ..._withLength(pB),
      ..._withLength(k.getEncoded(false)),
      ..._withLength(_bytes(_w, 32)),
    ];
    final hash = sha256.convert(transcript).bytes;
    final confirmationKeys = _hkdf(
        hash.sublist(16), [...utf8.encode('ConfirmationKeys'), ..._aad], 32);
    return Spake2Keys._(
        role,
        Uint8List.fromList(hash.sublist(0, 16)),
        confirmationKeys.sublist(0, 16),
        confirmationKeys.sublist(16),
        transcript);
  }
}

extension on ECPoint {
  ECPoint add(ECPoint? other) => (this + other)!;
}

/// [bytes] as an uncompressed point on the curve, not the identity.
ECPoint _validPoint(List<int> bytes) {
  if (bytes.length != 65 || bytes[0] != 4) {
    throw const FormatException('Not an uncompressed P-256 point');
  }
  final curve = _curve.curve as fp.ECCurve;
  final q = curve.q!;
  final x = _bigInt(bytes.sublist(1, 33));
  final y = _bigInt(bytes.sublist(33));
  final a = curve.a!.toBigInteger()!;
  final b = curve.b!.toBigInteger()!;
  if (x >= q ||
      y >= q ||
      (y * y - (x * x * x + a * x + b)) % q != BigInt.zero) {
    throw const FormatException('The point is not on P-256');
  }
  return curve.createPoint(x, y);
}
