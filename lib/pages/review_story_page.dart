// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/services/diary_statistics.dart';
import 'package:aid_diary/stats/period_review.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/story_cards.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:aid_diary/widgets/year_pixels.dart';
import 'package:intl/intl.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:material_ui/material_ui.dart';

export 'package:aid_diary/stats/period_review.dart' show ReviewSpan;

/// A week or year in review as story slides.
class ReviewStoryPage extends StatelessWidget {
  const ReviewStoryPage({super.key, required this.span});

  final ReviewSpan span;

  /// The review for the current week or year.
  static PeriodReview current(BuildContext context, ReviewSpan span) =>
      DiaryStatistics.review(span,
          // The settings index counts from Monday = 0; DateTime.weekday from 1.
          firstWeekday:
              ConfigProvider.instance.getFirstDayOfWeekIndex(context) + 1);

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
    final hasFavorites =
        review.topTags.isNotEmpty || review.topPlaces.isNotEmpty;
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
                ? StoryMoodDays(days: [
                    for (var i = 0; i < review.daysInPeriod; i++)
                      DateTime(review.start.year, review.start.month,
                          review.start.day + i),
                  ])
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
              body: StoryBarChart(labels: [
                for (var month = 1; month <= 12; month++)
                  DateFormat.MMM(locale)
                      .format(DateTime(review.start.year, month)),
              ], series: [
                (name: l10n.reviewEntries, values: review.perMonth),
              ]),
            ),
          if (highlight != null)
            (
              icon: Icons.star_rounded,
              title: l10n.reviewHighlight,
              body: StoryEntryCard(
                  key: const ValueKey('review-highlight'),
                  entry: highlight,
                  open: (context) => EntryNavigation.view(context, highlight)),
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
          child: EmptyState(
              icon: Icons.edit_note_rounded, title: l10n.reviewEmpty));
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
