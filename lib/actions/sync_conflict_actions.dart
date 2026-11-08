// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/sync/sync_conflicts.dart';
import 'package:aid_diary/sync/sync_service.dart';

/// Entries edited on two devices before either edit synced
/// (docs/ARCHITECTURE.md, "Conflicts"). The GUI's conflict dialog runs
/// these too.
final List<AppAction> syncConflictActions = [
  AppAction(
    id: 'sync.conflicts',
    describe: 'Lists the entries edited on two devices before either edit '
        'synced: for each, the version on this device and the other, with '
        'the device that made it, when it was saved and its text.',
    risk: ActionRisk.read,
    run: (context, args) async => [
      for (final conflict in await SyncService.instance.conflicts())
        conflict.toJson(),
    ],
  ),
  AppAction(
    id: 'sync.resolve_conflict',
    describe: "Keeps one version of an entry from sync.conflicts on every "
        "device: this device's, the other's, or both as two entries. The "
        'version not kept is gone, unless both are kept.',
    risk: ActionRisk.destructive,
    params: const [
      ActionParam('entry', ParamType.integer, 'The entry id'),
      ActionParam(
          'keep', ParamType.string, 'this, other or both (two entries)'),
    ],
    run: (context, args) async {
      final ConflictKeep keep;
      try {
        keep = ConflictKeep.parse(args['keep'] as String);
      } on FormatException catch (e) {
        throw ActionException('bad_args', e.message);
      }
      try {
        await SyncService.instance.resolveConflict(args['entry'] as int, keep);
      } on StateError catch (e) {
        throw ActionException('not_found', e.message);
      }
      return [
        for (final conflict in await SyncService.instance.conflicts())
          conflict.toJson(),
      ];
    },
  ),
];
