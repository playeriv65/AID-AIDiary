@Tags(['widget'])
library;

import 'dart:async';

import 'package:aid_diary/widgets/cloud_traffic_notice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

Map<Object?, Object?> _traffic({int remaining = 7500000000}) => {
      'monthlyLimitBytes': 10000000000,
      'monthlyUsedBytes': 2500000000,
      'monthlyRemainingBytes': remaining,
      'resetsAt': '2026-11-01T00:00:00Z',
      'account': 'private-account',
      'url': 'https://private-user:private-token@example.org/private',
    };

void main() {
  final harness = DiaryAppHarness()..register();

  test('byte labels use decimal MB and GB', () {
    expect(formatCloudTrafficBytes(1000000000, 'en'), '1 GB');
    expect(formatCloudTrafficBytes(2500000000, 'en'), '2.5 GB');
    expect(formatCloudTrafficBytes(500000000, 'en'), '500 MB');
  });

  testWidgets(
      'starts with one allowance line and reveals usage details on request',
      (tester) async {
    final changes = ChangeNotifier();
    addTearDown(changes.dispose);
    await tester.pumpWidget(harness.app(Scaffold(
        body: CloudTrafficNotice(
            changes: changes, load: () async => _traffic()))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('cloud-traffic-summary')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cloud-traffic-summary')));
    await tester.pumpAndSettle();
    expect(find.text('10 GB'), findsOneWidget);
    expect(find.text('2.5 GB'), findsOneWidget);
    expect(find.text('7.5 GB'), findsOneWidget);
    expect(find.textContaining('UTC'), findsOneWidget);
    expect(find.textContaining('private-'), findsNothing);
    expect(find.byKey(const ValueKey('cloud-traffic-exhausted')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('absent, invalid and failed policy stay silent', (tester) async {
    final changes = ChangeNotifier();
    addTearDown(changes.dispose);
    Object? response;
    Future<Map<Object?, Object?>?> load() async {
      if (response case final Exception failure) throw failure;
      return response as Map<Object?, Object?>?;
    }

    await tester.pumpWidget(harness
        .app(Scaffold(body: CloudTrafficNotice(changes: changes, load: load))));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    response = {..._traffic(), 'resetsAt': 'https://secret-token@example.org'};
    changes.notifyListeners();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    response = Exception('private-user:private-token');
    changes.notifyListeners();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.textContaining('private-'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('notifications coalesce and a read cannot trigger a refresh loop',
      (tester) async {
    final changes = ChangeNotifier();
    addTearDown(changes.dispose);
    var calls = 0;
    final first = Completer<Map<Object?, Object?>?>();
    Future<Map<Object?, Object?>?> load() async {
      calls++;
      changes.notifyListeners();
      if (calls == 1) return await first.future;
      return _traffic(remaining: 0);
    }

    await tester.pumpWidget(harness
        .app(Scaffold(body: CloudTrafficNotice(changes: changes, load: load))));
    expect(calls, 1);
    expect(find.byType(Card), findsNothing);
    changes.notifyListeners();
    changes.notifyListeners();
    first.complete(_traffic());
    await tester.pumpAndSettle();
    expect(calls, 1);
    changes.notifyListeners();
    await tester.pump(const Duration(milliseconds: 200));
    changes.notifyListeners();
    await tester.pump(const Duration(milliseconds: 499));
    expect(calls, 1);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(calls, 2);
    await tester.tap(find.byKey(const ValueKey('cloud-traffic-summary')));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('cloud-traffic-exhausted')), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 2);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('disposing ignores a late result', (tester) async {
    final changes = ChangeNotifier();
    addTearDown(changes.dispose);
    final pending = Completer<Map<Object?, Object?>?>();
    var calls = 0;
    await tester.pumpWidget(harness.app(Scaffold(
        body: CloudTrafficNotice(
            changes: changes,
            load: () {
              calls++;
              return pending.future;
            }))));
    await tester.pumpWidget(const SizedBox.shrink());
    changes.notifyListeners();
    pending.complete(_traffic());
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposing cancels a scheduled refresh', (tester) async {
    final changes = ChangeNotifier();
    addTearDown(changes.dispose);
    var calls = 0;
    await tester.pumpWidget(harness.app(Scaffold(
        body: CloudTrafficNotice(
            changes: changes,
            load: () async {
              calls++;
              return _traffic();
            }))));
    await tester.pumpAndSettle();
    changes.notifyListeners();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });
}
