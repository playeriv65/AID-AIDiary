// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/widgets/journal_entry_row.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:material_ui/material_ui.dart';

/// Deleted entries waiting out the retention period; restore or erase them.
class RecentlyDeletedPage extends StatefulWidget {
  const RecentlyDeletedPage({super.key});

  @override
  State<RecentlyDeletedPage> createState() => _RecentlyDeletedPageState();
}

class _RecentlyDeletedPageState extends State<RecentlyDeletedPage> {
  List<DeletedEntry>? _items;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final items = await EntryStore.instance.deleted();
    if (mounted) setState(() => _items = items);
  }

  int _daysLeft(DeletedEntry item) {
    final expires = item.deletedAt.add(AppConfig.instance.deletedRetention);
    final days = expires.difference(DateTime.now()).inHours / 24;
    return days.ceil().clamp(0, 9999);
  }

  Future<bool> _confirm(String title, String message) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              FilledButton(
                key: const ValueKey('deleted-confirm'),
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.deletedDeleteForever),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _actions(DeletedEntry item) async {
    final l10n = AppLocalizations.of(context)!;
    final restore = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            key: const ValueKey('deleted-restore'),
            leading: const Icon(Icons.restore_rounded),
            title: Text(l10n.deletedRestore),
            onTap: () => Navigator.pop(context, true),
          ),
          ListTile(
            key: const ValueKey('deleted-erase'),
            leading: const Icon(Icons.delete_forever_rounded),
            title: Text(l10n.deletedDeleteForever),
            onTap: () => Navigator.pop(context, false),
          ),
        ]),
      ),
    );
    if (restore == null) return;
    if (restore) {
      await EntryStore.instance.restore(item.entry);
    } else if (await _confirm(
        l10n.deletedDeleteForever, l10n.deletedDeleteForeverDescription)) {
      await EntryStore.instance.erase(item.entry);
    }
    await _reload();
  }

  Future<void> _emptyAll() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _confirm(l10n.deletedEmpty, l10n.deletedEmptyDescription)) {
      return;
    }
    for (final item in _items ?? const <DeletedEntry>[]) {
      await EntryStore.instance.erase(item.entry);
    }
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final items = _items;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deletedTitle),
        actions: [
          if (items?.isNotEmpty ?? false)
            TextButton(
              key: const ValueKey('deleted-empty'),
              onPressed: _emptyAll,
              child: Text(l10n.deletedEmpty),
            ),
        ],
      ),
      body: switch (items) {
        null => const Center(child: CircularProgressIndicator()),
        [] => EmptyState(
            icon: Icons.delete_outline_rounded,
            title: l10n.deletedNone,
            hint: l10n.deletedHint(AppConfig.instance.deletedRetention.inDays)),
        final items => ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                    l10n.deletedHint(
                        AppConfig.instance.deletedRetention.inDays),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline)),
              ),
              for (final (day, dayEntries)
                  in groupEntriesByDay([for (final item in items) item.entry]))
                EntryDayGroup(day: day, rows: [
                  for (final entry in dayEntries)
                    JournalEntryRow(
                      entry: entry,
                      images: EntryImagesProvider.instance.getForEntry(entry),
                      label: l10n.deletedDaysLeft(_daysLeft(
                          items.firstWhere((i) => i.entry.id == entry.id))),
                      onTap: () => _actions(
                          items.firstWhere((i) => i.entry.id == entry.id)),
                    ),
                ]),
            ],
          ),
      },
    );
  }
}
