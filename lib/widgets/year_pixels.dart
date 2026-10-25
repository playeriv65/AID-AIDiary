// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:material_ui/material_ui.dart';

/// Year in Pixels on the statistics page, with arrows between years.
class YearPixelsCard extends StatefulWidget {
  const YearPixelsCard({super.key});

  @override
  State<YearPixelsCard> createState() => _YearPixelsCardState();
}

class _YearPixelsCardState extends State<YearPixelsCard> {
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thisYear = DateTime.now().year;
    return Card.filled(
      key: const ValueKey('year-pixels'),
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Column(children: [
          Row(children: [
            IconButton(
              key: const ValueKey('year-pixels-previous'),
              onPressed: () => setState(() => _year--),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                  '${AppLocalizations.of(context)!.yearInPixels} $_year',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              key: const ValueKey('year-pixels-next'),
              onPressed:
                  _year < thisYear ? () => setState(() => _year++) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ]),
          YearInPixels(year: _year),
        ]),
      ),
    );
  }
}

/// A year as a 12 × 31 grid, one square per day tinted by that day's
/// latest mood. Tapping a day with an entry opens it.
class YearInPixels extends StatelessWidget {
  const YearInPixels({super.key, required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: cs.onSurfaceVariant, fontSize: 9);
    final provider = EntriesProvider.instance;
    final today = DateTime.now();
    return LayoutBuilder(builder: (context, constraints) {
      const dayLabelWidth = 16.0;
      const gap = 2.0;
      final cell =
          ((constraints.maxWidth - dayLabelWidth) / 12 - gap).clamp(4.0, 22.0);
      Widget square(int month, int day) {
        final date = DateTime(year, month, day);
        // Day 31 of a 30-day month rolls over; leave that square out.
        if (date.month != month) return SizedBox(width: cell, height: cell);
        final latest = provider.getEntriesForDate(date).firstOrNull;
        final color = latest != null
            ? moodColor(latest.mood, cs)
            : date.isAfter(today)
                ? cs.surfaceContainer
                : cs.surfaceContainerHighest;
        final shape = BorderRadius.circular(cell / 5);
        return Ink(
          width: cell,
          height: cell,
          decoration: BoxDecoration(color: color, borderRadius: shape),
          child: InkWell(
            key: ValueKey('pixel-$month-$day'),
            borderRadius: shape,
            onTap: latest == null
                ? null
                : () => EntryNavigation.view(context, latest),
          ),
        );
      }

      return Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          const SizedBox(width: dayLabelWidth),
          for (var month = 1; month <= 12; month++)
            SizedBox(
              width: cell + gap,
              // Month numbers read the same in every locale.
              child: Text('$month',
                  textAlign: TextAlign.center, style: labelStyle),
            ),
        ]),
        const SizedBox(height: 2),
        for (var day = 1; day <= 31; day++)
          Padding(
            padding: const EdgeInsets.only(bottom: gap),
            child: Row(children: [
              SizedBox(
                width: dayLabelWidth,
                child: Text(day == 1 || day % 5 == 0 ? '$day' : '',
                    style: labelStyle),
              ),
              for (var month = 1; month <= 12; month++)
                Padding(
                  padding: const EdgeInsets.only(right: gap),
                  child: square(month, day),
                ),
            ]),
          ),
      ]);
    });
  }
}
