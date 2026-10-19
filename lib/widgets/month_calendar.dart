// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// One calendar month in the active calendar system.
class CalendarMonth {
  const CalendarMonth(this.start, this.length);

  /// First day of the month as a local date.
  final DateTime start;
  final int length;

  DateTime day(int index) =>
      DateTime(start.year, start.month, start.day + index);

  /// The month [offset] months after the one containing [date].
  static CalendarMonth around(DateTime date, int offset,
      {required bool jalali}) {
    if (jalali) {
      final j = Jalali.fromDateTime(date);
      final total = j.year * 12 + (j.month - 1) + offset;
      final month = Jalali(total ~/ 12, total % 12 + 1, 1);
      return CalendarMonth(month.toDateTime(), month.monthLength);
    }
    final start = DateTime(date.year, date.month + offset, 1);
    return CalendarMonth(start, DateTime(start.year, start.month + 1, 0).day);
  }

  /// Day number shown in the grid for [index].
  int label(int index, {required bool jalali}) =>
      jalali ? Jalali.fromDateTime(day(index)).day : index + 1;
}

/// Months scrolling vertically with a dot under days that have entries.
/// The current month opens at the top; earlier months scroll up.
class MonthCalendar extends StatefulWidget {
  const MonthCalendar({
    super.key,
    required this.onDayTap,
    this.selectedDate,
    this.todayButtonBottom = 16,
    this.monthsAhead = 12,
  });

  final void Function(BuildContext dayContext, DateTime day) onDayTap;
  final DateTime? selectedDate;

  /// Keeps the jump-to-today button clear of other floating buttons.
  final double todayButtonBottom;
  final int monthsAhead;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  final _controller = ScrollController();
  final _centerKey = UniqueKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _monthsBack(DateTime now, bool jalali) {
    final entries = EntriesProvider.instance.entries;
    if (entries.isEmpty) return 12;
    final oldest = entries.last.timeCreate;
    int index(DateTime d) {
      if (jalali) {
        final j = Jalali.fromDateTime(d);
        return j.year * 12 + j.month;
      }
      return d.year * 12 + d.month;
    }

    return (index(now) - index(oldest)).clamp(12, 1200);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<EntriesProvider>();
    final jalali = TimeManager.isJalaliCalendar(context);
    final firstDay =
        context.watch<ConfigProvider>().getFirstDayOfWeekIndex(context);
    final labels = TimeManager.daysOfWeekLabels(context);
    final weekdays = [
      ...labels.sublist(firstDay),
      ...labels.sublist(0, firstDay)
    ];
    final now = DateTime.now();
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    Widget month(int offset) => _MonthGrid(
          key: ValueKey('calendar-month-$offset'),
          month: CalendarMonth.around(now, offset, jalali: jalali),
          jalali: jalali,
          firstDayIndex: firstDay,
          selectedDate: widget.selectedDate,
          onDayTap: widget.onDayTap,
        );

    return Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            for (final label in weekdays)
              Expanded(
                child: Center(
                  child: Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: CustomScrollView(
            key: const ValueKey('month-calendar'),
            controller: _controller,
            center: _centerKey,
            slivers: [
              SliverList.builder(
                itemCount: _monthsBack(now, jalali),
                itemBuilder: (context, i) => month(-(i + 1)),
              ),
              SliverList.builder(
                key: _centerKey,
                itemCount: widget.monthsAhead + 1,
                itemBuilder: (context, i) => month(i),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 96)),
            ],
          ),
        ),
      ]),
      PositionedDirectional(
        end: 16,
        bottom: widget.todayButtonBottom,
        child: FloatingActionButton.small(
          key: const ValueKey('calendar-today'),
          heroTag: 'calendar-today',
          tooltip: l10n.calendarJumpToToday,
          onPressed: () => _controller.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut),
          child: const Icon(Icons.today_rounded),
        ),
      ),
    ]);
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    super.key,
    required this.month,
    required this.jalali,
    required this.firstDayIndex,
    required this.selectedDate,
    required this.onDayTap,
  });

  final CalendarMonth month;
  final bool jalali;
  final int firstDayIndex;
  final DateTime? selectedDate;
  final void Function(BuildContext, DateTime) onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final entries = EntriesProvider.instance;
    final today = DateTime.now();
    // Monday is index 0 in firstDayIndex; DateTime.weekday is 1 for Monday.
    final leading = (month.start.weekday - 1 - firstDayIndex + 7) % 7;
    final cells = leading + month.length;
    final rows = (cells / 7).ceil();

    Widget cell(int index) {
      if (index < leading || index >= cells) return const SizedBox.shrink();
      final dayIndex = index - leading;
      final day = month.day(dayIndex);
      final hasEntries = entries.getEntriesForDate(day).isNotEmpty;
      final isToday = TimeManager.isSameDay(day, today);
      final selected =
          selectedDate != null && TimeManager.isSameDay(day, selectedDate!);
      final future = day.isAfter(today) && !isToday;
      final color = selected
          ? cs.onPrimary
          : isToday
              ? cs.primary
              : future
                  ? cs.outline
                  : cs.onSurface;
      return Builder(
        builder: (dayContext) => InkResponse(
          key: ValueKey('calendar-day-${day.year}-${day.month}-${day.day}'),
          radius: 22,
          onTap: future && !hasEntries ? null : () => onDayTap(dayContext, day),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? cs.primary : null,
                border: isToday && !selected
                    ? Border.all(color: cs.primary, width: 1.5)
                    : null,
              ),
              child: Text('${month.label(dayIndex, jalali: jalali)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: isToday || selected
                          ? FontWeight.w700
                          : FontWeight.w400)),
            ),
            const SizedBox(height: 2),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasEntries ? cs.primary : Colors.transparent),
            ),
          ]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(TimeManager.formatMonthYear(month.start, context),
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ),
        for (var row = 0; row < rows; row++)
          SizedBox(
            height: 48,
            child: Row(children: [
              for (var col = 0; col < 7; col++)
                Expanded(child: cell(row * 7 + col)),
            ]),
          ),
      ]),
    );
  }
}
