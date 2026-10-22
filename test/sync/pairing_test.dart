// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

const _cheap = KdfParams(memoryKiB: 64, iterations: 1);

/// Why [pairing] failed; null when it worked.
Future<PairingFailure?> failureOf(Future<Object?> pairing) async {
  try {
    await pairing;
    return null;
  } on PairingException catch (e) {
    return e.failure;
  }
}

void main() {
  late MemorySyncBackend storage;
  late DiaryIdentity owner;
  late DiaryIdentity stranger;
  late SpaceInfo space;
  var now = DateTime(2026, 10, 22, 9);

  Pairing device(DiaryIdentity identity, String name) => Pairing(
      backend: storage,
      space: space,
      identity: identity,
      holdsKey: identity.userId == space.userId,
      deviceName: name,
      poll: const Duration(milliseconds: 5),
      timeout: const Duration(seconds: 5),
      clock: () => now);

  setUp(() async {
    storage = MemorySyncBackend();
    owner = DiaryIdentity.create();
    stranger = DiaryIdentity.create();
    now = DateTime(2026, 10, 22, 9);
    space = await SpaceInfo.create(owner,
        recoveryCode: 'unused', generated: true, kdf: _cheap);
  });

  Future<(PairingResult, PairingResult)> pair(Pairing shows, Pairing types,
      {String Function(String)? typing}) async {
    final code = await shows.offer(8);
    final typed = PairingCode.parse(typing?.call(code.typed) ?? code.typed, 8)!;
    final results =
        await Future.wait([shows.finishOffer(code), types.accept(typed)]);
    return (results[0], results[1]);
  }

  test('the device with the key shows the code; the new one types it',
      () async {
    final (shown, typed) =
        await pair(device(owner, 'Phone'), device(stranger, 'Tablet'));
    expect(shown.received, isNull);
    expect(shown.otherDevice, 'Tablet');
    expect(typed.received!.userId, owner.userId);
    expect(typed.received!.masterKey, owner.masterKey);
    expect(typed.otherDevice, 'Phone');
    expect(await storage.list('pairing'), isEmpty, reason: 'cleared after');
  });

  test('the new device shows the code; the one with the key scans it',
      () async {
    final (shown, scanned) = await pair(
        device(stranger, 'Tablet'), device(owner, 'Phone'),
        typing: (code) => 'aid-pair:$code');
    expect(shown.received!.masterKey, owner.masterKey);
    expect(scanned.received, isNull);
    // What it received opens the space.
    expect(await space.dataKey(shown.received!.masterKey), hasLength(32));
    expect(await storage.list('pairing'), isEmpty);
  });

  test('a wrong code ends the offer on both devices; the next one works',
      () async {
    final shows = device(owner, 'Phone');
    final code = await shows.offer(8);
    final last = code.secret.substring(code.secret.length - 1);
    final wrong = PairingCode.parse(
        '${code.typed.substring(0, code.typed.length - 1)}'
        '${last == '0' ? '1' : '0'}',
        8)!;
    final outcomes = await Future.wait([
      failureOf(shows.finishOffer(code)),
      failureOf(device(stranger, 'Tablet').accept(wrong)),
    ]);
    expect(outcomes, [PairingFailure.wrongCode, PairingFailure.wrongCode]);
    expect(await storage.list('pairing'), isEmpty);
    // The used code is gone for good.
    await expectLater(
        device(stranger, 'Tablet').accept(code),
        throwsA(isA<PairingException>()
            .having((e) => e.failure, 'failure', PairingFailure.noOffer)));
    final (_, typed) =
        await pair(device(owner, 'Phone'), device(stranger, 'Tablet'));
    expect(typed.received!.userId, owner.userId);
  });

  test('exactly one of the two devices must hold the key', () async {
    Future<List<PairingFailure?>> outcomes(Pairing a, Pairing b) async {
      final code = await a.offer(8);
      return Future.wait([
        failureOf(a.finishOffer(code)),
        failureOf(b.accept(code)),
      ]);
    }

    expect(await outcomes(device(owner, 'A'), device(owner, 'B')),
        everyElement(PairingFailure.bothHoldKey));
    expect(await outcomes(device(stranger, 'A'), device(stranger, 'B')),
        everyElement(PairingFailure.neitherHoldsKey));
  });

  test('an offer expires, and the next offer clears it away', () async {
    final code = await device(owner, 'Phone').offer(8);
    now = now.add(const Duration(seconds: 6));
    await expectLater(
        device(stranger, 'Tablet').accept(code),
        throwsA(isA<PairingException>()
            .having((e) => e.failure, 'failure', PairingFailure.noOffer)));
    final next = await device(owner, 'Phone').offer(8);
    expect((await storage.list('pairing')).keys,
        ['pairing/${next.channel}-a.json']);
  });

  test('codes read however they are typed or scanned', () {
    final code = PairingCode.parse(' 12 345-678 ', 8)!;
    expect(code.typed, '12-345678');
    expect(PairingCode.parse(code.scannable, 8)!.typed, '12-345678');
    expect(PairingCode.parse('12-34567', 8), isNull);
    expect(PairingCode.parse('12-34567x', 8), isNull);
  });
}
