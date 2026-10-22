// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

Matcher refused(String code) =>
    throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  Future<Map<String, Object?>> run(String id,
      [Map<String, Object?> args = const {}, bool confirmed = false]) async {
    final result = await actions.run(id, args, confirmed: confirmed);
    // What the CLI prints must survive JSON.
    jsonEncode(result);
    return result as Map<String, Object?>;
  }

  group('coach', () {
    test('the programs are listed, none running at first', () async {
      final programs = (await run('coach.list'))['programs'] as List;
      expect([for (final program in programs) (program as Map)['id']],
          ['everyday', 'reflect']);
      expect(programs.every((program) => (program as Map)['enrolled'] == false),
          isTrue);
      expect(await run('coach.status'), {'enrolled': false});
    });

    test('a program is started, answered once a step, and ended', () async {
      final started = await run('coach.enroll', {'program': 'everyday'});
      expect(started['enrolled'], isTrue);
      expect((started['program'] as Map)['id'], 'everyday');
      expect(started['step'], 0);
      expect(started['start'], DiaryDay.format(DiaryDay.today()));
      expect(started['prompt'], isNotEmpty);
      expect(started['answered'], isFalse);
      expect(ConfigProvider.instance.get(Settings.coachProgram), 'everyday');
      expect(
          ((await run('coach.list'))['programs'] as List)
              .where((program) => (program as Map)['enrolled'] == true),
          hasLength(1));

      await expectLater(() => run('coach.enroll', {'program': 'everyday'}),
          refused('already_enrolled'));
      await expectLater(
          () => run('coach.answer', {'text': '  '}), refused('bad_args'));

      final answered = await run('coach.answer', {'text': 'A good start'});
      expect(answered['answered'], isTrue);
      final entry = EntryStore.instance.entries.single;
      expect(entry.id, answered['entry']);
      expect(entry.text, '## ${started['prompt']}\n\nA good start');
      await expectLater(() => run('coach.answer', {'text': 'Once more'}),
          refused('already_answered'));

      await expectLater(() => run('coach.end'), refused('needs_confirmation'));
      expect(await run('coach.end', {}, true), {'enrolled': false});
      expect(ConfigProvider.instance.get(Settings.coachProgram), '');
      await expectLater(
          () => run('coach.end', {}, true), refused('not_enrolled'));
      await expectLater(() => run('coach.answer', {'text': 'Nobody asks'}),
          refused('not_enrolled'));
    });

    test('another program replaces the running one', () async {
      await run('coach.enroll', {'program': 'everyday'});
      final reflect = await run('coach.enroll', {'program': 'reflect'});
      expect((reflect['program'] as Map)['id'], 'reflect');
      expect(reflect['stepLabel'], isNotEmpty);
      await expectLater(() => run('coach.enroll', {'program': 'nothing'}),
          refused('not_found'));
    });
  });

  group('stats', () {
    Future<void> write(int daysAgo, String text, {int? mood}) async {
      final today = DiaryDay.today();
      final written =
          DateTime(today.year, today.month, today.day - daysAgo, 12);
      await EntryStore.instance.add(Entry(
          text: text, mood: mood, timeCreate: written, timeModified: written));
    }

    test('an empty diary has zeros, not errors', () async {
      final stats = await run('stats.get');
      expect((stats['overview'] as Map)['entries'], 0);
      expect((stats['overview'] as Map)['streakCurrent'], 0);
      expect(stats['subject'], containsPair('type', 'mood'));
      expect((stats['yearInPixels'] as Map)['days'], isEmpty);
      expect((stats['weekReview'] as Map)['entries'], 0);
    });

    test('the mood subject counts moods, days and weekdays', () async {
      await write(0, 'One two three', mood: 2);
      await write(1, 'Four five', mood: 2);
      await write(1, 'Six', mood: -1);
      await write(3, 'Seven eight nine ten', mood: 0);
      await write(400, 'Long ago', mood: 1);

      final stats = await run('stats.get');
      final overview = stats['overview'] as Map;
      expect(overview['entries'], 5);
      expect(overview['days'], 4);
      expect(overview['words'], 12);
      expect(overview['streakCurrent'], 2);
      expect(overview['streakLongest'], 2);
      expect(overview['greatDays'], 3);
      expect(stats['range'], 'allTime');

      final mood = stats['subject'] as Map;
      expect(mood['type'], 'mood');
      expect(mood['counts'], {'-2': 0, '-1': 1, '0': 1, '1': 1, '2': 2});
      expect((mood['overTime'] as Map), hasLength(4));
      expect((mood['byWeekday'] as Map).keys,
          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);

      final month = await run('stats.get', {'range': 'month'});
      expect(((month['subject'] as Map)['overTime'] as Map), hasLength(3));
      // The overview is the whole diary whichever range is shown.
      expect((month['overview'] as Map)['entries'], 5);
      await expectLater(
          () => run('stats.get', {'range': 'decade'}), refused('bad_args'));
      await expectLater(
          () => run('stats.get', {'mood': '3'}), refused('bad_args'));
    });

    test('a tracker subject sums up its values', () async {
      await run('tag.create', {'name': 'Sleep', 'type': 'tracker'});
      await write(0, 'Rested');
      await write(1, 'Tired');
      await write(2, 'No number');
      final ids = [
        for (final entry in EntryStore.instance.entries) entry.id,
      ];
      await run('entry.tag', {'id': '${ids[0]}', 'tag': 'Sleep', 'value': '8'});
      await run('entry.tag', {'id': '${ids[1]}', 'tag': 'Sleep', 'value': '4'});

      final stats = await run('stats.get', {'subject': 'Sleep'});
      final subject = stats['subject'] as Map;
      expect(subject['type'], 'tracker');
      expect(subject['count'], 2);
      expect(subject['min'], 4);
      expect(subject['max'], 8);
      expect(subject['mean'], 6);
      expect(subject['overTime'] as Map, hasLength(2));
    });

    test('a label subject says how many entries have it', () async {
      await run('tag.create', {'name': 'Walked'});
      await write(0, 'Out', mood: 2);
      await write(1, 'In', mood: 0);
      await write(2, 'Out again', mood: 2);
      final entries = EntryStore.instance.entries;
      for (final entry in entries.where((e) => e.text.startsWith('Out'))) {
        await run('entry.tag', {'id': '${entry.id}', 'tag': 'Walked'});
      }

      final label =
          (await run('stats.get', {'subject': 'walked'}))['subject'] as Map;
      expect(label['type'], 'label');
      expect(label['present'], 2);
      expect(label['total'], 3);
      expect(label['coverage'], closeTo(2 / 3, 1e-9));

      // The tag shows up beside the mood it came with.
      final mood =
          (await run('stats.get', {'subject': 'mood', 'mood': '2'}))['subject']
              as Map;
      final factors = (mood['associations'] as Map)['factors'] as List;
      expect(factors.first, {'tag': 'Walked', 'matching': 2, 'total': 2});

      await expectLater(
          () => run('stats.get', {'subject': 'Missing'}), refused('not_found'));
    });

    test('the year in pixels and the reviews cover this week and year',
        () async {
      await write(0, 'Today', mood: 1);
      final stats = await run('stats.get');
      final days = (stats['yearInPixels'] as Map)['days'] as List;
      expect(
          days.single, {'day': DiaryDay.format(DiaryDay.today()), 'mood': 1});
      final week = stats['weekReview'] as Map;
      expect(week['entries'], 1);
      expect(week['daysInPeriod'], 7);
      expect(week['averageMood'], 1);
      final year = stats['yearReview'] as Map;
      expect(year['entries'], 1);
      expect(year['perMonth'] as List, hasLength(12));
      expect(year['highlight'], EntryStore.instance.entries.single.id);

      final other = await run('stats.get', {'year': '2001'});
      expect((other['yearInPixels'] as Map)['days'], isEmpty);
    });
  });
}
