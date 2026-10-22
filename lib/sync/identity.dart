// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/utils/crypto_utils.dart';
import 'package:uuid/uuid.dart';

/// Whose diary this is. Made on the first start, with no account or
/// password: a random user id and a 256-bit master key, kept in the
/// platform's secure storage. Every device of the user holds the same pair,
/// passed from one to the next by pairing (sync/pairing.dart) or restored
/// with the recovery code; the master key locks the keys of the user's sync
/// spaces, and nothing leaves the device unencrypted by it.
class DiaryIdentity {
  const DiaryIdentity({required this.userId, required this.masterKey});

  factory DiaryIdentity.create() => DiaryIdentity(
      userId: const Uuid().v4(), masterKey: secureRandomBytes(masterKeyLength));

  static const int masterKeyLength = 32;

  final String userId;
  final Uint8List masterKey;

  Map<String, Object?> toJson() =>
      {'userId': userId, 'masterKey': base64.encode(masterKey)};

  factory DiaryIdentity.fromJson(Map<String, Object?> json) {
    final key = base64.decode(json['masterKey'] as String);
    if (key.length != masterKeyLength) {
      throw const FormatException('A master key is 32 bytes');
    }
    return DiaryIdentity(userId: json['userId'] as String, masterKey: key);
  }

  /// This device's identity, made and kept on first use.
  static Future<DiaryIdentity> current() async {
    final stored = ConfigProvider.instance.get(Settings.identity);
    if (stored.isNotEmpty) {
      return DiaryIdentity.fromJson(jsonDecode(stored) as Map<String, Object?>);
    }
    final identity = DiaryIdentity.create();
    await identity.keep();
    return identity;
  }

  /// Makes this the device's identity, as when it joins another device's.
  Future<void> keep() =>
      ConfigProvider.instance.set(Settings.identity, jsonEncode(toJson()));
}
