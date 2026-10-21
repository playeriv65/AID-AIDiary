// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    DiaryDay.startHour = 4;
    DiaryDay.askUntilHour = 6;
  });
  tearDown(() {
    DiaryDay.startHour = 0;
    DiaryDay.askUntilHour = 0;
  });

  test('before 4 counts for yesterday, 4 to 6 asks, then today', () {
    expect(DiaryDay.defaultFor(DateTime(2026, 10, 21, 3, 59)),
        DateTime(2026, 10, 20));
    expect(DiaryDay.defaultFor(DateTime(2026, 3, 1, 1)), DateTime(2026, 2, 28));
    for (final hour in [4, 5]) {
      final time = DateTime(2026, 10, 21, hour, 30);
      expect(DiaryDay.asks(time), isTrue);
      // Until answered it counts for the day it is written on.
      expect(DiaryDay.defaultFor(time), DateTime(2026, 10, 21));
    }
    expect(DiaryDay.asks(DateTime(2026, 10, 21, 3)), isFalse);
    expect(DiaryDay.asks(DateTime(2026, 10, 21, 6)), isFalse);
    expect(
        DiaryDay.defaultFor(DateTime(2026, 10, 21, 6)), DateTime(2026, 10, 21));
  });

  test('stored days read back and malformed ones are none', () {
    final day = DateTime(2026, 1, 9);
    expect(DiaryDay.format(day), '2026-01-09');
    expect(DiaryDay.parse('2026-01-09'), day);
    expect(DiaryDay.parse(null), isNull);
    expect(DiaryDay.parse('2026-1'), isNull);
    expect(DiaryDay.parse('x-y-z'), isNull);
  });

  test('a new entry for today takes the default, another day is kept', () {
    expect(DiaryDay.forNewEntry(DiaryDay.today()), isNull);
    final past = DateTime(2025, 5, 4);
    expect(DiaryDay.forNewEntry(DateTime(2025, 5, 4, 13)), past);
  });
}
