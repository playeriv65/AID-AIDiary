// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Deleting or hiding an entry closes that entry only: the page showing it
// stays and moves on to what it still holds.

@Tags(['integration'])
library;

import 'dart:math';

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/entries_list_page.dart';
import 'package:aid_diary/pages/random_review_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  /// Opens [page] over a home page, as the app pushes it.
  Future<void> openOverHome(
      WidgetTester tester, void Function(BuildContext context) open) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(Scaffold(
        body: Builder(
            builder: (context) => TextButton(
                key: const ValueKey('home-open'),
                onPressed: () => open(context),
                child: const Text('home'))))));
    await tester.tap(find.byKey(const ValueKey('home-open')));
    await tester.pumpAndSettle();
  }

  Future<void> deleteShown(WidgetTester tester, int count) async {
    await tester.tap(find.byKey(const ValueKey('entry-more')).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await tester.pumpAndSettle();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, '删除'))
            .onPressed!(),
        () => EntryStore.instance.entries.length == count);
  }

  Future<List<Entry>> addThree(WidgetTester tester) async => [
        for (final (index, text) in ['第一篇', '第二篇', '第三篇'].indexed)
          await DiaryAppHarness.addEntry(
              tester, text, DateTime(2026, 10, 1 + index, 9)),
      ];

  testWidgets('deleting in the pager shows the next entry', (tester) async {
    final [_, second, _] = await addThree(tester);
    await openOverHome(
        tester, (context) => EntryNavigation.view(context, second));
    expect(find.text('第二篇'), findsOneWidget);

    await deleteShown(tester, 2);
    expect(find.byType(EntriesListPage), findsOneWidget);
    expect(find.text('第二篇'), findsNothing);
    expect(find.text('第一篇'), findsOneWidget);
    expect(find.text('home'), findsNothing);

    // The last one: the pager steps back to the one before.
    await deleteShown(tester, 1);
    expect(find.byType(EntriesListPage), findsOneWidget);
    expect(find.text('第三篇'), findsOneWidget);
    expect(EntryStore.instance.entries.single.text, '第三篇');

    // Nothing left to show: the pager closes.
    await deleteShown(tester, 0);
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(EntriesListPage).evaluate().isEmpty);
    expect(find.text('home'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('hiding in the pager shows the next entry and says where',
      (tester) async {
    final [_, _, third] = await addThree(tester);
    await openOverHome(
        tester, (context) => EntryNavigation.view(context, third));
    expect(find.text('第三篇'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('entry-more')).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry-hide')));
    await DiaryAppHarness.pumpUntil(
        tester, () => find.byType(SnackBar).evaluate().isNotEmpty);
    expect(EntryStore.instance.hiddenEntries.single.id, third.id);
    expect(find.byType(EntriesListPage), findsOneWidget);
    expect(find.text('第二篇'), findsOneWidget);
    expect(find.text('已隐藏。可在 设置 › 安全 › 隐藏日记 中找到并取消隐藏。'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('deleting in a random walk moves on to another entry',
      (tester) async {
    await addThree(tester);
    await openOverHome(
        tester,
        (context) => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => RandomReviewPage(random: Random(3)))));
    String shown() => ['第一篇', '第二篇', '第三篇']
        .singleWhere((text) => find.text(text).evaluate().isNotEmpty);
    final before = shown();

    await deleteShown(tester, 2);
    expect(find.byType(RandomReviewPage), findsOneWidget);
    expect(EntriesProvider.instance.entries.map((e) => e.text),
        isNot(contains(before)));
    expect(shown(), isNot(before));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
