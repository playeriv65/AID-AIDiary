// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/config_provider_harness.dart';

class _SignedIn implements GoogleAuth {
  @override
  Future<String> signIn({required String doneMessage}) async => 'a@b.c';
  @override
  Future<String> token({bool renew = false}) async => 'token';
  @override
  String get credential => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();

  setUp(() {
    final json = jsonDecode(File(AppConfig.assetPath).readAsStringSync())
        as Map<String, dynamic>;
    (json['sync'] as Map<String, dynamic>)['spaceFolder'] = 'Space folder';
    AppConfig.setForTesting(json);
  });

  test('WebDAV and Google Drive open the space in the configured folder', () {
    final webdav = WebDavLogin(
            server: Uri.parse('https://dav.example/dav/'),
            username: 'diary',
            password: 'secret')
        .backend();
    addTearDown(webdav.close);
    final drive =
        GoogleDriveLogin(username: 'a@b.c', auth: _SignedIn()).backend();

    expect(webdav.folder, 'Space folder');
    expect(drive.folder, 'Space folder');
  });
}
