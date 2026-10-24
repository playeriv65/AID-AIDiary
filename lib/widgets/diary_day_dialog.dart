// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:flutter/material.dart' as sdk_material
    show Material, MaterialType;
import 'package:material_ui/material_ui.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

/// Picks the day an entry belongs to, with when it was written always shown
/// beneath, since that stays whatever day is picked. Null when cancelled.
Future<DateTime?> showDiaryDayDialog(
  BuildContext context, {
  required DateTime initialDay,
  required DateTime firstDay,
  required DateTime lastDay,
  required String created,
}) =>
    showDialog<DateTime>(
      context: context,
      builder: (_) => _DiaryDayDialog(
          initialDay: initialDay,
          firstDay: firstDay,
          lastDay: lastDay,
          created: created),
    );

class _DiaryDayDialog extends StatefulWidget {
  const _DiaryDayDialog({
    required this.initialDay,
    required this.firstDay,
    required this.lastDay,
    required this.created,
  });

  final DateTime initialDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final String created;

  @override
  State<_DiaryDayDialog> createState() => _DiaryDayDialogState();
}

class _DiaryDayDialogState extends State<_DiaryDayDialog> {
  late DateTime _day = widget.initialDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
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
    return AlertDialog(
      title: Text(l10n.editorDiaryDayPicker),
      titleTextStyle: theme.textTheme.titleMedium,
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      content: SizedBox(
        width: 328,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The month grid's own height: header and six weeks.
              SizedBox(height: 346, child: calendar),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.editorCreatedAt(widget.created),
                  key: const ValueKey('diary-day-created'),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(material.cancelButtonLabel)),
        TextButton(
            onPressed: () => Navigator.of(context).pop(_day),
            child: Text(material.okButtonLabel)),
      ],
    );
  }
}
