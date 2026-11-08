// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/time_manager.dart';
import 'package:flutter/material.dart' as sdk_material
    show Material, MaterialType;
import 'package:material_ui/material_ui.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

/// [DayPicker] in a dialog under [title], with Cancel and OK. The picked
/// day, or null when cancelled.
Future<DateTime?> showDayPicker(
  BuildContext context, {
  required String title,
  required DateTime initialDay,
  required DateTime firstDay,
  required DateTime lastDay,
  String? note,
}) =>
    showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        return AlertDialog(
          title: Text(title),
          titleTextStyle: Theme.of(dialogContext).textTheme.titleMedium,
          contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          scrollable: true,
          content: SizedBox(
            width: DayPicker.width,
            child: DayPicker(
              initialDay: initialDay,
              firstDay: firstDay,
              lastDay: lastDay,
              note: note,
              confirm: MaterialLocalizations.of(dialogContext).okButtonLabel,
              onPicked: (day) => navigator.pop(day),
              onCancel: () => navigator.pop(),
            ),
          ),
        );
      },
    );

/// Picks one day between [firstDay] and [lastDay] on a month grid, in the
/// calendar dates are read in (Gregorian or Jalali, see
/// [TimeManager.isJalaliCalendar]), the same way everywhere: in a dialog
/// through [showDayPicker], or on a page of its own. [note] is a line of
/// small print under the grid; [confirm] takes the day to [onPicked], and
/// a Cancel button calls [onCancel] when given.
class DayPicker extends StatefulWidget {
  const DayPicker({
    super.key,
    required this.initialDay,
    required this.firstDay,
    required this.lastDay,
    required this.confirm,
    required this.onPicked,
    this.onCancel,
    this.note,
  });

  /// The month grid's own width.
  static const double width = 328;

  final DateTime initialDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final String confirm;
  final ValueChanged<DateTime> onPicked;
  final VoidCallback? onCancel;
  final String? note;

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  late DateTime _day = widget.initialDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendar = TimeManager.isJalaliCalendar(context)
        // Built on the SDK's Material, which it needs above it.
        ? sdk_material.Material(
            type: sdk_material.MaterialType.transparency,
            child: PersianCalendarDatePicker(
              initialDate: Jalali.fromDateTime(_day),
              firstDate: Jalali.fromDateTime(widget.firstDay),
              lastDate: Jalali.fromDateTime(widget.lastDay),
              onDateChanged: (day) => setState(() => _day = day.toDateTime()),
            ),
          )
        : CalendarDatePicker(
            initialDate: _day,
            firstDate: widget.firstDay,
            lastDate: widget.lastDay,
            onDateChanged: (day) => setState(() => _day = day),
          );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The month grid's own height: header and six weeks.
        SizedBox(height: 346, child: calendar),
        if (widget.note case final note?)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              note,
              key: const ValueKey('day-picker-note'),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              if (widget.onCancel case final cancel?)
                TextButton(
                    onPressed: cancel,
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel)),
              FilledButton(
                key: const ValueKey('day-picker-confirm'),
                onPressed: () => widget.onPicked(_day),
                child: Text(widget.confirm),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
