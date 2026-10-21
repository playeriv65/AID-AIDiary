// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/widgets/journal_entry_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  tearDown(() => SyncService.instance.unsyncedEntryIds = const {});

  Future<void> show(WidgetTester tester, Entry entry) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Scaffold(
        body: JournalEntryRow(entry: entry, images: const [], onTap: () {}))));
    await tester.pumpAndSettle();
  }

  testWidgets('synced entries carry no mark; failed ones a small one',
      (tester) async {
    final time = DateTime(2026, 10, 21, 9);
    final entry =
        Entry(id: 7, text: 'walk', timeCreate: time, timeModified: time);

    await show(tester, entry);
    expect(find.byKey(const ValueKey('unsynced-7')), findsNothing);

    SyncService.instance.unsyncedEntryIds = {7};
    await show(tester, entry.copy(text: 'walk again'));
    expect(find.byKey(const ValueKey('unsynced-7')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
