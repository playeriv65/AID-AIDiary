// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/link_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/widgets/entry_links.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Every passage kept from the diary, newest first; each opens its entry.
class PassagesPage extends StatelessWidget {
  const PassagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    context.watch<EntriesProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notesPassages)),
      body: ListenableBuilder(
        listenable: LinksProvider.instance,
        builder: (context, _) {
          final open = openEntryIds();
          final passages = [
            for (final passage in LinksProvider.instance.passages.reversed)
              if (open.contains(passage.entryId)) passage
          ];
          final entries = {
            for (final entry in EntriesProvider.instance.entries)
              entry.id: entry
          };
          if (passages.isEmpty) {
            return EmptyState(
                icon: Icons.format_quote_rounded, title: l10n.notesPassages);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: passages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final passage = passages[index];
              final entry = entries[passage.entryId]!;
              return Card.filled(
                key: ValueKey('kept-${passage.id}'),
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => EntryNavigation.view(context, entry),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuoteBlock(passage.quote),
                        const SizedBox(height: 8),
                        Text(TimeManager.formatDate(entry.day, context),
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
