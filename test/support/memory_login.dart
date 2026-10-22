// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_service.dart';

/// A sign-in to a storage held in memory, looking like a WebDAV one, so
/// the sync service runs end to end without a network.
class MemoryLogin implements SyncLogin {
  MemoryLogin([MemorySyncBackend? storage])
      : storage = storage ?? MemorySyncBackend();

  final MemorySyncBackend storage;

  @override
  SyncProvider get provider => SyncProvider.webdav;
  @override
  Uri? get server => Uri.parse('https://dav.example.test/');
  @override
  String get username => 'diary';
  @override
  String get credential => 'secret';
  @override
  SyncBackend backend() => storage;
}
