// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/stats/period_review.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_navigation.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:aid_diary/widgets/year_pixels.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

enum ReviewSpan { week, year }

/// A week or year in review as story slides.
class ReviewStoryPage extends StatelessWidget {
  const ReviewStoryPage({super.key, required this.span});

  final ReviewSpan span;

  static Future<void> open(BuildContext context, ReviewSpan span) =>
      StoryPlayer.show(context, groups: (context) => [group(context, span)]);

  /// The review for the current week or year.
  static PeriodReview current(BuildContext context, ReviewSpan span) {
    final now = DiaryDay.today();
    // The settings index counts from Monday = 0; DateTime.weekday from 1.
    final weekStart = TimeManager.startOfWeek(
        now, ConfigProvider.instance.getFirstDayOfWeekIndex(context) + 1);
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

  @override
  Widget build(BuildContext context) =>
      StoryPlayer(groups: [group(context, span)]);

  static StoryGroup group(BuildContext context, ReviewSpan span) {
    final l10n = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    final review = current(context, span);
    final week = span == ReviewSpan.week;
    final subtitle = week
        ? '${DateFormat.MMMd(locale).format(review.start)} – '
            '${DateFormat.MMMd(locale).format(review.end.subtract(const Duration(days: 1)))}'
        : '${review.start.year}';
    final highlight = review.highlight;
    final hasFavorites = review.topTags.isNotEmpty ||
        review.topActivities.isNotEmpty ||
        review.topPlaces.isNotEmpty;
    return StoryGroup(
      id: 'review-${span.name}',
      subtitle: subtitle,
      slides: [
        (
          icon: Icons.auto_graph_rounded,
          title: week ? l10n.reviewWeekTitle : l10n.reviewYearTitle,
          body: _Overview(review: review, showStreak: !week),
        ),
        if (review.entries.isNotEmpty) ...[
          (
            icon: Icons.mood_rounded,
            title: l10n.storyMoodChart,
            body: week
                ? _WeekMoods(review: review)
                : Center(
                    child: SingleChildScrollView(
                        child: YearInPixels(year: review.start.year))),
          ),
          if (hasFavorites)
            (
              icon: Icons.local_offer_rounded,
              title: l10n.reviewFavorites,
              body: _Favorites(review: review),
            ),
          if (review.photos.isNotEmpty)
            (
              icon: Icons.photo_library_rounded,
              title: l10n.reviewPhotos,
              body: _Photos(review: review, max: week ? 9 : 12),
            ),
          if (!week)
            (
              icon: Icons.bar_chart_rounded,
              title: l10n.reviewByMonth,
              body: _PerMonth(review: review),
            ),
          if (highlight != null)
            (
              icon: Icons.star_rounded,
              title: l10n.reviewHighlight,
              body: _Highlight(entry: highlight),
            ),
        ],
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.review, required this.showStreak});
  final PeriodReview review;
  final bool showStreak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (review.entries.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.edit_note_rounded,
              size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(l10n.reviewEmpty, style: theme.textTheme.titleLarge),
        ]),
      );
    }
    final average = review.averageMood;
    final numbers = [
      (
        Icons.description_outlined,
        '${review.entries.length}',
        l10n.reviewEntries
      ),
      (
        Icons.today_rounded,
        '${review.daysWritten.length}/${review.daysInPeriod}',
        l10n.reviewDaysWritten
      ),
      (Icons.sort_rounded, '${review.words}', l10n.reviewWords),
      (Icons.photo_outlined, '${review.photos.length}', l10n.reviewPhotos),
      if (showStreak)
        (Icons.bolt_rounded, '${review.longestStreak}', l10n.reviewLongestRun),
    ];
    return Center(
      child: SingleChildScrollView(
        child: Column(children: [
          if (average != null) ...[
            MoodIcon(moodValue: average.round(), size: 64),
            Text(l10n.reviewAverageMood, style: theme.textTheme.labelLarge),
            const SizedBox(height: 24),
          ],
          Wrap(spacing: 12, runSpacing: 12, children: [
            for (final (icon, value, label) in numbers)
              SizedBox(
                width: 150,
                child: Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: theme.colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(value,
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text(label, style: theme.textTheme.labelMedium),
                        ]),
                  ),
                ),
              ),
          ]),
        ]),
      ),
    );
  }
}

/// The seven days of the week, each with its mood or an empty ring.
class _WeekMoods extends StatelessWidget {
  const _WeekMoods({required this.review});
  final PeriodReview review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final locale = TimeManager.currentLocale(context);
    final provider = EntriesProvider.instance;
    return Center(
      child: Wrap(spacing: 8, runSpacing: 12, children: [
        for (var i = 0; i < review.daysInPeriod; i++)
          Builder(builder: (context) {
            final day = DateTime(
                review.start.year, review.start.month, review.start.day + i);
            final latest = provider.getEntriesForDate(day).firstOrNull;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                key: ValueKey('review-day-${day.day}'),
                customBorder: const CircleBorder(),
                onTap: latest == null
                    ? null
                    : () => EntryNavigation.view(context, latest),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: latest == null
                      ? cs.surfaceContainerHighest
                      : moodColor(latest.mood, cs),
                  child: latest != null &&
                          MoodIcon.getMoodIcon(latest.mood).isNotEmpty
                      ? MoodIcon(moodValue: latest.mood, size: 20)
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(DateFormat.E(locale).format(day),
                  style: Theme.of(context).textTheme.labelSmall),
            ]);
          }),
      ]),
    );
  }
}

class _Favorites extends StatelessWidget {
  const _Favorites({required this.review});
  final PeriodReview review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    Widget group(String title, List<(IconData, String, int)> items) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final (icon, label, count) in items.take(6))
              Chip(
                  avatar: Icon(icon, size: 18), label: Text('$label · $count')),
          ]),
          const SizedBox(height: 16),
        ]);
    return Center(
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (review.topTags.isNotEmpty)
            group(l10n.searchFilterTags, [
              for (final t in review.topTags)
                (Icons.local_offer_outlined, t.item, t.count)
            ]),
          if (review.topActivities.isNotEmpty)
            group(l10n.activityTitle, [
              for (final a in review.topActivities)
                (activityIcon(a.item), activityLabel(a.item, l10n), a.count)
            ]),
          if (review.topPlaces.isNotEmpty)
            group(l10n.locationTitle, [
              for (final p in review.topPlaces)
                (Icons.place_outlined, p.item, p.count)
            ]),
        ]),
      ),
    );
  }
}

class _Photos extends StatelessWidget {
  const _Photos({required this.review, required this.max});
  final PeriodReview review;
  final int max;

  @override
  Widget build(BuildContext context) {
    final photos = review.photos.take(max).toList();
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final photo in photos)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LocalImageLoader(imagePath: photo.imgPath, cacheSize: 400),
            ),
        ],
      ),
    );
  }
}

class _PerMonth extends StatelessWidget {
  const _PerMonth({required this.review});
  final PeriodReview review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final counts = review.perMonth;
    final most = counts.reduce((a, b) => a > b ? a : b).clamp(1, 1 << 30);
    return Center(
      child: SizedBox(
        height: 260,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var month = 0; month < 12; month++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  if (counts[month] > 0)
                    Text('${counts[month]}',
                        style: Theme.of(context).textTheme.labelSmall),
                  Container(
                    height: 200 * counts[month] / most,
                    decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 4),
                  Text('${month + 1}',
                      style: Theme.of(context).textTheme.labelSmall),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = entryPreview(entry.text);
    return Center(
      child: Card.filled(
        child: InkWell(
          key: const ValueKey('review-highlight'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => EntryNavigation.view(context, entry),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                          TimeManager.formatDateWithWeekday(entry.day, context),
                          style: theme.textTheme.labelLarge),
                    ),
                    if (MoodIcon.getMoodIcon(entry.mood).isNotEmpty)
                      MoodIcon(moodValue: entry.mood, size: 28),
                  ]),
                  const SizedBox(height: 12),
                  if (preview.title != null)
                    Text(preview.title!, style: theme.textTheme.titleMedium),
                  Text(preview.snippet,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium),
                ]),
          ),
        ),
      ),
    );
  }
}
