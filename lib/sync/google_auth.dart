// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/sync/google_drive_backend.dart';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Google no longer lets this device use Drive without the user: they
/// revoked access, or the sign-in expired. Connect again to go on.
class GoogleSignInNeeded implements Exception {
  const GoogleSignInNeeded();

  @override
  String toString() => 'Google sign-in is needed again';
}

/// The user signed in but left Drive unticked on Google's consent page,
/// where each access is a choice of its own.
class GoogleDriveNotAllowed implements Exception {
  const GoogleDriveNotAllowed();

  @override
  String toString() => 'Access to Google Drive was not allowed';
}

/// Signs the user in to Google for Drive and hands out access tokens.
abstract interface class GoogleAuth {
  /// Google's own sign-in on Android, the browser on Windows. [credential]
  /// is what an earlier sign-in left to keep.
  factory GoogleAuth.forPlatform({String credential = ''}) {
    final config = AppConfig.instance.googleDrive;
    return Platform.isAndroid
        ? AndroidGoogleAuth(serverClientId: config.webClientId)
        : DesktopGoogleAuth(config: config, refreshToken: credential);
  }

  /// Whether this build is registered for Google sign-in on this platform.
  static bool get available {
    final config = AppConfig.instance.googleDrive;
    return Platform.isAndroid
        ? config.webClientId.isNotEmpty
        : config.desktopClientId.isNotEmpty;
  }

  /// Asks the user to sign in and allow Drive; returns their address.
  /// [doneMessage] is shown where the sign-in happened, when that is a
  /// browser tab the app cannot close.
  Future<String> signIn({required String doneMessage});

  /// An access token for Drive, got without the user; a new one when
  /// [renew] is set after the last one was refused.
  Future<String> token({bool renew = false});

  /// What to keep, secretly, to get tokens later.
  String get credential;
}

/// Google Play services' sign-in: it keeps the grant itself.
class AndroidGoogleAuth implements GoogleAuth {
  AndroidGoogleAuth({required this.serverClientId});

  final String serverClientId;
  static Future<void>? _initialized;
  GoogleSignInAccount? _account;
  String? _token;

  Future<void> _initialize() => _initialized ??=
      GoogleSignIn.instance.initialize(serverClientId: serverClientId);

  @override
  String get credential => '';

  @override
  Future<String> signIn({required String doneMessage}) async {
    await _initialize();
    final account = await GoogleSignIn.instance
        .authenticate(scopeHint: const [GoogleDriveBackend.scope]);
    _account = account;
    _token = (await account.authorizationClient
            .authorizeScopes(const [GoogleDriveBackend.scope]))
        .accessToken;
    return account.email;
  }

  @override
  Future<String> token({bool renew = false}) async {
    await _initialize();
    final stale = _token;
    if (renew && stale != null) {
      await _account?.authorizationClient
          .clearAuthorizationToken(accessToken: stale);
    }
    if (!renew && stale != null) return stale;
    final account = _account ??=
        await GoogleSignIn.instance.attemptLightweightAuthentication();
    final authorization = await account?.authorizationClient
        .authorizationForScopes(const [GoogleDriveBackend.scope]);
    if (authorization == null) throw const GoogleSignInNeeded();
    return _token = authorization.accessToken;
  }
}

/// The browser sign-in for installed apps: Google sends the browser back to
/// a port on this machine, and the refresh token it then gives is kept.
class DesktopGoogleAuth implements GoogleAuth {
  DesktopGoogleAuth(
      {required this.config,
      String refreshToken = '',
      http.Client? client,
      Future<bool> Function(Uri uri)? openBrowser})
      : _refreshToken = refreshToken,
        _client = client ?? http.Client(),
        _openBrowser = openBrowser ??
            ((uri) => launchUrl(uri, mode: LaunchMode.externalApplication));

  final GoogleDriveConfig config;
  final http.Client _client;
  final Future<bool> Function(Uri uri) _openBrowser;
  String _refreshToken;
  String? _token;
  DateTime _expires = DateTime(0);

  @override
  String get credential => _refreshToken;

  static String _random(int bytes) => base64Url
      .encode(List.generate(bytes, (_) => Random.secure().nextInt(256)))
      .replaceAll('=', '');

  @override
  Future<String> signIn({required String doneMessage}) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    try {
      final redirect = 'http://${server.address.address}:${server.port}';
      final verifier = _random(48);
      final state = _random(16);
      final opened =
          await _openBrowser(config.authUrl.replace(queryParameters: {
        'client_id': config.desktopClientId,
        'redirect_uri': redirect,
        'response_type': 'code',
        'scope': '${GoogleDriveBackend.scope} openid email',
        'code_challenge': base64Url
            .encode(sha256.convert(ascii.encode(verifier)).bytes)
            .replaceAll('=', ''),
        'code_challenge_method': 'S256',
        'state': state,
        'access_type': 'offline',
        'prompt': 'consent',
      }));
      if (!opened) throw StateError('Could not open the browser');
      final code = await _answer(server, state, doneMessage)
          .timeout(config.signInTimeout);
      final tokens = await _tokens({
        'grant_type': 'authorization_code',
        'code': code,
        'code_verifier': verifier,
        'redirect_uri': redirect,
      });
      final granted = (tokens['scope'] as String).split(' ');
      if (!granted.contains(GoogleDriveBackend.scope)) {
        throw const GoogleDriveNotAllowed();
      }
      _refreshToken = tokens['refresh_token'] as String;
      return _email(tokens['id_token'] as String);
    } finally {
      await server.close(force: true);
    }
  }

  /// Waits for Google to send the browser back, and answers it.
  Future<String> _answer(
      HttpServer server, String state, String doneMessage) async {
    await for (final request in server) {
      final query = request.uri.queryParameters;
      if (!query.containsKey('code') && !query.containsKey('error')) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      request.response.headers.contentType = ContentType.html;
      request.response.write('<!doctype html><meta charset="utf-8">'
          '<title>AID Diary</title>'
          '<p style="font:18px sans-serif;margin:3em;text-align:center">'
          '${const HtmlEscape().convert(doneMessage)}</p>');
      await request.response.close();
      if (query['state'] != state) throw StateError('Sign-in state mismatch');
      final code = query['code'];
      if (code == null) throw StateError('Google sign-in: ${query['error']}');
      return code;
    }
    throw StateError('Sign-in ended without an answer');
  }

  Future<Map<String, Object?>> _tokens(Map<String, String> fields) async {
    final response = await _client.post(config.tokenUrl, body: {
      'client_id': config.desktopClientId,
      'client_secret': config.desktopClientSecret,
      ...fields,
    });
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;
    if (response.statusCode == 400 && json['error'] == 'invalid_grant') {
      throw const GoogleSignInNeeded();
    }
    if (response.statusCode != 200) {
      throw StateError('Google sign-in failed: ${json['error']}');
    }
    _token = json['access_token'] as String;
    // A minute early, so a token never runs out on the way.
    _expires =
        DateTime.now().add(Duration(seconds: (json['expires_in'] as int) - 60));
    return json;
  }

  /// The address in an ID token, which comes straight from Google over
  /// TLS, so it is read without checking its signature.
  static String _email(String idToken) {
    final payload = idToken.split('.')[1];
    final json =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(payload))))
            as Map<String, Object?>;
    return json['email'] as String;
  }

  @override
  Future<String> token({bool renew = false}) async {
    final token = _token;
    if (!renew && token != null && DateTime.now().isBefore(_expires)) {
      return token;
    }
    if (_refreshToken.isEmpty) throw const GoogleSignInNeeded();
    await _tokens(
        {'grant_type': 'refresh_token', 'refresh_token': _refreshToken});
    return _token!;
  }
}
