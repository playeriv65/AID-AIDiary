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

  group('late-night entries', () {
    tearDown(() => Entry.dayStartHour = 0);
    Entry at(DateTime time) =>
        Entry(text: '', timeCreate: time, timeModified: time);

    test('count for the day before when the setting is on', () {
      final late = at(DateTime(2026, 10, 21, 1, 30));
      final morning = at(DateTime(2026, 10, 21, 4));
      expect(late.day, DateTime(2026, 10, 21));
      expect(late.isLateNight, isFalse);

      Entry.dayStartHour = 4;
      expect(late.day, DateTime(2026, 10, 20));
      expect(late.isLateNight, isTrue);
      expect(late.timeCreate, DateTime(2026, 10, 21, 1, 30));
      expect(morning.day, DateTime(2026, 10, 21));
      expect(at(DateTime(2026, 11, 1, 2)).day, DateTime(2026, 10, 31));
      expect(Entry.diaryDayOf(DateTime(2026, 1, 1, 3)), DateTime(2025, 12, 31));
    });
  });
}
