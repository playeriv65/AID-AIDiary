// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Two devices syncing through a real Google Drive, signed in with the
// app's desktop client. The sign-in page's address is written to the file
// named in AID_GOOGLE_LIVE; open it in a browser on this machine and allow
// access:
//
//   AID_GOOGLE_LIVE=D:/software/temp/google-sign-in.txt
//   flutter test --tags live test/sync/live_google_drive_test.dart
//
// Each test works in a Drive folder of its own and removes it afterwards.

@Tags(['live'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/live_sync_scenarios.dart';

void main() {
  final urlFile = Platform.environment['AID_GOOGLE_LIVE'];
  final run = 'aid-live-${DateTime.now().millisecondsSinceEpoch}';
  var folder = run;
  var tests = 0;
  late DesktopGoogleAuth auth;
  late GoogleDriveConfig config;

  GoogleDriveBackend backend() => GoogleDriveBackend(
      api: config.apiUrl,
      upload: config.uploadUrl,
      token: auth.token,
      folder: folder);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The test binding answers every HTTP request with 400; this suite
    // talks to Google.
    HttpOverrides.global = null;
    sqfliteFfiInit();
    if (urlFile == null) return;
    config = (await AppConfig.load()).googleDrive;
    auth = DesktopGoogleAuth(
        config: config,
        openBrowser: (uri) async {
          await File(urlFile).writeAsString('$uri');
          return true;
        });
    await auth.signIn(doneMessage: 'AID Diary live test signed in');
  });

  setUp(() => folder = '$run-${++tests}');

  tearDown(() async {
    if (urlFile == null) return;
    // The backend removes files only; the space folder goes here, with
    // what is left inside it.
    final headers = {'Authorization': 'Bearer ${await auth.token()}'};
    final found = await http.get(
        config.apiUrl.resolve('files').replace(queryParameters: {
          'q': "name = '$folder' and 'root' in parents and trashed = false",
          'fields': 'files(id)',
        }),
        headers: headers);
    for (final file in (jsonDecode(found.body)['files'] as List)) {
      await http.delete(config.apiUrl.resolve('files/${file['id']}'),
          headers: headers);
    }
  });

  liveSyncScenarios(backend,
      skip: urlFile == null
          ? 'Set AID_GOOGLE_LIVE to sign in to Google Drive'
          : null);
}
