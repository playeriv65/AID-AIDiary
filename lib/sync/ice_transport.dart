// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef IcePeerFactory = Future<RTCPeerConnection> Function(
    Map<String, dynamic> configuration);

/// A reliable binary data channel. The caller authenticates and encrypts all
/// signaling and application packets; opening a channel establishes no trust.
/// STUN supplies connectivity candidates, never an operator-funded TURN path.
class IcePeerLink {
  IcePeerLink(
      {required this.initiator,
      required List<String> stunUrls,
      required this.sendSignal,
      this.timeout = const Duration(seconds: 20),
      IcePeerFactory? peerFactory})
      : stunUrls = List.unmodifiable(stunUrls),
        _peerFactory =
            peerFactory ?? ((config) => createPeerConnection(config)) {
    if (timeout <= Duration.zero ||
        stunUrls.length > 16 ||
        stunUrls.any((url) =>
            url.length > 2048 ||
            !{'stun', 'stuns'}.contains(Uri.tryParse(url)?.scheme))) {
      throw ArgumentError('Invalid ICE timeout or STUN configuration');
    }
    // Callers may subscribe after native startup fails. Keep the original
    // future observable without an unhandled error in that interval.
    _ready.future.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _initialized.future
        .then<void>((_) {}, onError: (Object _, StackTrace __) {});
  }

  final bool initiator;
  final List<String> stunUrls;
  final Future<void> Function(Map<String, dynamic>) sendSignal;
  final Duration timeout;
  final IcePeerFactory _peerFactory;
  final _packets = StreamController<Uint8List>.broadcast();
  final _disconnected = StreamController<void>.broadcast();
  final _ready = Completer<void>();
  final _initialized = Completer<void>();
  final _waiters = <void Function()>{};
  final _framing = IcePacketFraming();
  final _earlyCandidates = <RTCIceCandidate>[];
  final _outgoingCandidates = <Map<String, dynamic>>[];
  RTCPeerConnection? _peer;
  RTCDataChannel? _channel;
  Future<void>? _starting;
  Future<void>? _closing;
  Future<void> _signalTail = Future.value();
  Future<void> _sendTail = Future.value();
  Completer<void>? _drainWake;
  Timer? _connectTimer;
  Timer? _assemblyTimer;
  Timer? _drainTimer;
  bool _closed = false;
  bool _remoteDescription = false;
  bool _descriptionSent = false;
  int _queuedBytes = 0;
  int _queuedPackets = 0;
  int _queuedSignals = 0;
  int _bufferedBytes = 0;
  int _txFrames = 0;
  int _rxFrames = 0;
  String? _lastFailure;
  static const _bufferLimit = 256 * 1024;
  static const _drainPollInterval = Duration(milliseconds: 20);
  static const _channelLabel = 'aid-sync-v1';

  Stream<Uint8List> get packets => _packets.stream;
  Stream<void> get disconnected => _disconnected.stream;
  Future<void> get ready => _ready.future;

  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    if (_closed) throw StateError('ICE link is closed');
    _connectTimer = Timer(timeout,
        () => unawaited(_fail(TimeoutException('ICE channel did not open'))));
    try {
      final native = _peerFactory({
        'iceServers': [
          if (stunUrls.isNotEmpty) {'urls': stunUrls}
        ],
        'iceTransportPolicy': 'all',
        'sdpSemantics': 'unified-plan',
        'bundlePolicy': 'max-bundle',
      });
      final peer = await native.timeout(timeout, onTimeout: () {
        unawaited(native.then(_disposePeer).catchError((Object _) {}));
        throw TimeoutException('Native ICE startup timed out');
      });
      if (_closed) {
        await _disposePeer(peer);
        throw StateError('ICE link closed during startup');
      }
      _peer = peer;
      peer.onIceCandidate = (candidate) {
        if (_closed || (candidate.candidate ?? '').isEmpty) return;
        final signal = <String, dynamic>{
          'type': 'candidate',
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        };
        if (_descriptionSent) {
          unawaited(_emitSignal(signal));
        } else if (_outgoingCandidates.length < 512) {
          _outgoingCandidates.add(signal);
        } else {
          unawaited(
              _fail(const FormatException('Too many local ICE candidates')));
        }
      };
      peer.onConnectionState = (state) {
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
            state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
          unawaited(_fail(StateError('ICE peer connection ${state.name}')));
        }
      };
      peer.onIceConnectionState = (state) {
        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
            state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
          unawaited(_fail(StateError('ICE connectivity ${state.name}')));
        }
      };
      peer.onDataChannel = (channel) {
        if (initiator || _channel != null || channel.label != _channelLabel) {
          unawaited(channel.close().catchError((Object _) {}));
        } else {
          _attach(channel);
        }
      };
      if (initiator) {
        final channel = await peer.createDataChannel(
            _channelLabel,
            RTCDataChannelInit()
              ..ordered = true
              ..binaryType = 'binary');
        if (_closed) {
          await channel.close();
          throw StateError('ICE link closed during channel creation');
        }
        _attach(channel);
      }
      _initialized.complete();
      if (initiator) {
        final offer = await _wait(peer.createOffer());
        await _wait(peer.setLocalDescription(offer));
        await _sendDescription('offer', offer.sdp);
      }
    } catch (error, stack) {
      if (!_initialized.isCompleted) _initialized.completeError(error, stack);
      await _fail(error);
      rethrow;
    }
  }

  Future<void> _emitSignal(Map<String, dynamic> signal) async {
    try {
      await _wait(sendSignal(signal));
    } catch (error) {
      await _fail(error);
    }
  }

  Future<void> _sendDescription(String type, String? sdp) async {
    await _wait(sendSignal({'type': type, 'sdp': sdp}));
    _descriptionSent = true;
    final candidates = _outgoingCandidates.toList();
    _outgoingCandidates.clear();
    for (final signal in candidates) {
      await _wait(sendSignal(signal));
    }
  }

  /// Signaling may arrive before start, SDP or even before native startup.
  /// The externally deterministic initiator prevents offer collisions.
  Future<void> receiveSignal(Map<String, dynamic> signal) {
    if (_queuedSignals >= 1024) {
      return Future.error(const FormatException('ICE signaling queue is full'));
    }
    _queuedSignals++;
    final operation = _signalTail.then((_) async {
      if (_closed) throw StateError('ICE link is closed');
      if (_starting == null) unawaited(start().catchError((Object _) {}));
      await _wait(_initialized.future);
      final peer = _peer!;
      final type = signal['type'];
      if (type == 'candidate') {
        final value = signal['candidate'];
        final mid = signal['sdpMid'];
        final line = signal['sdpMLineIndex'];
        if (value is! String ||
            value.length > 4096 ||
            (mid != null && (mid is! String || mid.length > 128)) ||
            (line != null && (line is! int || line < 0 || line > 65535))) {
          throw const FormatException('Invalid ICE candidate');
        }
        if (value.isEmpty) return;
        final candidate = RTCIceCandidate(value, mid as String?, line as int?);
        if (_remoteDescription) {
          await _wait(peer.addCandidate(candidate));
        } else {
          if (_earlyCandidates.length >= 512) {
            throw const FormatException('Too many early ICE candidates');
          }
          _earlyCandidates.add(candidate);
        }
      } else if (type == 'offer' || type == 'answer') {
        final sdp = signal['sdp'];
        if (sdp is! String ||
            sdp.isEmpty ||
            sdp.length > 256 * 1024 ||
            (type == 'offer') == initiator ||
            _remoteDescription) {
          throw const FormatException('Unexpected ICE description');
        }
        await _wait(
            peer.setRemoteDescription(RTCSessionDescription(sdp, type)));
        _remoteDescription = true;
        for (final candidate in _earlyCandidates) {
          await _wait(peer.addCandidate(candidate));
        }
        _earlyCandidates.clear();
        if (type == 'offer') {
          final answer = await _wait(peer.createAnswer());
          await _wait(peer.setLocalDescription(answer));
          await _sendDescription('answer', answer.sdp);
        }
      } else {
        throw const FormatException('Unknown ICE signal');
      }
    });
    final tracked = operation.whenComplete(() => _queuedSignals--);
    _signalTail = tracked.then<void>((_) {},
        onError: (Object error, StackTrace _) => unawaited(_fail(error)));
    return tracked;
  }

  void _attach(RTCDataChannel channel) {
    _channel = channel;
    channel.bufferedAmountLowThreshold = _bufferLimit ~/ 2;
    channel.onBufferedAmountLow = _bufferChanged;
    channel.onBufferedAmountChange = (amount, _) => _bufferChanged(amount);
    channel.onDataChannelState = (state) {
      if (state == RTCDataChannelState.RTCDataChannelOpen && !_closed) {
        _connectTimer?.cancel();
        if (!_ready.isCompleted) _ready.complete();
      } else if (state == RTCDataChannelState.RTCDataChannelClosed ||
          state == RTCDataChannelState.RTCDataChannelClosing) {
        unawaited(_fail(StateError('ICE data channel closed')));
      }
    };
    channel.onMessage = (message) {
      if (_closed) return;
      try {
        if (!message.isBinary) {
          throw const FormatException('ICE channel requires binary frames');
        }
        _rxFrames++;
        final packet = _framing.receive(message.binary);
        if (packet != null) {
          _assemblyTimer?.cancel();
          _assemblyTimer = null;
          _packets.add(packet);
        } else {
          _assemblyTimer ??= Timer(
              timeout,
              () => unawaited(
                  _fail(TimeoutException('Incomplete ICE packet timed out'))));
        }
      } catch (error) {
        unawaited(_fail(error));
      }
    };
    final state = channel.state;
    if (state != null) channel.onDataChannelState!(state);
  }

  Future<void> send(Uint8List packet) async {
    if (_closed) throw StateError('ICE link is closed');
    if (packet.length > IcePacketFraming.maxPacketBytes ||
        _queuedPackets >= 32 ||
        _queuedBytes + packet.length > IcePacketFraming.maxPacketBytes) {
      throw ArgumentError('ICE outgoing queue exceeds packet limit');
    }
    final bytes = Uint8List.fromList(packet);
    _queuedBytes += bytes.length;
    _queuedPackets++;
    final operation = _sendTail.then((_) async {
      await _wait(ready);
      for (final frame in IcePacketFraming.frames(bytes)) {
        final channel = _channel!;
        while (true) {
          if (_closed) throw StateError('ICE link is closed');
          final wake = _drainWake = Completer<void>();
          final buffered = await _wait(channel.getBufferedAmount());
          _bufferedBytes = buffered;
          if (buffered + frame.length <= _bufferLimit) {
            _drainWake = null;
            break;
          }
          // Desktop WebRTC currently omits native buffer-change events
          // (upstream #2206). Recheck the native getter even without callbacks.
          // A single timer exists only while this serialized sender is blocked.
          try {
            if (!wake.isCompleted) {
              _drainTimer = Timer(_drainPollInterval, _wakeDrain);
            }
            await _wait(wake.future);
          } finally {
            _drainTimer?.cancel();
            _drainTimer = null;
            if (_drainWake == wake) _drainWake = null;
          }
        }
        await _wait(channel.send(RTCDataChannelMessage.fromBinary(frame)));
        _txFrames++;
      }
    });
    _sendTail =
        operation.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    try {
      await _wait(operation);
    } catch (error) {
      await _fail(error);
      rethrow;
    } finally {
      _queuedBytes -= bytes.length;
      _queuedPackets--;
    }
  }

  void _wakeDrain() {
    _drainTimer?.cancel();
    _drainTimer = null;
    final wake = _drainWake;
    _drainWake = null;
    if (wake != null && !wake.isCompleted) wake.complete();
  }

  void _bufferChanged(int amount) {
    _bufferedBytes = amount;
    _wakeDrain();
  }

  Future<T> _wait<T>(Future<T> operation) {
    final result = Completer<T>();
    Timer? timer;
    late void Function() cancel;
    void remove() {
      timer?.cancel();
      _waiters.remove(cancel);
    }

    void fail(Object error, [StackTrace? stack]) {
      if (result.isCompleted) return;
      remove();
      result.completeError(error, stack);
    }

    cancel = () => fail(StateError('ICE link is closed'));
    _waiters.add(cancel);
    operation.then<void>((value) {
      if (result.isCompleted) return;
      remove();
      result.complete(value);
    }, onError: fail);
    timer =
        Timer(timeout, () => fail(TimeoutException('ICE operation timed out')));
    if (_closed) cancel();
    return result.future;
  }

  Future<Map<String, Object?>> diagnostics() async {
    final peer = _peer;
    final result = <String, Object?>{
      'channelOpen':
          !_closed && _channel?.state == RTCDataChannelState.RTCDataChannelOpen,
      'connectionState': peer?.connectionState?.name,
      'iceState': peer?.iceConnectionState?.name,
      'selectedPair': null,
      'queuedBytes': _queuedBytes,
      'bufferedBytes': _bufferedBytes,
      'txFrames': _txFrames,
      'rxFrames': _rxFrames,
      'rxPartialBytes': _framing.partialBytes,
      'backpressurePolling': _drainTimer?.isActive ?? false,
      'lastFailure': _lastFailure,
    };
    if (_closed || peer == null) return result;
    final channel = _channel;
    if (channel != null) {
      try {
        _bufferedBytes = await _wait(channel.getBufferedAmount());
        result['bufferedBytes'] = _bufferedBytes;
      } catch (error) {
        result['diagnosticsFailure'] = _failureKind(error);
      }
    }
    List<StatsReport> reports;
    try {
      reports = await _wait(peer.getStats());
    } catch (error) {
      result['diagnosticsFailure'] = _failureKind(error);
      return result;
    }
    final byId = {for (final report in reports) report.id: report};
    StatsReport? selected;
    for (final report
        in reports.where((report) => report.type == 'transport')) {
      final id = report.values['selectedCandidatePairId'];
      if (id is String && byId[id]?.type == 'candidate-pair') {
        selected = byId[id];
        break;
      }
    }
    selected ??= reports
        .where((report) =>
            report.type == 'candidate-pair' &&
            (report.values['selected'] == true ||
                (report.values['nominated'] == true &&
                    report.values['state'] == 'succeeded')))
        .firstOrNull;
    if (selected != null) {
      Map<String, Object?> candidate(Object? id) {
        final values = byId[id]?.values;
        return {
          'type': values?['candidateType'],
          'protocol': values?['protocol'],
        };
      }

      result['selectedPair'] = {
        'local': candidate(selected.values['localCandidateId']),
        'remote': candidate(selected.values['remoteCandidateId']),
        'state': selected.values['state'],
        'roundTripSeconds': selected.values['currentRoundTripTime'],
        'bytesSent': selected.values['bytesSent'],
        'bytesReceived': selected.values['bytesReceived'],
      };
    }
    return result;
  }

  Future<void> _fail(Object error) async {
    if (_closed) return;
    _lastFailure = _failureKind(error);
    if (!_ready.isCompleted) _ready.completeError(error);
    if (!_initialized.isCompleted) _initialized.completeError(error);
    _packets.addError(error);
    await close();
  }

  Future<void> close() => _closing ??= _close();

  static String _failureKind(Object error) => switch (error) {
        TimeoutException() => 'timeout',
        FormatException() => 'protocol',
        ArgumentError() => 'limits',
        StateError() => 'state',
        _ => 'transport',
      };

  Future<void> _close() async {
    _closed = true;
    _connectTimer?.cancel();
    _assemblyTimer?.cancel();
    _earlyCandidates.clear();
    _outgoingCandidates.clear();
    _framing.reset();
    if (!_ready.isCompleted) {
      _ready.completeError(StateError('ICE link closed'));
    }
    if (!_initialized.isCompleted) {
      _initialized.completeError(StateError('ICE link closed'));
    }
    for (final cancel in _waiters.toList()) {
      cancel();
    }
    _disconnected.add(null);
    _wakeDrain();
    final channel = _channel;
    if (channel != null) {
      channel.onMessage = null;
      channel.onDataChannelState = null;
      channel.onBufferedAmountChange = null;
      channel.onBufferedAmountLow = null;
      try {
        await channel.close().timeout(timeout);
      } catch (_) {}
    }
    final peer = _peer;
    if (peer != null) await _disposePeer(peer);
    await _packets.close();
    await _disconnected.close();
  }

  Future<void> _disposePeer(RTCPeerConnection peer) async {
    peer.onIceCandidate = null;
    peer.onDataChannel = null;
    peer.onConnectionState = null;
    peer.onIceConnectionState = null;
    try {
      await peer.close().timeout(timeout);
    } catch (_) {}
    try {
      await peer.dispose().timeout(timeout);
    } catch (_) {}
  }
}

/// One packet at a time on the ordered reliable channel; fixed headers prevent
/// native message-size limits from leaking into the application RPC protocol.
class IcePacketFraming {
  static const maxPacketBytes = 24 * 1024 * 1024;
  static const maxFrameBytes = 16 * 1024;
  static const _headerBytes = 12;
  static const _magic = 0x41494431;
  Uint8List? _assembling;
  int _received = 0;
  int get partialBytes => _received;

  static Iterable<Uint8List> frames(Uint8List packet) sync* {
    if (packet.length > maxPacketBytes) {
      throw ArgumentError('ICE packet exceeds reassembly limit');
    }
    var offset = 0;
    do {
      final count = min(maxFrameBytes - _headerBytes, packet.length - offset);
      final frame = Uint8List(_headerBytes + count);
      ByteData.sublistView(frame)
        ..setUint32(0, _magic)
        ..setUint32(4, packet.length)
        ..setUint32(8, offset);
      frame.setRange(_headerBytes, frame.length, packet, offset);
      yield frame;
      offset += count;
    } while (offset < packet.length);
  }

  Uint8List? receive(Uint8List frame) {
    try {
      if (frame.length < _headerBytes || frame.length > maxFrameBytes) {
        throw const FormatException('Invalid ICE frame size');
      }
      final header = ByteData.sublistView(frame);
      final length = header.getUint32(4);
      final offset = header.getUint32(8);
      final count = frame.length - _headerBytes;
      if (header.getUint32(0) != _magic ||
          length > maxPacketBytes ||
          offset != _received ||
          offset + count > length ||
          (count == 0 && length != 0)) {
        throw const FormatException('Invalid ICE frame header');
      }
      final target = _assembling ??= Uint8List(length);
      if (target.length != length) {
        throw const FormatException('ICE packet length changed');
      }
      target.setRange(offset, offset + count, frame, _headerBytes);
      _received += count;
      if (_received == length) {
        reset();
        return target;
      }
      return null;
    } catch (_) {
      reset();
      rethrow;
    }
  }

  void reset() {
    _assembling = null;
    _received = 0;
  }
}
