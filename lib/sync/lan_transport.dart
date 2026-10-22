// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';
import 'package:crypto/crypto.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_object_paths.dart';

/// Discovery records are hints. Only the signed probe can establish a peer.
class LanCandidate {
  const LanCandidate(this.endpoint, this.tag);
  final Uri endpoint;
  final String tag;
}

class LanAdvertisement {
  const LanAdvertisement(this.id, this.port, this.tag);
  final String id;
  final int port;
  final String tag;
}

abstract interface class LanDiscovery {
  Stream<LanCandidate> get candidates;
  Future<void> start(LanAdvertisement local);
  Future<void> close();
}

/// Native DNS-SD on Windows and Android; contains no keys or account IDs.
class BonsoirLanDiscovery implements LanDiscovery {
  BonsoirLanDiscovery({this.serviceType = '_aid-diary._tcp'});
  final String serviceType;
  final _candidates = StreamController<LanCandidate>.broadcast();
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _subscription;

  @override
  Stream<LanCandidate> get candidates => _candidates.stream;

  @override
  Future<void> start(LanAdvertisement local) async {
    final broadcast = _broadcast = BonsoirBroadcast(
        service: BonsoirService(
            name: 'aid-${local.id}',
            type: serviceType,
            port: local.port,
            attributes: {'tag': local.tag, 'protocol': '1'}),
        printLogs: false);
    await broadcast.initialize();
    await broadcast.start();
    final discovery =
        _discovery = BonsoirDiscovery(type: serviceType, printLogs: false);
    await discovery.initialize();
    _subscription = discovery.eventStream!.listen((event) {
      if (event is BonsoirDiscoveryServiceFoundEvent) {
        event.service.resolve(discovery.serviceResolver);
      } else if (event is BonsoirDiscoveryServiceResolvedEvent ||
          event is BonsoirDiscoveryServiceUpdatedEvent) {
        final service = event.service;
        if (service == null ||
            service.name == 'aid-${local.id}' ||
            service.attributes['protocol'] != '1' ||
            service.attributes['tag'] != local.tag) {
          return;
        }
        for (final address in service.hostAddresses) {
          _candidates.add(LanCandidate(
              Uri(scheme: 'http', host: address, port: service.port),
              local.tag));
        }
      }
    }, onError: (Object _) {});
    await discovery.start();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    try {
      await _discovery?.stop();
    } catch (_) {
      // A missing native plugin must not disable cloud sync.
    }
    try {
      await _broadcast?.stop();
    } catch (_) {}
    await _candidates.close();
  }
}

class LanMediaPeer {
  const LanMediaPeer(
      {required this.id,
      required this.userId,
      required this.spaceId,
      required this.backend});
  final String id;
  final String userId;
  final String spaceId;
  final LanMediaBackend backend;
}

/// Serves encrypted sync objects, including sealed space metadata and packs.
/// The vault must contain protocol ciphertext only, never local diary files.
/// Requests and responses are authenticated independently of the network path.
class LanMediaHost {
  LanMediaHost(
      {required SyncBackend vault,
      required this.deviceId,
      required this.userId,
      required this.spaceId,
      required Uint8List masterKey,
      LanDiscovery? discovery,
      String serviceType = '_aid-diary._tcp',
      this.maxBytes = 16 * 1024 * 1024,
      this.maxConcurrent = 4,
      this.requestTimeout = const Duration(seconds: 15)})
      : _vault = vault,
        _auth = _LanAuth(masterKey, userId, spaceId),
        _discovery = discovery ?? BonsoirLanDiscovery(serviceType: serviceType);

  final SyncBackend _vault;
  final String deviceId;
  final String userId;
  final String spaceId;
  final int maxBytes;
  final int maxConcurrent;
  final Duration requestTimeout;
  final _LanAuth _auth;
  final LanDiscovery _discovery;
  final _peers = StreamController<LanMediaPeer>.broadcast();
  final _nonces = <String, int>{};
  final _audience = _nonce();
  final _probing = <Uri>{};
  final _clients = <Uri, LanMediaBackend>{};
  final _peerIds = <Uri, String>{};
  final _pruning = <Uri>{};
  StreamSubscription<LanCandidate>? _subscription;
  HttpServer? _server;
  bool _closed = false;
  Future<void>? _closing;
  int _active = 0;

  Stream<LanMediaPeer> get peers => _peers.stream;
  Uri? get endpoint => _server == null
      ? null
      : Uri(
          scheme: 'http', host: _server!.address.address, port: _server!.port);

  Future<Uri> start({InternetAddress? bindAddress}) async {
    if (_closed || _server != null) {
      throw StateError('LAN host already started');
    }
    if (maxBytes < 1 || maxConcurrent < 1) {
      throw ArgumentError('LAN limits must be positive');
    }
    _server = await HttpServer.bind(bindAddress ?? InternetAddress.anyIPv6, 0,
        v6Only: false);
    _server!.idleTimeout = requestTimeout;
    _server!.listen((request) => unawaited(_handle(request)),
        onError: (Object _) {});
    _subscription = _discovery.candidates.listen((candidate) {
      if (!_closed && candidate.tag == _auth.tag && _probing.length < 8) {
        unawaited(_probe(candidate));
      }
    }, onError: (Object _) {});
    try {
      await _discovery
          .start(LanAdvertisement(deviceId, _server!.port, _auth.tag));
    } catch (_) {
      // Discovery failure is a quiet fallback to the configured cloud backend.
    }
    return endpoint!;
  }

  Future<void> _probe(LanCandidate candidate) async {
    if (_clients.containsKey(candidate.endpoint) || _clients.length >= 64) {
      return;
    }
    if (!_probing.add(candidate.endpoint)) return;
    LanMediaBackend? backend;
    try {
      backend = LanMediaBackend._(
          candidate.endpoint, _auth, maxBytes, requestTimeout);
      final peer = await backend.probe();
      if (_closed || peer.id == deviceId) {
        backend.close();
        return;
      }
      _clients[candidate.endpoint] = backend;
      _peerIds[candidate.endpoint] = peer.id;
      _peers.add(peer);
      unawaited(_pruneFailedAlternates(peer.id, candidate.endpoint));
    } catch (_) {
      backend?.close();
    } finally {
      _probing.remove(candidate.endpoint);
    }
  }

  /// Keep working IPv4/IPv6 alternatives; retire addresses that stopped working
  /// after the same verified device appeared on another network interface.
  Future<void> _pruneFailedAlternates(String peerId, Uri current) async {
    final previous = _clients.entries
        .where((entry) => entry.key != current && _peerIds[entry.key] == peerId)
        .toList();
    for (final entry in previous) {
      if (_closed || !_pruning.add(entry.key)) continue;
      try {
        await entry.value.check();
      } catch (_) {
        if (_clients[entry.key] == entry.value) {
          _clients.remove(entry.key);
          _peerIds.remove(entry.key);
          entry.value.close();
        }
      } finally {
        _pruning.remove(entry.key);
      }
    }
  }

  Future<void> _handle(HttpRequest request) async {
    if (_closed || _active >= maxConcurrent) {
      request.response.statusCode = HttpStatus.serviceUnavailable;
      try {
        await request.response.close();
      } catch (_) {}
      return;
    }
    _active++;
    String? nonce;
    var authenticated = false;
    try {
      if (request.contentLength > maxBytes) throw const _LanFailure(413);
      final body = await _bounded(request, maxBytes, timeout: requestTimeout);
      final time = request.headers.value('x-aid-time') ?? '';
      nonce = request.headers.value('x-aid-nonce') ?? '';
      final timestamp = int.tryParse(time);
      final audience = request.headers.value('x-aid-audience') ?? '';
      final probe = request.method == 'GET' && request.uri.path == '/v1/probe';
      final now = DateTime.now().millisecondsSinceEpoch;
      _nonces.removeWhere((_, expiry) => expiry < now);
      if (timestamp == null ||
          (timestamp - now).abs() > _LanAuth.clockWindow.inMilliseconds ||
          !RegExp(r'^[a-f0-9]{32}$').hasMatch(nonce) ||
          (probe ? audience.isNotEmpty : audience != _audience) ||
          _nonces.containsKey(nonce) ||
          !_auth.matches(
              _auth.request(request.method, request.uri, time, nonce, body,
                  audience: audience),
              request.headers.value('x-aid-signature'))) {
        throw const _LanFailure(401);
      }
      if (_nonces.length >= 4096) throw const _LanFailure(429);
      _nonces[nonce] = now + _LanAuth.clockWindow.inMilliseconds * 2;
      authenticated = true;
      Uint8List result;
      if (request.method == 'GET' && request.uri.path == '/v1/probe') {
        result = _json({
          'id': deviceId,
          'userId': userId,
          'spaceId': spaceId,
          'audience': _audience
        });
      } else if (request.method == 'GET' && request.uri.path == '/v1/list') {
        final folder = request.uri.queryParameters['folder'] ?? '';
        if (!SyncObjectPaths.validFolder(folder)) throw const _LanFailure(400);
        final files = await _vault.list(folder);
        result = _json({
          for (final file in files.entries)
            if (SyncObjectPaths.validFile(file.key) &&
                file.key.startsWith('$folder/') &&
                !file.key.substring(folder.length + 1).contains('/'))
              file.key: file.value,
        });
      } else if (request.uri.path == '/v1/file') {
        final path = request.uri.queryParameters['path'] ?? '';
        if (!SyncObjectPaths.validFile(path)) throw const _LanFailure(400);
        switch (request.method) {
          case 'GET':
            final bytes = await _vault.read(path);
            if (bytes == null) throw const _LanFailure(404);
            result = bytes;
          case 'PUT':
            SyncObjectPaths.verifyChunk(path, body);
            result = _json({'version': await _vault.write(path, body)});
          case 'DELETE':
            await _vault.delete(path);
            result = Uint8List(0);
          default:
            throw const _LanFailure(405);
        }
      } else {
        throw const _LanFailure(404);
      }
      if (result.length > maxBytes) throw const _LanFailure(413);
      request.response.headers
          .set('x-aid-signature', _auth.response(nonce, HttpStatus.ok, result));
      request.response.add(result);
    } catch (error) {
      final status = error is _LanFailure ? error.status : 500;
      request.response.statusCode = status;
      if (authenticated) {
        request.response.headers.set(
            'x-aid-signature', _auth.response(nonce!, status, Uint8List(0)));
      }
    } finally {
      _active--;
      try {
        await request.response.close();
      } catch (_) {
        // A disconnected peer is retried by the route manager.
      }
    }
  }

  Future<void> close() => _closing ??= _close();
  Future<void> _close() async {
    _closed = true;
    try {
      await _subscription?.cancel();
      await _discovery.close();
    } finally {
      await _server?.close(force: true);
      for (final client in _clients.values) {
        client.close();
      }
      await _peers.close();
    }
  }
}

class LanMediaBackend implements SyncBackend {
  LanMediaBackend._(this.endpoint, this._auth, this.maxBytes, this.timeout) {
    _client.connectionTimeout = timeout;
    _client.findProxy = (_) => 'DIRECT';
  }
  final Uri endpoint;
  final _LanAuth _auth;
  final int maxBytes;
  final Duration timeout;
  final HttpClient _client = HttpClient();
  String _audience = '';

  static Future<LanMediaPeer> connect(
      {required Uri endpoint,
      required String userId,
      required String spaceId,
      required Uint8List masterKey,
      int maxBytes = 16 * 1024 * 1024,
      Duration timeout = const Duration(seconds: 15)}) async {
    final backend = LanMediaBackend._(
        endpoint, _LanAuth(masterKey, userId, spaceId), maxBytes, timeout);
    try {
      return await backend.probe();
    } catch (_) {
      backend.close();
      rethrow;
    }
  }

  Future<LanMediaPeer> probe() async {
    final data = jsonDecode(utf8.decode(await _send('GET', '/v1/probe')))
        as Map<String, dynamic>;
    if (data['userId'] != _auth.userId ||
        data['spaceId'] != _auth.spaceId ||
        data['audience'] is! String ||
        !RegExp(r'^[a-f0-9]{32}$').hasMatch(data['audience'] as String) ||
        data['id'] is! String ||
        (data['id'] as String).isEmpty) {
      throw const FormatException('LAN peer belongs to another space');
    }
    _audience = data['audience'] as String;
    return LanMediaPeer(
        id: data['id'] as String,
        userId: _auth.userId,
        spaceId: _auth.spaceId,
        backend: this);
  }

  @override
  Future<void> check() async => probe();

  @override
  Future<Map<String, String>> list(String folder) async {
    if (!SyncObjectPaths.validFolder(folder)) {
      throw ArgumentError.value(folder, 'folder');
    }
    final decoded = jsonDecode(utf8.decode(
        await _send('GET', '/v1/list', query: {'folder': folder}))) as Map;
    final result = decoded.cast<String, String>();
    if (result.keys.any((path) =>
        !SyncObjectPaths.validFile(path) ||
        !path.startsWith('$folder/') ||
        path.substring(folder.length + 1).contains('/'))) {
      throw const FormatException('Invalid LAN media listing');
    }
    return result;
  }

  @override
  Future<Uint8List?> read(String path) async {
    if (!SyncObjectPaths.validFile(path)) {
      throw ArgumentError.value(path, 'path');
    }
    try {
      final bytes = await _send('GET', '/v1/file', query: {'path': path});
      SyncObjectPaths.verifyChunk(path, bytes);
      return bytes;
    } on _LanFailure catch (error) {
      if (error.status == 404) return null;
      rethrow;
    }
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    if (!SyncObjectPaths.validFile(path)) {
      throw ArgumentError.value(path, 'path');
    }
    SyncObjectPaths.verifyChunk(path, bytes);
    final data = jsonDecode(utf8.decode(await _send('PUT', '/v1/file',
        query: {'path': path}, bytes: bytes))) as Map;
    return data['version'] as String?;
  }

  @override
  Future<void> delete(String path) async {
    if (!SyncObjectPaths.validFile(path)) {
      throw ArgumentError.value(path, 'path');
    }
    await _send('DELETE', '/v1/file', query: {'path': path});
  }

  Future<Uint8List> _send(String method, String path,
      {Map<String, String>? query, Uint8List? bytes}) async {
    bytes ??= Uint8List(0);
    if (bytes.length > maxBytes) throw const _LanFailure(413);
    final uri = endpoint.replace(path: path, queryParameters: query);
    if (uri.scheme != 'http' || uri.userInfo.isNotEmpty || uri.host.isEmpty) {
      throw ArgumentError.value(endpoint, 'endpoint');
    }
    final nonce = _nonce();
    final audience = path == '/v1/probe' ? '' : _audience;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    HttpClientRequest? pending;
    try {
      return await (() async {
        final request = pending = await _client.openUrl(method, uri);
        request.followRedirects = false;
        request.headers.set('x-aid-time', time);
        request.headers.set('x-aid-nonce', nonce);
        request.headers.set('x-aid-audience', audience);
        request.headers.set(
            'x-aid-signature',
            _auth.request(method, uri, time, nonce, bytes!,
                audience: audience));
        request.contentLength = bytes.length;
        request.add(bytes);
        final response = await request.close();
        final data = await _bounded(response, maxBytes, timeout: timeout);
        if (!_auth.matches(_auth.response(nonce, response.statusCode, data),
            response.headers.value('x-aid-signature'))) {
          throw const FormatException('LAN response authentication failed');
        }
        if (response.statusCode != HttpStatus.ok) {
          throw _LanFailure(response.statusCode);
        }
        return data;
      })()
          .timeout(timeout);
    } on TimeoutException {
      pending?.abort();
      rethrow;
    }
  }

  void close() => _client.close(force: true);
}

class _LanAuth {
  _LanAuth(Uint8List masterKey, this.userId, this.spaceId)
      : key = Hmac(sha256, masterKey)
            .convert(utf8.encode('aid-lan-media-v1\n$userId\n$spaceId'))
            .bytes;
  static const clockWindow = Duration(minutes: 2);
  final List<int> key;
  final String userId;
  final String spaceId;
  String get tag => _sign('discovery').substring(0, 32);
  String _sign(String value) =>
      Hmac(sha256, key).convert(utf8.encode(value)).toString();
  String request(
          String method, Uri uri, String time, String nonce, List<int> body,
          {String audience = ''}) =>
      _sign(
          'request\n$method\n${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}'
          '\n$time\n$nonce\n${sha256.convert(body)}\n$audience');
  String response(String nonce, int status, List<int> body) =>
      _sign('response\n$nonce\n$status\n${sha256.convert(body)}');
  bool matches(String expected, String? actual) {
    if (actual == null || actual.length != expected.length) return false;
    var difference = 0;
    for (var i = 0; i < expected.length; i++) {
      difference |= expected.codeUnitAt(i) ^ actual.codeUnitAt(i);
    }
    return difference == 0;
  }
}

Future<Uint8List> _bounded(Stream<List<int>> stream, int limit,
    {Duration? timeout}) {
  final builder = BytesBuilder(copy: false);
  final result = Completer<Uint8List>();
  late StreamSubscription<List<int>> subscription;
  Timer? timer;
  void fail(Object error, [StackTrace? stack]) {
    if (result.isCompleted) return;
    timer?.cancel();
    unawaited(subscription.cancel());
    result.completeError(error, stack);
  }

  subscription = stream.listen(
      (part) {
        if (builder.length + part.length > limit) {
          fail(const _LanFailure(413));
        } else {
          builder.add(part);
        }
      },
      onError: fail,
      onDone: () {
        timer?.cancel();
        if (!result.isCompleted) result.complete(builder.takeBytes());
      });
  if (timeout != null) {
    timer = Timer(timeout, () => fail(TimeoutException('LAN read timed out')));
  }
  return result.future;
}

Uint8List _json(Object object) =>
    Uint8List.fromList(utf8.encode(jsonEncode(object)));
String _nonce() => List.generate(16, (_) => Random.secure().nextInt(256))
    .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
    .join();

class _LanFailure implements Exception {
  const _LanFailure(this.status);
  final int status;
  @override
  String toString() => 'LAN media request failed ($status)';
}
