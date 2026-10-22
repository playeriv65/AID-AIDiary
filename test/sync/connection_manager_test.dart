// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/sync/connection_manager.dart';
import 'package:aid_diary/sync/sync_backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _Clock clock;
  late SyncConnectionManager manager;

  setUp(() => clock = _Clock());
  tearDown(() async => manager.close());

  SyncConnectionManager create({
    required SyncRouteProbe probe,
    SyncConnectionPolicy policy = const SyncConnectionPolicy(jitter: 0),
    double Function()? random,
  }) =>
      manager = SyncConnectionManager(
        userId: 'user',
        spaceId: 'space',
        probe: probe,
        policy: policy,
        now: () => clock.now,
        schedule: clock.schedule,
        random: random ?? () => 0.5,
      );

  test(
    'probes run together, use the first cache, then upgrade to direct',
    () async {
      final lan = Completer<void>();
      final cache = Completer<void>();
      final calls = <String>[];
      create(
        probe: (candidate) {
          calls.add(candidate.id);
          return candidate.id == 'lan' ? lan.future : cache.future;
        },
      );
      final changes = <String?>[];
      manager.changes.listen((route) => changes.add(route?.id));
      final round = manager.start([
        _route('lan', SyncRouteType.lan),
        _route('cache', SyncRouteType.cache),
      ]);

      expect(calls, ['lan', 'cache']);
      cache.complete();
      await _flush();
      expect(manager.current?.id, 'cache');
      lan.complete();
      await round;
      expect(manager.current?.id, 'lan');
      expect(changes, ['cache', 'lan']);
    },
  );

  test(
    'a hung direct probe never delays usable cache and has a deadline',
    () async {
      final hung = Completer<void>();
      create(
        probe: (candidate) => candidate.isDirect ? hung.future : Future.value(),
      );
      final round = manager.start([
        _route('lan', SyncRouteType.lan),
        _route('cache', SyncRouteType.cache),
      ]);
      await _flush();
      expect(manager.current?.id, 'cache');
      await clock.elapse(const Duration(seconds: 4));
      await round;
      expect(manager.current?.id, 'cache');
      hung.complete();
      await _flush();
      expect(manager.current?.id, 'cache');
    },
  );

  test(
    'small score improvements do not switch a healthy direct connection',
    () async {
      final lan = Completer<void>();
      create(
        probe: (candidate) =>
            candidate.id == 'lan' ? lan.future : Future.value(),
      );
      final round = manager.start([
        _route('direct', SyncRouteType.direct),
        _route('lan', SyncRouteType.lan),
      ]);
      await _flush();
      expect(manager.current?.id, 'direct');
      lan.complete();
      await round;
      await clock.elapse(const Duration(seconds: 16));
      await manager.refresh();
      expect(manager.current?.id, 'direct');
    },
  );

  test(
    'a worthwhile improvement waits for dwell before changing direct routes',
    () async {
      final lan = Completer<void>();
      create(
        probe: (candidate) =>
            candidate.id == 'lan' ? lan.future : Future.value(),
      );
      final round = manager.start([
        _route('direct', SyncRouteType.direct),
        _route('lan', SyncRouteType.lan, throughput: 100000000),
      ]);
      await _flush();
      lan.complete();
      await round;
      expect(manager.current?.id, 'direct');
      await clock.elapse(const Duration(seconds: 16));
      await manager.refresh();
      expect(manager.current?.id, 'lan');
    },
  );

  test(
    'an operation failure immediately chooses a healthy alternative',
    () async {
      create(probe: (_) async {});
      await manager.start([
        _route('lan', SyncRouteType.lan),
        _route('relay', SyncRouteType.relay),
      ]);
      expect(manager.current?.id, 'lan');
      manager.markFailed('lan');
      expect(manager.current?.id, 'relay');
    },
  );

  test('failed current revalidation leaves other routes usable', () async {
    var failLan = false;
    create(
      probe: (candidate) async {
        if (failLan && candidate.id == 'lan') throw StateError('Offline');
      },
    );
    await manager.start([
      _route('lan', SyncRouteType.lan),
      _route('relay', SyncRouteType.relay),
    ]);
    failLan = true;
    await manager.refresh();
    expect(manager.current?.id, 'relay');
  });

  test('network snapshots fence stale successful probes', () async {
    final oldLan = Completer<void>();
    final newCache = Completer<void>();
    create(
      probe: (candidate) =>
          candidate.id == 'old' ? oldLan.future : newCache.future,
    );
    final oldRound = manager.start([_route('old', SyncRouteType.lan)]);
    final newRound = manager.updateCandidates([
      _route('new', SyncRouteType.cache),
    ]);
    await oldRound;
    oldLan.complete();
    await _flush();
    expect(manager.current, isNull);
    newCache.complete();
    await newRound;
    expect(manager.current?.id, 'new');
  });

  test(
    'operation failure fences an already running success for that route',
    () async {
      Completer<void>? pending;
      create(probe: (_) => pending?.future ?? Future<void>.value());
      await manager.start([_route('lan', SyncRouteType.lan)]);
      pending = Completer<void>();
      final round = manager.refresh();
      manager.markFailed('lan');
      pending.complete();
      await round;
      await _flush();
      expect(manager.current, isNull);
    },
  );

  test(
    'close cancels delayed probes, pending deadlines and retry timers',
    () async {
      final pending = Completer<void>();
      final calls = <String>[];
      create(
        policy: const SyncConnectionPolicy(directFirst: true),
        probe: (candidate) {
          calls.add(candidate.id);
          return pending.future;
        },
      );
      final round = manager.start([
        _route('lan', SyncRouteType.lan),
        _route('relay', SyncRouteType.relay),
      ]);
      await manager.close();
      await round;
      pending.complete();
      await clock.elapse(const Duration(minutes: 5));
      expect(calls, ['lan']);
      expect(manager.current, isNull);
      expect(clock.activeTimers, 0);
      expect(() => manager.refresh(), throwsStateError);
    },
  );

  test('direct-first gives direct probes a bounded head start', () async {
    final hung = Completer<void>();
    final calls = <String>[];
    create(
      policy: const SyncConnectionPolicy(directFirst: true, jitter: 0),
      probe: (candidate) {
        calls.add(candidate.id);
        return candidate.isDirect ? hung.future : Future.value();
      },
    );
    final round = manager.start([
      _route('lan', SyncRouteType.lan),
      _route('relay', SyncRouteType.relay),
    ]);
    expect(calls, ['lan']);
    await clock.elapse(const Duration(milliseconds: 400));
    expect(calls, ['lan', 'relay']);
    expect(manager.current?.id, 'relay');
    hung.complete();
    await round;
    expect(manager.current?.id, 'lan');
  });

  test(
    'unreachable routes retry with exponential backoff and configured jitter',
    () async {
      var probes = 0;
      create(
        policy: const SyncConnectionPolicy(
          retryBase: Duration(seconds: 10),
          retryMax: Duration(seconds: 40),
          jitter: 0.2,
        ),
        random: () => 1,
        probe: (_) async {
          probes++;
          throw StateError('Offline');
        },
      );
      await manager.start([_route('lan', SyncRouteType.lan)]);
      expect(clock.nextDelay, const Duration(seconds: 12));
      await clock.elapse(const Duration(seconds: 12));
      expect(probes, 2);
      expect(clock.nextDelay, const Duration(seconds: 24));
      await clock.elapse(const Duration(seconds: 24));
      expect(probes, 3);
      expect(clock.nextDelay, const Duration(seconds: 40));
    },
  );

  test(
    'periodic probing upgrades when direct connectivity appears later',
    () async {
      var lanAvailable = false;
      create(
        probe: (candidate) async {
          if (candidate.isDirect && !lanAvailable) throw StateError('Offline');
        },
      );
      await manager.start([
        _route('lan', SyncRouteType.lan),
        _route('cache', SyncRouteType.cache),
      ]);
      expect(manager.current?.id, 'cache');
      lanAvailable = true;
      await clock.elapse(const Duration(seconds: 30));
      expect(manager.current?.id, 'lan');
    },
  );

  test('rejects mismatched trust bindings before probing', () async {
    var probes = 0;
    create(probe: (_) async => probes++);
    expect(
      () => manager.start([
        SyncRouteCandidate(
          id: 'other',
          backend: MemorySyncBackend(),
          type: SyncRouteType.lan,
          userId: 'someone-else',
          spaceId: 'space',
        ),
      ]),
      throwsArgumentError,
    );
    expect(probes, 0);
  });

  test(
    'unavailable routes are not probed; verified additions are probed',
    () async {
      final calls = <String>[];
      create(probe: (candidate) async => calls.add(candidate.id));
      await manager.start([
        _route('offline', SyncRouteType.lan, available: false),
      ]);
      expect(calls, isEmpty);
      await manager.addVerifiedCandidate(_route('new', SyncRouteType.direct));
      expect(calls, ['new']);
      expect(manager.current?.id, 'new');
    },
  );

  test(
      'healthy sources include alternate peers but exclude failed or untrusted',
      () async {
    create(probe: (candidate) async {
      if (candidate.id == 'offline') throw StateError('Offline');
    });
    await manager.start([
      _route('lan', SyncRouteType.lan),
      _route('other-peer', SyncRouteType.direct),
      _route('offline', SyncRouteType.direct),
    ]);
    final snapshot = manager.healthyRoutes;
    expect(snapshot.map((route) => route.id), ['lan', 'other-peer']);
    expect(() => snapshot.clear(), throwsUnsupportedError);
    expect(
        () => manager.addVerifiedCandidate(SyncRouteCandidate(
            id: 'untrusted',
            backend: MemorySyncBackend(),
            type: SyncRouteType.lan,
            userId: 'someone-else',
            spaceId: 'space')),
        throwsArgumentError);
    manager.markFailed('lan');
    expect(manager.healthyRoutes.map((route) => route.id), ['other-peer']);
    expect(snapshot.map((route) => route.id), ['lan', 'other-peer'],
        reason: 'returned lists are immutable snapshots');
    await manager.close();
    expect(manager.healthyRoutes, isEmpty);
  });

  test('add/remove bursts share one actual check for each retained backend',
      () async {
    final retained = Completer<void>();
    final calls = <String, int>{};
    create(probe: (candidate) {
      calls.update(candidate.id, (count) => count + 1, ifAbsent: () => 1);
      return candidate.id == 'retained'
          ? retained.future
          : Future<void>.value();
    });
    final original = manager.start([_route('retained', SyncRouteType.lan)]);
    final first =
        manager.addVerifiedCandidate(_route('first', SyncRouteType.ice));
    final second =
        manager.addVerifiedCandidate(_route('second', SyncRouteType.ice));
    manager.removeCandidate('first');
    manager.removeCandidate('second');
    await Future.wait([original, first, second]);
    expect(calls['retained'], 1);
    retained.complete();
    await _flush();
    expect(manager.current?.id, 'retained');
    expect(manager.healthyRoutes.map((route) => route.id), ['retained']);
  });

  test('a probe deadline and retry do not duplicate the physical backend check',
      () async {
    final actual = Completer<void>();
    var checks = 0;
    create(probe: (_) {
      checks++;
      return actual.future;
    });
    final first = manager.start([_route('lan', SyncRouteType.lan)]);
    await clock.elapse(const Duration(seconds: 4));
    await first;
    expect(manager.current, isNull);
    await clock.elapse(const Duration(seconds: 2));
    expect(checks, 1);
    actual.complete();
    await _flush();
    expect(manager.current?.id, 'lan');
  });

  test('different candidate IDs sharing a backend share its outstanding check',
      () async {
    final backend = MemorySyncBackend();
    final probe = Completer<void>();
    var checks = 0;
    create(probe: (_) {
      checks++;
      return probe.future;
    });
    final round = manager.start([
      for (final id in ['first', 'second'])
        SyncRouteCandidate(
            id: id,
            backend: backend,
            type: SyncRouteType.lan,
            userId: 'user',
            spaceId: 'space'),
    ]);
    expect(checks, 1);
    probe.complete();
    await round;
    expect(manager.healthyRoutes, hasLength(2));
  });

  test('removing a pending candidate fences its late success', () async {
    final removed = Completer<void>();
    create(
        probe: (candidate) =>
            candidate.id == 'removed' ? removed.future : Future<void>.value());
    final round = manager.start([
      _route('removed', SyncRouteType.lan),
      _route('retained', SyncRouteType.direct),
    ]);
    await _flush();
    manager.removeCandidate('removed');
    removed.complete();
    await round;
    await _flush();
    expect(manager.current?.id, 'retained');
    expect(manager.healthyRoutes.map((route) => route.id), ['retained']);
  });

  test('failure-reported actual check cannot acknowledge a refreshed round',
      () async {
    Completer<void>? pending;
    var checks = 0;
    create(probe: (_) {
      checks++;
      return pending?.future ?? Future<void>.value();
    });
    await manager.start([_route('lan', SyncRouteType.lan)]);
    pending = Completer<void>();
    final round = manager.refresh();
    manager.markFailed('lan');
    final refreshed = manager.refresh();
    expect(checks, 2);
    pending.complete();
    await Future.wait([round, refreshed]);
    expect(manager.current, isNull);
    await manager.refresh();
    expect(checks, 3);
    expect(manager.current?.id, 'lan');
  });

  test('removal can close through its change listener without starting a round',
      () async {
    create(probe: (_) async {});
    await manager.start([
      _route('first', SyncRouteType.lan),
      _route('second', SyncRouteType.direct),
    ]);
    manager.changes.listen((route) {
      if (route?.id == 'second') unawaited(manager.close());
    });
    manager.removeCandidate('first');
    await _flush();
    expect(manager.current, isNull);
    expect(clock.activeTimers, 0);
  });

  test('candidate replacement can close in a listener without reprobes',
      () async {
    var checks = 0;
    create(probe: (_) async => checks++);
    await manager.start([_route('lan', SyncRouteType.lan)]);
    manager.changes.listen((route) {
      if (route == null) unawaited(manager.close());
    });
    await manager.addVerifiedCandidate(_route('lan', SyncRouteType.lan));
    expect(checks, 1);
    expect(clock.activeTimers, 0);
  });
}

SyncRouteCandidate _route(
  String id,
  SyncRouteType type, {
  double throughput = 0,
  bool available = true,
}) =>
    SyncRouteCandidate(
      id: id,
      backend: MemorySyncBackend(),
      type: type,
      userId: 'user',
      spaceId: 'space',
      throughput: throughput,
      available: available,
    );

Future<void> _flush() async {
  for (var i = 0; i < 12; i++) {
    await Future<void>.value();
  }
}

class _Clock {
  DateTime now = DateTime.utc(2026);
  final List<_Scheduled> _timers = [];

  CancelConnectionTimer schedule(Duration delay, void Function() callback) {
    final timer = _Scheduled(now.add(delay), callback);
    _timers.add(timer);
    return () => timer.cancelled = true;
  }

  int get activeTimers => _timers.where((timer) => !timer.cancelled).length;

  Duration? get nextDelay {
    final active = _timers.where((timer) => !timer.cancelled).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return active.isEmpty ? null : active.first.at.difference(now);
  }

  Future<void> elapse(Duration duration) async {
    final until = now.add(duration);
    while (true) {
      final due = _timers
          .where((timer) => !timer.cancelled && !timer.at.isAfter(until))
          .toList()
        ..sort((a, b) => a.at.compareTo(b.at));
      if (due.isEmpty) break;
      final timer = due.first;
      now = timer.at;
      timer.cancelled = true;
      timer.callback();
      await _flush();
    }
    now = until;
    await _flush();
  }
}

class _Scheduled {
  _Scheduled(this.at, this.callback);
  final DateTime at;
  final void Function() callback;
  bool cancelled = false;
}
