import 'package:aid_diary/time_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weeks start on the chosen weekday', () {
    final wednesday = DateTime(2026, 10, 21, 15);
    expect(TimeManager.startOfWeek(wednesday, DateTime.monday),
        DateTime(2026, 10, 19));
    expect(TimeManager.startOfWeek(wednesday, DateTime.sunday),
        DateTime(2026, 10, 18));
    expect(TimeManager.startOfWeek(DateTime(2026, 10, 19), DateTime.monday),
        DateTime(2026, 10, 19));
  });
}
