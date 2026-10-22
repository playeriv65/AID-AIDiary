// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/stats/entry_stats.dart';
import 'package:aid_diary/stats/period_review.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/diary_day.dart';

/// Statistics that need the diary's tags and attachments, which the pure
/// code in `stats/` does not see.
abstract final class DiaryStatistics {
  /// The review for the current week or year. [firstWeekday] is the day the
  /// week starts on, as `DateTime.weekday` counts it (Monday = 1).
  static PeriodReview review(ReviewSpan span,
      {required int firstWeekday, DateTime? today}) {
    final now = today ?? DiaryDay.today();
    final weekStart = TimeManager.startOfWeek(now, firstWeekday);
    final (start, end) = switch (span) {
      ReviewSpan.week => (weekStart, weekStart.add(const Duration(days: 7))),
      ReviewSpan.year => (DateTime(now.year), DateTime(now.year + 1)),
    };
    final tags = TagsProvider.instance;
    final tagById = {for (final tag in tags.tags) tag.id: tag};
    final favoriteId = tags.favoriteTag?.id;
    return PeriodReview.of(
      [
        for (final entry in EntriesProvider.instance.entries)
          if (!entry.isSealed) entry,
      ],
      start,
      end,
      tagsOf: (entry) => [
        for (final entryTag in tags.getEntryTagsForEntry(entry.id!))
          if (entryTag.tagId != favoriteId)
            if (tagById[entryTag.tagId] case final tag?) tag.name,
      ],
      imagesOf: EntryImagesProvider.instance.getForEntry,
    );
  }

  /// What most often came with [mood] in [entries]: activities
  /// ([EntryActivity]) and tags ([Tag]), most telling first.
  static List<MoodAssociation<Object>> moodAssociationsOf(
      List<Entry> entries, int mood) {
    final tags = TagsProvider.instance;
    final tagById = {for (final tag in tags.tags) tag.id!: tag};
    return moodAssociations<Object>(
      entries,
      mood,
      (entry) => [
        if (entry.activity case final activity?) activity,
        for (final entryTag in tags.getEntryTagsForEntry(entry.id!))
          if (tagById[entryTag.tagId] case final tag?) tag,
      ],
    );
  }
}
