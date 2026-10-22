// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:typed_data';

import 'package:aid_diary/sync/ice_transport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  test('framing reconstructs empty, boundary and maximum-size packets', () {
    for (final size in [
      0,
      1,
      16372,
      16373,
      1048576,
      IcePacketFraming.maxPacketBytes
    ]) {
      final packet = Uint8List(size);
      for (var i = 0; i < size; i++) {
        packet[i] = i % 251;
      }
      final framing = IcePacketFraming();
      Uint8List? received;
      for (final frame in IcePacketFraming.frames(packet)) {
        expect(frame.length, lessThanOrEqualTo(16384));
        received = framing.receive(frame);
      }
      expect(received, orderedEquals(packet));
    }
  });

  test('framing rejects malformed, reordered and oversized frames', () {
    final packet = Uint8List(20000);
    final frames = IcePacketFraming.frames(packet).toList();
    final framing = IcePacketFraming();
    expect(() => framing.receive(frames[1]), throwsFormatException);
    expect(() => framing.receive(Uint8List(16385)), throwsFormatException);
    final changed = Uint8List.fromList(frames[0]);
    ByteData.sublistView(changed)
        .setUint32(4, IcePacketFraming.maxPacketBytes + 1);
    expect(() => framing.receive(changed), throwsFormatException);
    changed[0] = 0;
    expect(() => framing.receive(changed), throwsFormatException);
    expect(framing.receive(frames[0]), isNull);
    final changedLength = Uint8List.fromList(frames[1]);
    ByteData.sublistView(changedLength).setUint32(4, 20001);
    expect(() => framing.receive(changedLength), throwsFormatException);
    expect(
        framing
            .receive(IcePacketFraming.frames(Uint8List.fromList([7])).single),
        [7]);
  });

  test('STUN configuration never accepts TURN endpoints', () {
    expect(
        () => IcePeerLink(
            initiator: true,
            stunUrls: ['turn:example.org'],
            sendSignal: (_) async {}),
        throwsArgumentError);
  });

  test('early candidates wait for SDP and signaling is reentrant-safe',
      () async {
    final peer = _Peer();
    final sent = <Map<String, dynamic>>[];
    final link = IcePeerLink(
        initiator: false,
        stunUrls: [],
        sendSignal: (signal) async => sent.add(signal),
        peerFactory: (_) async => peer);
    addTearDown(link.close);
    await link.receiveSignal({
      'type': 'candidate',
      'candidate': 'candidate-one',
      'sdpMid': '0',
      'sdpMLineIndex': 0
    });
    expect(peer.events, isEmpty);
    await link.receiveSignal({'type': 'offer', 'sdp': 'offer-sdp'});
    expect(
        peer.events, ['remote:offer', 'candidate', 'answer', 'local:answer']);
    expect(sent.single, {'type': 'answer', 'sdp': 'answer-sdp'});
  });

  test('paired links exchange fragmented binary RPC packets', () async {
    final nativeA = _Peer();
    final nativeB = _Peer();
    nativeA.channel.other = nativeB.channel;
    nativeB.channel.other = nativeA.channel;
    late IcePeerLink a;
    late IcePeerLink b;
    a = IcePeerLink(
        initiator: true,
        stunUrls: ['stun:example.org:3478'],
        sendSignal: (signal) => b.receiveSignal(signal),
        peerFactory: (config) async {
          expect(config['iceServers'], [
            {
              'urls': ['stun:example.org:3478']
            }
          ]);
          return nativeA;
        });
    b = IcePeerLink(
        initiator: false,
        stunUrls: [],
        sendSignal: (signal) => a.receiveSignal(signal),
        peerFactory: (_) async => nativeB);
    addTearDown(a.close);
    addTearDown(b.close);
    await a.start().timeout(const Duration(seconds: 2));
    await Future.wait([a.ready, b.ready]);
    final received = b.packets.first;
    final bytes = Uint8List.fromList(List.generate(100000, (i) => i % 256));
    await a.send(bytes);
    expect(await received, orderedEquals(bytes));
    expect(nativeA.channel.frames.length, greaterThan(1));
    expect(nativeA.init!.ordered, isTrue);
    expect(nativeA.init!.maxRetransmits, -1);
  });

  test('local candidates emitted during SDP setup follow the initial offer',
      () async {
    final native = _Peer()..candidateDuringLocalDescription = true;
    final signals = <Map<String, dynamic>>[];
    final link = IcePeerLink(
        initiator: true,
        stunUrls: [],
        sendSignal: (signal) async => signals.add(signal),
        peerFactory: (_) async => native);
    addTearDown(link.close);
    await link.start();
    expect(signals.map((signal) => signal['type']), ['offer', 'candidate']);
  });

  test('backpressure waits and close releases an in-flight sender', () async {
    final native = _Peer();
    final link = _link(native);
    addTearDown(link.close);
    await link.start();
    native.channel.amount = 256 * 1024;
    final pending = link.send(Uint8List(20000));
    await native.channel.queried.future;
    expect(native.channel.frames, isEmpty);
    final fails = expectLater(pending, throwsStateError);
    await link.close();
    await fails;
    expect(native.disposed, isTrue);
  });

  test('buffer drain notification resumes a blocked sender', () async {
    final native = _Peer();
    final link = _link(native);
    addTearDown(link.close);
    await link.start();
    native.channel.amount = 256 * 1024;
    final pending = link.send(Uint8List.fromList([8]));
    await native.channel.queried.future;
    native.channel.amount = 0;
    native.channel.onBufferedAmountLow?.call(0);
    await pending;
    expect(native.channel.frames, hasLength(1));
  });

  test('native getter drain resumes large transfers without buffer callbacks',
      () async {
    final native = _Peer();
    native.channel
      ..amount = 256 * 1024
      ..silentDrain = true;
    final link = _link(native);
    addTearDown(link.close);
    await link.start();
    final pending = link.send(Uint8List(700000));
    await native.channel.queried.future;
    final release = Timer(const Duration(milliseconds: 45), () {
      // Model desktop draining its native buffer without posting Dart events.
      native.channel.amount = 0;
    });
    addTearDown(release.cancel);
    await pending.timeout(const Duration(seconds: 2));
    expect(native.channel.frames.length, greaterThan(40));
    expect(native.channel.peakAmount, lessThanOrEqualTo(256 * 1024));
    expect(native.channel.bufferQueries,
        greaterThan(native.channel.frames.length));
    final diagnostics = await link.diagnostics();
    expect(diagnostics['txFrames'], native.channel.frames.length);
    expect(diagnostics['queuedBytes'], 0);
    expect(diagnostics['backpressurePolling'], isFalse);
  });

  test('closing a blocked sender cancels native buffer polling', () async {
    final native = _Peer();
    final link = _link(native);
    await link.start();
    native.channel.amount = 256 * 1024;
    final pending = expectLater(link.send(Uint8List(1)), throwsStateError);
    await native.channel.queried.future;
    await Future<void>.delayed(const Duration(milliseconds: 45));
    expect(native.channel.bufferQueries, greaterThan(1));
    await link.close();
    await pending;
    final count = native.channel.bufferQueries;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(native.channel.bufferQueries, count);
    expect((await link.diagnostics())['backpressurePolling'], isFalse);
  });

  test('close rejects pending readiness and publishes disconnection once',
      () async {
    final native = _Peer(open: false);
    final link = _link(native);
    await link.start();
    final events = <void>[];
    final subscription = link.disconnected.listen(events.add);
    final readiness = expectLater(link.ready, throwsStateError);
    await link.close();
    await link.close();
    await readiness;
    expect(events, hasLength(1));
    expect(native.disposed, isTrue);
    await subscription.cancel();
  });

  test('a late native result is disposed after startup times out', () async {
    final pending = Completer<RTCPeerConnection>();
    final native = _Peer();
    final link = IcePeerLink(
        initiator: true,
        stunUrls: [],
        timeout: const Duration(milliseconds: 20),
        sendSignal: (_) async {},
        peerFactory: (_) => pending.future);
    addTearDown(link.close);
    await expectLater(link.start(), throwsA(isA<TimeoutException>()));
    pending.complete(native);
    await native.disposedSignal.future;
    expect(native.disposed, isTrue);
  });

  test(
      'channel loss after readiness notifies coordinator and closes native peer',
      () async {
    final native = _Peer();
    final link = _link(native);
    await link.start();
    await link.ready;
    final disconnected = link.disconnected.first;
    native.channel.onDataChannelState
        ?.call(RTCDataChannelState.RTCDataChannelClosed);
    await disconnected;
    await native.disposedSignal.future;
    expect((await link.diagnostics())['channelOpen'], isFalse);
  });

  test('diagnostics report the selected host pair without public-path claims',
      () async {
    final native = _Peer();
    native.reports = [
      StatsReport(
          'transport', 'transport', 0, {'selectedCandidatePairId': 'pair'}),
      StatsReport('pair', 'candidate-pair', 0, {
        'state': 'succeeded',
        'localCandidateId': 'local',
        'remoteCandidateId': 'remote'
      }),
      StatsReport('local', 'local-candidate', 0,
          {'candidateType': 'host', 'protocol': 'udp'}),
      StatsReport('remote', 'remote-candidate', 0,
          {'candidateType': 'host', 'protocol': 'udp'}),
    ];
    final link = _link(native);
    addTearDown(link.close);
    await link.start();
    final diagnostic = await link.diagnostics();
    expect(diagnostic['selectedPair'], {
      'local': {'type': 'host', 'protocol': 'udp'},
      'remote': {'type': 'host', 'protocol': 'udp'},
      'state': 'succeeded',
      'roundTripSeconds': null,
      'bytesSent': null,
      'bytesReceived': null,
    });
    native.reports = [];
    expect((await link.diagnostics())['selectedPair'], isNull);
  });

  test('malformed native frames close the link and discard reassembly',
      () async {
    final native = _Peer();
    final link = _link(native);
    final errors = <Object>[];
    final done = Completer<void>();
    link.packets.listen((_) {}, onError: errors.add, onDone: done.complete);
    await link.start();
    native.channel.onMessage!(RTCDataChannelMessage.fromBinary(Uint8List(2)));
    await done.future;
    expect(errors.single, isFormatException);
    expect(native.disposed, isTrue);
    expect((await link.diagnostics())['lastFailure'], 'protocol');
  });
}

IcePeerLink _link(_Peer peer) => IcePeerLink(
    initiator: true,
    stunUrls: [],
    sendSignal: (_) async {},
    peerFactory: (_) async => peer);

class _Peer extends RTCPeerConnection {
  _Peer({bool open = true}) : channel = _Channel(open);
  final _Channel channel;
  final events = <String>[];
  final disposedSignal = Completer<void>();
  bool disposed = false;
  bool candidateDuringLocalDescription = false;
  RTCDataChannelInit? init;
  List<StatsReport> reports = [];
  @override
  RTCPeerConnectionState? get connectionState =>
      RTCPeerConnectionState.RTCPeerConnectionStateConnected;
  @override
  RTCIceConnectionState? get iceConnectionState =>
      RTCIceConnectionState.RTCIceConnectionStateConnected;
  @override
  Future<RTCDataChannel> createDataChannel(
      String label, RTCDataChannelInit dataChannelDict) async {
    init = dataChannelDict;
    return channel;
  }

  @override
  Future<RTCSessionDescription> createOffer(
          [Map<String, dynamic>? constraints]) async =>
      RTCSessionDescription('offer-sdp', 'offer');
  @override
  Future<RTCSessionDescription> createAnswer(
      [Map<String, dynamic>? constraints]) async {
    events.add('answer');
    return RTCSessionDescription('answer-sdp', 'answer');
  }

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    events.add('local:${description.type}');
    if (candidateDuringLocalDescription) {
      onIceCandidate?.call(RTCIceCandidate('candidate-local', '0', 0));
    }
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    events.add('remote:${description.type}');
    if (description.type == 'offer') onDataChannel?.call(channel);
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async =>
      events.add('candidate');
  @override
  Future<List<StatsReport>> getStats([MediaStreamTrack? track]) async =>
      reports;
  @override
  Future<void> close() async {}
  @override
  Future<void> dispose() async {
    disposed = true;
    if (!disposedSignal.isCompleted) disposedSignal.complete();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Channel extends RTCDataChannel {
  _Channel(bool open)
      : _state = open
            ? RTCDataChannelState.RTCDataChannelOpen
            : RTCDataChannelState.RTCDataChannelConnecting;
  _Channel? other;
  final frames = <Uint8List>[];
  final queried = Completer<void>();
  RTCDataChannelState _state;
  int amount = 0;
  int bufferQueries = 0;
  bool silentDrain = false;
  int peakAmount = 0;
  final drainTimers = <Timer>[];
  @override
  String get label => 'aid-sync-v1';
  @override
  RTCDataChannelState get state => _state;
  @override
  Future<int> getBufferedAmount() async {
    bufferQueries++;
    if (!queried.isCompleted) queried.complete();
    return amount;
  }

  @override
  Future<void> send(RTCDataChannelMessage message) async {
    if (silentDrain) {
      amount += message.binary.length;
      if (amount > peakAmount) peakAmount = amount;
      if (amount > 256 * 1024) {
        throw StateError('Native buffer limit exceeded');
      }
      drainTimers.add(Timer(const Duration(milliseconds: 5), () {
        amount -= message.binary.length;
      }));
    }
    frames.add(message.binary);
    other?.onMessage?.call(message);
  }

  @override
  Future<void> close() async {
    for (final timer in drainTimers) {
      timer.cancel();
    }
    _state = RTCDataChannelState.RTCDataChannelClosed;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
