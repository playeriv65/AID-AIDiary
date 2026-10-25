// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/search_page.dart';
import 'package:aid_diary/widgets/entry_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  final time = DateTime(2026, 10, 20, 9, 5);

  Future<void> show(WidgetTester tester, Widget card) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester
        .pumpWidget(harness.app(Scaffold(body: Column(children: [card]))));
    await tester.pumpAndSettle();
  }

  /// The spans of the text with [key], marked or not.
  List<(String, bool)> spans(WidgetTester tester, String key) {
    final rich = tester.widget<RichText>(find.descendant(
        of: find.byKey(ValueKey(key)), matching: find.byType(RichText)));
    final out = <(String, bool)>[];
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text != null) {
        out.add((span.text!, span.style?.backgroundColor != null));
      }
      return true;
    });
    return out;
  }

  testWidgets('the title is on top beside the time, then three lines',
      (tester) async {
    await show(
        tester,
        EntryCard(
            entry: Entry(
                title: '周末',
                text: '去了公园。' * 60,
                timeCreate: time,
                timeModified: time),
            onTap: () {}));
    final title = tester.getRect(find.text('周末'));
    final snippet =
        tester.getRect(find.byKey(const ValueKey('entry-card-snippet')));
    expect(title.bottom, lessThanOrEqualTo(snippet.top));
    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('entry-card-snippet')))
            .maxLines,
        entryCardLines);
    expect(find.text('09:05'), findsOneWidget);
    expect(tester.getRect(find.text('09:05')).top, lessThan(snippet.top));
  });

  testWidgets('search words are marked and the text shows around them',
      (tester) async {
    await show(
        tester,
        EntryCard(
            entry: Entry(
                title: '日常记录',
                text: '${'很早之前的事。' * 30}\n下午的日常很平静。',
                timeCreate: time,
                timeModified: time),
            highlight: '日常',
            onTap: () {}));
    expect(spans(tester, 'entry-card-title'), [('日常', true), ('记录', false)]);
    final snippet = spans(tester, 'entry-card-snippet');
    expect(snippet.first.$1, startsWith('…'));
    expect(snippet.where((span) => span.$2).map((span) => span.$1), ['日常']);
  });

  testWidgets('a list switches parts off and adds its own action',
      (tester) async {
    await show(
        tester,
        EntryCard(
            entry: Entry(
                text: '湖边',
                mood: 2,
                timeCreate: time,
                timeModified: time,
                location: const EntryLocation(name: '湖')),
            showDate: true,
            showDetails: false,
            trailing: const Icon(Icons.restore, key: ValueKey('restore')),
            onTap: () {}));
    expect(find.text('湖'), findsNothing);
    expect(find.byKey(const ValueKey('restore')), findsOneWidget);
    expect(find.textContaining('09:05'), findsOneWidget);
    expect(find.text('09:05'), findsNothing, reason: 'the date comes first');
  });

  testWidgets('search results mark what was searched for', (tester) async {
    await DiaryAppHarness.addEntry(tester, '下午的日常很平静', time);
    await show(tester, const SizedBox());
    await tester.pumpWidget(harness.app(const SearchPage()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search-field')), '日常');
    await tester.pumpAndSettle();
    expect(spans(tester, 'entry-card-snippet').where((span) => span.$2),
        hasLength(1));
  });
}
