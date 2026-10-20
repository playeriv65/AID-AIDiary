@Tags(['widget'])
library;

import 'package:aid_diary/widgets/month_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  test('gregorian months step across year ends', () {
    final date = DateTime(2026, 12, 15);
    final dec = CalendarMonth.around(date, 0, jalali: false);
    expect(dec.start, DateTime(2026, 12, 1));
    expect(dec.length, 31);
    final feb = CalendarMonth.around(date, 2, jalali: false);
    expect(feb.start, DateTime(2027, 2, 1));
    expect(feb.length, 28);
    expect(feb.label(27, jalali: false), 28);
  });

  test('jalali months start on their first day', () {
    final date = DateTime(2026, 10, 19);
    for (final offset in [-13, -1, 0, 1, 6]) {
      final month = CalendarMonth.around(date, offset, jalali: true);
      final first = Jalali.fromDateTime(month.start);
      expect(first.day, 1);
      expect(month.length, first.monthLength);
      expect(month.label(month.length - 1, jalali: true), month.length);
    }
  });

  testWidgets('tapping a day reports it; entries show a dot', (tester) async {
    final now = DateTime.now();
    await DiaryAppHarness.addEntry(tester, '今天', now);
    DiaryAppHarness.size(tester, const Size(390, 844));
    DateTime? tapped;
    await tester.pumpWidget(harness.app(
        Scaffold(body: MonthCalendar(onDayTap: (_, day) => tapped = day))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('calendar-today')), findsOneWidget);
    await tester.tap(find
        .byKey(ValueKey('calendar-day-${now.year}-${now.month}-${now.day}')));
    expect(tapped, DateTime(now.year, now.month, now.day));
    expect(tester.takeException(), isNull);
  });
}
