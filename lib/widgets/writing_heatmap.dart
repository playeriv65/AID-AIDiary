// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/time_manager.dart';
import 'package:material_ui/material_ui.dart';

/// Weeks-by-weekday grid of recent writing, as many weeks as fit the width.
class WritingHeatmap extends StatelessWidget {
  const WritingHeatmap(
      {super.key, required this.entries, this.onDayTap, this.now});

  final List<Entry> entries;
  final ValueChanged<DateTime>? onDayTap;
  final DateTime? now;

  static const double _cell = 14;
  static const double _gap = 3;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final counts = <DateTime, int>{};
    for (final e in entries) {
      final day = _day(e.timeCreate);
      counts[day] = (counts[day] ?? 0) + 1;
    }
    final today = _day(now ?? DateTime.now());
    // Align columns to the locale's first weekday (Sunday = 0).
    final firstWeekday = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final offset = (today.weekday % 7 - firstWeekday) % 7;
    final currentWeekStart = today.subtract(Duration(days: offset));

    Color colorFor(int count) => switch (count) {
          0 => cs.surfaceContainerHighest,
          1 => cs.primary.withValues(alpha: .4),
          2 => cs.primary.withValues(alpha: .7),
          _ => cs.primary,
        };

    Widget cell(Color color, {Widget? child}) => Container(
        width: _cell,
        height: _cell,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        child: child);

    return LayoutBuilder(builder: (context, constraints) {
      final weeks =
          ((constraints.maxWidth + _gap) / (_cell + _gap)).floor().clamp(4, 53);
      final start = currentWeekStart.subtract(Duration(days: 7 * (weeks - 1)));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var w = 0; w < weeks; w++)
                Column(children: [
                  for (var d = 0; d < 7; d++)
                    Builder(builder: (context) {
                      final day = DateTime(
                          start.year, start.month, start.day + w * 7 + d);
                      final future = day.isAfter(today);
                      final count = counts[day] ?? 0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: d < 6 ? _gap : 0),
                        child: future
                            ? const SizedBox(width: _cell, height: _cell)
                            : Tooltip(
                                message:
                                    '${TimeManager.formatDateWithWeekday(day, context)} · ${l10n.todayEntryCount(count)}',
                                child: GestureDetector(
                                  onTap: onDayTap == null
                                      ? null
                                      : () => onDayTap!(day),
                                  child: cell(colorFor(count),
                                      child: day == today
                                          ? DecoratedBox(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: cs.onSurface,
                                                      width: 1.2),
                                                  borderRadius:
                                                      BorderRadius.circular(3)))
                                          : null),
                                ),
                              ),
                      );
                    }),
                ]),
            ],
          ),
          const SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.todayActivityLess,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(width: 4),
            for (final c in [0, 1, 2, 3]) ...[
              cell(colorFor(c)),
              const SizedBox(width: 2),
            ],
            const SizedBox(width: 2),
            Text(l10n.todayActivityMore,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ]),
        ],
      );
    });
  }
}
