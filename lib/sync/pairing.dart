// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/spake2.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';

// Pairing two devices of one user, so the one without the master key gets
// it from the one with it. Either device may show the code and either may
// type or scan it: who shows it decides nothing but the SPAKE2 role, and
// the key goes from whichever device holds it.
//
// The devices meet in the space's own storage, in files under `pairing/`
// that both can reach once signed in. The storage, and anyone who can
// write there, sees only SPAKE2 messages and ciphertext: the code never
// leaves the devices, a wrong code costs the attacker the whole channel
// after one try, and the key is sent only after both sides have proved
// they hold the same code.
//
//   A (shows the code)               B (types or scans it)
//   NN-a.json: pA, holds key?   ->
//                               <-   NN-b.json: pB, cB, holds key?
//   NN-a2.json: cA [, key]      ->   (or "failed" for a wrong code)
//                               <-   NN-b2.json: [key] or receipt

const String _version = 'aid-diary-pair-v1';
const String _folder = 'pairing';

enum PairingFailure {
  /// The code was wrong, or someone in between tried one.
  wrongCode,

  /// No device shows this code: mistyped, expired or already used.
  noOffer,

  /// The other device did not answer in time.
  timedOut,

  /// Neither device holds the key of this space.
  neitherHoldsKey,

  /// Both devices hold it already.
  bothHoldKey,

  cancelled,
}

class PairingException implements Exception {
  const PairingException(this.failure);

  final PairingFailure failure;

  @override
  String toString() => switch (failure) {
        PairingFailure.wrongCode => 'The pairing code did not match',
        PairingFailure.noOffer =>
          'No device shows this code; it may have expired',
        PairingFailure.timedOut => 'The other device did not answer in time',
        PairingFailure.neitherHoldsKey =>
          'Neither device is set up with this space yet',
        PairingFailure.bothHoldKey => 'Both devices already open this space',
        PairingFailure.cancelled => 'Pairing was cancelled',
      };
}

/// A pairing code: a channel to meet on and a secret, both digits, typed
/// as `NN-NNNNNN` or scanned from a QR code holding the same digits.
class PairingCode {
  const PairingCode._(this.channel, this.secret);

  static const int _channelDigits = 2;
  static const String _scheme = 'aid-pair:';

  final String channel;
  final String secret;

  /// To type.
  String get typed => '$channel-$secret';

  /// To show as a QR code.
  String get scannable => '$_scheme$typed';

  String get _password => '$_version:$channel:$secret';

  /// A new code of [digits] digits on a channel not in [taken].
  static PairingCode create(int digits, Set<String> taken) {
    final random = Random.secure();
    String number(int length) =>
        List.generate(length, (_) => random.nextInt(10)).join();
    final free = [
      for (var i = 0; i < pow(10, _channelDigits); i++)
        '$i'.padLeft(_channelDigits, '0'),
    ].where((channel) => !taken.contains(channel)).toList();
    if (free.isEmpty) throw StateError('Every pairing channel is in use');
    return PairingCode._(
        free[random.nextInt(free.length)], number(digits - _channelDigits));
  }

  /// Whether [text] read from a QR code is a pairing code at all.
  static bool isScanned(String text) => text.startsWith(_scheme);

  /// A typed or scanned code of [digits] digits; null when it is not one.
  static PairingCode? parse(String text, int digits) {
    var clean = text.trim();
    if (clean.startsWith(_scheme)) clean = clean.substring(_scheme.length);
    clean = clean.replaceAll(RegExp(r'[\s-]'), '');
    if (clean.length != digits || !RegExp(r'^\d+$').hasMatch(clean)) {
      return null;
    }
    return PairingCode._(
        clean.substring(0, _channelDigits), clean.substring(_channelDigits));
  }
}

/// What a finished pairing gives: the identity received, when this device
/// was the one without the key, and the other device's name.
typedef PairingResult = ({DiaryIdentity? received, String otherDevice});

/// One device's side of a pairing in [space], stored in [backend].
class Pairing {
  Pairing(
      {required this.backend,
      required this.space,
      required this.identity,
      required this.holdsKey,
      required this.deviceName,
      required this.poll,
      required this.timeout,
      DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final SyncBackend backend;
  final SpaceInfo space;

  /// This device's identity, sent when [holdsKey].
  final DiaryIdentity identity;

  /// Whether this device's master key opens [space].
  final bool holdsKey;

  /// Shown to the other device.
  final String deviceName;
  final Duration poll;
  final Duration timeout;
  final DateTime Function() _clock;

  Spake2? _offered;

  String get _aad => '$_version:${space.id}';

  static String _path(String channel, String message) =>
      '$_folder/$channel-$message.json';

  /// Shows a new code of [digits] digits: the other device types or scans
  /// it, and [finishOffer] waits for it.
  Future<PairingCode> offer(int digits) async {
    // A channel is taken while its offer is fresh; anything else there is
    // left over from a pairing that ended or failed.
    final channels = {
      for (final path in (await backend.list(_folder)).keys)
        path.split('/').last.split('-').first,
    };
    final taken = <String>{};
    for (final channel in channels) {
      final offer = _path(channel, 'a');
      if (await _read(offer) != null && !await _stale(offer)) {
        taken.add(channel);
      } else {
        await _clear(channel);
      }
    }
    final code = PairingCode.create(digits, taken);
    final spake = _offered = Spake2(Spake2Role.a, code._password, aad: _aad);
    await _write(_path(code.channel, 'a'), {
      'message': base64.encode(spake.message),
      'holdsKey': holdsKey,
      'device': deviceName,
      'created': _clock().millisecondsSinceEpoch,
    });
    return code;
  }

  /// Waits for the device that took [code] from [offer], then sends or
  /// receives the key.
  Future<PairingResult> finishOffer(PairingCode code,
      {bool Function()? cancelled}) async {
    final spake = _offered!;
    final deadline = _clock().add(timeout);
    final channel = code.channel;
    Map<String, Object?> b;
    try {
      b = await _wait(_path(channel, 'b'), deadline, cancelled);
    } on PairingException {
      await _clear(channel);
      rethrow;
    }
    final Spake2Keys keys;
    try {
      keys = spake.finish(base64.decode(b['message'] as String));
    } on FormatException {
      throw await _fail(channel, PairingFailure.wrongCode);
    }
    if (!keys.verify(base64.decode(b['confirm'] as String))) {
      throw await _fail(channel, PairingFailure.wrongCode);
    }
    final mismatch = _mismatch(b['holdsKey'] as bool);
    if (mismatch != null) throw await _fail(channel, mismatch);
    try {
      await _write(_path(channel, 'a2'), {
        'confirm': base64.encode(keys.confirmation),
        if (holdsKey) 'key': await _sealIdentity(keys, channel),
      });
      final b2 = await _wait(_path(channel, 'b2'), deadline, cancelled);
      return (
        received: holdsKey ? null : await _openIdentity(keys, channel, b2),
        otherDevice: b['device'] as String,
      );
    } finally {
      await _clear(channel);
    }
  }

  /// Takes [code] from the device showing it, then sends or receives the
  /// key.
  Future<PairingResult> accept(PairingCode code,
      {bool Function()? cancelled}) async {
    final deadline = _clock().add(timeout);
    final aPath = _path(code.channel, 'a');
    final a = await _read(aPath);
    if (a == null || await _stale(aPath)) {
      throw const PairingException(PairingFailure.noOffer);
    }
    final spake = Spake2(Spake2Role.b, code._password, aad: _aad);
    final Spake2Keys keys;
    try {
      keys = spake.finish(base64.decode(a['message'] as String));
    } on FormatException {
      throw const PairingException(PairingFailure.wrongCode);
    }
    await _write(_path(code.channel, 'b'), {
      'message': base64.encode(spake.message),
      'confirm': base64.encode(keys.confirmation),
      'holdsKey': holdsKey,
      'device': deviceName,
    });
    final a2 = await _wait(_path(code.channel, 'a2'), deadline, cancelled);
    if (a2['failed'] case final String failed) {
      // The offer is over; what is left of it goes.
      await _clear(code.channel);
      throw PairingException(PairingFailure.values
              .where((failure) => failure.name == failed)
              .firstOrNull ??
          PairingFailure.wrongCode);
    }
    if (!keys.verify(base64.decode(a2['confirm'] as String))) {
      throw const PairingException(PairingFailure.wrongCode);
    }
    final mismatch = _mismatch(a['holdsKey'] as bool);
    if (mismatch != null) throw PairingException(mismatch);
    if (holdsKey) {
      await _write(_path(code.channel, 'b2'),
          {'key': await _sealIdentity(keys, code.channel)});
      return (received: null, otherDevice: a['device'] as String);
    }
    final received = await _openIdentity(keys, code.channel, a2);
    await _write(_path(code.channel, 'b2'), {'received': true});
    return (received: received, otherDevice: a['device'] as String);
  }

  /// Why the two devices cannot pair, given whether the other holds the
  /// key: exactly one must.
  PairingFailure? _mismatch(bool otherHoldsKey) =>
      switch ((holdsKey, otherHoldsKey)) {
        (true, true) => PairingFailure.bothHoldKey,
        (false, false) => PairingFailure.neitherHoldsKey,
        _ => null,
      };

  String _payloadAad(String channel) => '$_aad:key:$channel';

  Future<String> _sealIdentity(Spake2Keys keys, String channel) async =>
      base64.encode(await sealBytes(keys.derive('$_version key', 32),
          utf8.encode(jsonEncode(identity.toJson())), _payloadAad(channel)));

  Future<DiaryIdentity> _openIdentity(
      Spake2Keys keys, String channel, Map<String, Object?> message) async {
    final plain = await openBytes(keys.derive('$_version key', 32),
        base64.decode(message['key'] as String), _payloadAad(channel));
    return DiaryIdentity.fromJson(
        jsonDecode(utf8.decode(plain)) as Map<String, Object?>);
  }

  /// Ends [channel] for both devices: the offer goes, so the code is used
  /// up, and the device waiting learns why from what is left.
  Future<PairingException> _fail(String channel, PairingFailure failure) async {
    await _write(_path(channel, 'a2'), {'failed': failure.name});
    for (final message in ['a', 'b']) {
      await backend.delete(_path(channel, message));
    }
    return PairingException(failure);
  }

  Future<bool> _stale(String path) async {
    final message = await _read(path);
    final created = message?['created'];
    return created is! int ||
        _clock().millisecondsSinceEpoch - created > timeout.inMilliseconds;
  }

  Future<Map<String, Object?>> _wait(
      String path, DateTime deadline, bool Function()? cancelled) async {
    while (true) {
      if (cancelled?.call() ?? false) {
        throw const PairingException(PairingFailure.cancelled);
      }
      final message = await _read(path);
      if (message != null) return message;
      if (_clock().isAfter(deadline)) {
        throw const PairingException(PairingFailure.timedOut);
      }
      await Future<void>.delayed(poll);
    }
  }

  Future<Map<String, Object?>?> _read(String path) async {
    final bytes = await backend.read(path);
    return bytes == null
        ? null
        : jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
  }

  Future<void> _write(String path, Map<String, Object?> message) =>
      backend.write(path, Uint8List.fromList(utf8.encode(jsonEncode(message))));

  /// Removes [channel]'s files, whichever exist.
  Future<void> _clear(String channel) async {
    for (final message in ['a', 'b', 'a2', 'b2']) {
      try {
        await backend.delete(_path(channel, message));
      } on Exception {
        // Gone already, or the storage is unreachable: a stale offer is
        // cleared by the next one.
      }
    }
  }
}
