// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/widgets/entry_card.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/choice_sheet.dart';
import 'package:material_ui/material_ui.dart';

/// Deleted entries waiting out the retention period; restore or erase them.
/// Opened in the hidden diary, it holds the hidden diary's deleted entries,
/// else the rest.
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

  /// The hidden diary this page was opened in, or null.
  HiddenDiarySession? get _hidden =>
      context.getInheritedWidgetOfExactType<HiddenDiaryScope>()?.notifier;

  Future<void> _reload() async {
    final items = await (_hidden?.deleted() ?? EntryStore.instance.deleted());
    if (mounted) setState(() => _items = items);
  }

  Future<void> _restore(Entry entry) async {
    if (_hidden case final hidden?) {
      await hidden.restore(entry);
    } else {
      await AppActions.instance.run('entry.restore', {'id': entry.id});
    }
  }

  Future<void> _erase(Entry entry) async {
    if (_hidden case final hidden?) {
      await hidden.erase([entry]);
    } else {
      await AppActions.instance
          .run('entry.erase', {'id': entry.id}, confirmed: true);
    }
  }

  Future<void> _eraseAll(List<DeletedEntry> items) async {
    if (_hidden case final hidden?) {
      await hidden.erase([for (final item in items) item.entry]);
    } else {
      await AppActions.instance.run('entry.empty_deleted', {}, confirmed: true);
    }
  }

  Future<bool> _confirm(String title, String message) async {
    final l10n = AppLocalizations.of(context)!;
    return showConfirmDialog(context,
        title: title,
        message: message,
        confirm: l10n.deletedDeleteForever,
        destructive: true,
        confirmKey: const ValueKey('deleted-confirm'));
  }

  Future<void> _actions(DeletedEntry item) async {
    final l10n = AppLocalizations.of(context)!;
    final restore = await showChoiceSheet(context, [
      (
        value: true,
        icon: Icons.restore_rounded,
        label: l10n.deletedRestore,
        key: const ValueKey('deleted-restore')
      ),
      (
        value: false,
        icon: Icons.delete_forever_rounded,
        label: l10n.deletedDeleteForever,
        key: const ValueKey('deleted-erase')
      ),
    ]);
    if (restore == null) return;
    if (restore) {
      await _restore(item.entry);
    } else if (await _confirm(
        l10n.deletedDeleteForever, l10n.deletedDeleteForeverDescription)) {
      await _erase(item.entry);
    }
    await _reload();
  }

  Future<void> _emptyAll(List<DeletedEntry> items) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _confirm(l10n.deletedEmpty, l10n.deletedEmptyDescription)) {
      return;
    }
    await _eraseAll(items);
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
          if (items != null && items.isNotEmpty)
            TextButton(
              key: const ValueKey('deleted-empty'),
              onPressed: () => _emptyAll(items),
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
                    EntryCard(
                      entry: entry,
                      images: EntryImagesProvider.instance.getForEntry(entry),
                      label: l10n.deletedDaysLeft(items
                          .firstWhere((i) => i.entry.id == entry.id)
                          .daysLeft),
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
