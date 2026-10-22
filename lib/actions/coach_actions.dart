// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/tag_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/shown_language.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/stats_subject.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/services/diary_statistics.dart';
import 'package:aid_diary/stats/entry_stats.dart';
import 'package:aid_diary/stats/period_review.dart';
import 'package:aid_diary/stats/stats_range.dart';
import 'package:aid_diary/stats/streaks.dart';
import 'package:aid_diary/utils/bucket_combiner.dart';
import 'package:aid_diary/utils/diary_day.dart';

ActionException _notEnrolled() => const ActionException(
    'not_enrolled', 'No coach program is running; coach.enroll starts one');

Map<String, Object?> _programJson(CoachProgram program) => {
      'id': program.id,
      'title': program.title,
      'tagline': program.tagline,
      'description': program.description,
      'interval': program.interval.name,
      'difficulty': program.difficulty.name,
      'steps': program.prompts.length,
    };

/// The running program and where it stands today, as the stories show it.
Future<Map<String, Object?>> _status() async {
  final l10n = await loadShownLocalizations();
  final enrollment = CoachService.current(l10n);
  if (enrollment == null) return {'enrolled': false};
  final today = DiaryDay.today();
  final step = enrollment.stepOn(today);
  return {
    'enrolled': true,
    'program': _programJson(enrollment.program),
    'start': DiaryDay.format(enrollment.start),
    'step': step,
    'stepLabel': enrollment.program.stepLabel(l10n, step),
    'newPromptToday': enrollment.schedule.newPromptOn(today),
    'prompt': enrollment.promptOn(today),
    'answered': enrollment.answeredOn(today),
  };
}

Map<String, Object?> _points(List<DayValue> points) => {
      for (final point in points)
        DiaryDay.format(point.date):
            double.parse(point.value.toStringAsFixed(2)),
    };

Map<String, double?> _rounded(Map<String, double?> byWeekday) => {
      for (final MapEntry(:key, :value) in byWeekday.entries)
        key: value == null ? null : double.parse(value.toStringAsFixed(2)),
    };

Map<String, Object?> _reviewJson(PeriodReview review, ReviewSpan span) {
  Map<String, Object?> tally(Tally<String> items) => {
        for (final (:item, :count) in items) item: count,
      };
  return {
    'from': DiaryDay.format(review.start),
    'to': DiaryDay.format(review.end.subtract(const Duration(days: 1))),
    'entries': review.entries.length,
    'daysWritten': review.daysWritten.length,
    'daysInPeriod': review.daysInPeriod,
    'words': review.words,
    'photos': review.photos.length,
    'averageMood': review.averageMood,
    'longestStreak': review.longestStreak,
    'topTags': tally(review.topTags),
    'topActivities': {
      for (final (:item, :count) in review.topActivities) item.name: count,
    },
    'topPlaces': tally(review.topPlaces),
    if (span == ReviewSpan.year) 'perMonth': review.perMonth,
    'highlight': review.highlight?.id,
  };
}

Map<String, Object?> _moodStats(List<Entry> entries, int mood) => {
      'type': 'mood',
      'counts': {
        for (final MapEntry(:key, :value) in moodTotals(entries).entries)
          '$key': value,
      },
      'overTime': _points(combinePerDay(moodPoints(entries), combineByAverage)),
      'byWeekday': _rounded(
          averageByDayOfWeek(entries, (entry) => entry.mood?.toDouble())),
      'associations': {
        'mood': mood,
        'factors': [
          for (final association
              in DiaryStatistics.moodAssociationsOf(entries, mood).take(10))
            {
              ...switch (association.factor) {
                final Tag tag => {'tag': tag.name},
                final EntryActivity activity => {'activity': activity.name},
                _ => const {},
              },
              'matching': association.matching,
              'total': association.total,
            },
        ],
      },
    };

Map<String, Object?> _trackerStats(List<Entry> entries, Tag tag) {
  final valueByEntryId =
      trackerValuesByEntry(entries, TagsProvider.instance.entryTags, tag.id!);
  final points = trackerPoints(entries, valueByEntryId);
  final values = [for (final point in points) point.value];
  return {
    'type': 'tracker',
    'tag': {'id': tag.id, 'name': tag.name},
    'count': values.length,
    if (values.isNotEmpty) ...{
      'min': values.reduce(math.min),
      'max': values.reduce(math.max),
      'mean': values.reduce((a, b) => a + b) / values.length,
    },
    'overTime': _points(combinePerDay(points, combineByAverage)),
    'byWeekday': _rounded(
        averageByDayOfWeek(entries, (entry) => valueByEntryId[entry.id])),
  };
}

Map<String, Object?> _labelStats(List<Entry> entries, Tag tag) {
  final presentIds = entryIdsWithTag(TagsProvider.instance.entryTags, tag.id!);
  final present =
      entries.where((entry) => presentIds.contains(entry.id)).length;
  return {
    'type': 'label',
    'tag': {'id': tag.id, 'name': tag.name},
    'present': present,
    'total': entries.length,
    'coverage': entries.isEmpty ? 0.0 : present / entries.length,
    'overTime':
        _points(combinePerDay(labelPoints(entries, presentIds), combineBySum)),
    'byWeekday':
        countByDayOfWeek(entries, (entry) => presentIds.contains(entry.id)),
  };
}

/// Each day of [year] that has entries, with the mood of the latest.
List<Map<String, Object?>> _yearInPixels(int year) {
  final provider = EntriesProvider.instance;
  return [
    for (var day = DateTime(year);
        day.year == year;
        day = DateTime(year, day.month, day.day + 1))
      if (provider.getEntriesForDate(day).firstOrNull case final latest?)
        {'day': DiaryDay.format(day), 'mood': latest.mood},
  ];
}

final List<AppAction> coachActions = [
  AppAction(
    id: 'coach.list',
    describe: 'Lists the coach programs: series of writing prompts, one a '
        'day or a week.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final l10n = await loadShownLocalizations();
      final running = CoachService.current(l10n)?.program.id;
      return {
        'programs': [
          for (final program in CoachProgram.all(l10n))
            {..._programJson(program), 'enrolled': program.id == running},
        ],
      };
    },
  ),
  AppAction(
    id: 'coach.status',
    describe: "Shows the running coach program, today's step and prompt, "
        'and whether the prompt was answered.',
    risk: ActionRisk.read,
    run: (context, args) async => _status(),
  ),
  AppAction(
    id: 'coach.enroll',
    describe: 'Starts a coach program today, in place of the running one. '
        'On Android it sets the notification for each new prompt.',
    risk: ActionRisk.write,
    params: const [
      ActionParam(
          'program', ParamType.string, 'The program id, see coach.list'),
    ],
    run: (context, args) async {
      final l10n = await loadShownLocalizations();
      final id = args['program'] as String;
      final program = CoachProgram.byId(l10n, id) ??
          (throw ActionException(
              'not_found',
              'There is no program $id; try ${[
                for (final program in CoachProgram.all(l10n)) program.id,
              ].join(', ')}'));
      if (CoachService.current(l10n)?.program.id == id) {
        throw ActionException('already_enrolled', '$id is running already');
      }
      await CoachService.enroll(l10n, program);
      return _status();
    },
  ),
  AppAction(
    id: 'coach.end',
    describe: 'Ends the running coach program; enrolling again starts it '
        'from the first prompt.',
    risk: ActionRisk.destructive,
    run: (context, args) async {
      if (CoachService.current(await loadShownLocalizations()) == null) {
        throw _notEnrolled();
      }
      await CoachService.end();
      return _status();
    },
  ),
  AppAction(
    id: 'coach.answer',
    describe: "Answers today's coach prompt: saves the answer as an entry "
        'headed with the prompt.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('text', ParamType.string, 'The answer'),
    ],
    run: (context, args) async {
      final enrollment = CoachService.current(await loadShownLocalizations());
      if (enrollment == null) throw _notEnrolled();
      final today = DiaryDay.today();
      if (enrollment.answeredOn(today)) {
        throw const ActionException(
            'already_answered', "Today's prompt is answered already");
      }
      final text = (args['text'] as String).trim();
      if (text.isEmpty) {
        throw const ActionException('bad_args', 'The answer is empty');
      }
      final entry = await CoachService.answer(
          enrollment.promptOn(today), text, enrollment.stepOn(today));
      return {'entry': entry.id, ...await _status()};
    },
  ),
  AppAction(
    id: 'stats.get',
    describe: 'Shows the numbers behind the statistics screen: streaks and '
        'counts, the chosen subject (mood, a label or a tracker) over the '
        'chosen range, the year in pixels, and the week and year in review.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('range', ParamType.string,
          'month, sixMonths, year or allTime; as on the screen by default',
          required: false),
      ActionParam(
          'subject',
          ParamType.string,
          'mood, or a label or tracker by name or id; as on the screen by '
              'default',
          required: false),
      ActionParam('mood', ParamType.integer,
          'The mood, -2 to 2, to list what goes with it; 2 by default',
          required: false),
      ActionParam('year', ParamType.integer,
          'The year of the year in pixels; this year by default',
          required: false),
    ],
    run: (context, args) async {
      await EntryStore.instance.complete;
      final config = ConfigProvider.instance;
      final entries = EntriesProvider.instance.entries;
      final ranges = StatsRange.values.asNameMap();
      final range = switch (args['range']) {
        final String name => ranges[name] ??
            (throw ActionException(
                'bad_args', 'range must be one of ${ranges.keys.join(', ')}')),
        _ => ranges[config.get(Settings.statsRange)] ?? StatsRange.allTime,
      };
      final subject = switch (args['subject']) {
        'mood' => const MoodSubject(),
        final String ref => switch (findTag(ref)) {
            final tag when tag.tagType == TagType.tracker =>
              TrackerSubject(tag),
            final tag => LabelSubject(tag),
          },
        _ => StatsSubject.fromConfigString(
            config.get(Settings.statsSubject), TagsProvider.instance.tags),
      };
      final mood = args['mood'] as int? ?? 2;
      if (mood < -2 || mood > 2) {
        throw const ActionException('bad_args', 'mood must be -2 to 2');
      }
      final ranged = entriesInRange(entries, range);
      final streaks = calculateStreaks(entries);
      final year = args['year'] as int? ?? DateTime.now().year;
      final firstWeekday = firstWeekdayShown();
      return {
        'range': range.name,
        'overview': {
          'entries': entries.length,
          'days': EntriesProvider.instance.getEntryDayCount(),
          'words': totalWordCount(entries),
          'streakCurrent': streaks.current,
          'streakLongest': streaks.longest,
          'daysSinceBadDay': streaks.daysSinceBadDay,
          'greatDays': greatDayCount(entries),
        },
        'subject': switch (subject) {
          MoodSubject() => _moodStats(ranged, mood),
          TrackerSubject(:final tag) => _trackerStats(ranged, tag),
          LabelSubject(:final tag) => _labelStats(ranged, tag),
        },
        'yearInPixels': {'year': year, 'days': _yearInPixels(year)},
        'weekReview': _reviewJson(
            DiaryStatistics.review(ReviewSpan.week, firstWeekday: firstWeekday),
            ReviewSpan.week),
        'yearReview': _reviewJson(
            DiaryStatistics.review(ReviewSpan.year, firstWeekday: firstWeekday),
            ReviewSpan.year),
      };
    },
  ),
];
