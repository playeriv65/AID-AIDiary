// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final lastYear = DateTime(2025, 3, 1, 21);
  final store = EntryStore.instance;

  Future<int> openPast(WidgetTester tester, String text) async {
    final entry = await DiaryAppHarness.addEntry(tester, text, lastYear);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(Scaffold(body: EntryViewPage(entryId: entry.id!))));
    await tester.pumpAndSettle();
    return entry.id!;
  }

  Future<void> writeComment(WidgetTester tester, String text) async {
    await tester.tap(find.byKey(const ValueKey('entry-comment')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('comment-field')), text);
  }

  Future<void> editorOpens(WidgetTester tester) => DiaryAppHarness.pumpUntil(
      tester, () => find.byType(AddEditEntryPage).evaluate().isNotEmpty);

  /// Leaves the editor as its close button does, saving in real time.
  Future<void> closeEditor(WidgetTester tester) async {
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<IconButton>(find.byKey(const ValueKey('entry-close')))
            .onPressed!(),
        () => find.byType(AddEditEntryPage).evaluate().isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('a short comment is an entry of today answering this one',
      (tester) async {
    final id = await openPast(tester, '湖上结冰了');
    await writeComment(tester, '现在想起来还觉得冷');
    await tester.tap(find.byKey(const ValueKey('comment-save')));
    await DiaryAppHarness.pumpUntil(
        tester, () => LinksProvider.instance.repliesTo(id).isNotEmpty);
    await tester.pumpAndSettle();

    final reply = store.entries.firstWhere((entry) => entry.id != id);
    expect(reply.text, '现在想起来还觉得冷');
    expect(find.byKey(ValueKey('reply-${reply.id}')), findsOneWidget);
  });

  testWidgets('a comment expands into the full editor, citation and all',
      (tester) async {
    await openPast(tester, '湖上结冰了');
    await writeComment(tester, '想多写一点');
    await tester.tap(find.byKey(const ValueKey('comment-expand')));
    await editorOpens(tester);

    expect(find.byType(AddEditEntryPage), findsOneWidget);
    expect(find.text('想多写一点'), findsOneWidget);
    expect(find.byKey(const ValueKey('entry-citations')), findsOneWidget);
    await closeEditor(tester);
  });

  testWidgets('the comment shows what it answers', (tester) async {
    final lake = await DiaryAppHarness.addEntry(tester, '湖上结冰了', lastYear);
    final result = (await tester.runAsync(() => AppActions(devBuild: true).run(
            'entry.create', {'text': '还记得', 'cite': lake.id, 'quote': '结冰'})))!
        as Map;
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness
        .app(Scaffold(body: EntryViewPage(entryId: result['id'] as int))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entry-citations')), findsOneWidget);
    expect(find.text('结冰'), findsOneWidget);
  });

  testWidgets('an entry of today has no comment button', (tester) async {
    final entry =
        await DiaryAppHarness.addEntry(tester, '今天的事', DateTime.now());
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(
        harness.app(Scaffold(body: EntryViewPage(entryId: entry.id!))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entry-comment')), findsNothing);
  });

  testWidgets('editing a past entry asks first, until told not to',
      (tester) async {
    await openPast(tester, '旧日记');
    await tester.tap(find.byKey(const ValueKey('diary-entry-edit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('edit-past-dialog')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('edit-past-dont-ask')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('edit-past-confirm')));
    await editorOpens(tester);
    expect(find.byType(AddEditEntryPage), findsOneWidget);
    expect(ConfigProvider.instance.get(Settings.confirmEditPast), isFalse);
    // The setting's own delayed write, as DiaryAppHarness.setSetting does.
    EasyDebounce.cancel('save-config');
    // Nothing was changed: nothing to save on the way out.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the editor cites an entry found by its words', (tester) async {
    final lake = await DiaryAppHarness.addEntry(tester, '湖上结冰了', lastYear);
    await DiaryAppHarness.addEntry(tester, '别的事', lastYear);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Scaffold(
        body: Builder(
            builder: (context) => FilledButton(
                onPressed: () => EntryNavigation.edit(context, null),
                child: const Text('写'))))));
    await tester.tap(find.text('写'));
    await editorOpens(tester);

    await tester.tap(find.byKey(const ValueKey('editor-cite')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('cite-search')), '结冰');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('cite-entry-${lake.id}')));
    await DiaryAppHarness.pumpUntil(
        tester,
        () => find
            .byKey(const ValueKey('entry-citations'))
            .evaluate()
            .isNotEmpty);
    expect(find.byKey(const ValueKey('entry-citations')), findsOneWidget);
    await closeEditor(tester);
  });
}
