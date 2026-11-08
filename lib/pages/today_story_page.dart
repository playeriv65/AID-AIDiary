// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/widgets/coach_widgets.dart';
import 'package:aid_diary/widgets/story_cards.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// The stories row played as one chain: today's statistics
/// and mood chart, the coach program's prompt, the throwback, then a
/// closing card. A row card starts the chain at its own story.
class TodayStory {
  static const today = 'today';
  static const coach = 'coach';
  static const throwback = 'throwback';

  /// The stories that exist now: the coach's needs a program, the throwback
  /// a flashback. Outside a build, [listen] is false.
  static List<StoryGroup> groups(BuildContext context, {bool listen = true}) {
    final l10n = AppLocalizations.of(context)!;
    final entries = EntriesProvider.instance.entries;
    final days = EntriesProvider.instance.getEntryDayCount();
    final flashback =
        FlashbackManager.getFlashbacks(context, entries, listen: listen)
            .firstOrNull;
    final enrollment = CoachService.current(l10n);
    final now = DiaryDay.today();
    final locale = TimeManager.currentLocale(context);
    // The last six months, this year against last year.
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    int count(DateTime month) => entries
        .where((e) => e.day.year == month.year && e.day.month == month.month)
        .length;
    return [
      StoryGroup(
        id: today,
        subtitle: l10n.storyEntriesAndDays(entries.length, days),
        slides: [
          (
            icon: Icons.insights_rounded,
            title: l10n.storyStatistics,
            body: StoryBarChart(labels: [
              for (final month in months) DateFormat.MMM(locale).format(month),
            ], series: [
              (
                name: l10n.storyLastYear,
                values: [
                  for (final month in months)
                    count(DateTime(month.year - 1, month.month)),
                ]
              ),
              (
                name: l10n.storyThisYear,
                values: [for (final month in months) count(month)]
              ),
            ]),
          ),
          (
            icon: Icons.mood_rounded,
            title: l10n.storyMoodChart,
            // The last 30 days.
            body: StoryMoodDays(days: [
              for (var i = 29; i >= 0; i--)
                DateTime(now.year, now.month, now.day - i),
            ]),
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
              body: StoryEntryCard(
                  key: const ValueKey('story-throwback-entry'),
                  entry: flashback.firstEntry,
                  heading: flashback.title,
                  open: (context) =>
                      EntryNavigation.flashback(context, flashback, 0)),
            ),
          ],
        ),
    ];
  }

  /// The program's cover with the day, then today's prompt to answer.
  static StoryGroup _coachGroup(
      AppLocalizations l10n, CoachEnrollment enrollment) {
    final program = enrollment.program;
    final today = DiaryDay.today();
    final step = enrollment.stepOn(today);
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
              prompt: enrollment.promptOn(today),
              answeredEarlier: enrollment.answeredOn(today)),
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
  const _CoachPrompt({required this.prompt, required this.answeredEarlier});
  final String prompt;
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
    final answered = await AppActions.instance
        .run('coach.answer', {'text': text}) as Map<String, Object?>;
    final entry = EntryStore.instance.entries
        .firstWhere((e) => e.id == answered['entry']);
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
