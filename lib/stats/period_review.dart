// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/stats/entry_stats.dart';

/// The stretch of time a review covers.
enum ReviewSpan { week, year }

/// A count of how often something came up, most frequent first.
typedef Tally<T> = List<({T item, int count})>;

/// What a week or a year of entries adds up to.
class PeriodReview {
  PeriodReview._({
    required this.start,
    required this.end,
    required this.entries,
    required this.photos,
    required this.topTags,
    required this.topActivities,
    required this.topPlaces,
  });

  /// Entries from [start] (inclusive) to [end] (exclusive), as given (newest
  /// first). [tagsOf] names an entry's tags; [imagesOf] lists attachments.
  factory PeriodReview.of(
    List<Entry> all,
    DateTime start,
    DateTime end, {
    required Iterable<String> Function(Entry entry) tagsOf,
    required List<EntryImage> Function(Entry entry) imagesOf,
  }) {
    final entries = [
      for (final entry in all)
        if (!entry.day.isBefore(start) && entry.day.isBefore(end)) entry,
    ];
    return PeriodReview._(
      start: start,
      end: end,
      entries: entries,
      photos: [
        for (final entry in entries)
          for (final image in imagesOf(entry))
            if (image.isImage) image,
      ],
      topTags: _tally(entries.expand(tagsOf)),
      topActivities: _tally(entries.map((e) => e.activity).nonNulls),
      topPlaces: _tally(
          entries.map((e) => e.location?.name).nonNulls.where((n) => n != '')),
    );
  }

  final DateTime start;
  final DateTime end;
  final List<Entry> entries;
  final List<EntryImage> photos;
  final Tally<String> topTags;
  final Tally<EntryActivity> topActivities;
  final Tally<String> topPlaces;

  int get daysInPeriod => end.difference(start).inDays;

  Set<DateTime> get daysWritten => {
        for (final e in entries) e.day,
      };

  int get words => totalWordCount(entries);

  double? get averageMood {
    final moods = entries.map((e) => e.mood).nonNulls;
    return moods.isEmpty ? null : moods.reduce((a, b) => a + b) / moods.length;
  }

  /// Longest run of consecutive days with an entry inside the period.
  int get longestStreak {
    final days = daysWritten.toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? previous;
    for (final day in days) {
      run = previous != null &&
              DateTime(previous.year, previous.month, previous.day + 1) == day
          ? run + 1
          : 1;
      if (run > best) best = run;
      previous = day;
    }
    return best;
  }

  /// The entry to remember the period by: best mood, then the longest.
  Entry? get highlight {
    if (entries.isEmpty) return null;
    return entries.reduce((a, b) {
      final byMood = (a.mood ?? -3).compareTo(b.mood ?? -3);
      if (byMood != 0) return byMood > 0 ? a : b;
      return a.text.length >= b.text.length ? a : b;
    });
  }

  /// Entry counts per month of the period's year (index 0 = January).
  List<int> get perMonth {
    final counts = List.filled(12, 0);
    for (final e in entries) {
      counts[e.day.month - 1]++;
    }
    return counts;
  }

  static Tally<T> _tally<T>(Iterable<T> items) {
    final counts = <T, int>{};
    for (final item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    return [
      for (final MapEntry(:key, :value) in counts.entries)
        (item: key, count: value),
    ]..sort((a, b) => b.count.compareTo(a.count));
  }
}
