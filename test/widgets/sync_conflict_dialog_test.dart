// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/sync_conflicts.dart';
import 'package:aid_diary/widgets/sync_conflict_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  final conflict = SyncConflict(
      entry: 7,
      mine: ConflictVersion(
          device: 'Tablet',
          modified: DateTime(2026, 3, 14, 9, 30),
          title: 'Picnic',
          snippet: 'Sandwiches by the lake.'),
      other: ConflictVersion(
          device: 'Phone',
          modified: DateTime(2026, 3, 14, 9, 45),
          title: 'Picnic',
          snippet: 'Sandwiches by the river.'));

  /// Opens the dialog, taps [button] and returns what it answered.
  Future<ConflictKeep?> answer(WidgetTester tester, String button) async {
    ConflictKeep? picked;
    await tester.pumpWidget(harness.app(Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          key: const ValueKey('open'),
          onPressed: () async => picked =
              await showSyncConflictDialog(context, conflict, total: 2),
          child: const Text('open'),
        ),
      ),
    )));
    await tester.tap(find.byKey(const ValueKey('open')));
    await tester.pumpAndSettle();
    expect(find.text('Sandwiches by the lake.'), findsOneWidget);
    expect(find.text('Sandwiches by the river.'), findsOneWidget);
    expect(find.textContaining('Tablet'), findsOneWidget);
    expect(find.textContaining('Phone'), findsOneWidget);
    final l10n = AppLocalizations.of(
        tester.element(find.byKey(const ValueKey('sync-conflict-dialog'))))!;
    expect(find.text(l10n.syncConflictCount(1, 2)), findsOneWidget);
    await tester.tap(find.byKey(ValueKey(button)));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('sync-conflict-dialog')), findsNothing);
    return picked;
  }

  testWidgets("keeps this device's version", (tester) async {
    expect(await answer(tester, 'sync-conflict-this'), ConflictKeep.mine);
  });

  testWidgets('keeps the other version', (tester) async {
    expect(await answer(tester, 'sync-conflict-other'), ConflictKeep.other);
  });

  testWidgets('keeps both', (tester) async {
    expect(await answer(tester, 'sync-conflict-both'), ConflictKeep.both);
  });

  testWidgets('asks again later', (tester) async {
    expect(await answer(tester, 'sync-conflict-later'), isNull);
  });
}
