// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/sync_conflicts.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Asks which version of a conflicted entry to keep: this device's, the
/// other's or both; null for later. [index] of [total] counts the
/// conflicts asked about one after another.
Future<ConflictKeep?> showSyncConflictDialog(
        BuildContext context, SyncConflict conflict,
        {int index = 1, int total = 1}) =>
    showDialog<ConflictKeep>(
      context: context,
      builder: (context) =>
          _SyncConflictDialog(conflict, index: index, total: total),
    );

/// Asks about each pending conflict in turn and keeps what the user picks,
/// through `sync.conflicts` and `sync.resolve_conflict`. Entries in [skip]
/// are not asked about; those the user puts off are added to it. Returns
/// whether the user went through all of them.
Future<bool> resolveSyncConflicts(BuildContext context,
    {Set<int>? skip}) async {
  final listed = await AppActions.instance.run('sync.conflicts', {}) as List;
  final conflicts = [
    for (final json in listed)
      SyncConflict.fromJson((json as Map).cast<String, Object?>()),
  ]..removeWhere((conflict) => skip?.contains(conflict.entry) ?? false);
  for (final (index, conflict) in conflicts.indexed) {
    if (!context.mounted) return false;
    final keep = await showSyncConflictDialog(context, conflict,
        index: index + 1, total: conflicts.length);
    if (keep == null) {
      skip?.addAll([for (final later in conflicts.skip(index)) later.entry]);
      return false;
    }
    await AppActions.instance.run(
        'sync.resolve_conflict', {'entry': conflict.entry, 'keep': keep.arg},
        confirmed: true);
  }
  return true;
}

/// Asks about conflicts when the app opens and after each sync that leaves
/// some the user has not put off in this session.
class SyncConflictPrompt {
  SyncConflictPrompt._();

  static final instance = SyncConflictPrompt._();

  BuildContext? Function()? _context;
  final Set<int> _later = {};
  var _wasSyncing = false;
  var _asking = false;

  /// Runs once the shell is on screen; [context] gives the navigator's.
  void start(BuildContext? Function() context) {
    _context = context;
    SyncService.instance.addListener(_changed);
    _ask();
  }

  void stop() {
    SyncService.instance.removeListener(_changed);
    _context = null;
  }

  void _changed() {
    final syncing = SyncService.instance.state == SyncState.syncing;
    if (_wasSyncing && !syncing) _ask();
    _wasSyncing = syncing;
  }

  Future<void> _ask() async {
    final context = _context?.call();
    if (_asking || context == null || !context.mounted) return;
    _asking = true;
    try {
      await resolveSyncConflicts(context, skip: _later);
    } finally {
      _asking = false;
    }
  }
}

class _SyncConflictDialog extends StatelessWidget {
  const _SyncConflictDialog(this.conflict,
      {required this.index, required this.total});

  final SyncConflict conflict;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final versions = [
      _VersionCard(l10n.syncConflictThisVersion, conflict.mine),
      _VersionCard(l10n.syncConflictOtherVersion, conflict.other),
    ];
    void pick(ConflictKeep? keep) => Navigator.of(context).pop(keep);
    return AlertDialog(
      key: const ValueKey('sync-conflict-dialog'),
      title: Text(l10n.syncConflictTitle),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (total > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(l10n.syncConflictCount(index, total),
                      style: theme.textTheme.labelMedium),
                ),
              Text(l10n.syncConflictMessage),
              const SizedBox(height: 16),
              // Side by side where there is room, else one above the other.
              if (MediaQuery.sizeOf(context).width >= 600)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: versions[0]),
                      const SizedBox(width: 12),
                      Expanded(child: versions[1]),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    versions[0],
                    const SizedBox(height: 12),
                    versions[1],
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            key: const ValueKey('sync-conflict-later'),
            onPressed: () => pick(null),
            child: Text(l10n.syncConflictLater)),
        TextButton(
            key: const ValueKey('sync-conflict-both'),
            onPressed: () => pick(ConflictKeep.both),
            child: Text(l10n.syncConflictKeepBoth)),
        FilledButton.tonal(
            key: const ValueKey('sync-conflict-other'),
            onPressed: () => pick(ConflictKeep.other),
            child: Text(l10n.syncConflictKeepOther)),
        FilledButton(
            key: const ValueKey('sync-conflict-this'),
            onPressed: () => pick(ConflictKeep.mine),
            child: Text(l10n.syncConflictKeepThis)),
      ],
    );
  }
}

/// One version: whose it is, when it was saved and how it begins.
class _VersionCard extends StatelessWidget {
  const _VersionCard(this.label, this.version);

  final String label;
  final ConflictVersion version;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = TimeManager.currentLocale(context);
    final made = [
      if (version.device case final device?) device,
      if (version.modified case final modified?)
        DateFormat.yMMMd(locale).add_Hm().format(modified),
    ].join(' · ');
    final sealed = version.opensAt;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.primary)),
            if (made.isNotEmpty)
              Text(made,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            if (sealed != null)
              Text(l10n.capsuleOpensOn(DateFormat.yMMMd(locale).format(sealed)))
            else ...[
              if (version.title.isNotEmpty)
                Text(version.title, style: theme.textTheme.titleSmall),
              Text(version.snippet,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
