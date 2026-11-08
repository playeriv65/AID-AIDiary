// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/share_page.dart';
import 'package:aid_diary/widgets/legacy_material_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_receiver/share_receiver.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  Future<void> openShare(WidgetTester tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    // The bridge the app puts above every page, for the text preview.
    await tester.pumpWidget(harness.app(const LegacyMaterialBridge(
        child: SharePage(payload: SharePayload(text: '分享来的一段话')))));
    await tester.pumpAndSettle();
  }

  Future<void> editorOpens(WidgetTester tester) => DiaryAppHarness.pumpUntil(
      tester, () => find.byType(AddEditEntryPage).evaluate().isNotEmpty);

  String editorText(WidgetTester tester) =>
      tester.widget<EditableText>(DiaryAppHarness.entryBody).controller.text;

  testWidgets('sharing to a day with entries offers them and a new one',
      (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '今天写过的', DateTime.now());
    await openShare(tester);
    await tester.tap(find.byKey(const ValueKey('day-picker-confirm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('share-new-entry')), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('share-entry-${entry.id}')));
    await editorOpens(tester);
    expect(editorText(tester), allOf(contains('今天写过的'), contains('分享来的一段话')));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('sharing to a day without entries starts a new one',
      (tester) async {
    await openShare(tester);
    await tester.tap(find.byKey(const ValueKey('day-picker-confirm')));
    await editorOpens(tester);
    expect(find.byKey(const ValueKey('share-new-entry')), findsNothing);
    expect(editorText(tester), contains('分享来的一段话'));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
