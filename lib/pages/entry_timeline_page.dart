// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/models/entry.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/journal_entry_row.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// A titled list of entries, such as one day or a throwback.
class EntryTimelinePage extends StatelessWidget {
  const EntryTimelinePage({
    super.key,
    required this.header,
    required this.getEntries,
    required this.labelBuilder,
  });

  final String header;
  final List<Entry> Function() getEntries;
  final String Function(BuildContext, Entry) labelBuilder;

  /// Pushes a list of every entry created on [date], newest first.
  static Future<void> pushForDay(BuildContext context, DateTime date) {
    return Navigator.of(context).push(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) => EntryTimelinePage(
        header: TimeManager.formatDate(date, context),
        getEntries: () => EntriesProvider.instance.getEntriesForDate(date),
        labelBuilder: (context, entry) => TimeManager.localizedTimeFormat(
                context, TimeManager.currentLocale(context))
            .format(entry.timeCreate),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<EntriesProvider>();
    final images = context.watch<EntryImagesProvider>();
    final entries = getEntries();
    if (entries.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).maybePop();
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text(header)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (final (day, dayEntries) in groupEntriesByDay(entries))
            EntryDayGroup(day: day, rows: [
              for (final entry in dayEntries)
                JournalEntryRow(
                  entry: entry,
                  images: images.getForEntry(entry),
                  label: labelBuilder(context, entry),
                  onTap: () =>
                      EntryNavigation.view(context, entry, entries: getEntries),
                ),
            ]),
        ],
      ),
    );
  }
}
