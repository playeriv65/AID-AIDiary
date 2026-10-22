// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:aid_diary/sync/connection_manager.dart';
import 'package:aid_diary/sync/ice_transport.dart';
import 'package:aid_diary/sync/lan_transport.dart';
import 'package:aid_diary/sync/peer_object_link.dart';
import 'package:aid_diary/sync/relay_packets.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:aid_diary/sync/sync_crypto.dart';

/// An account-scoped directory is only a hint. MK-authenticated messages and
/// object probes establish trust before a route reaches the selector.
class InternetTransport {
  InternetTransport(
      {required this.endpoint,
      required this.authorization,
      this.authorizationProvider,
      required this.deviceId,
      required this.userId,
      required this.spaceId,
      required this.masterKey,
      required this.vault,
      required this.localEndpoint,
      required this.stunUrls,
      required this.onCandidate,
      required this.onLost,
      this.reprobe = const Duration(seconds: 30),
      this.enableDirect = true,
      this.enableIce = true,
      this.enableRelay = true,
      this.stunOnly = false})
      : _signalKey = Uint8List.fromList(Hmac(sha256, masterKey)
            .convert(utf8.encode('aid-network-signal-v1\n$userId\n$spaceId'))
            .bytes);

  final Uri endpoint;
  final String authorization, deviceId, userId, spaceId;
  final Future<String> Function()? authorizationProvider;
  final Uint8List masterKey;
  final SyncBackend vault;
  final Uri Function() localEndpoint;
  final List<String> stunUrls;
  final Future<void> Function(SyncRouteCandidate) onCandidate;
  final void Function(String) onLost;
  final Duration reprobe;
  final bool enableDirect, enableIce, enableRelay;
  final bool stunOnly;
  final Uint8List _signalKey;
  final _peers = <String, _InternetPeer>{};
  final _detached = <_InternetPeer>[];
  final _random = Random.secure();
  WebSocket? _socket;
  String? _session;
  String _localNonce = '';
  Timer? _retry, _refresh, _welcomeTimeout, _budgetRetry;
  StreamSubscription<dynamic>? _subscription;
  Future<void> _incoming = Future.value(), _sending = Future.value();
  Future<void> _wireTail = Future.value();
  bool _closed = false, _connecting = false;
  int _failures = 0, _epoch = 0;
  int relayRemainingBytes = 0;
  int relayMaxFrameBytes = 0;
  String state = 'disconnected';
  String? _lastFailure;

  Future<void> start() => _connect();

  /// Refresh signaling without interrupting independently authenticated paths.
  Future<void> reconnect({Duration delay = const Duration(seconds: 5)}) async {
    if (_closed) return;
    await _disconnect(_epoch);
    _retry?.cancel();
    if (!_closed) _retry = Timer(delay, () => unawaited(_connect()));
  }

  Map<String, Object?> diagnostics() => {
        'state': state,
        if (_lastFailure != null) 'lastFailure': _lastFailure,
        'relayRemainingBytes': relayRemainingBytes,
        'peers': [
          for (final peer in _peers.values)
            {
              'ice': peer.iceDiagnostics,
              'gatheredCandidateTypes': peer.candidateTypes,
              'publicEndpoints': peer.direct.length,
              'relayReady': peer.relayVerified,
              'trusted': peer.trusted,
            }
        ],
      };

  Future<void> _connect() async {
    if (_closed || _connecting || _socket != null) return;
    _connecting = true;
    final epoch = ++_epoch;
    try {
      state = 'connecting';
      _localNonce = List.generate(16, (_) => _random.nextInt(256))
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      final tag =
          Hmac(sha256, _signalKey).convert(utf8.encode('directory')).toString();
      final uri =
          endpoint.replace(queryParameters: {'space': tag, 'device': deviceId});
      final socket = await WebSocket.connect(uri.toString(), headers: {
        'Authorization': authorizationProvider == null
            ? authorization
            : await authorizationProvider!()
      }).timeout(const Duration(seconds: 10));
      if (_closed || epoch != _epoch) {
        await socket.close();
        return;
      }
      _socket = socket;
      _welcomeTimeout = Timer(const Duration(seconds: 10), () {
        if (_session == null) unawaited(_disconnect(epoch));
      });
      socket.pingInterval = const Duration(seconds: 20);
      _subscription = socket.listen((event) {
        _incoming = _incoming.then((_) async {
          if (_closed ||
              epoch != _epoch ||
              event is! String ||
              event.length > 65536) {
            return;
          }
          final value = jsonDecode(event);
          if (value is Map<String, dynamic>) await _receive(value);
        }).catchError((Object error) {
          _lastFailure = error.runtimeType.toString();
        });
      },
          onDone: () => unawaited(_disconnect(epoch)),
          onError: (Object _) => unawaited(_disconnect(epoch)),
          cancelOnError: true);
    } catch (_) {
      state = 'disconnected';
      _scheduleRetry();
    } finally {
      _connecting = false;
    }
  }

  void _scheduleRetry() {
    if (_closed) return;
    _retry?.cancel();
    final seconds = min(120, 2 * pow(2, min(_failures++, 6))).toDouble();
    _retry = Timer(
        Duration(
            milliseconds:
                (seconds * (0.8 + _random.nextDouble() * 0.4) * 1000).round()),
        () => unawaited(_connect()));
  }

  Future<void> _disconnect(int epoch) async {
    if (epoch != _epoch) return;
    ++_epoch;
    state = 'disconnected';
    _refresh?.cancel();
    _welcomeTimeout?.cancel();
    final socket = _socket;
    _socket = null;
    _session = null;
    relayRemainingBytes = 0;
    await _subscription?.cancel();
    await socket?.close();
    for (final peer in _peers.values.toList()) {
      if (_closed) {
        await _remove(peer);
      } else {
        await _detach(peer);
      }
    }
    while (_detached.length > 16) {
      await _remove(_detached.removeAt(0));
    }
    _scheduleRetry();
  }

  Future<void> _receive(Map<String, dynamic> frame) async {
    switch (frame['type']) {
      case 'welcome':
        if (_session != null ||
            frame['session'] is! String ||
            !RegExp(r'^[a-f0-9]{32}$').hasMatch(frame['session'] as String)) {
          return;
        }
        _session = frame['session'] as String;
        _welcomeTimeout?.cancel();
        state = 'online';
        _failures = 0;
        _budget(frame['relay']);
        for (final raw in (frame['peers'] as List? ?? const []).take(8)) {
          if (raw is Map) _addPeer(raw['device'], raw['session']);
        }
        _refresh = Timer.periodic(reprobe, (_) => unawaited(_refreshPeers()));
      case 'join':
        _addPeer(frame['device'], frame['session']);
      case 'leave':
        final peer = _peers[frame['device']];
        if (peer != null && peer.session == frame['session']) {
          unawaited(_detach(peer));
        }
      case 'budget':
        _budget(frame['relay']);
      case 'error':
        if (frame['code'] == 'budget' && frame['kind'] == 'relay') {
          relayRemainingBytes = 0;
          for (final peer in _peers.values) {
            peer.relayVerified = false;
            onLost(_routeId(peer, 'relay'));
          }
          _retryBudgetTomorrow();
        }
      case 'signal' || 'relay':
        final peer = _peers[frame['from']];
        if (peer == null ||
            peer.session != frame['session'] ||
            frame['payload'] is! String) {
          return;
        }
        final bytes = base64Decode(frame['payload'] as String);
        if (frame['type'] == 'relay') {
          if (enableRelay) peer.relay?.receive(bytes);
        } else {
          await _signal(peer, bytes);
        }
    }
  }

  void _budget(dynamic value) {
    if (value is Map && value['remainingBytes'] is int) {
      relayRemainingBytes = max(0, value['remainingBytes'] as int);
      if (relayRemainingBytes < 2048) {
        for (final peer in _peers.values) {
          peer.relayVerified = false;
          onLost(_routeId(peer, 'relay'));
        }
        _retryBudgetTomorrow();
      }
    }
    if (value is Map && value['maxFrameBytes'] is int) {
      relayMaxFrameBytes = max(0, value['maxFrameBytes'] as int);
    }
  }

  void _retryBudgetTomorrow() {
    if (_closed || _budgetRetry?.isActive == true) return;
    final now = DateTime.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);
    _budgetRetry = Timer(tomorrow.difference(now) + const Duration(seconds: 1),
        () => unawaited(_disconnect(_epoch)));
  }

  void _addPeer(dynamic id, dynamic session) {
    if (_session == null ||
        id is! String ||
        session is! String ||
        id == deviceId ||
        !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(id) ||
        !RegExp(r'^[a-f0-9]{16,128}$').hasMatch(session)) {
      return;
    }
    final previous = _peers[id];
    if (previous?.session == session) return;
    if (previous != null) unawaited(_detach(previous));
    if (_peers.length >= 8) return;
    final peer = _InternetPeer(id, session);
    _peers[id] = peer;
    unawaited(_hello(peer));
  }

  void _enablePeer(_InternetPeer peer) {
    if (enableRelay && relayMaxFrameBytes >= 2048) {
      final fragmentBytes =
          min(12 * 1024, (relayMaxFrameBytes - 512) * 3 ~/ 4 - 8);
      final relay = peer.relay = RelayPackets(
          fragmentBytes: fragmentBytes,
          timeout: const Duration(minutes: 2),
          write: (packet) => _write(peer, 'relay', packet));
      peer.relayObjects = PeerObjectLink(
          vault: vault,
          masterKey: masterKey,
          userId: userId,
          spaceId: spaceId,
          localSession: '${_session!}:$_localNonce',
          remoteSession: '${peer.session}:${peer.nonce}',
          transport: 'relay',
          packets: relay.packets,
          send: relay.send,
          timeout: const Duration(minutes: 3));
    }
  }

  Future<void> _verifyRelay(_InternetPeer peer) async {
    if (!_live(peer) ||
        !peer.ready ||
        peer.relayObjects == null ||
        relayRemainingBytes < 2048) {
      return;
    }
    try {
      await peer.relayObjects!.backend.check();
      if (!_live(peer) || relayRemainingBytes < 2048) return;
      peer.relayVerified = true;
      await onCandidate(_candidate(
          peer, 'relay', peer.relayObjects!.backend, SyncRouteType.relay));
    } catch (_) {
      onLost(_routeId(peer, 'relay'));
    }
  }

  Future<void> _hello(_InternetPeer peer) async {
    try {
      final addresses =
          enableDirect ? await publicSyncEndpoints(localEndpoint()) : <Uri>[];
      if (!_live(peer)) return;
      await _sendSignal(peer, {
        'type': 'hello',
        'nonce': _localNonce,
        'echo': peer.nonce,
        'endpoints': [for (final uri in addresses) uri.toString()]
      });
      if (peer.ready && enableIce && deviceId.compareTo(peer.id) < 0) {
        await _ensureIce(peer);
      }
    } catch (error) {
      _lastFailure = error.runtimeType.toString();
    }
  }

  Future<void> _signal(_InternetPeer peer, Uint8List bytes) async {
    if (!_live(peer) || bytes.length < 25 || bytes.length > 48000) return;
    final sequence = ByteData.sublistView(bytes).getUint64(0);
    if (sequence <= peer.received) return;
    final nonce = bytes
        .sublist(8, 24)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    if (peer.nonce != null && peer.nonce != nonce) return;
    final plain = await openBytes(_signalKey, Uint8List.sublistView(bytes, 24),
        'signal:${peer.session}:${_session!}:$nonce:$sequence');
    final data = jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
    peer.received = sequence;
    if (data['type'] == 'hello') {
      if (data['nonce'] != nonce) return;
      final first = peer.nonce == null;
      peer.nonce = nonce;
      final trust = !peer.trusted && data['echo'] == _localNonce;
      if (trust) {
        peer.trusted = true;
        _enablePeer(peer);
      }
      if (first || trust) await _hello(peer);
      if (trust) await _sendSignal(peer, {'type': 'ready', 'echo': peer.nonce});
      if (!peer.trusted) return;
      if (enableDirect) {
        final addresses = (data['endpoints'] as List? ?? const [])
            .take(8)
            .whereType<String>()
            .toSet();
        for (final old in peer.direct.keys.toList()) {
          if (!addresses.contains(old)) {
            final uri = Uri.parse(old);
            onLost(_routeId(peer, 'direct:${uri.host}:${uri.port}'));
            peer.direct.remove(old)?.close();
          }
        }
        for (final raw in addresses) {
          unawaited(_probeDirect(peer, raw));
        }
      }
    } else if (peer.trusted &&
        data['type'] == 'ready' &&
        data['echo'] == _localNonce) {
      peer.ready = true;
      if (enableRelay) unawaited(_verifyRelay(peer));
      if (enableIce && deviceId.compareTo(peer.id) < 0) {
        unawaited(_ensureIce(peer));
      }
    } else if (peer.ready &&
        data['type'] == 'rtc' &&
        enableIce &&
        data['value'] is Map) {
      final generation = data['generation'];
      if (generation is! String ||
          !RegExp(r'^[a-f0-9]{32}$').hasMatch(generation)) {
        return;
      }
      if (deviceId.compareTo(peer.id) < 0 && generation != peer.iceGeneration) {
        return;
      }
      await _ensureIce(peer, generation: generation);
      await peer.ice
          ?.receiveSignal((data['value'] as Map).cast<String, dynamic>());
    }
  }

  Future<void> _sendSignal(_InternetPeer peer, Map<String, dynamic> value) {
    final next = _sending.then((_) async {
      if (!_live(peer)) throw StateError('Peer disconnected');
      final sequence = ++peer.sent;
      final sealed = await sealBytes(_signalKey, utf8.encode(jsonEncode(value)),
          'signal:${_session!}:${peer.session}:$_localNonce:$sequence');
      final bytes = Uint8List(24 + sealed.length);
      ByteData.sublistView(bytes).setUint64(0, sequence);
      for (var i = 0; i < 16; i++) {
        bytes[8 + i] =
            int.parse(_localNonce.substring(i * 2, i * 2 + 2), radix: 16);
      }
      bytes.setRange(24, bytes.length, sealed);
      await _write(peer, 'signal', bytes);
    });
    _sending = next.catchError((Object _) {});
    return next;
  }

  Future<void> _write(_InternetPeer peer, String type, Uint8List bytes) {
    final next = _wireTail.then((_) async {
      final socket = _socket;
      if (!_live(peer) || socket == null) {
        throw StateError('Network disconnected');
      }
      final encoded = jsonEncode({
        'type': type,
        'to': peer.id,
        'session': peer.session,
        'payload': base64Encode(bytes)
      });
      if (type == 'relay') {
        if (utf8.encode(encoded).length > relayMaxFrameBytes) {
          throw StateError('Relay frame limit');
        }
        // Reserve both server legs including base64/envelope. The server ledger
        // remains authoritative across concurrent devices and process restarts.
        final cost = utf8.encode(encoded).length * 2 + 256;
        if (cost > relayRemainingBytes) {
          peer.relayVerified = false;
          onLost(_routeId(peer, 'relay'));
          throw StateError('Relay budget exhausted');
        }
        relayRemainingBytes -= cost;
      }
      socket.add(encoded);
      // A bounded sender stays below the default server's per-connection rate
      // even when several metadata and media RPCs run concurrently.
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    _wireTail = next.catchError((Object _) {});
    return next;
  }

  Future<void> _ensureIce(_InternetPeer peer, {String? generation}) async {
    if (!_live(peer)) return;
    if (peer.ice != null &&
        (generation == null || peer.iceGeneration == generation)) {
      return;
    }
    if (generation == null && deviceId.compareTo(peer.id) > 0) return;
    final previous = peer.ice;
    final previousObjects = peer.iceObjects;
    peer.ice = null;
    peer.iceObjects = null;
    peer.iceGeneration = generation ??
        List.generate(16, (_) => _random.nextInt(256))
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join();
    final attempt = peer.iceGeneration!;
    final ice = peer.ice = IcePeerLink(
        initiator: deviceId.compareTo(peer.id) < 0,
        stunUrls: stunUrls,
        sendSignal: (value) {
          final candidate = value['candidate'];
          if (candidate is String) {
            final type = RegExp(r' typ (\w+)').firstMatch(candidate)?.group(1);
            if (type != null) {
              peer.candidateTypes.update(type, (n) => n + 1, ifAbsent: () => 1);
            }
            if (stunOnly && type != 'srflx' && type != 'prflx') {
              return Future.value();
            }
          }
          final signal = Map<String, dynamic>.from(value);
          if (stunOnly && signal['sdp'] is String) {
            signal['sdp'] = (signal['sdp'] as String)
                .split('\r\n')
                .where((line) =>
                    !line.startsWith('a=candidate:') ||
                    line.contains(' typ srflx ') ||
                    line.contains(' typ prflx '))
                .join('\r\n');
          }
          return _sendSignal(
              peer, {'type': 'rtc', 'generation': attempt, 'value': signal});
        });
    final objects = peer.iceObjects = PeerObjectLink(
        vault: vault,
        masterKey: masterKey,
        userId: userId,
        spaceId: spaceId,
        localSession: '${_session!}:$_localNonce',
        remoteSession: '${peer.session}:${peer.nonce}',
        transport: 'ice:$attempt',
        packets: ice.packets,
        send: ice.send);
    await peer.iceLoss?.cancel();
    peer.iceLoss = ice.disconnected.listen((_) {
      if (_live(peer) && peer.ice == ice) {
        onLost(_routeId(peer, 'ice'));
        peer.ice = null;
        peer.iceObjects = null;
        unawaited(objects.close());
      }
    });
    await previousObjects?.close();
    await previous?.close();
    unawaited(() async {
      try {
        await ice.ready;
        await objects.backend.check();
        if (!_live(peer) || peer.ice != ice) return;
        peer.iceDiagnostics = await ice.diagnostics();
        await onCandidate(
            _candidate(peer, 'ice', objects.backend, SyncRouteType.ice));
        for (final old in _detached.where((p) => p.id == peer.id)) {
          if (old.ice != null) onLost(_routeId(old, 'ice'));
          await old.iceLoss?.cancel();
          await old.iceObjects?.close();
          await old.ice?.close();
          old.ice = null;
          old.iceObjects = null;
        }
      } catch (_) {
        if (_live(peer) && peer.ice == ice) {
          onLost(_routeId(peer, 'ice'));
          peer.ice = null;
          peer.iceObjects = null;
          await objects.close();
          await ice.close();
        }
      }
    }());
    await ice.start();
  }

  Future<void> _probeDirect(_InternetPeer peer, String raw) async {
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        !isPublicSyncEndpoint(uri) ||
        !_live(peer) ||
        peer.direct.containsKey(raw) ||
        peer.direct.length >= 8 ||
        !peer.probing.add(raw)) {
      return;
    }
    try {
      final verified = await LanMediaBackend.connect(
          endpoint: uri,
          userId: userId,
          spaceId: spaceId,
          masterKey: masterKey);
      if (!_live(peer) || verified.id != peer.id) {
        verified.backend.close();
        return;
      }
      peer.direct[raw] = verified.backend;
      await onCandidate(_candidate(peer, 'direct:${uri.host}:${uri.port}',
          verified.backend, SyncRouteType.direct));
      for (final old in _detached.where((p) => p.id == peer.id)) {
        final replaced = old.direct.remove(raw);
        if (replaced != null) {
          onLost(_routeId(old, 'direct:${uri.host}:${uri.port}'));
          replaced.close();
        }
      }
    } catch (_) {
      /* An address hint is never proof of public reachability. */
    } finally {
      peer.probing.remove(raw);
    }
  }

  SyncRouteCandidate _candidate(_InternetPeer peer, String name,
          SyncBackend backend, SyncRouteType type) =>
      SyncRouteCandidate(
          id: _routeId(peer, name),
          backend: backend,
          type: type,
          userId: userId,
          spaceId: spaceId,
          cost: type == SyncRouteType.relay ? 0.8 : 0);

  String _routeId(_InternetPeer peer, String name) =>
      '$name:${peer.id}:${peer.session}';

  bool _live(_InternetPeer peer) =>
      !_closed && _session != null && identical(_peers[peer.id], peer);

  Future<void> _refreshPeers() async {
    for (final peer in _peers.values.toList()) {
      if (peer.relayObjects?.isClosed == true && relayRemainingBytes >= 2048) {
        // A new authenticated client nonce fences failed relay fragments while
        // established direct channels remain usable during signaling recovery.
        await _disconnect(_epoch);
        return;
      }
      unawaited(_hello(peer));
      if (!peer.relayVerified && enableRelay) unawaited(_verifyRelay(peer));
      final ice = peer.ice;
      if (ice != null) {
        try {
          peer.iceDiagnostics = await ice.diagnostics();
        } catch (_) {}
      }
    }
  }

  Future<void> _remove(_InternetPeer peer) async {
    if (identical(_peers[peer.id], peer)) _peers.remove(peer.id);
    onLost(_routeId(peer, 'relay'));
    onLost(_routeId(peer, 'ice'));
    for (final entry in peer.direct.entries) {
      final uri = Uri.parse(entry.key);
      onLost(_routeId(peer, 'direct:${uri.host}:${uri.port}'));
      entry.value.close();
    }
    await peer.relayObjects?.close();
    await peer.iceObjects?.close();
    await peer.iceLoss?.cancel();
    await peer.relay?.close();
    await peer.ice?.close();
  }

  Future<void> _detach(_InternetPeer peer) async {
    if (identical(_peers[peer.id], peer)) _peers.remove(peer.id);
    onLost(_routeId(peer, 'relay'));
    peer.relayVerified = false;
    if (!_detached.contains(peer)) _detached.add(peer);
    await peer.relayObjects?.close();
    await peer.relay?.close();
    while (_detached.length > 16) {
      await _remove(_detached.removeAt(0));
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _retry?.cancel();
    _refresh?.cancel();
    _budgetRetry?.cancel();
    await _disconnect(_epoch);
    for (final peer in _detached) {
      await _remove(peer);
    }
    _detached.clear();
  }
}

class _InternetPeer {
  _InternetPeer(this.id, this.session);
  final String id, session;
  int sent = 0, received = 0;
  String? nonce;
  bool trusted = false;
  bool ready = false;
  final direct = <String, LanMediaBackend>{};
  final probing = <String>{};
  bool relayVerified = false;
  RelayPackets? relay;
  PeerObjectLink? relayObjects, iceObjects;
  IcePeerLink? ice;
  String? iceGeneration;
  StreamSubscription<void>? iceLoss;
  Map<String, Object?>? iceDiagnostics;
  final candidateTypes = <String, int>{};
}

/// Only numeric global unicast addresses may be advertised. DNS, credentials,
/// overlay/loopback/link-local/private and arbitrary URL paths are rejected.
bool isPublicSyncEndpoint(Uri uri) {
  if (uri.scheme != 'http' ||
      uri.userInfo.isNotEmpty ||
      uri.port <= 0 ||
      uri.hasQuery ||
      uri.hasFragment ||
      (uri.path.isNotEmpty && uri.path != '/')) {
    return false;
  }
  final address = InternetAddress.tryParse(uri.host);
  if (address == null ||
      address.isLoopback ||
      address.isLinkLocal ||
      address.isMulticast) {
    return false;
  }
  final bytes = address.rawAddress;
  if (address.type == InternetAddressType.IPv6) {
    return bytes[0] & 0xe0 == 0x20 &&
        !(bytes[0] == 0x20 &&
            bytes[1] == 1 &&
            bytes[2] == 0x0d &&
            bytes[3] == 0xb8);
  }
  return bytes[0] > 0 &&
      bytes[0] < 224 &&
      bytes[0] != 10 &&
      bytes[0] != 127 &&
      !(bytes[0] == 169 && bytes[1] == 254) &&
      !(bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) &&
      !(bytes[0] == 192 && bytes[1] == 168) &&
      !(bytes[0] == 100 && bytes[1] >= 64 && bytes[1] <= 127) &&
      !(bytes[0] == 192 && bytes[1] == 0) &&
      !(bytes[0] == 198 &&
          (bytes[1] == 18 || bytes[1] == 19 || bytes[1] == 51)) &&
      !(bytes[0] == 203 && bytes[1] == 0 && bytes[2] == 113);
}

Future<List<Uri>> publicSyncEndpoints(Uri listener) async => [
      for (final interface
          in await NetworkInterface.list(includeLinkLocal: false))
        for (final address in interface.addresses)
          if (isPublicSyncEndpoint(
              Uri(scheme: 'http', host: address.address, port: listener.port)))
            Uri(scheme: 'http', host: address.address, port: listener.port),
    ].take(8).toList();
