// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/sync/network_diagnostics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('diagnostics keep retention receipts distinct from pending media', () {
    final data = SyncNetworkDiagnostics.fromJson({
      'route': 'ice',
      'pendingMedia': 3,
      'durableRemoteMedia': 2,
      'temporaryOrUnconfirmedRemoteMedia': 7,
      'availableRoutes': [
        {'type': 'ice'},
        {'type': 'cache'},
        {'type': 'ice'}
      ],
      'internet': {
        'state': 'disconnected',
        'relayRemainingBytes': 0,
        'peers': [
          {
            'trusted': true,
            'ice': {
              'selectedPair': {
                'local': {'type': 'host', 'protocol': 'udp'},
                'remote': {'type': 'prflx', 'protocol': 'udp'},
              }
            }
          },
        ]
      },
    });
    expect(data.durableReceipts, 2);
    expect(data.temporaryReceipts, 7);
    expect(data.pending, 3);
    expect(data.routes, ['ice', 'cache']);
    expect(data.peers.single.remoteType, 'prflx');
  });

  test('unrecognized map values cannot become UI strings', () {
    final data = SyncNetworkDiagnostics.fromJson({
      'route': 'https://user:secret@example.org',
      'pendingMedia': -1,
      'availableRoutes': [
        {'type': 'private-token'}
      ],
      'internet': {
        'state': 'secret',
        'relayRemainingBytes': -50,
        'peers': [
          {
            'trusted': 'yes',
            'ice': {
              'selectedPair': {
                'local': {'type': '10.0.0.1', 'protocol': 'token'},
              }
            }
          },
        ]
      },
    });
    expect(data.route, isNull);
    expect(data.routes, isEmpty);
    expect(data.signaling, isNull);
    expect(data.relayRemaining, 0);
    expect(data.pending, 0);
    expect(data.peers.single.localType, isNull);
    expect(data.peers.single.protocol, isNull);
    expect(data.peers.single.trusted, false);
  });
}
