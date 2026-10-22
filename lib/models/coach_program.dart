// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';

enum CoachInterval { daily, weekly }

enum CoachDifficulty { beginner, intermediate }

/// A series of writing prompts, one per day or per week once enrolled.
class CoachProgram {
  const CoachProgram({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.interval,
    required this.difficulty,
    required this.prompts,
  });

  final String id;
  final String title;

  /// One line under the cover.
  final String tagline;
  final String description;
  final CoachInterval interval;
  final CoachDifficulty difficulty;
  final List<String> prompts;

  int get days => interval == CoachInterval.daily ? 1 : 7;

  String durationLabel(AppLocalizations l10n) => interval == CoachInterval.daily
      ? l10n.coachDurationDays(prompts.length)
      : l10n.coachDurationWeeks(prompts.length);

  String intervalLabel(AppLocalizations l10n) => interval == CoachInterval.daily
      ? l10n.coachIntervalDaily
      : l10n.coachIntervalWeekly;

  String difficultyLabel(AppLocalizations l10n) => switch (difficulty) {
        CoachDifficulty.beginner => l10n.coachDifficultyBeginner,
        CoachDifficulty.intermediate => l10n.coachDifficultyIntermediate,
      };

  /// "Day 3" or "Week 3" for the zero-based [step].
  String stepLabel(AppLocalizations l10n, int step) =>
      interval == CoachInterval.daily
          ? l10n.coachDayN(step + 1)
          : l10n.coachWeekN(step + 1);

  static List<CoachProgram> all(AppLocalizations l10n) => [
        CoachProgram(
          id: 'everyday',
          title: l10n.coachProgramEverydayTitle,
          tagline: l10n.coachProgramEverydayTagline,
          description: l10n.coachProgramEverydayDescription,
          interval: CoachInterval.daily,
          difficulty: CoachDifficulty.beginner,
          prompts: [
            l10n.coachPrompt1,
            l10n.coachPrompt2,
            l10n.coachPrompt6,
            l10n.coachPrompt9,
            l10n.coachPrompt10,
          ],
        ),
        CoachProgram(
          id: 'reflect',
          title: l10n.coachProgramReflectTitle,
          tagline: l10n.coachProgramReflectTagline,
          description: l10n.coachProgramReflectDescription,
          interval: CoachInterval.weekly,
          difficulty: CoachDifficulty.intermediate,
          prompts: [
            l10n.coachPrompt3,
            l10n.coachPrompt4,
            l10n.coachPrompt5,
            l10n.coachPrompt7,
            l10n.coachPrompt8,
          ],
        ),
      ];

  static CoachProgram? byId(AppLocalizations l10n, String id) =>
      all(l10n).where((p) => p.id == id).firstOrNull;
}

/// When a program's prompts fall due. Plain data, so the background
/// notification can use it without localizations.
class CoachSchedule {
  const CoachSchedule(
      {required this.start, required this.days, required this.steps});

  /// The day the program started; only the date counts.
  final DateTime start;

  /// Days between prompts.
  final int days;

  /// Number of prompts.
  final int steps;

  /// Calendar days from the start to [day]; UTC dates so a daylight saving
  /// change does not shorten a day.
  int _daysTo(DateTime day) => DateTime.utc(day.year, day.month, day.day)
      .difference(DateTime.utc(start.year, start.month, start.day))
      .inDays;

  /// Zero-based step for [day]; past the last prompt once finished.
  int stepOn(DateTime day) => _daysTo(day) ~/ days;

  bool finishedOn(DateTime day) => stepOn(day) >= steps;

  /// Whether [day] brings a new prompt: every day, or the start weekday.
  bool newPromptOn(DateTime day) =>
      !finishedOn(day) && _daysTo(day) % days == 0;
}

/// An enrolled program and the last step answered.
class CoachEnrollment {
  const CoachEnrollment(
      {required this.program, required this.start, required this.answered});

  final CoachProgram program;
  final DateTime start;

  /// The last answered step, or -1.
  final int answered;

  CoachSchedule get schedule => CoachSchedule(
      start: start, days: program.days, steps: program.prompts.length);

  /// Zero-based step due on [day].
  int stepOn(DateTime day) => schedule.stepOn(day);

  String promptOn(DateTime day) => program.prompts[stepOn(day)];

  /// Whether the prompt due on [day] was answered already.
  bool answeredOn(DateTime day) => answered >= stepOn(day);
}
