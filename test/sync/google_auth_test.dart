// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_auth.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Google's token endpoint: codes, refresh tokens and their revocation.
class FakeTokens {
  final List<Map<String, String>> requests = [];
  String? verifier;
  var revoked = false;

  /// What the user ticked on the consent page.
  var granted = '${GoogleDriveBackend.scope} openid email';
  var _issued = 0;

  String _idToken(String email) =>
      'header.${base64Url.encode(utf8.encode(jsonEncode({
                'email': email
              }))).replaceAll('=', '')}.signature';

  late final http.Client client = MockClient((request) async {
    final fields = Uri.splitQueryString(request.body);
    requests.add(fields);
    expect(fields['client_id'], 'desktop-client');
    expect(fields['client_secret'], 'desktop-secret');
    if (fields['grant_type'] == 'refresh_token' && revoked) {
      return http.Response(jsonEncode({'error': 'invalid_grant'}), 400);
    }
    if (fields['grant_type'] == 'authorization_code') {
      verifier = fields['code_verifier'];
      expect(fields['code'], 'the-code');
    }
    return http.Response(
        jsonEncode({
          'access_token': 'access-${++_issued}',
          // Already within the minute kept in hand, so the next ask renews.
          'expires_in': 30,
          'scope': granted,
          if (fields['grant_type'] == 'authorization_code') ...{
            'refresh_token': 'refresh-token',
            'id_token': _idToken('writer@example.com'),
          },
        }),
        200);
  });
}

void main() {
  setUpAll(() {
    // The browser's visit to the loopback port is a real request.
    HttpOverrides.global = null;
    AppConfig.setForTesting({
      'sync': {
        'googleDrive': {
          'webClientId': 'web-client',
          'desktopClientId': 'desktop-client',
          'desktopClientSecret': 'desktop-secret',
          'authUrl': 'https://accounts.example/auth',
          'tokenUrl': 'https://oauth.example/token',
          'apiUrl': 'https://drive.example/drive/v3/',
          'uploadUrl': 'https://drive.example/upload/drive/v3/',
          'signInTimeoutMinutes': 1,
        },
      },
    });
  });

  /// A browser that signs straight in and returns to the app, answering
  /// with [state] in place of the one it was given when that is set.
  Future<bool> Function(Uri) browser(List<String> pages,
          {String? state, List<Uri>? opened}) =>
      (uri) async {
        opened?.add(uri);
        final query = uri.queryParameters;
        final back = Uri.parse(query['redirect_uri']!).replace(
            queryParameters: {
              'code': 'the-code',
              'state': state ?? query['state']!
            });
        unawaited(http.get(back).then((response) => pages.add(response.body)));
        return true;
      };

  test('signs in through the browser with PKCE and keeps the refresh token',
      () async {
    final tokens = FakeTokens();
    final pages = <String>[];
    final opened = <Uri>[];
    final auth = DesktopGoogleAuth(
        config: AppConfig.instance.googleDrive,
        client: tokens.client,
        openBrowser: browser(pages, opened: opened));

    expect(
        await auth.signIn(doneMessage: 'Done & dusted'), 'writer@example.com');

    final query = opened.single.queryParameters;
    expect(opened.single.host, 'accounts.example');
    expect(query['client_id'], 'desktop-client');
    expect(query['scope'], contains(GoogleDriveBackend.scope));
    expect(query['access_type'], 'offline');
    expect(Uri.parse(query['redirect_uri']!).host, '127.0.0.1');
    expect(query['code_challenge_method'], 'S256');
    expect(
        query['code_challenge'],
        base64Url
            .encode(sha256.convert(ascii.encode(tokens.verifier!)).bytes)
            .replaceAll('=', ''));
    expect(auth.credential, 'refresh-token');
    await pumpEventQueue();
    expect(pages.single, contains('Done &amp; dusted'));
  });

  test('tokens are renewed with the kept refresh token', () async {
    final tokens = FakeTokens();
    final auth = DesktopGoogleAuth(
        config: AppConfig.instance.googleDrive,
        client: tokens.client,
        refreshToken: 'refresh-token');

    expect(await auth.token(), 'access-1');
    expect(await auth.token(renew: true), 'access-2');
    expect(tokens.requests.map((r) => r['grant_type']),
        everyElement('refresh_token'));

    tokens.revoked = true;
    expect(auth.token(renew: true), throwsA(isA<GoogleSignInNeeded>()));
  });

  test('without a sign-in there is no token to give', () {
    final auth = DesktopGoogleAuth(
        config: AppConfig.instance.googleDrive, client: FakeTokens().client);
    expect(auth.token(), throwsA(isA<GoogleSignInNeeded>()));
  });

  test('a sign-in with Drive left unticked is not taken', () async {
    final tokens = FakeTokens()..granted = 'openid email';
    final auth = DesktopGoogleAuth(
        config: AppConfig.instance.googleDrive,
        client: tokens.client,
        openBrowser: browser([]));

    await expectLater(
        auth.signIn(doneMessage: ''), throwsA(isA<GoogleDriveNotAllowed>()));
    expect(auth.credential, isEmpty);
  });

  test('an answer for another sign-in is refused', () async {
    final tokens = FakeTokens();
    final auth = DesktopGoogleAuth(
        config: AppConfig.instance.googleDrive,
        client: tokens.client,
        openBrowser: browser([], state: 'forged'));

    await expectLater(auth.signIn(doneMessage: ''), throwsA(isA<StateError>()));
    expect(tokens.requests, isEmpty);
  });
}
