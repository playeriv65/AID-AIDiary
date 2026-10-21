// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Keeps every day-based rule on DiaryDay: an entry's calendar date is not
// its diary day once days start after midnight, so taking a date, weekday
// or "same day" straight from a timeCreate quietly breaks streaks, reviews
// and statistics. Use entry.day or DiaryDay instead.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Day math on a creation time: its date parts, a day comparison, or a
/// date (not time) formatted from it.
final _rawDayMath = RegExp(
  r'timeCreate\.(year|month|day|weekday)\b'
  r'|(isToday|isSameDay|isSameCalendarDayOfYear|calendarYearOf|isOnThisDayMatch'
  r'|datesExactCalendarMonthDiff|startOfDay|jalaliDayNumber|formatDate'
  r'|formatDateWithWeekday|formatMonthDay|formatYear|formatMonthYear)'
  r'\(\s*[\w.!]*timeCreate\b'
  r'''|DateFormat(\.(yMMMEd|yMMMd|yMd|MMMd|MEd|EEEE|E)\([^)]*\)|\(['"]yyyy-MM-dd['"][^)]*\))'''
  r'\.format\(\s*[\w.!]*timeCreate\b',
);

/// Where a creation time's own date is right, and why.
const _allowed = {
  // The diary day itself is defined from the time as written.
  'lib/models/entry.dart',
  'lib/utils/diary_day.dart',
  // Other apps' formats store the moment as written.
  'lib/utils/imports/',
  'lib/utils/formats/',
  // An attachment file's own timestamp, not an entry's day.
  'lib/pages/image_view_page.dart',
};

void main() {
  test('day-based logic goes through the diary day', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final path = file.path.replaceAll(r'\', '/');
      if (path.contains('/generated/')) continue;
      if (_allowed.any(path.startsWith)) continue;
      final lines = file.readAsLinesSync();
      for (final (index, line) in lines.indexed) {
        if (_rawDayMath.hasMatch(line)) {
          offenders.add('$path:${index + 1}: ${line.trim()}');
        }
      }
    }
    expect(offenders, isEmpty,
        reason: 'Use entry.day or DiaryDay for dates of entries.');
  });

  test('the rule catches the usual ways around it', () {
    for (final line in [
      'final d = entry.timeCreate.day;',
      'TimeManager.isSameDay(entry.timeCreate, today)',
      'TimeManager.formatDate(e.timeCreate, context)',
      "DateFormat('yyyy-MM-dd').format(latest.timeCreate)",
      'DateFormat.yMMMEd(locale).format(entry.timeCreate)',
    ]) {
      expect(_rawDayMath.hasMatch(line), isTrue, reason: line);
    }
    for (final line in [
      'TimeManager.formatDate(entry.day, context)',
      'TimeManager.localizedTimeFormat(context, locale).format(entry.timeCreate)',
      'timeCreate: entry.timeCreate,',
    ]) {
      expect(_rawDayMath.hasMatch(line), isFalse, reason: line);
    }
  });
}
