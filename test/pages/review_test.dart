@Tags(['widget'])
library;

import 'dart:math';

import 'package:aid_diary/pages/random_review_page.dart';
import 'package:aid_diary/pages/review_story_page.dart';
import 'package:aid_diary/widgets/year_pixels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('random walk shows an entry and moves to another',
      (tester) async {
    await DiaryAppHarness.addEntry(tester, '第一篇', DateTime(2026, 9, 1),
        mood: 2);
    await DiaryAppHarness.addEntry(tester, '第二篇', DateTime(2026, 9, 2),
        mood: -1);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(RandomReviewPage(random: Random(3))));
    await tester.pumpAndSettle();
    final first = find.textContaining('第一篇').evaluate().isNotEmpty;
    await tester.tap(find.byKey(const ValueKey('random-next')));
    await tester.pumpAndSettle();
    expect(find.textContaining(first ? '第二篇' : '第一篇'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('random-filter-goodDays')));
    await tester.pumpAndSettle();
    expect(find.textContaining('第一篇'), findsWidgets);
    expect(find.textContaining('第二篇'), findsNothing);
  });

  testWidgets('the week review opens on an overview', (tester) async {
    await DiaryAppHarness.addEntry(tester, '今天写的', DateTime.now(), mood: 1);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester
        .pumpWidget(harness.app(const ReviewStoryPage(span: ReviewSpan.week)));
    await tester.pump();
    expect(find.text('本周回顾'.toUpperCase()), findsOneWidget);
    expect(find.text('篇日记'), findsOneWidget);
    // Skip to the mood slide: the right edge steps forward.
    await tester.tapAt(const Offset(350, 820));
    await tester.pump(const Duration(milliseconds: 300));
    final today = DateTime.now();
    expect(find.byKey(ValueKey('review-day-${today.day}')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('year in pixels tints written days', (tester) async {
    await DiaryAppHarness.addEntry(tester, '像素', DateTime(2026, 3, 14),
        mood: 2);
    DiaryAppHarness.size(tester, const Size(390, 900));
    await tester.pumpWidget(harness.app(const Scaffold(
        body: SingleChildScrollView(child: YearInPixels(year: 2026)))));
    await tester.pumpAndSettle();
    final written = tester.widget<Container>(find.descendant(
        of: find.byKey(const ValueKey('pixel-3-14')),
        matching: find.byType(Container)));
    final empty = tester.widget<Container>(find.descendant(
        of: find.byKey(const ValueKey('pixel-3-15')),
        matching: find.byType(Container)));
    expect((written.decoration as BoxDecoration).color,
        isNot((empty.decoration as BoxDecoration).color));
    // February has no 30th.
    expect(find.byKey(const ValueKey('pixel-2-30')), findsNothing);
  });
}
