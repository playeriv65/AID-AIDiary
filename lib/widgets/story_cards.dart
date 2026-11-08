// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// One entry on a story slide: an optional [heading] (a throwback's "a year
/// ago"), its day and mood, title and the start of its text. A tap calls
/// [open] with the card's context to open the entry where it belongs.
class StoryEntryCard extends StatelessWidget {
  const StoryEntryCard(
      {super.key, required this.entry, required this.open, this.heading});

  final Entry entry;
  final String? heading;
  final void Function(BuildContext context) open;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = entryPreview(entry);
    return Center(
      child: Card.filled(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => open(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heading case final heading?)
                    Text(heading, style: theme.textTheme.titleLarge),
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

/// [days] in rows of a week under their weekday names, each tinted by its
/// latest entry's mood; a tap on a day with an entry opens it.
class StoryMoodDays extends StatelessWidget {
  const StoryMoodDays({super.key, required this.days});

  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final locale = TimeManager.currentLocale(context);
    final provider = EntriesProvider.instance;
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          GridView.count(
            crossAxisCount: DateTime.daysPerWeek,
            shrinkWrap: true,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final day in days.take(DateTime.daysPerWeek))
                Center(
                    child: Text(DateFormat.E(locale).format(day),
                        style: theme.textTheme.labelSmall)),
              for (final day in days)
                Builder(builder: (context) {
                  final latest = provider.getEntriesForDate(day).firstOrNull;
                  return Material(
                    key: ValueKey('story-mood-${day.month}-${day.day}'),
                    color: latest == null
                        ? cs.surfaceContainerHighest
                        : moodColor(latest.mood, cs),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: latest == null
                          ? null
                          : () => EntryNavigation.view(context, latest),
                      child: Center(
                        child: latest != null &&
                                MoodIcon.getMoodIcon(latest.mood).isNotEmpty
                            ? MoodIcon(moodValue: latest.mood, size: 22)
                            : Text(
                                day.day == 1 || day == days.first
                                    ? '${DateFormat.MMM(locale).format(day)}\n${day.day}'
                                    : '${day.day}',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelMedium),
                      ),
                    ),
                  );
                }),
            ],
          ),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.storyTapToOpen,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

/// A series of entry counts in [StoryBarChart]: its [name] for the legend
/// and one value per label.
typedef StoryBarSeries = ({String name, List<int> values});

/// Entry counts as bars, one group per label. The last of [series] is the
/// current one: drawn in the primary color with its counts above the bars;
/// earlier ones stand beside it for comparison, with a legend.
class StoryBarChart extends StatelessWidget {
  const StoryBarChart({super.key, required this.labels, required this.series});

  final List<String> labels;
  final List<StoryBarSeries> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    Color colorOf(int index) =>
        index == series.length - 1 ? cs.primary : cs.outlineVariant;
    final most = [
      for (final s in series) ...s.values,
      1,
    ].reduce((a, b) => a > b ? a : b);
    final current = series.length - 1;
    final barWidth = labels.length > 6 ? 14.0 : 10.0;
    return Column(children: [
      const Spacer(),
      SizedBox(
        height: 280,
        child: BarChart(BarChartData(
          maxY: most * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 2,
              getTooltipItem: (group, _, rod, __) => rod.toY == 0
                  ? null
                  : BarTooltipItem(
                      '${rod.toY.round()}', theme.textTheme.labelSmall!),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(labels[value.toInt()],
                      style: theme.textTheme.labelSmall),
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < labels.length; i++)
              BarChartGroupData(
                x: i,
                showingTooltipIndicators: [current],
                barRods: [
                  for (final (index, s) in series.indexed)
                    BarChartRodData(
                        toY: s.values[i].toDouble(),
                        color: colorOf(index),
                        width: barWidth,
                        borderRadius: BorderRadius.circular(4)),
                ],
              ),
          ],
        )),
      ),
      if (series.length > 1) ...[
        const SizedBox(height: 16),
        Wrap(alignment: WrapAlignment.center, spacing: 24, children: [
          for (final (index, s) in series.indexed)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 12, height: 12, color: colorOf(index)),
              const SizedBox(width: 6),
              Text(s.name),
            ]),
        ]),
      ],
      const Spacer(),
    ]);
  }
}
