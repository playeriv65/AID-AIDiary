import 'package:aid_diary/utils/local_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('matches DateTime.parse for stored local times', () {
    var time = DateTime(2015, 1, 1, 0, 0, 0, 123, 456);
    for (var i = 0; i < 2000; i++) {
      final text = time.toIso8601String();
      final parsed = parseLocalTime(text);
      expect(parsed, DateTime.parse(text), reason: text);
      expect(parsed.isUtc, isFalse);
      time = time.add(const Duration(hours: 61, minutes: 7));
    }
  });

  test('zoned and date-only texts parse as DateTime.parse does', () {
    for (final text in [
      '2026-03-08T02:30:00Z',
      '2026-03-08T02:30:00+08:00',
      '2026-03-08T02:30:00-05:00',
      '2026-03-08',
      '2026-03-08 21:04:05',
    ]) {
      expect(parseLocalTime(text), DateTime.parse(text), reason: text);
      expect(parseLocalTime(text).isUtc, DateTime.parse(text).isUtc);
    }
  });
}
