// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

import 'dart:async';
import 'dart:typed_data';

/// Ordered, bounded packet framing for a live relay. No objects are persisted.
class RelayPackets {
  RelayPackets(
      {required this.write,
      this.maxPacketBytes = 24 * 1024 * 1024,
      this.fragmentBytes = 12 * 1024,
      this.timeout = const Duration(seconds: 20)});
  final Future<void> Function(Uint8List) write;
  final int maxPacketBytes;
  final int fragmentBytes;
  final Duration timeout;
  final _packets = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get packets => _packets.stream;
  Future<void> _tail = Future.value();
  BytesBuilder? _incoming;
  int _expected = 0;
  Timer? _timer;
  bool _closed = false;

  Future<void> send(Uint8List packet) {
    final next = _tail.then((_) async {
      if (_closed) throw StateError('Relay closed');
      if (packet.isEmpty || packet.length > maxPacketBytes) {
        throw const FormatException('Relay packet limit');
      }
      for (var offset = 0; offset < packet.length; offset += fragmentBytes) {
        if (_closed) throw StateError('Relay closed');
        final end = (offset + fragmentBytes).clamp(0, packet.length);
        final frame = Uint8List(8 + end - offset);
        final header = ByteData.sublistView(frame);
        header.setUint32(0, packet.length);
        header.setUint32(4, offset);
        frame.setRange(8, frame.length, packet, offset);
        await write(frame).timeout(timeout);
      }
    });
    _tail = next.catchError((Object _) {});
    return next;
  }

  void receive(Uint8List frame) {
    if (_closed) return;
    try {
      if (frame.length <= 8 || frame.length > fragmentBytes + 8) {
        throw const FormatException('Invalid relay fragment');
      }
      final header = ByteData.sublistView(frame);
      final length = header.getUint32(0);
      final offset = header.getUint32(4);
      if (length == 0 ||
          length > maxPacketBytes ||
          offset + frame.length - 8 > length) {
        throw const FormatException('Invalid relay packet length');
      }
      if (offset == 0) {
        _incoming = BytesBuilder(copy: false);
        _expected = length;
        _timer?.cancel();
        _timer = Timer(timeout, _expire);
      }
      final incoming = _incoming;
      if (incoming == null ||
          incoming.length != offset ||
          _expected != length) {
        throw const FormatException('Out of order relay fragment');
      }
      incoming.add(Uint8List.sublistView(frame, 8));
      if (incoming.length == length) {
        _timer?.cancel();
        _incoming = null;
        _packets.add(incoming.takeBytes());
      }
    } catch (error, stack) {
      _timer?.cancel();
      _incoming = null;
      _packets.addError(error, stack);
    }
  }

  void _expire() {
    _incoming = null;
    if (!_closed) {
      _packets.addError(TimeoutException('Incomplete relay packet'));
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _timer?.cancel();
    _incoming = null;
    await _packets.close();
  }
}
