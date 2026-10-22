// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// A deliberately narrow presentation model: diagnostics never render arbitrary
/// server maps, exception text, account names, addresses or credentials.
class SyncNetworkDiagnostics {
  SyncNetworkDiagnostics.fromJson(Map<Object?, Object?> json)
      : route = _known(json['route'], _routes),
        routes = {
          for (final raw in json['availableRoutes'] is List
              ? json['availableRoutes'] as List
              : const [])
            if (raw is Map && _known(raw['type'], _routes) != null)
              _known(raw['type'], _routes)!,
        }.toList(growable: false),
        signaling = _known(_map(json['internet'])['state'],
            const {'online', 'connecting', 'disconnected'}),
        relayRemaining = _count(_map(json['internet'])['relayRemainingBytes']),
        peers = [
          for (final raw in _map(json['internet'])['peers'] is List
              ? _map(json['internet'])['peers'] as List
              : const [])
            if (raw is Map) SyncPeerDiagnostics.fromJson(raw),
        ],
        pending = _count(json['pendingMedia']),
        durableReceipts = _count(json['durableRemoteMedia']),
        temporaryReceipts = _count(json['temporaryOrUnconfirmedRemoteMedia']);

  final String? route;
  final List<String> routes;
  final String? signaling;
  final int relayRemaining;
  final List<SyncPeerDiagnostics> peers;
  final int pending;
  final int durableReceipts;
  final int temporaryReceipts;

  static const _routes = {'lan', 'direct', 'ice', 'relay', 'cache'};
}

class SyncPeerDiagnostics {
  SyncPeerDiagnostics.fromJson(Map<Object?, Object?> json)
      : trusted = json['trusted'] == true,
        localType = _known(
            _map(_map(_map(json['ice'])['selectedPair'])['local'])['type'],
            _types),
        remoteType = _known(
            _map(_map(_map(json['ice'])['selectedPair'])['remote'])['type'],
            _types),
        protocol = _known(
            _map(_map(_map(json['ice'])['selectedPair'])['local'])['protocol'],
            const {'udp', 'tcp'});

  final bool trusted;
  final String? localType;
  final String? remoteType;
  final String? protocol;
  static const _types = {'host', 'srflx', 'prflx', 'relay'};
}

Map<Object?, Object?> _map(Object? value) => value is Map ? value : const {};
int _count(Object? value) => value is int && value >= 0 ? value : 0;
String? _known(Object? value, Set<String> allowed) =>
    value is String && allowed.contains(value) ? value : null;
