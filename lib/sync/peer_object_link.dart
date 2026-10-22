// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';
import 'package:aid_diary/sync/sync_object_paths.dart';
import 'package:crypto/crypto.dart';

/// A sanitized protocol error: storage and transport exception text never
/// crosses the link or appears in this error's message.
class PeerObjectException implements Exception {
  const PeerObjectException(this.code);
  final String code;
  @override
  String toString() => 'Peer object operation failed ($code)';
}

/// Bidirectional object RPC on an ordered packet transport. The owner supplies
/// a ciphertext-only vault and fresh, distinct endpoint sessions for every link
/// generation. This class neither grants first-time trust nor owns the transport.
/// Call [backend.check] explicitly before registering the route.
class PeerObjectLink {
  PeerObjectLink({
    required SyncBackend vault,
    required Uint8List masterKey,
    required this.userId,
    required this.spaceId,
    required this.localSession,
    required this.remoteSession,
    required this.transport,
    required Stream<Uint8List> packets,
    required Future<void> Function(Uint8List) send,
    this.timeout = const Duration(seconds: 15),
    this.maxBytes = 16 * 1024 * 1024 + 64 * 1024,
    this.maxPacketBytes = 24 * 1024 * 1024,
    this.maxConcurrent = 4,
    this.maxListEntries = 4096,
  })  : _vault = vault,
        _send = send,
        _key = Uint8List.fromList(Hmac(sha256, masterKey)
            .convert(utf8
                .encode('aid-peer-object-v1\n$userId\n$spaceId\n$transport'))
            .bytes) {
    if (masterKey.length != 32 ||
        !_validBinding(userId) ||
        !_validBinding(spaceId) ||
        !_validBinding(transport) ||
        !_validBinding(localSession) ||
        !_validBinding(remoteSession) ||
        localSession == remoteSession ||
        timeout <= Duration.zero ||
        maxBytes < 1 ||
        maxPacketBytes < 128 ||
        maxConcurrent < 1 ||
        maxListEntries < 1) {
      throw ArgumentError('Invalid peer object link configuration');
    }
    _subscription = packets.listen(_enqueuePacket,
        onError: (Object _, StackTrace __) =>
            unawaited(_shutdown(const PeerObjectException('transport_failed'))),
        onDone: () => unawaited(
            _shutdown(const PeerObjectException('transport_closed'))));
  }

  final String userId;
  final String spaceId;
  final String localSession;
  final String remoteSession;
  final String transport;
  final Duration timeout;
  final int maxBytes;
  final int maxPacketBytes;
  final int maxConcurrent;
  final int maxListEntries;
  final SyncBackend _vault;
  final Future<void> Function(Uint8List) _send;
  final Uint8List _key;
  late final StreamSubscription<Uint8List> _subscription;
  late final SyncBackend backend = _PeerBackend(this);
  final Map<int, _PendingRequest> _pending = {};
  Future<void> _receiveTail = Future.value();
  Future<void> _sendTail = Future.value();
  Future<void>? _closing;
  int _sentSequence = 0;
  int _receivedSequence = 0;
  int _requestId = 0;
  int _active = 0;
  int _queuedPackets = 0;
  int _queuedSends = 0;
  bool _closed = false;

  bool get isClosed => _closed;

  Future<void> close() => _shutdown(const PeerObjectException('closed'));

  Future<Object?> _request(String op, {String? path, Uint8List? bytes}) {
    if (_closed) return Future.error(const PeerObjectException('closed'));
    if (_pending.length >= maxConcurrent) {
      return Future.error(const PeerObjectException('busy'));
    }
    final id = ++_requestId;
    final result = Completer<Object?>();
    final timer = Timer(timeout, () {
      _pending.remove(id)?.result.completeError(
          TimeoutException('Peer object operation timed out', timeout));
    });
    _pending[id] = _PendingRequest(result, timer);
    unawaited(_sendMessage({
      'id': id,
      'op': op,
      if (path != null) 'path': path,
      if (bytes != null) 'bytes': base64.encode(bytes),
    }, obsolete: () => !_pending.containsKey(id))
        .catchError((Object _, StackTrace __) {
      return _shutdown(const PeerObjectException('transport_failed'));
    }));
    return result.future;
  }

  Future<void> _sendMessage(Map<String, Object?> message,
      {bool Function()? obsolete}) {
    if (_closed) return Future.error(const PeerObjectException('closed'));
    if (_queuedSends >= maxConcurrent * 2) {
      return Future.error(const PeerObjectException('congestion'));
    }
    _queuedSends++;
    final operation = _sendTail.then<void>((_) async {
      if (_closed) throw const PeerObjectException('closed');
      if (obsolete?.call() ?? false) return;
      final plain = utf8.encode(jsonEncode(message));
      if (plain.length > maxPacketBytes - _headerLength - 29) {
        throw const PeerObjectException('packet_too_large');
      }
      final sequence = _sentSequence + 1;
      final sealed = await sealBytes(
          _key, plain, _aad(localSession, remoteSession, sequence));
      final from = utf8.encode(localSession);
      final to = utf8.encode(remoteSession);
      final packet = Uint8List(_headerLength + sealed.length);
      final header = ByteData.sublistView(packet);
      header.setUint8(0, 1);
      header.setUint64(1, sequence);
      header.setUint16(9, from.length);
      header.setUint16(11, to.length);
      packet.setRange(13, 13 + from.length, from);
      packet.setRange(13 + from.length, _headerLength, to);
      packet.setRange(_headerLength, packet.length, sealed);
      if (_closed) throw const PeerObjectException('closed');
      if (obsolete?.call() ?? false) return;
      _sentSequence = sequence;
      await _send(packet).timeout(timeout);
    });
    // A failed tail is consumed; each caller still gets its operation's failure.
    _sendTail = operation.then((_) {}, onError: (Object _, StackTrace __) {});
    return operation.whenComplete(() => _queuedSends--);
  }

  int get _headerLength =>
      13 + utf8.encode(localSession).length + utf8.encode(remoteSession).length;

  String _aad(String from, String to, int sequence) => jsonEncode(
      ['aid-peer-object-v1', userId, spaceId, transport, from, to, sequence]);

  void _enqueuePacket(Uint8List bytes) {
    if (_closed) return;
    if (bytes.length > maxPacketBytes ||
        _queuedPackets >= maxConcurrent * 2 + 2) {
      unawaited(_shutdown(const PeerObjectException('packet_limit')));
      return;
    }
    final packet = Uint8List.fromList(bytes);
    _queuedPackets++;
    _receiveTail = _receiveTail.then<void>((_) async {
      if (!_closed) await _receive(packet);
    }).catchError((Object _, StackTrace __) {
      return _shutdown(const PeerObjectException('invalid_packet'));
    }).whenComplete(() => _queuedPackets--);
  }

  Future<void> _receive(Uint8List packet) async {
    if (packet.length < 42) throw const FormatException('Short packet');
    final header = ByteData.sublistView(packet);
    final sequence = header.getUint64(1);
    final fromLength = header.getUint16(9);
    final toLength = header.getUint16(11);
    final offset = 13 + fromLength + toLength;
    if (header.getUint8(0) != 1 ||
        fromLength > 256 ||
        toLength > 256 ||
        packet.length < offset + 29) {
      throw const FormatException('Invalid header');
    }
    final from = utf8.decode(packet.sublist(13, 13 + fromLength));
    final to = utf8.decode(packet.sublist(13 + fromLength, offset));
    final plain = await openBytes(
        _key, Uint8List.sublistView(packet, offset), _aad(from, to, sequence));
    if (_closed) return;
    // Never advance the counter for an unauthenticated or misbound packet.
    if (from != remoteSession ||
        to != localSession ||
        sequence != _receivedSequence + 1) {
      throw const FormatException('Invalid packet order or session');
    }
    _receivedSequence = sequence;
    final message = jsonDecode(utf8.decode(plain));
    if (message is! Map<String, dynamic> ||
        message['id'] is! int ||
        (message['id'] as int) < 1) {
      throw const FormatException('Invalid RPC');
    }
    final id = message['id'] as int;
    if (message.containsKey('op') && !message.containsKey('ok')) {
      if (_active >= maxConcurrent) {
        _reply({'id': id, 'ok': false, 'error': 'busy'});
      } else {
        _active++;
        unawaited(_serve(id, message));
      }
    } else if (!message.containsKey('op') && message['ok'] is bool) {
      final pending = _pending.remove(id);
      if (pending == null) return; // A timed-out request can finish later.
      pending.timer.cancel();
      if (message['ok'] == true) {
        pending.result.complete(message['value']);
      } else {
        final code = message['error'];
        pending.result.completeError(PeerObjectException(
            code is String && _errors.contains(code)
                ? code
                : 'remote_failure'));
      }
    } else {
      throw const FormatException('Invalid RPC kind');
    }
  }

  Future<void> _serve(int id, Map<String, dynamic> message) async {
    final operation = _operate(message);
    // Keep a slot until the actual storage operation ends, even if our reply
    // deadline expires: SyncBackend cannot cancel a hung read or write.
    unawaited(operation.then((_) => _active--,
        onError: (Object _, StackTrace __) => _active--));
    Map<String, Object?> response;
    try {
      response = {
        'id': id,
        'ok': true,
        'value': await operation.timeout(timeout)
      };
    } catch (error) {
      final code = error is _RequestFailure
          ? error.code
          : error is TimeoutException
              ? 'timeout'
              : 'storage_failure';
      response = {'id': id, 'ok': false, 'error': code};
    }
    _reply(response);
  }

  void _reply(Map<String, Object?> message) {
    if (_closed) return;
    unawaited(_sendMessage(message).catchError((Object _, StackTrace __) {
      return _shutdown(const PeerObjectException('transport_failed'));
    }));
  }

  Future<Object?> _operate(Map<String, dynamic> request) async {
    if (request.keys
        .any((key) => !const {'id', 'op', 'path', 'bytes'}.contains(key))) {
      throw const _RequestFailure('bad_request');
    }
    final op = request['op'];
    if (op == 'check') {
      if (request.containsKey('path') || request.containsKey('bytes')) {
        throw const _RequestFailure('bad_request');
      }
      await _vault.check();
      return {'userId': userId, 'spaceId': spaceId};
    }
    final path = request['path'];
    if (path is! String ||
        (op == 'list'
            ? !SyncObjectPaths.validFolder(path)
            : !SyncObjectPaths.validFile(path))) {
      throw const _RequestFailure('forbidden_path');
    }
    if (op != 'write' && request.containsKey('bytes')) {
      throw const _RequestFailure('bad_request');
    }
    switch (op) {
      case 'list':
        final files = await _vault.list(path);
        if (files.length > maxListEntries) {
          throw const _RequestFailure('listing_too_large');
        }
        return {
          for (final file in files.entries)
            if (SyncObjectPaths.directChild(path, file.key))
              file.key: _version(file.value)
        };
      case 'read':
        final bytes = await _vault.read(path);
        if (bytes == null) return null;
        if (bytes.length > maxBytes) {
          throw const _RequestFailure('object_too_large');
        }
        _verify(path, bytes);
        return base64.encode(bytes);
      case 'write':
        final bytes = _decodeBytes(request['bytes']);
        _verify(path, bytes);
        return _version(await _vault.write(path, bytes));
      case 'delete':
        await _vault.delete(path);
        return null;
      default:
        throw const _RequestFailure('bad_request');
    }
  }

  Uint8List _decodeBytes(Object? value) {
    if (value is! String || value.length > ((maxBytes + 2) ~/ 3) * 4) {
      throw const _RequestFailure('object_too_large');
    }
    try {
      final bytes = base64.decode(value);
      if (bytes.length > maxBytes) {
        throw const _RequestFailure('object_too_large');
      }
      return bytes;
    } on FormatException {
      throw const _RequestFailure('bad_request');
    }
  }

  static String? _version(String? value) {
    if (value != null && utf8.encode(value).length > 256) {
      throw const _RequestFailure('bad_response');
    }
    return value;
  }

  static void _verify(String path, Uint8List bytes) {
    try {
      SyncObjectPaths.verifyChunk(path, bytes);
    } on FormatException {
      throw const _RequestFailure('hash_mismatch');
    }
  }

  Future<void> _shutdown(PeerObjectException error) {
    if (_closing != null) return _closing!;
    _closed = true;
    for (final request in _pending.values) {
      request.timer.cancel();
      request.result.completeError(error);
    }
    _pending.clear();
    return _closing = _subscription.cancel();
  }

  static bool _validBinding(String value) =>
      value.isNotEmpty &&
      utf8.encode(value).length <= 256 &&
      !value.contains(RegExp(r'[\r\n]'));

  static const _errors = {
    'busy',
    'timeout',
    'bad_request',
    'forbidden_path',
    'listing_too_large',
    'object_too_large',
    'hash_mismatch',
    'bad_response',
    'storage_failure'
  };
}

class _PeerBackend implements SyncBackend {
  _PeerBackend(this.link);
  final PeerObjectLink link;

  @override
  Future<void> check() async {
    final value = await link._request('check');
    if (value is! Map ||
        value['userId'] != link.userId ||
        value['spaceId'] != link.spaceId) {
      throw const PeerObjectException('bad_response');
    }
  }

  @override
  Future<Map<String, String>> list(String folder) async {
    if (!SyncObjectPaths.validFolder(folder)) {
      throw ArgumentError.value(folder, 'folder');
    }
    final value = await link._request('list', path: folder);
    if (value is! Map || value.length > link.maxListEntries) {
      throw const PeerObjectException('bad_response');
    }
    final files = <String, String>{};
    for (final entry in value.entries) {
      if (entry.key is! String ||
          entry.value is! String ||
          !SyncObjectPaths.directChild(folder, entry.key as String) ||
          utf8.encode(entry.value as String).length > 256) {
        throw const PeerObjectException('bad_response');
      }
      files[entry.key as String] = entry.value as String;
    }
    return files;
  }

  @override
  Future<Uint8List?> read(String path) async {
    _path(path);
    final value = await link._request('read', path: path);
    if (value == null) return null;
    try {
      final bytes = link._decodeBytes(value);
      SyncObjectPaths.verifyChunk(path, bytes);
      return bytes;
    } on _RequestFailure {
      throw const PeerObjectException('bad_response');
    }
  }

  @override
  Future<String?> write(String path, Uint8List bytes) async {
    _path(path);
    if (bytes.length > link.maxBytes) {
      throw ArgumentError('Object exceeds peer limit');
    }
    SyncObjectPaths.verifyChunk(path, bytes);
    final value = await link._request('write', path: path, bytes: bytes);
    if (value != null &&
        (value is! String || utf8.encode(value).length > 256)) {
      throw const PeerObjectException('bad_response');
    }
    return value as String?;
  }

  @override
  Future<void> delete(String path) async {
    _path(path);
    await link._request('delete', path: path);
  }

  static void _path(String path) {
    if (!SyncObjectPaths.validFile(path)) {
      throw ArgumentError.value(path, 'path');
    }
  }
}

class _PendingRequest {
  const _PendingRequest(this.result, this.timer);
  final Completer<Object?> result;
  final Timer timer;
}

class _RequestFailure implements Exception {
  const _RequestFailure(this.code);
  final String code;
}
