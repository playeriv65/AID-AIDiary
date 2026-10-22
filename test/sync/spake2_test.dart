// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:typed_data';

import 'package:aid_diary/sync/spake2.dart';
import 'package:flutter_test/flutter_test.dart';

BigInt _int(String hex) => BigInt.parse(hex, radix: 16);

Uint8List _hex(String hex) => Uint8List.fromList([
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ]);

String _str(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

/// A test vector of RFC 9382, appendix B.
typedef _Vector = ({
  String idA,
  String idB,
  String w,
  String x,
  String pA,
  String y,
  String pB,
  String ke,
  String confA,
  String confB,
});

const _vectors = <_Vector>[
  (
    idA: 'server',
    idB: 'client',
    w: '2ee57912099d31560b3a44b1184b9b4866e904c49d12ac5042c97dca461b1a5f',
    x: '43dd0fd7215bdcb482879fca3220c6a968e66d70b1356cac18bb26c84a78d729',
    pA: '04a56fa807caaa53a4d28dbb9853b9815c61a411118a6fe516a8798434751470'
        'f9010153ac33d0d5f2047ffdb1a3e42c9b4e6be662766e1eeb4116988ede5f912c',
    y: 'dcb60106f276b02606d8ef0a328c02e4b629f84f89786af5befb0bc75b6e66be',
    pB: '0406557e482bd03097ad0cbaa5df82115460d951e3451962f1eaf4367a420676'
        'd09857ccbc522686c83d1852abfa8ed6e4a1155cf8f1543ceca528afb591a1e0b7',
    ke: '0e0672dc86f8e45565d338b0540abe69',
    confA: '58ad4aa88e0b60d5061eb6b5dd93e80d9c4f00d127c65b3b35b1b5281fee38f0',
    confB: 'd3e2e547f1ae04f2dbdbf0fc4b79f8ecff2dff314b5d32fe9fcef2fb26dc459b',
  ),
  (
    idA: '',
    idB: 'client',
    w: '0548d8729f730589e579b0475a582c1608138ddf7054b73b5381c7e883e2efae',
    x: '403abbe3b1b4b9ba17e3032849759d723939a27a27b9d921c500edde18ed654b',
    pA: '04a897b769e681c62ac1c2357319a3d363f610839c4477720d24cbe32f5fd8'
        '5f44fb92ba966578c1b712be6962498834078262caa5b441ecfa9d4a9485720e918a',
    y: '903023b6598908936ea7c929bd761af6039577a9c3f9581064187c3049d87065',
    pB: '04e0f816fd1c35e22065d5556215c097e799390d16661c386e0ecc84593974'
        'a61b881a8c82327687d0501862970c64565560cb5671f696048050ca66ca5f8cc7fc',
    ke: '642f05c473c2cd79909f9a841e2f30a7',
    confA: '47d29e6666af1b7dd450d571233085d7a9866e4d49d2645e2df975489521232b',
    confB: '3313c5cefc361d27fb16847a91c2a73b766ffa90a4839122a9b70a2f6bd1d6df',
  ),
];

void main() {
  for (final v in _vectors) {
    test('RFC 9382 vector A="${v.idA}" B="${v.idB}"', () {
      final a = Spake2.withSecrets(Spake2Role.a,
          w: _int(v.w), scalar: _int(v.x), idA: v.idA, idB: v.idB);
      final b = Spake2.withSecrets(Spake2Role.b,
          w: _int(v.w), scalar: _int(v.y), idA: v.idA, idB: v.idB);
      expect(_str(a.message), v.pA);
      expect(_str(b.message), v.pB);

      final keysA = a.finish(b.message);
      final keysB = b.finish(a.message);
      expect(_str(keysA.sharedKey), v.ke);
      expect(_str(keysB.sharedKey), v.ke);
      expect(_str(keysA.confirmation), v.confA);
      expect(_str(keysB.confirmation), v.confB);
      expect(keysA.verify(keysB.confirmation), isTrue);
      expect(keysB.verify(keysA.confirmation), isTrue);
    });
  }

  test('the same password agrees on a key, another one does not', () {
    final a = Spake2(Spake2Role.a, '12345678', aad: 'v1');
    final b = Spake2(Spake2Role.b, '12345678', aad: 'v1');
    final keysA = a.finish(b.message);
    final keysB = b.finish(a.message);
    expect(keysA.sharedKey, keysB.sharedKey);
    expect(keysB.verify(keysA.confirmation), isTrue);

    final wrong = Spake2(Spake2Role.b, '12345679', aad: 'v1');
    final keysWrong = wrong.finish(a.message);
    expect(a.finish(wrong.message).verify(keysWrong.confirmation), isFalse);
    expect(keysWrong.verify(keysA.confirmation), isFalse);
  });

  test('a point off the curve is refused', () {
    final a = Spake2(Spake2Role.a, 'pw');
    final bad = Uint8List.fromList(a.message)..[64] ^= 1;
    expect(() => a.finish(bad), throwsFormatException);
    expect(() => a.finish(_hex('04')), throwsFormatException);
  });
}
