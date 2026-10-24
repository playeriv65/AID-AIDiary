// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('hiding an entry says where to show it again', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '今天的事', DateTime(2026, 10, 1));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(Scaffold(body: EntryViewPage(entryId: entry.id!))));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('entry-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry-hide')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(SnackBar).evaluate().isNotEmpty);

    expect(EntryStore.instance.hiddenEntries.single.id, entry.id);
    expect(find.text('已隐藏。可在 设置 › 安全 › 隐藏日记 中找到并取消隐藏。'), findsOneWidget);
  });
}
