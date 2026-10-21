// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/flashback.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/coach_widgets.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// The stories row played as one chain, like Journey: today's statistics
/// and mood chart, the coach program's prompt, the throwback, then a
/// closing card. A row card starts the chain at its own story.
class TodayStory {
  static const today = 'today';
  static const coach = 'coach';
  static const throwback = 'throwback';

  static Future<void> open(BuildContext context, {String from = today}) =>
      StoryPlayer.show(context, groups: groups, startAt: from, wrapUp: true);

  static List<StoryGroup> groups(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = EntriesProvider.instance.entries;
    final days = EntriesProvider.instance.getEntryDayCount();
    final flashback = ConfigProvider.instance.get(Settings.showFlashbacks)
        ? FlashbackManager.getFlashbacks(context, entries).firstOrNull
        : null;
    final enrollment = CoachService.current(l10n);
    return [
      StoryGroup(
        id: today,
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
        ],
      ),
      if (enrollment != null) _coachGroup(l10n, enrollment),
      if (flashback != null)
        StoryGroup(
          id: throwback,
          subtitle: flashback.title,
          slides: [
            (
              icon: Icons.history_rounded,
              title: l10n.storyThrowback,
              body: _Throwback(flashback: flashback),
            ),
          ],
        ),
    ];
  }

  /// The program's cover with the day, then today's prompt to answer.
  static StoryGroup _coachGroup(
      AppLocalizations l10n, CoachEnrollment enrollment) {
    final program = enrollment.program;
    final step = enrollment.schedule.stepOn(DiaryDay.today());
    final label = program.stepLabel(l10n, step);
    return StoryGroup(
      id: coach,
      subtitle: label,
      leading: const CoachAvatar(),
      backdrop: ProgramCover(program: program, iconSize: 240, radius: 0),
      slides: [
        (
          icon: Icons.flag_outlined,
          title: l10n.pageCoachTitle,
          body: _CoachCover(program: program, label: label),
        ),
        (
          icon: Icons.flag_outlined,
          title: l10n.pageCoachTitle,
          body: _CoachPrompt(
              prompt: program.prompts[step],
              step: step,
              answeredEarlier: enrollment.answered >= step),
        ),
      ],
    );
  }
}

class _CoachCover extends StatelessWidget {
  const _CoachCover({required this.program, required this.label});
  final CoachProgram program;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CoachAvatar(radius: 32),
        const SizedBox(height: 20),
        Text(program.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 32),
        Text(label,
            style: theme.textTheme.displaySmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

/// The prompt in large type over an answer bar. The answer is written in
/// place and saved as an entry with the prompt as its heading.
class _CoachPrompt extends StatefulWidget {
  const _CoachPrompt(
      {required this.prompt,
      required this.step,
      required this.answeredEarlier});
  final String prompt;
  final int step;
  final bool answeredEarlier;

  @override
  State<_CoachPrompt> createState() => _CoachPromptState();
}

class _CoachPromptState extends State<_CoachPrompt> {
  Entry? _saved;

  Future<void> _answer() async {
    final saved = _saved;
    if (saved != null) {
      return StoryPlayer.pauseDuring(
          context, () => EntryNavigation.edit(context, saved));
    }
    final text = await StoryPlayer.pauseDuring(
        context,
        () => showGeneralDialog<String>(
              context: context,
              barrierDismissible: true,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.black54,
              pageBuilder: (_, __, ___) => _AnswerSheet(prompt: widget.prompt),
            ));
    if (text == null || text.trim().isEmpty) return;
    final entry = await CoachService.answer(widget.prompt, text, widget.step);
    if (mounted) setState(() => _saved = entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final done = _saved != null || widget.answeredEarlier;
    return Column(children: [
      Expanded(
        child: Center(
          child: Text(widget.prompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ),
      Material(
        color: Colors.black26,
        shape: const StadiumBorder(side: BorderSide(color: Colors.white70)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey('coach-answer'),
          onTap: _saved == null && widget.answeredEarlier ? null : _answer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(children: [
              Icon(done ? Icons.check_rounded : Icons.edit_rounded,
                  color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                    _saved != null
                        ? l10n.coachAnswered
                        : widget.answeredEarlier
                            ? l10n.coachAnsweredEarlier
                            : l10n.coachAnswerHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white)),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}

/// A full-height box over the story for writing the answer.
class _AnswerSheet extends StatefulWidget {
  const _AnswerSheet({required this.prompt});
  final String prompt;

  @override
  State<_AnswerSheet> createState() => _AnswerSheetState();
}

class _AnswerSheetState extends State<_AnswerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const border = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.all(Radius.circular(20)));
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Text(widget.prompt,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  TextButton(
                    key: const ValueKey('coach-answer-done'),
                    onPressed: () =>
                        Navigator.of(context).pop(_controller.text),
                    child: Text(l10n.coachAnswerDone),
                  ),
                ]),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    key: const ValueKey('coach-answer-field'),
                    controller: _controller,
                    autofocus: true,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.coachAnswerHint,
                      hintStyle: const TextStyle(color: Colors.white60),
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
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
    final now = DiaryDay.today();
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    int count(DateTime month) => entries
        .where((e) => e.day.year == month.year && e.day.month == month.month)
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
    final today = DiaryDay.today();
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
  const _Throwback({required this.flashback});
  final Flashback flashback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Text(TimeManager.formatDateWithWeekday(entry.day, context),
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
