import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an entry is sealed only until its opening day', () {
    final now = DateTime.now();
    Entry entry(DateTime? openAt) =>
        Entry(text: '', timeCreate: now, timeModified: now, openAt: openAt);
    expect(entry(null).isSealed, isFalse);
    expect(entry(now.add(const Duration(days: 1))).isSealed, isTrue);
    expect(entry(now.subtract(const Duration(days: 1))).isSealed, isFalse);
    expect(entry(now).copy(openAt: null).openAt, isNull);
  });

  test('an entry from another time zone says which, and keeps its moment', () {
    final written = DateTime(2025, 6, 7, 23, 30);
    final here = written.timeZoneOffset.inMinutes;
    Entry at(int? offset) => Entry(
        text: '',
        timeCreate: written,
        timeModified: written,
        utcOffset: offset);
    expect(at(null).otherZoneLabel, isNull);
    expect(at(here).otherZoneLabel, isNull);
    final away = here == 8 * 60 ? -5 * 60 : 8 * 60;
    expect(at(away).otherZoneLabel, away > 0 ? 'UTC+8' : 'UTC−5');
    expect(at(330).createdInstant, DateTime.utc(2025, 6, 7, 18));
    expect(
        Entry.wallClockAt(
            DateTime.utc(2025, 6, 7, 18), const Duration(minutes: 330)),
        written);
  });

  group('diary day', () {
    tearDown(() => DiaryDay.startHour = 0);
    Entry at(DateTime time, {DateTime? day}) =>
        Entry(text: '', timeCreate: time, timeModified: time, day: day);

    test('a new entry takes the default and keeps it', () {
      DiaryDay.startHour = 4;
      final late = at(DateTime(2026, 10, 21, 1, 30));
      expect(late.day, DateTime(2026, 10, 20));
      expect(late.isLateNight, isTrue);
      expect(late.timeCreate, DateTime(2026, 10, 21, 1, 30));
      // Changing the hours later moves no entry.
      DiaryDay.startHour = 0;
      expect(late.day, DateTime(2026, 10, 20));
      expect(at(DateTime(2026, 10, 21, 1, 30)).day, DateTime(2026, 10, 21));
    });

    test('the day and the written time change apart', () {
      final entry = at(DateTime(2026, 10, 21, 9));
      final moved = entry.copy(day: DateTime(2026, 10, 18));
      expect(moved.day, DateTime(2026, 10, 18));
      expect(moved.timeCreate, entry.timeCreate);
      expect(moved.isForAnotherDay, isTrue);
      final retimed = moved.copy(timeCreate: DateTime(2026, 10, 22, 8));
      expect(retimed.day, DateTime(2026, 10, 18));
      // Other journals get the day at the written time of day.
      expect(moved.journalTime, DateTime(2026, 10, 18, 9));
      expect(entry.journalTime, entry.timeCreate);
    });

    test('the day survives the database row', () {
      final entry = at(DateTime(2026, 10, 21, 9), day: DateTime(2026, 10, 18));
      final back = Entry.fromJson(entry.toJson());
      expect(back.day, DateTime(2026, 10, 18));
      expect(back.timeCreate, entry.timeCreate);
    });
  });
}
