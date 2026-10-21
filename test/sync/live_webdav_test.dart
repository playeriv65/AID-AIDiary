// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Two devices syncing through a real WebDAV server, end to end encrypted.
// Runs only against a server named in the environment:
//
//   AID_SYNC_URL=https://example.com/dav/ AID_SYNC_USER=aid
//   AID_SYNC_PASSWORD=... flutter test --tags live
//
// Each test works in a folder of its own and removes it afterwards.

@Tags(['live'])
library;

import 'dart:io';

import 'package:aid_diary/sync/webdav_backend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/live_sync_scenarios.dart';

void main() {
  final env = Platform.environment;
  final url = env['AID_SYNC_URL'];
  final run = 'aid-live-${DateTime.now().millisecondsSinceEpoch}';
  // Each test gets its own space.
  var folder = run;
  var tests = 0;

  WebDavBackend backend() => WebDavBackend(
      server: Uri.parse(url!),
      username: env['AID_SYNC_USER'] ?? '',
      password: env['AID_SYNC_PASSWORD'] ?? '',
      folder: folder);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The test binding answers every HTTP request with 400; this suite
    // talks to a real server.
    HttpOverrides.global = null;
    sqfliteFfiInit();
  });

  setUp(() => folder = '$run-${++tests}');

  tearDown(() async {
    if (url != null) await backend().delete('');
  });

  liveSyncScenarios(backend,
      skip: url == null ? 'Set AID_SYNC_URL to sync with a server' : null);
}
