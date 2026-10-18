// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/new_entry_fab.dart';
import 'package:daily_you/widgets/vertical_calendar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

/// Scrolling calendar; wide windows show the selected day beside it.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final _calendarKey = GlobalKey();
  DateTime _selectedDate = DateTime.now();
  int? _selectedEntryId;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);

    return LayoutBuilder(builder: (context, constraints) {
      final split = diarySupportsSplit(constraints.biggest);
      final calendar = Column(
        children: [
          Expanded(
            child: VerticalCalendar(
              key: _calendarKey,
              scrollController: _scrollController,
              showControlsWithSelection: split,
              selectedDate: split ? _selectedDate : null,
              onDaySelected: split
                  ? (_, date) => setState(() {
                        _selectedDate = date;
                        _selectedEntryId = null;
                      })
                  : null,
            ),
          ),
        ],
      );
      return Stack(alignment: Alignment.bottomCenter, children: [
        if (split)
          Row(key: const ValueKey('diary-home-split'), children: [
            SizedBox(
                width: (constraints.maxWidth * .4).clamp(280.0, 420.0),
                child: calendar),
            const VerticalDivider(width: 1),
            Expanded(child: _buildSelectedDay(context, entriesProvider)),
          ])
        else
          calendar,
        const Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: NewEntryFab(),
          ),
        )
      ]);
    });
  }

  Widget _buildSelectedDay(BuildContext context, EntriesProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final entries = provider.getEntriesForDate(_selectedDate);
    final selected =
        entries.where((e) => e.id == _selectedEntryId).firstOrNull ??
            entries.firstOrNull;
    return Column(key: const ValueKey('diary-day-pane'), children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(children: [
            Expanded(
                child: Text(
                    TimeManager.formatDateWithWeekday(_selectedDate, context),
                    style: Theme.of(context).textTheme.titleMedium)),
            IconButton(
                key: const ValueKey('diary-day-add'),
                tooltip: l10n.adaptiveNewEntry,
                icon: const Icon(Icons.add_rounded),
                onPressed: _selectedDate.isAfter(DateTime.now())
                    ? null
                    : () => EntryNavigation.addForDay(context, _selectedDate)),
          ])),
      if (entries.length > 1)
        SizedBox(
            height: 48,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ChoiceChip(
                    label: Text(TimeManager.localizedTimeFormat(
                            context, TimeManager.currentLocale(context))
                        .format(entries[index].timeCreate)),
                    selected: entries[index].id == selected?.id,
                    onSelected: (_) =>
                        setState(() => _selectedEntryId = entries[index].id)))),
      Expanded(
          child: selected != null
              ? SelectionArea(
                  child: EntryViewPage(
                      key: ValueKey(selected.id),
                      embedded: true,
                      entryId: selected.id!,
                      onEntryEdited: (id) {
                        if (mounted) setState(() => _selectedEntryId = id);
                      }))
              : Center(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.auto_stories_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(height: 16),
                        Text(l10n.adaptiveEmptyDay,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                            key: const ValueKey('diary-day-write'),
                            onPressed: _selectedDate.isAfter(DateTime.now())
                                ? null
                                : () => EntryNavigation.addForDay(
                                    context, _selectedDate),
                            icon: const Icon(Icons.edit_rounded),
                            label: Text(l10n.adaptiveNewEntry)),
                      ])))),
    ]);
  }
}
