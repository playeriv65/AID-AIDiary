// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/pages/settings/sync_network_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('retention receipts stay distinct and refresh reads new state',
      (tester) async {
    var calls = 0;
    DiaryAppHarness.size(tester, const Size(800, 1000));
    await tester.pumpWidget(harness.app(SyncNetworkSettings(load: () async {
      calls++;
      return {
        'route': 'ice',
        'durableRemoteMedia': calls == 1 ? 2 : 4,
        'temporaryOrUnconfirmedRemoteMedia': 9,
        'pendingMedia': 3,
      };
    })));
    await tester.pumpAndSettle();
    Finder count(String key, String value) => find.descendant(
        of: find.byKey(ValueKey(key)), matching: find.text(value));
    expect(count('sync-media-durable-count', '2'), findsOneWidget);
    expect(count('sync-media-temporary-count', '9'), findsOneWidget);
    expect(count('sync-media-pending-count', '3'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('sync-network-refresh')));
    await tester.pumpAndSettle();
    expect(count('sync-media-durable-count', '4'), findsOneWidget);
    expect(count('sync-media-temporary-count', '9'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('storage exceptions never expose credential text',
      (tester) async {
    await tester.pumpWidget(harness.app(SyncNetworkSettings(load: () async {
      throw StateError('https://account:secret-token@example.org/private');
    })));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('sync-network-error')), findsOneWidget);
    expect(find.textContaining('secret-token'), findsNothing);
    expect(find.textContaining('account:'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
