// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => DiaryDay.startHour = 4);
  tearDown(() => DiaryDay.startHour = 0);

  test('the small hours belong to the day before', () {
    expect(DiaryDay.of(DateTime(2026, 10, 21, 3, 59)), DateTime(2026, 10, 20));
    expect(DiaryDay.of(DateTime(2026, 10, 21, 4)), DateTime(2026, 10, 21));
    expect(DiaryDay.of(DateTime(2026, 3, 1, 1)), DateTime(2026, 2, 28));
    expect(DiaryDay.same(DateTime(2026, 10, 20, 22), DateTime(2026, 10, 21, 2)),
        isTrue);
    DiaryDay.startHour = 0;
    expect(DiaryDay.of(DateTime(2026, 10, 21, 1)), DateTime(2026, 10, 21));
  });

  test('a time on a diary day lands on the right calendar day', () {
    final day = DateTime(2026, 10, 20);
    // Changing an evening entry to 1:00 keeps it on the same night.
    expect(DiaryDay.at(day, 1, 0), DateTime(2026, 10, 21, 1));
    expect(DiaryDay.at(day, 23, 30), DateTime(2026, 10, 20, 23, 30));
    for (final time in [DiaryDay.at(day, 1, 0), DiaryDay.at(day, 23, 30)]) {
      expect(DiaryDay.of(time), day);
    }
  });

  test('an entry written now for a past day keeps that day', () {
    final now = DateTime.now();
    final past = DateTime(now.year, now.month, now.day - 3);
    final written = DiaryDay.nowOn(past);
    expect(DiaryDay.of(written), past);
    expect(written.hour, now.hour);
    final today = DiaryDay.nowOn(DiaryDay.today());
    expect(today.difference(DateTime.now()).inSeconds.abs(), lessThan(5));
  });
}
