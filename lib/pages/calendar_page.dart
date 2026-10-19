// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/journal_entry_row.dart';
import 'package:daily_you/widgets/list_detail_layout.dart';
import 'package:daily_you/widgets/top_search_card.dart';
import 'package:daily_you/widgets/month_calendar.dart';
import 'package:daily_you/pages/entry_timeline_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Scrolling months; wide windows show the selected day beside them.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  final _calendarKey = GlobalKey();
  DateTime _selectedDate = DateTime.now();
  int? _selectedEntryId;

  @override
  bool get wantKeepAlive => true;

  /// Phones open the day directly: its entry, its list, or a new entry.
  void _openDay(BuildContext context, DateTime day) {
    final entries = EntriesProvider.instance.getEntriesForDate(day);
    if (entries.length == 1) {
      EntryNavigation.view(context, entries.single);
    } else if (entries.length > 1) {
      EntryTimelinePage.pushForDay(context, day);
    } else if (!day.isAfter(DateTime.now())) {
      EntryNavigation.addForDay(context, day);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.watch<EntriesProvider>();
    return ListDetailLayout(
      detail: _dayPane(context),
      listBuilder: (context, split) => Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TopSearchCard(),
        ),
        Expanded(
          child: MonthCalendar(
            key: _calendarKey,
            selectedDate: split ? _selectedDate : null,
            // Phones keep the new-entry button in the corner below.
            todayButtonBottom: split ? 16 : 88,
            onDayTap: split
                ? (_, date) => setState(() {
                      _selectedDate = date;
                      _selectedEntryId = null;
                    })
                : _openDay,
          ),
        ),
      ]),
    );
  }

  Widget _dayPane(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries =
        EntriesProvider.instance.getEntriesForDate(_selectedDate).toList();
    final selected = entries.where((e) => e.id == _selectedEntryId).firstOrNull;
    if (selected != null) {
      return Column(key: const ValueKey('diary-day-pane'), children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => _selectedEntryId = null),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(TimeManager.formatDate(_selectedDate, context)),
          ),
        ),
        Expanded(
          child: EntryViewPage(
              key: ValueKey(selected.id),
              embedded: true,
              entryId: selected.id!,
              onEntryEdited: (id) => setState(() => _selectedEntryId = id)),
        ),
      ]);
    }
    final canWrite = !_selectedDate.isAfter(DateTime.now());
    final images = EntryImagesProvider.instance;
    return ListView(
      key: const ValueKey('diary-day-pane'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Row(children: [
          Expanded(
            child: Text(
                TimeManager.formatDateWithWeekday(_selectedDate, context),
                style: Theme.of(context).textTheme.titleLarge),
          ),
          FilledButton.tonalIcon(
            key: const ValueKey('diary-day-write'),
            onPressed: canWrite
                ? () => EntryNavigation.addForDay(context, _selectedDate)
                : null,
            icon: const Icon(Icons.edit_rounded),
            label: Text(l10n.adaptiveNewEntry),
          ),
        ]),
        if (entries.isEmpty)
          EmptyState(
              icon: Icons.event_note_rounded, title: l10n.adaptiveEmptyDay)
        else
          EntryDayGroup(day: _selectedDate, rows: [
            for (final entry in entries)
              JournalEntryRow(
                entry: entry,
                images: images.getForEntry(entry),
                onTap: () => setState(() => _selectedEntryId = entry.id),
              ),
          ]),
      ],
    );
  }
}
