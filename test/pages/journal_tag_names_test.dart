// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/pages/journal_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('a journal card names its tags', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '上课', DateTime(2026, 10, 1));
    await tester.runAsync(() async {
      final actions = AppActions(devBuild: true);
      for (final name in ['UMN', '想法']) {
        await actions.run('tag.create', {'name': name});
        await actions.run('entry.tag', {'id': entry.id, 'tag': name});
      }
    });
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: JournalPage())));
    await tester.pumpAndSettle();

    final card = find.byKey(ValueKey('journal-entry-${entry.id}'));
    for (final name in ['UMN', '想法']) {
      expect(
          find.descendant(of: card, matching: find.text(name)), findsOneWidget);
    }
  });
}
