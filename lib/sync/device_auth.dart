// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DeviceAuthorizationNeeded implements Exception {
  @override
  String toString() => 'Device authorization required';
}

abstract interface class DeviceKeyStore {
  Future<Map<String, Object?>> ensure(String alias);
  Future<Uint8List> sign(String alias, List<int> message);
  Future<void> delete(String alias);
}

/// Native keys are created in Android Keystore / Windows CNG. No export method
/// exists. The provider reports hardware support rather than assuming it.
class NativeDeviceKeys implements DeviceKeyStore {
  const NativeDeviceKeys();
  static const _channel = MethodChannel('aid.device_keys');
  @override
  Future<Map<String, Object?>> ensure(String alias) async => (await _channel
      .invokeMapMethod<String, Object?>('ensure', {'alias': alias}))!;
  @override
  Future<Uint8List> sign(String alias, List<int> message) async {
    final result = await _channel.invokeMapMethod<String, Object?>(
        'sign', {'alias': alias, 'message': base64Encode(message)});
    return base64Decode(result!['signature'] as String);
  }

  @override
  Future<void> delete(String alias) =>
      _channel.invokeMethod<void>('delete', {'alias': alias});
}

Uri aidSyncApi(Uri server, String resource) {
  var path = server.path;
  if (!path.endsWith('/')) path = '$path/';
  final marker = path.endsWith('/dav/') ? path.length - 5 : -1;
  return server.replace(
      path: '${marker < 0 ? '' : path.substring(0, marker)}/api/sync/$resource',
      query: '',
      fragment: '');
}

String _serverKey(Uri server) => server
    .replace(
        path: server.path.endsWith('/') ? server.path : '${server.path}/',
        query: '',
        fragment: '')
    .toString();
bool _secure(Uri server) =>
    server.scheme == 'https' ||
    (server.scheme == 'http' &&
        (server.host == 'localhost' ||
            InternetAddress.tryParse(server.host)?.isLoopback == true));

class DeviceRegistration {
  DeviceRegistration(
      {required this.server,
      required this.username,
      required this.id,
      required this.alias,
      required this.publicKeySpki,
      required this.hardwareBacked,
      required this.provider,
      this.next});
  final Uri server;
  final String username, id, alias, publicKeySpki, provider;
  final bool hardwareBacked;
  final DeviceRegistration? next;
  String get fingerprint =>
      sha256.convert(base64Decode(publicKeySpki)).toString();
  Map<String, Object?> toJson() => {
        'server': _serverKey(server),
        'username': username,
        'id': id,
        'alias': alias,
        'publicKeySpki': publicKeySpki,
        'hardwareBacked': hardwareBacked,
        'provider': provider,
        if (next != null) 'next': next!.toJson()
      };
  factory DeviceRegistration.fromJson(Map<String, Object?> data) =>
      DeviceRegistration(
          server: Uri.parse(data['server'] as String),
          username: data['username'] as String,
          id: data['id'] as String,
          alias: data['alias'] as String,
          publicKeySpki: data['publicKeySpki'] as String,
          hardwareBacked: data['hardwareBacked'] as bool,
          provider: data['provider'] as String,
          next: data['next'] == null
              ? null
              : DeviceRegistration.fromJson(
                  (data['next'] as Map).cast<String, Object?>()));
}

/// Tokens live in memory only, are refreshed through native signatures, and are
/// never returned in GUI/action status. Each server/account has a separate key.
class DeviceAuthSession {
  DeviceAuthSession(this.registration, this.keys, this.client);
  final DeviceRegistration registration;
  final DeviceKeyStore keys;
  final http.Client client;
  String? _token;
  DateTime? _expires;
  Future<String>? _refresh;
  void invalidate() {
    _token = null;
    _expires = null;
  }

  Future<String> authorization() {
    if (_token != null &&
        DateTime.now().add(const Duration(seconds: 30)).isBefore(_expires!)) {
      return Future.value('Bearer $_token');
    }
    return _refresh ??= _issue().whenComplete(() => _refresh = null);
  }

  Future<String> _issue() async {
    final challenge = await request('POST', 'auth/challenge',
        body: {'username': registration.username, 'device': registration.id},
        authenticated: false);
    final id = challenge['challenge'] as String;
    final message = base64Decode(challenge['message'] as String);
    // A server must never turn the signing API into an enrollment/rotation
    // oracle, or request proof for a different account, device or public key.
    final expected =
        'aid-device-token-v1\n${registration.username}\n${registration.id}\n${registration.fingerprint}\n$id';
    if (!RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(id) ||
        utf8.decode(message) != expected) {
      throw const FormatException('Invalid device challenge');
    }
    final signature = await keys.sign(registration.alias, message);
    final result = await request('POST', 'auth/token',
        body: {'challenge': id, 'signature': base64Encode(signature)},
        authenticated: false);
    final token = result['token'] as String;
    final expires =
        DateTime.fromMillisecondsSinceEpoch((result['expires'] as int) * 1000);
    if (!RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(token) ||
        !expires.isAfter(DateTime.now()) ||
        expires.isAfter(DateTime.now().add(const Duration(hours: 24)))) {
      throw const FormatException('Invalid device token');
    }
    _token = token;
    _expires = expires;
    return 'Bearer $token';
  }

  Future<Map<String, dynamic>> request(String method, String resource,
      {Map<String, Object?>? body,
      bool authenticated = true,
      String? authorization}) async {
    if (!_secure(registration.server)) {
      throw StateError('Device authorization requires HTTPS');
    }
    final request =
        http.Request(method, aidSyncApi(registration.server, resource))
          ..followRedirects = false;
    if (authenticated || authorization != null) {
      request.headers['Authorization'] =
          authorization ?? await this.authorization();
    }
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    final response =
        await client.send(request).timeout(const Duration(seconds: 10));
    final bytes = BytesBuilder(copy: false);
    await for (final part
        in response.stream.timeout(const Duration(seconds: 10))) {
      if (bytes.length + part.length > 64 * 1024) {
        throw const FormatException('Device response too large');
      }
      bytes.add(part);
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      if (authenticated) invalidate();
      throw DeviceAuthorizationNeeded();
    }
    if (response.statusCode != 200) {
      throw HttpException('Device request failed (${response.statusCode})');
    }
    return jsonDecode(utf8.decode(bytes.takeBytes())) as Map<String, dynamic>;
  }

  Future<Map<String, Object?>> enrollment({bool rotation = false}) async {
    final message =
        '${rotation ? 'aid-device-rotate-v1\n' : ''}aid-device-enroll-v1\n${registration.username}\n${registration.id}\n${registration.publicKeySpki}';
    return {
      'id': registration.id,
      'label': LocalDevice.name,
      'publicKeySpki': registration.publicKeySpki,
      'signature': base64Encode(
          await keys.sign(registration.alias, utf8.encode(message)))
    };
  }
}

class DeviceAuthManager {
  DeviceAuthManager({this.keys = const NativeDeviceKeys(), http.Client? client})
      : client = client ?? http.Client();
  static final instance = DeviceAuthManager();
  final DeviceKeyStore keys;
  final http.Client client;
  final _sessions = <String, DeviceAuthSession>{};
  final _accountTails = <String, Future<void>>{};
  Future<void> _settingsTail = Future.value();
  Future<T> _account<T>(
      Uri server, String username, Future<T> Function() work) {
    final id = '${_serverKey(server)}\n${username.toLowerCase()}';
    final previous = _accountTails[id] ?? Future.value();
    final result = previous.then((_) => work());
    final tail = result.then<void>((_) {}, onError: (Object _) {});
    _accountTails[id] = tail;
    unawaited(tail.then((_) {
      if (identical(_accountTails[id], tail)) _accountTails.remove(id);
    }));
    return result;
  }

  Future<T> _settings<T>(Future<T> Function() work) {
    final result = _settingsTail.then((_) => work());
    _settingsTail = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  List<DeviceRegistration> get registrations {
    final stored = ConfigProvider.instance.get(Settings.deviceAuthorizations);
    return stored.isEmpty
        ? []
        : [
            for (final row in jsonDecode(stored) as List)
              DeviceRegistration.fromJson((row as Map).cast<String, Object?>())
          ];
  }

  DeviceRegistration? registration(Uri server, String username) => registrations
      .where((r) =>
          _serverKey(r.server) == _serverKey(server) &&
          r.username == username.toLowerCase())
      .firstOrNull;
  DeviceAuthSession? session(Uri server, String username) {
    final record = registration(server, username);
    if (record == null) return null;
    return _sessions.putIfAbsent(
        record.alias, () => DeviceAuthSession(record, keys, client));
  }

  Future<void> _save(DeviceRegistration record) => _settings(() async {
        final all = registrations
            .where((r) =>
                _serverKey(r.server) != _serverKey(record.server) ||
                r.username != record.username)
            .toList()
          ..add(record);
        await ConfigProvider.instance.set(Settings.deviceAuthorizations,
            jsonEncode(all.map((r) => r.toJson()).toList()));
      });

  Future<DeviceRegistration> _create(Uri server, String username,
      {String? id}) async {
    if (!_secure(server)) {
      throw StateError('Device authorization requires HTTPS');
    }
    final alias = 'aid-sync-${const Uuid().v4()}';
    final key = await keys.ensure(alias);
    final record = DeviceRegistration(
        server: server,
        username: username.toLowerCase(),
        id: id ?? const Uuid().v4(),
        alias: alias,
        publicKeySpki: key['publicKeySpki'] as String,
        hardwareBacked: key['hardwareBacked'] as bool,
        provider: key['provider'] as String);
    if (base64Decode(record.publicKeySpki).length > 1024) {
      throw const FormatException('Invalid device public key');
    }
    return record;
  }

  /// Ordinary DAV installations return false and retain their chosen login.
  Future<bool> prepare(Uri server, String username, String password) =>
      _account(server, username, () => _prepare(server, username, password));
  Future<bool> _prepare(Uri server, String username, String password) async {
    var record = registration(server, username);
    if (record == null) {
      final response = await client
          .get(aidSyncApi(server, 'devices/capabilities'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 404 ||
          response.statusCode == 405 ||
          response.statusCode == 401) {
        return false;
      }
      if (response.statusCode != 200 ||
          jsonDecode(response.body)['protocol'] != 'aid-device-auth-v1') {
        return false;
      }
      record = await _create(server, username);
      await _save(record);
    }
    if (record.next case final next?) {
      try {
        await DeviceAuthSession(next, keys, client).authorization();
        await _promote(record, next);
        record = next;
      } on DeviceAuthorizationNeeded {
        /* A rotation may not have reached the server. */
      }
    }
    final current = session(server, username)!;
    try {
      await current.authorization();
      return true;
    } on DeviceAuthorizationNeeded {
      if (password.isEmpty) rethrow;
      final basic =
          'Basic ${base64Encode(utf8.encode('${current.registration.username}:$password'))}';
      await current.request('POST', 'devices',
          body: await current.enrollment(),
          authenticated: false,
          authorization: basic);
      await current.authorization();
      return true;
    }
  }

  Future<String> authorizationRequest(Uri server, String username) =>
      _account(server, username, () => _authorizationRequest(server, username));
  Future<String> _authorizationRequest(Uri server, String username) async {
    var record = registration(server, username);
    if (record == null) {
      record = await _create(server, username);
      await _save(record);
    }
    final current = session(server, username)!;
    final request = {
      'server': _serverKey(server),
      'username': record.username,
      ...await current.enrollment()
    };
    return Uri(scheme: 'aid-device', host: 'authorize', queryParameters: {
      'v': '1',
      'request': base64UrlEncode(utf8.encode(jsonEncode(request)))
    }).toString();
  }

  Map<String, Object?> _authorizationBody(
      DeviceAuthSession current, String qr) {
    if (qr.length > 8192) {
      throw const FormatException('Device request too large');
    }
    final uri = Uri.parse(qr);
    if (uri.scheme != 'aid-device' ||
        uri.host != 'authorize' ||
        uri.userInfo.isNotEmpty ||
        uri.path.isNotEmpty ||
        uri.hasFragment ||
        uri.queryParameters['v'] != '1') {
      throw const FormatException('Invalid device request');
    }
    final request = jsonDecode(
            utf8.decode(base64Url.decode(uri.queryParameters['request']!)))
        as Map<String, dynamic>;
    if (request['server'] != _serverKey(current.registration.server) ||
        request['username'] != current.registration.username) {
      throw const FormatException('Device request belongs to another account');
    }
    return {
      for (final key in ['id', 'label', 'publicKeySpki', 'signature'])
        key: request[key]
    };
  }

  Future<void> authorize(DeviceAuthSession current, String qr) async {
    await current.request('POST', 'devices',
        body: _authorizationBody(current, qr));
  }

  Future<List<Map<String, dynamic>>> devices(DeviceAuthSession current) async =>
      ((await current.request('GET', 'devices'))['devices'] as List)
          .cast<Map<String, dynamic>>();
  Future<void> revoke(DeviceAuthSession current, String id) async {
    if (!RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(id)) {
      throw const FormatException('Invalid device');
    }
    await current.request('DELETE', 'devices/$id');
    if (id == current.registration.id) current.invalidate();
  }

  Future<void> _promote(DeviceRegistration old, DeviceRegistration next) async {
    await _save(next);
    _sessions.remove(old.alias)?.invalidate();
    await keys.delete(old.alias);
  }

  Future<void> rotate(DeviceAuthSession current) => _account(
      current.registration.server,
      current.registration.username,
      () => _rotate(current));
  Future<void> _rotate(DeviceAuthSession current) async {
    final old = current.registration;
    final next = registration(old.server, old.username)?.next ??
        await _create(old.server, old.username, id: old.id);
    // Save both native aliases before changing the server. A lost response or
    // process exit can safely discover which key the server retained on restart.
    await _save(DeviceRegistration(
        server: old.server,
        username: old.username,
        id: old.id,
        alias: old.alias,
        publicKeySpki: old.publicKeySpki,
        hardwareBacked: old.hardwareBacked,
        provider: old.provider,
        next: next));
    final candidate = DeviceAuthSession(next, keys, client);
    try {
      await current.request('POST', 'devices/rotate',
          body: await candidate.enrollment(rotation: true));
    } catch (_) {
      try {
        await candidate.authorization();
      } catch (_) {
        rethrow;
      }
    }
    await candidate.authorization();
    await _promote(old, next);
  }

  List<Map<String, dynamic>> get _approvals {
    final stored = ConfigProvider.instance.get(Settings.pendingDeviceApprovals);
    return stored.isEmpty
        ? []
        : (jsonDecode(stored) as List).cast<Map<String, dynamic>>();
  }

  /// The sender has already approved this key through the pinned SAS channel.
  /// Queue only its public, signed request, never passwords, MK or bearer tokens.
  Future<bool> queueAndAuthorize(
      DeviceAuthSession current, String request) async {
    _authorizationBody(current, request);
    await _settings(() async {
      final pending = _approvals;
      if (!pending.any((row) => row['request'] == request)) {
        if (pending.length >= 32) {
          throw StateError('Pending device authorization limit');
        }
        pending.add({
          'server': _serverKey(current.registration.server),
          'username': current.registration.username,
          'request': request
        });
        await ConfigProvider.instance
            .set(Settings.pendingDeviceApprovals, jsonEncode(pending));
      }
    });
    return flushApprovals(
        current.registration.server, current.registration.username);
  }

  Future<bool> flushApprovals(Uri server, String username) async {
    final current = session(server, username);
    if (current == null) return false;
    final pending = _approvals
        .where((row) =>
            row['server'] == _serverKey(server) &&
            row['username'] == username.toLowerCase())
        .toList();
    for (final row in pending) {
      try {
        await authorize(current, row['request'] as String);
      } on DeviceAuthorizationNeeded {
        return false;
      } on SocketException {
        return false;
      } on TimeoutException {
        return false;
      } on http.ClientException {
        return false;
      } on HttpException {
        return false;
      }
      await _settings(() async {
        final all = _approvals
          ..removeWhere((item) => item['request'] == row['request']);
        await ConfigProvider.instance
            .set(Settings.pendingDeviceApprovals, jsonEncode(all));
      });
    }
    return true;
  }
}
