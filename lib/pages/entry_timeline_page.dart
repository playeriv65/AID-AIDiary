// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/widgets/entry_card.dart';
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
                EntryCard(
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
