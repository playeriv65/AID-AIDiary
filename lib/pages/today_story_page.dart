// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/flashback_manager.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/flashback.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_context_display.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/utils/entry_preview.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/story_shell.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Full-screen slides about the diary: statistics, a 30-day mood chart and
/// a throwback.
class TodayStoryPage extends StatelessWidget {
  const TodayStoryPage(
      {super.key, this.slideDuration = const Duration(seconds: 6)});

  final Duration slideDuration;

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          allowSnapshotting: false,
          builder: (_) => const TodayStoryPage()));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = EntriesProvider.instance.entries;
    final days = entries
        .map((e) =>
            DateTime(e.timeCreate.year, e.timeCreate.month, e.timeCreate.day))
        .toSet()
        .length;
    return StoryShell(
      slideDuration: slideDuration,
      subtitle: l10n.storyEntriesAndDays(entries.length, days),
      slides: [
        (
          icon: Icons.insights_rounded,
          title: l10n.storyStatistics,
          body: _Statistics(entries: entries),
        ),
        (
          icon: Icons.mood_rounded,
          title: l10n.storyMoodChart,
          body: _MoodChart(entries: entries),
        ),
        (
          icon: Icons.history_rounded,
          title: l10n.storyThrowback,
          body: _Throwback(
              flashbacks: FlashbackManager.getFlashbacks(context, entries)),
        ),
      ],
    );
  }
}

/// Entries per month for the last six months, this year against last year.
class _Statistics extends StatelessWidget {
  const _Statistics({required this.entries});
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final locale = TimeManager.currentLocale(context);
    final now = DateTime.now();
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    int count(DateTime month) => entries
        .where((e) =>
            e.timeCreate.year == month.year &&
            e.timeCreate.month == month.month)
        .length;
    final thisYear = [for (final m in months) count(m)];
    final lastYear = [
      for (final m in months) count(DateTime(m.year - 1, m.month)),
    ];
    final maxY = [...thisYear, ...lastYear, 1]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Column(children: [
      const Spacer(),
      SizedBox(
        height: 280,
        child: BarChart(BarChartData(
          maxY: maxY * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                      DateFormat.MMM(locale).format(months[value.toInt()])),
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < months.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                    toY: lastYear[i].toDouble(),
                    color: cs.outlineVariant,
                    width: 10),
                BarChartRodData(
                    toY: thisYear[i].toDouble(), color: cs.primary, width: 10),
              ]),
          ],
        )),
      ),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _Legend(color: cs.outlineVariant, label: l10n.storyLastYear),
        const SizedBox(width: 24),
        _Legend(color: cs.primary, label: l10n.storyThisYear),
      ]),
      const Spacer(),
    ]);
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(label),
      ]);
}

/// The last 30 days, each tinted by its latest mood; tap a day to open it.
class _MoodChart extends StatelessWidget {
  const _MoodChart({required this.entries});
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final days = [
      for (var i = 29; i >= 0; i--)
        DateTime(today.year, today.month, today.day - i),
    ];
    final provider = EntriesProvider.instance;
    return Column(children: [
      const Spacer(),
      GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final day in days)
            Builder(builder: (context) {
              final dayEntries = provider.getEntriesForDate(day);
              final latest = dayEntries.firstOrNull;
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
                                ? '${DateFormat.MMM(TimeManager.currentLocale(context)).format(day)}\n${day.day}'
                                : '${day.day}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              );
            }),
        ],
      ),
      const Spacer(),
      Text(l10n.storyTapToOpen,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: cs.onSurfaceVariant)),
    ]);
  }
}

class _Throwback extends StatelessWidget {
  const _Throwback({required this.flashbacks});
  final List<Flashback> flashbacks;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final flashback = flashbacks.firstOrNull;
    if (flashback == null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.history_rounded,
              size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(l10n.storyNoThrowback, style: theme.textTheme.titleLarge),
        ]),
      );
    }
    final entry = flashback.firstEntry;
    final preview = entryPreview(entry.text);
    return Center(
      child: Card.filled(
        child: InkWell(
          key: const ValueKey('story-throwback-entry'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => EntryNavigation.flashback(context, flashback),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(flashback.title, style: theme.textTheme.titleLarge),
                  Text(
                      TimeManager.formatDateWithWeekday(
                          entry.timeCreate, context),
                      style: theme.textTheme.labelLarge),
                  const SizedBox(height: 12),
                  if (preview.title != null)
                    Text(preview.title!, style: theme.textTheme.titleMedium),
                  Text(preview.snippet,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium),
                ]),
          ),
        ),
      ),
    );
  }
}
