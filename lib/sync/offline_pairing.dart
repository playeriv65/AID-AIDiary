// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/sync/identity.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/utils/crypto_utils.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

// RFC 7748 X25519 and RFC 5869 HKDF bind an ephemeral channel to the public
// key physically scanned from the owner's QR. A matching SAS must be confirmed
// on both devices before MK is released. No long-term signing key is exported.
const _protocol = 'aid-offline-pair-v1';
const _maxBody = 16 * 1024;
final _id = RegExp(r'^[a-f0-9]{32}$');
final _x25519 = X25519();
final _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

enum OfflinePairingStage {
  waiting,
  comparing,
  approved,
  transferred,
  cancelled
}

class OfflinePairingInvite {
  OfflinePairingInvite(
      {required this.session,
      required this.publicKey,
      required this.expires,
      required this.endpoints}) {
    if (!_id.hasMatch(session) ||
        publicKey.length != 32 ||
        endpoints.isEmpty ||
        endpoints.length > 8 ||
        endpoints.any((e) => !_endpoint(e))) {
      throw const FormatException('Invalid nearby invitation');
    }
  }
  final String session;
  final Uint8List publicKey;
  final DateTime expires;
  final List<Uri> endpoints;

  String get qr => Uri(scheme: 'aid-nearby', host: 'pair', queryParameters: {
        'v': '1',
        'session': session,
        'key': base64UrlEncode(publicKey),
        'expires': '${expires.millisecondsSinceEpoch}',
        'endpoints': jsonEncode(endpoints.map((e) => e.toString()).toList()),
      }).toString();

  factory OfflinePairingInvite.parse(String qr) {
    if (qr.length > 4096) {
      throw const FormatException('Nearby invitation too large');
    }
    final uri = Uri.parse(qr);
    final p = uri.queryParameters;
    if (uri.scheme != 'aid-nearby' ||
        uri.host != 'pair' ||
        p['v'] != '1' ||
        uri.userInfo.isNotEmpty ||
        uri.path.isNotEmpty ||
        uri.hasFragment) {
      throw const FormatException('Invalid nearby invitation');
    }
    final addresses = jsonDecode(p['endpoints'] ?? '') as List;
    return OfflinePairingInvite(
        session: p['session'] ?? '',
        publicKey: base64Url.decode(p['key'] ?? ''),
        expires:
            DateTime.fromMillisecondsSinceEpoch(int.parse(p['expires'] ?? '')),
        endpoints: addresses.map((e) => Uri.parse(e as String)).toList());
  }
}

bool _endpoint(Uri uri) =>
    uri.scheme == 'http' &&
    uri.userInfo.isEmpty &&
    uri.port > 0 &&
    uri.port <= 65535 &&
    !uri.hasQuery &&
    !uri.hasFragment &&
    (uri.path.isEmpty || uri.path == '/') &&
    InternetAddress.tryParse(uri.host) != null &&
    !InternetAddress(uri.host).isMulticast;

String _nonce() => secureRandomBytes(16)
    .map((b) => b.toRadixString(16).padLeft(2, '0'))
    .join();
String _transcript(
        OfflinePairingInvite invite, List<int> receiver, String nonce) =>
    jsonEncode([
      _protocol,
      invite.session,
      base64Encode(invite.publicKey),
      base64Encode(receiver),
      nonce,
      invite.expires.millisecondsSinceEpoch,
    ]);

Future<Uint8List> _derive(
    SimpleKeyPair key, List<int> remote, String transcript) async {
  if (remote.length != 32) throw const FormatException('Invalid ephemeral key');
  final shared = await _x25519.sharedSecretKey(
      keyPair: key,
      remotePublicKey: SimplePublicKey(remote, type: KeyPairType.x25519));
  final check = await shared.extractBytes();
  if (check.every((b) => b == 0)) {
    throw const FormatException('Invalid shared secret');
  }
  final derived = await _hkdf.deriveKey(
      secretKey: shared,
      nonce: utf8.encode(_protocol),
      info: utf8.encode(transcript));
  return Uint8List.fromList(await derived.extractBytes());
}

Future<String> _sas(Uint8List key, String transcript) async {
  final mac = await Hmac.sha256()
      .calculateMac(utf8.encode('sas:$transcript'), secretKey: SecretKey(key));
  final number =
      ByteData.sublistView(Uint8List.fromList(mac.bytes)).getUint32(0) %
          1000000;
  return number.toString().padLeft(6, '0');
}

Future<Map<String, dynamic>> _read(Stream<List<int>> body) async {
  final builder = BytesBuilder(copy: false);
  await for (final bytes in body.timeout(const Duration(seconds: 10))) {
    if (builder.length + bytes.length > _maxBody) {
      throw const FormatException('Nearby message too large');
    }
    builder.add(bytes);
  }
  final value = jsonDecode(utf8.decode(builder.takeBytes()));
  if (value is! Map<String, dynamic>) {
    throw const FormatException('Invalid nearby message');
  }
  return value;
}

/// One owner-approved, expiring invitation. Only ephemeral public material is
/// displayed in QR; identity stays sealed until the owner confirms the SAS.
class OfflinePairingHost extends ChangeNotifier {
  OfflinePairingHost(
      {required this.identity,
      this.transfer,
      this.account,
      this.authorizeDevice,
      this.lifetime = const Duration(minutes: 2),
      Future<HttpServer> Function(InternetAddress, int)? bindServer,
      DateTime Function()? now})
      : _now = now ?? DateTime.now,
        _bindServer = bindServer ??
            ((address, port) => HttpServer.bind(address, port, v6Only: false));
  final DiaryIdentity identity;

  /// Optional migration capability, released only inside the approved channel.
  final Map<String, Object?>? transfer;
  final Map<String, Object?>? account;
  final Future<bool> Function(String request)? authorizeDevice;
  String? _deviceRequest;
  Future<bool>? _deviceApproval;
  final Duration lifetime;
  final DateTime Function() _now;
  final Future<HttpServer> Function(InternetAddress, int) _bindServer;
  OfflinePairingStage stage = OfflinePairingStage.waiting;
  String? sas;
  OfflinePairingInvite? _invite;
  SimpleKeyPair? _key;
  Uint8List? _channel;
  String? _binding;
  String? _receiverNonce;
  HttpServer? _server;
  Timer? _expiry;
  int _lastSequence = 0;
  int _active = 0;
  bool _closed = false;
  bool _started = false;
  bool _notifierDisposed = false;
  final _finished = Completer<void>();
  Future<void> get finished => _finished.future;

  Future<OfflinePairingInvite> start(
      {InternetAddress? bind, List<InternetAddress>? addresses}) async {
    if (_started || _closed || lifetime <= Duration.zero) {
      throw StateError('Invitation cannot start');
    }
    _started = true;
    try {
      final key = await _x25519.newKeyPair();
      if (_closed) throw StateError('Invitation closed');
      _key = key;
      final server = await _bindServer(bind ?? InternetAddress.anyIPv6, 0);
      // close() can finish while bind is pending. Close the newly returned
      // listener locally rather than publishing a port after cancellation.
      if (_closed) {
        await server.close(force: true);
        throw StateError('Invitation closed');
      }
      _server = server;
      final available = addresses ??
          [
            for (final interface
                in await NetworkInterface.list(includeLinkLocal: false))
              for (final address in interface.addresses)
                if (!address.isLoopback) address,
          ];
      if (_closed) throw StateError('Invitation closed');
      final publicKey = await key.extractPublicKey();
      if (_closed) throw StateError('Invitation closed');
      final invite = _invite = OfflinePairingInvite(
          session: _nonce(),
          publicKey: Uint8List.fromList(publicKey.bytes),
          expires: _now().add(lifetime),
          endpoints: [
            for (final address in available.take(8))
              Uri(scheme: 'http', host: address.address, port: server.port),
          ]);
      server.listen((request) => unawaited(_handle(request)));
      _expiry = Timer(lifetime, () => unawaited(close()));
      return invite;
    } catch (_) {
      await close();
      rethrow;
    }
  }

  Future<void> confirm(String matchingSas) async {
    if (_closed ||
        stage != OfflinePairingStage.comparing ||
        matchingSas != sas ||
        !_now().isBefore(_invite!.expires)) {
      throw StateError('Compare the same code on both devices');
    }
    stage = OfflinePairingStage.approved;
    _notify();
  }

  Future<void> _handle(HttpRequest request) async {
    if (_closed || _active >= 4) {
      request.response.statusCode = 503;
      await request.response.close();
      return;
    }
    _active++;
    var acknowledged = false;
    try {
      if (!_now().isBefore(_invite!.expires)) {
        throw const FormatException('Expired invitation');
      }
      if (request.method != 'POST' || request.contentLength > _maxBody) {
        throw const FormatException('Invalid nearby request');
      }
      final message = await _read(request);
      if (message['session'] != _invite!.session) {
        throw const FormatException('Wrong invitation');
      }
      Map<String, Object?> response;
      if (request.uri.path == '/v1/nearby/hello') {
        if (stage != OfflinePairingStage.waiting) {
          throw StateError('Invitation already claimed');
        }
        // Claim before awaiting crypto, so simultaneous requests cannot establish
        // two receivers. A failed handshake burns this invitation.
        stage = OfflinePairingStage.comparing;
        final nonce = message['nonce'];
        if (nonce is! String || !_id.hasMatch(nonce)) {
          throw const FormatException('Invalid receiver nonce');
        }
        final receiver = base64Decode(message['key'] as String);
        final binding = _binding = _transcript(_invite!, receiver, nonce);
        _receiverNonce = nonce;
        final channel = await _derive(_key!, receiver, binding);
        if (_closed) {
          channel.fillRange(0, channel.length, 0);
          throw StateError('Invitation closed');
        }
        _channel = channel;
        sas = await _sas(channel, binding);
        response = {
          'sealed': base64Encode(await sealBytes(
              channel, utf8.encode('owner-ready'), '$binding:hello'))
        };
        _notify();
      } else {
        final key = _channel == null ? null : Uint8List.fromList(_channel!);
        final sequence = message['sequence'];
        if (key == null ||
            sequence is! int ||
            sequence <= _lastSequence ||
            sequence > 1000 ||
            message['nonce'] != _receiverNonce) {
          throw const FormatException('Invalid nearby sequence');
        }
        final plain = await openBytes(
            key,
            base64Decode(message['sealed'] as String),
            '$_binding:${request.uri.path}:$sequence');
        if (_closed || !_now().isBefore(_invite!.expires)) {
          throw StateError('Invitation closed');
        }
        final proofText = utf8.decode(plain);
        final proof = proofText == 'receiver-ready'
            ? <String, dynamic>{'proof': 'receiver-ready'}
            : jsonDecode(proofText) as Map<String, dynamic>;
        if (proof['proof'] != 'receiver-ready') {
          throw const FormatException('Invalid nearby proof');
        }
        // Recheck after the await to fence concurrent replay of the same request.
        if (sequence <= _lastSequence) {
          throw const FormatException('Replayed nearby request');
        }
        _lastSequence = sequence;
        if (request.uri.path == '/v1/nearby/status') {
          response = {
            'sealed': base64Encode(await sealBytes(
                key,
                utf8.encode(jsonEncode(stage == OfflinePairingStage.approved
                    ? {
                        'identity': identity.toJson(),
                        if (transfer != null) 'transfer': transfer,
                        if (account != null) 'account': account
                      }
                    : {'waiting': true})),
                '$_binding:reply:$sequence'))
          };
        } else if (request.uri.path == '/v1/nearby/authorize' &&
            stage == OfflinePairingStage.approved) {
          final deviceRequest = proof['request'];
          if (deviceRequest is! String ||
              deviceRequest.length > 8192 ||
              authorizeDevice == null ||
              (_deviceRequest != null && _deviceRequest != deviceRequest)) {
            throw const FormatException('Invalid device authorization request');
          }
          _deviceRequest = deviceRequest;
          final approved =
              await (_deviceApproval ??= authorizeDevice!(deviceRequest));
          if (_closed) throw StateError('Invitation closed');
          response = {
            'sealed': base64Encode(await sealBytes(
                key,
                utf8.encode(jsonEncode({'authorized': approved})),
                '$_binding:reply:$sequence'))
          };
        } else if (request.uri.path == '/v1/nearby/ack' &&
            stage == OfflinePairingStage.approved) {
          response = {
            'sealed': base64Encode(await sealBytes(
                key, utf8.encode('complete'), '$_binding:reply:$sequence'))
          };
          stage = OfflinePairingStage.transferred;
          acknowledged = true;
          _notify();
        } else {
          throw const FormatException('Invalid nearby operation');
        }
      }
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(response));
    } catch (_) {
      request.response.statusCode = 400;
      if (sas == null && stage == OfflinePairingStage.comparing) {
        unawaited(close());
      }
    } finally {
      _active--;
      try {
        await request.response.close();
      } catch (_) {}
      if (acknowledged) {
        if (!_finished.isCompleted) _finished.complete();
        unawaited(close());
      }
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _expiry?.cancel();
    if (stage != OfflinePairingStage.transferred) {
      stage = OfflinePairingStage.cancelled;
    }
    _channel?.fillRange(0, _channel!.length, 0);
    _channel = null;
    _key = null;
    sas = null;
    await _server?.close(force: true);
    if (!_finished.isCompleted) _finished.complete();
    _notify();
  }

  void _notify() {
    if (!_notifierDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _notifierDisposed = true;
    unawaited(close());
    super.dispose();
  }
}

/// The joining device pins the QR public key, then asks the user to compare SAS.
/// It returns an identity for a separate atomic adoption step; it never mutates
/// existing diary data or secret stores by itself.
class OfflinePairingClient {
  OfflinePairingClient(this.invite, {DateTime Function()? now})
      : _now = now ?? DateTime.now {
    _http.connectionTimeout = const Duration(seconds: 5);
    _http.findProxy = (_) => 'DIRECT';
  }
  final OfflinePairingInvite invite;
  final DateTime Function() _now;
  final HttpClient _http = HttpClient();
  Uri? _endpoint;
  Uint8List? _key;
  String? _binding;
  String? _nonceValue;
  int _sequence = 0;
  String? sas;
  bool _confirmed = false;
  bool _closed = false;

  Future<void> start() async {
    if (_closed || _key != null || !_now().isBefore(invite.expires)) {
      throw StateError('Invitation expired or already used');
    }
    final ephemeral = await _x25519.newKeyPair();
    final public = await ephemeral.extractPublicKey();
    final nonce = _nonceValue = _nonce();
    final binding = _binding = _transcript(invite, public.bytes, nonce);
    final key = _key = await _derive(ephemeral, invite.publicKey, binding);
    Object? failure;
    for (final endpoint in invite.endpoints) {
      try {
        _endpoint = endpoint;
        final reply = await _post('/v1/nearby/hello',
            {'key': base64Encode(public.bytes), 'nonce': nonce});
        final plain = await openBytes(
            key, base64Decode(reply['sealed'] as String), '$binding:hello');
        if (utf8.decode(plain) != 'owner-ready') {
          throw const FormatException('Invalid nearby owner proof');
        }
        sas = await _sas(key, binding);
        return;
      } catch (error) {
        failure = error;
      }
    }
    close();
    throw StateError(
        'Could not reach the scanned nearby device (${failure.runtimeType})');
  }

  void confirm(String matchingSas) {
    if (_closed || sas == null || matchingSas != sas) {
      throw StateError('Compare the same code on both devices');
    }
    _confirmed = true;
  }

  Future<DiaryIdentity?> receive() async {
    final grant = await receiveGrant();
    return grant == null
        ? null
        : DiaryIdentity.fromJson(
            (grant['identity'] as Map).cast<String, Object?>());
  }

  /// The owner-approved capability is delivered only through the sealed channel.
  Future<Map<String, dynamic>?> receiveGrant() async {
    if (!_confirmed) {
      throw StateError('Confirm the matching code before accepting identity');
    }
    final reply = await _authenticated('/v1/nearby/status');
    final message = jsonDecode(utf8.decode(reply)) as Map<String, dynamic>;
    if (message['waiting'] == true) return null;
    return message;
  }

  Future<void> acknowledge() async {
    if (!_confirmed) throw StateError('No confirmed nearby transfer');
    if (utf8.decode(await _authenticated('/v1/nearby/ack')) != 'complete') {
      throw const FormatException('Invalid nearby receipt');
    }
    close();
  }

  Future<bool> authorizeDevice(String request) async {
    if (!_confirmed || request.length > 8192) {
      throw StateError('No confirmed device request');
    }
    final reply = jsonDecode(utf8.decode(
        await _authenticated('/v1/nearby/authorize', request: request))) as Map;
    return reply['authorized'] == true;
  }

  Future<Uint8List> _authenticated(String path, {String? request}) async {
    if (_closed || _key == null || !_now().isBefore(invite.expires)) {
      throw StateError('Nearby session expired');
    }
    final sequence = ++_sequence;
    final reply = await _post(path, {
      'sequence': sequence,
      'nonce': _nonceValue,
      'sealed': base64Encode(await sealBytes(
          _key!,
          utf8.encode(request == null
              ? 'receiver-ready'
              : jsonEncode({'proof': 'receiver-ready', 'request': request})),
          '$_binding:$path:$sequence'))
    });
    return openBytes(_key!, base64Decode(reply['sealed'] as String),
        '$_binding:reply:$sequence');
  }

  Future<Map<String, dynamic>> _post(
      String path, Map<String, Object?> message) async {
    final request = await _http
        .postUrl(_endpoint!.replace(path: path))
        .timeout(const Duration(seconds: 5));
    request.followRedirects = false;
    request.headers.contentType = ContentType.json;
    final data =
        utf8.encode(jsonEncode({'session': invite.session, ...message}));
    request.contentLength = data.length;
    request.add(data);
    final response = await request.close().timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      request.abort();
      throw StateError('Nearby handshake rejected');
    }
    return _read(response);
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _http.close(force: true);
    _key?.fillRange(0, _key!.length, 0);
    _key = null;
    sas = null;
  }
}
