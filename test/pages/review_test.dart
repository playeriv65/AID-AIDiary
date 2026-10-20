import 'dart:math';

import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/random_review_page.dart';
import 'package:daily_you/pages/review_story_page.dart';
import 'package:daily_you/stats/period_review.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/year_pixels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

Entry _entry(int id, DateTime time,
        {int? mood,
        String text = '',
        EntryActivity? activity,
        String? place}) =>
    Entry(
        id: id,
        text: text,
        mood: mood,
        activity: activity,
        location: place == null ? null : EntryLocation(name: place),
        timeCreate: time,
        timeModified: time);

void main() {
  final harness = DiaryAppHarness()..register();

  test('weeks start on the chosen weekday', () {
    final wednesday = DateTime(2026, 10, 21, 15);
    expect(TimeManager.startOfWeek(wednesday, DateTime.monday),
        DateTime(2026, 10, 19));
    expect(TimeManager.startOfWeek(wednesday, DateTime.sunday),
        DateTime(2026, 10, 18));
    expect(TimeManager.startOfWeek(DateTime(2026, 10, 19), DateTime.monday),
        DateTime(2026, 10, 19));
  });

  test('a period review counts what happened inside it', () {
    final entries = [
      _entry(5, DateTime(2026, 10, 25), mood: -1, text: 'outside'),
      _entry(4, DateTime(2026, 10, 21, 20),
          mood: 2, text: 'great long day', activity: EntryActivity.cycling),
      _entry(3, DateTime(2026, 10, 21, 8), mood: 1, place: '家'),
      _entry(2, DateTime(2026, 10, 20), mood: 1, place: '家'),
      _entry(1, DateTime(2026, 10, 18), text: 'before'),
    ];
    final review =
        PeriodReview.of(entries, DateTime(2026, 10, 19), DateTime(2026, 10, 26),
            tagsOf: (e) => e.id! >= 3 ? ['工作'] : const [],
            imagesOf: (e) => [
                  EntryImage(
                      entryId: e.id,
                      imgPath: e.id == 2 ? 'a.jpg' : 'b.m4a',
                      imgRank: 0,
                      timeCreate: e.timeCreate)
                ]);
    expect(review.entries.map((e) => e.id), [5, 4, 3, 2]);
    expect(review.daysInPeriod, 7);
    expect(review.daysWritten.length, 3);
    expect(review.longestStreak, 2);
    expect(review.averageMood, 0.75);
    expect(review.photos.single.imgPath, 'a.jpg');
    expect(review.topTags.single, (item: '工作', count: 3));
    expect(review.topPlaces.single, (item: '家', count: 2));
    expect(review.topActivities.single.item, EntryActivity.cycling);
    expect(review.highlight!.id, 4);
    expect(review.perMonth[9], 4);
  });

  test('the random deck shows every entry before repeating', () {
    final deck = RandomDeck(Random(1));
    final seen = <int>{};
    int? last;
    for (var i = 0; i < 4; i++) {
      last = deck.next([1, 2, 3, 4], avoid: last);
      seen.add(last!);
    }
    expect(seen, {1, 2, 3, 4});
    final next = deck.next([1, 2, 3, 4], avoid: last);
    expect(next, isNot(last));
    expect(deck.next(const []), isNull);
  });

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
