import 'package:daily_you/models/coach_program.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a daily program brings a prompt every day until it runs out', () {
    final schedule =
        CoachSchedule(start: DateTime(2026, 10, 20), days: 1, steps: 5);
    expect(schedule.stepOn(DateTime(2026, 10, 20, 23, 59)), 0);
    expect(schedule.stepOn(DateTime(2026, 10, 24)), 4);
    expect(schedule.newPromptOn(DateTime(2026, 10, 22, 8)), isTrue);
    expect(schedule.finishedOn(DateTime(2026, 10, 24)), isFalse);
    expect(schedule.finishedOn(DateTime(2026, 10, 25)), isTrue);
    expect(schedule.newPromptOn(DateTime(2026, 10, 25)), isFalse);
  });

  test('a weekly program brings its prompt on the start weekday', () {
    final schedule =
        CoachSchedule(start: DateTime(2026, 10, 20), days: 7, steps: 5);
    expect(schedule.stepOn(DateTime(2026, 10, 26)), 0);
    expect(schedule.stepOn(DateTime(2026, 10, 27)), 1);
    expect(schedule.newPromptOn(DateTime(2026, 10, 27)), isTrue);
    expect(schedule.newPromptOn(DateTime(2026, 10, 28)), isFalse);
    expect(schedule.finishedOn(DateTime(2026, 11, 24)), isTrue);
  });

  test('a daylight saving change does not shift the steps', () {
    // Europe and North America move their clocks around these dates.
    final schedule =
        CoachSchedule(start: DateTime(2026, 10, 24), days: 1, steps: 30);
    expect(schedule.stepOn(DateTime(2026, 10, 26)), 2);
    expect(schedule.stepOn(DateTime(2026, 11, 2)), 9);
  });
}
