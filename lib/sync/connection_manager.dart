// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:aid_diary/sync/sync_backend.dart';

enum SyncRouteType { lan, direct, ice, relay, cache }

/// An endpoint already authenticated by its owner. Discovery alone must never
/// construct a candidate: the peer identity and space binding need verification.
class SyncRouteCandidate {
  const SyncRouteCandidate({
    required this.id,
    required this.backend,
    required this.type,
    required this.userId,
    required this.spaceId,
    this.available = true,
    this.stability = 1,
    this.cost = 0,
    this.throughput = 0,
  })  : assert(stability >= 0 && stability <= 1),
        assert(cost >= 0 && cost <= 1),
        assert(throughput >= 0);

  final String id;
  final SyncBackend backend;
  final SyncRouteType type;
  final String userId;
  final String spaceId;
  final bool available;

  /// Recent successful fraction and relative metered cost, both in [0, 1].
  final double stability;
  final double cost;

  /// Measured bytes per second; zero means unknown, rather than unavailable.
  final double throughput;

  bool get isDirect => switch (type) {
        SyncRouteType.lan || SyncRouteType.direct || SyncRouteType.ice => true,
        SyncRouteType.relay || SyncRouteType.cache => false,
      };
}

class SyncConnectionPolicy {
  const SyncConnectionPolicy({
    this.probeTimeout = const Duration(seconds: 4),
    this.reprobeInterval = const Duration(seconds: 30),
    this.retryBase = const Duration(seconds: 2),
    this.retryMax = const Duration(minutes: 2),
    this.minimumDwell = const Duration(seconds: 15),
    this.switchImprovement = 0.2,
    this.jitter = 0.2,
    this.directFirst = false,
    this.directFirstDelay = const Duration(milliseconds: 400),
  })  : assert(switchImprovement >= 0),
        assert(jitter >= 0 && jitter <= 1);

  final Duration probeTimeout;
  final Duration reprobeInterval;
  final Duration retryBase;
  final Duration retryMax;
  final Duration minimumDwell;
  final double switchImprovement;
  final double jitter;
  final bool directFirst;
  final Duration directFirstDelay;
}

typedef SyncRouteProbe = Future<void> Function(SyncRouteCandidate candidate);
typedef CancelConnectionTimer = void Function();
typedef ScheduleConnectionTimer = CancelConnectionTimer Function(
  Duration delay,
  void Function() callback,
);

CancelConnectionTimer _scheduleTimer(
  Duration delay,
  void Function() callback,
) =>
    Timer(delay, callback).cancel;

/// Selects among supplied, trusted routes; it does not discover peers, implement
/// ICE, or grant trust. Every probe starts independently, so a usable cache or
/// relay can serve work while a slower direct probe completes. The sync engine
/// reads [current] between chunk operations; changing routes never changes a
/// task's identity, ciphertext or acknowledgement semantics.
class SyncConnectionManager {
  SyncConnectionManager({
    required this.userId,
    required this.spaceId,
    this.policy = const SyncConnectionPolicy(),
    SyncRouteProbe? probe,
    DateTime Function()? now,
    double Function()? random,
    ScheduleConnectionTimer? schedule,
  })  : _probe = probe ?? ((candidate) => candidate.backend.check()),
        _now = now ?? DateTime.now,
        _random = random ?? Random().nextDouble,
        _schedule = schedule ?? _scheduleTimer {
    if (userId.isEmpty || spaceId.isEmpty) {
      throw ArgumentError('Connection identity and space must not be empty');
    }
    if (policy.probeTimeout <= Duration.zero ||
        policy.reprobeInterval <= Duration.zero ||
        policy.retryBase <= Duration.zero ||
        policy.retryMax < policy.retryBase ||
        policy.minimumDwell < Duration.zero ||
        policy.directFirstDelay < Duration.zero ||
        !policy.switchImprovement.isFinite ||
        policy.switchImprovement < 0 ||
        !policy.jitter.isFinite ||
        policy.jitter < 0 ||
        policy.jitter > 1) {
      throw ArgumentError('Invalid connection policy');
    }
  }

  final String userId;
  final String spaceId;
  final SyncConnectionPolicy policy;
  final SyncRouteProbe _probe;
  final DateTime Function() _now;
  final double Function() _random;
  final ScheduleConnectionTimer _schedule;
  final _changes = StreamController<SyncRouteCandidate?>.broadcast(sync: true);
  final Map<String, SyncRouteCandidate> _candidates = {};
  final Map<String, SyncRouteCandidate> _healthy = {};
  final Set<_PendingProbe> _pending = {};
  final Map<SyncBackend, _ActualProbe> _actualProbes = HashMap.identity();
  CancelConnectionTimer? _cancelRetry;
  Future<void>? _closing;
  SyncRouteCandidate? _current;
  DateTime? _selectedAt;
  int _generation = 0;
  int _failedRounds = 0;
  bool _closed = false;

  SyncRouteCandidate? get current => _current;
  Stream<SyncRouteCandidate?> get changes => _changes.stream;

  /// All verified endpoints whose most recent probe succeeded, so a missing
  /// blob can be sought on other devices as well as on the selected route.
  List<SyncRouteCandidate> get healthyRoutes =>
      List.unmodifiable(_healthy.values);

  /// The default probe calls [SyncBackend.check], which can create the remote
  /// folder. Supply a read-only probe when candidates need non-mutating checks.
  Future<void> start(Iterable<SyncRouteCandidate> candidates) =>
      updateCandidates(candidates);

  /// Replaces the network snapshot and fences off all older probe results.
  Future<void> updateCandidates(Iterable<SyncRouteCandidate> candidates) {
    _ensureOpen();
    final next = <String, SyncRouteCandidate>{};
    for (final candidate in candidates) {
      _validate(candidate);
      if (next.containsKey(candidate.id)) {
        throw ArgumentError.value(candidate.id, 'id', 'Duplicate route');
      }
      next[candidate.id] = candidate;
    }
    _candidates
      ..clear()
      ..addAll(next);
    _healthy.clear();
    _setCurrent(null);
    if (_closed) return Future.value();
    _failedRounds = 0;
    return refresh();
  }

  /// Adds an owner-verified endpoint and starts a fresh parallel probe round.
  Future<void> addVerifiedCandidate(SyncRouteCandidate candidate) {
    _ensureOpen();
    _validate(candidate);
    _candidates[candidate.id] = candidate;
    _healthy.remove(candidate.id);
    _select();
    if (_closed) return Future.value();
    return refresh();
  }

  /// Session-scoped transports cannot be retried after their owner closes.
  void removeCandidate(String id) {
    if (_closed || _candidates.remove(id) == null) return;
    _healthy.remove(id);
    _select();
    if (!_closed) unawaited(refresh());
  }

  Future<void> refresh() async {
    _ensureOpen();
    final generation = ++_generation;
    _cancelRound();
    final probes = <Future<void>>[];
    final hasDirect = _candidates.values.any((c) => c.available && c.isDirect);
    for (final candidate in _candidates.values.toList()) {
      if (_closed || generation != _generation) break;
      if (!candidate.available) continue;
      final delay = policy.directFirst && hasDirect && !candidate.isDirect
          ? policy.directFirstDelay
          : Duration.zero;
      probes.add(_probeCandidate(candidate, generation, delay));
    }
    await Future.wait(probes);
    if (_closed || generation != _generation) return;
    _failedRounds = _healthy.isEmpty ? _failedRounds + 1 : 0;
    _scheduleRetry();
  }

  /// Reports a failed operation. Pending checks cannot resurrect that route;
  /// other successful routes can be used immediately, then probing resumes
  /// after the retry delay. Callers retain and retry the unfinished chunk.
  void markFailed(String id) {
    _ensureOpen();
    final backend = _candidates[id]?.backend;
    if (backend != null) _actualProbes[backend]?.invalidated = true;
    ++_generation;
    _cancelRound();
    _healthy.remove(id);
    _select();
    if (_closed) return;
    _failedRounds++;
    _scheduleRetry();
  }

  Future<void> close() {
    if (_closing != null) return _closing!;
    _closed = true;
    ++_generation;
    _cancelRound();
    _healthy.clear();
    _candidates.clear();
    _actualProbes.clear();
    _current = null;
    // A synchronous route listener may close its owner while the broadcast
    // controller is delivering that event. Close the stream after dispatch.
    return _closing = Future<void>.microtask(() async {
      await _changes.close();
    });
  }

  Future<void> _probeCandidate(
    SyncRouteCandidate candidate,
    int generation,
    Duration delay,
  ) {
    final pending = _PendingProbe();
    _pending.add(pending);
    void finish(bool success) {
      if (!pending.finish()) return;
      _pending.remove(pending);
      if (_closed || generation != _generation) return;
      if (success) {
        _healthy[candidate.id] = candidate;
      } else {
        _healthy.remove(candidate.id);
      }
      _select();
    }

    void begin() {
      if (pending.finished || _closed || generation != _generation) return;
      pending.cancelTimer = _schedule(policy.probeTimeout, () => finish(false));
      final actual = _actualCheck(candidate);
      actual.result.future.then(
        (_) => finish(!actual.invalidated),
        onError: (Object _, StackTrace __) => finish(false),
      );
    }

    if (delay == Duration.zero) {
      begin();
    } else {
      pending.cancelTimer = _schedule(delay, begin);
    }
    return pending.done.future;
  }

  /// A round owns its deadlines, not the backend operation. A canceled check
  /// can still be running on the socket, so retain and reuse it by identity
  /// until completion instead of flooding the backend on add/remove bursts.
  _ActualProbe _actualCheck(SyncRouteCandidate candidate) {
    final backend = candidate.backend;
    final existing = _actualProbes[backend];
    if (existing != null) return existing;
    final actual = _ActualProbe();
    _actualProbes[backend] = actual;
    void forget() {
      if (identical(_actualProbes[backend], actual)) {
        _actualProbes.remove(backend);
      }
    }

    unawaited(Future<void>.sync(() => _probe(candidate)).then<void>((_) {
      forget();
      actual.result.complete();
    }, onError: (Object error, StackTrace stack) {
      forget();
      actual.result.completeError(error, stack);
    }));
    return actual;
  }

  void _select() {
    SyncRouteCandidate? best;
    for (final candidate in _healthy.values) {
      if (best == null || _score(candidate) > _score(best)) best = candidate;
    }
    final previous = _current;
    if (best == null ||
        previous == null ||
        !_healthy.containsKey(previous.id)) {
      _setCurrent(best);
      return;
    }
    if (best.id == previous.id) {
      _current = best;
      return;
    }
    // Escaping a metered path is useful even before the dwell period expires.
    if (best.isDirect && !previous.isDirect) {
      _setCurrent(best);
      return;
    }
    if (_now().difference(_selectedAt!) < policy.minimumDwell) return;
    if (_score(best) > _score(previous) * (1 + policy.switchImprovement)) {
      _setCurrent(best);
    }
  }

  double _score(SyncRouteCandidate candidate) {
    final preference = switch (candidate.type) {
      SyncRouteType.lan => 300.0,
      SyncRouteType.direct => 290.0,
      SyncRouteType.ice => 280.0,
      SyncRouteType.relay => 100.0,
      SyncRouteType.cache => 90.0,
    };
    final speed = candidate.throughput <= 0
        ? 0.0
        : min(100.0, log(1 + candidate.throughput / 1024) * 10);
    return preference + candidate.stability * 50 + speed - candidate.cost * 80;
  }

  void _setCurrent(SyncRouteCandidate? candidate) {
    final changed = _current?.id != candidate?.id ||
        _current?.backend != candidate?.backend;
    _current = candidate;
    if (!changed) return;
    _selectedAt = candidate == null ? null : _now();
    _changes.add(candidate);
  }

  void _scheduleRetry() {
    _cancelRetry?.call();
    final exponent = min(20, max(0, _failedRounds - 1));
    final retryMicros = min(
      policy.retryMax.inMicroseconds,
      policy.retryBase.inMicroseconds * (1 << exponent),
    );
    final baseMicros =
        _healthy.isEmpty ? retryMicros : policy.reprobeInterval.inMicroseconds;
    final factor = 1 + (2 * _random().clamp(0, 1) - 1) * policy.jitter;
    var delayMicros = max(1, (baseMicros * factor).round());
    if (_healthy.isEmpty) {
      delayMicros = min(delayMicros, policy.retryMax.inMicroseconds);
    }
    final delay = Duration(microseconds: delayMicros);
    _cancelRetry = _schedule(delay, () {
      _cancelRetry = null;
      if (!_closed) unawaited(refresh());
    });
  }

  void _cancelRound() {
    _cancelRetry?.call();
    _cancelRetry = null;
    for (final probe in _pending) {
      probe.finish();
    }
    _pending.clear();
  }

  void _validate(SyncRouteCandidate candidate) {
    if (candidate.id.isEmpty ||
        candidate.userId != userId ||
        candidate.spaceId != spaceId) {
      throw ArgumentError('Route must be bound to this identity and space');
    }
    if (!candidate.stability.isFinite ||
        candidate.stability < 0 ||
        candidate.stability > 1 ||
        !candidate.cost.isFinite ||
        candidate.cost < 0 ||
        candidate.cost > 1 ||
        !candidate.throughput.isFinite ||
        candidate.throughput < 0) {
      throw ArgumentError('Invalid route measurements');
    }
  }

  void _ensureOpen() {
    if (_closed) throw StateError('Connection manager is closed');
  }
}

class _PendingProbe {
  final done = Completer<void>();
  CancelConnectionTimer? cancelTimer;
  bool finished = false;

  bool finish() {
    if (finished) return false;
    finished = true;
    cancelTimer?.call();
    done.complete();
    return true;
  }
}

class _ActualProbe {
  final result = Completer<void>();
  bool invalidated = false;
}
