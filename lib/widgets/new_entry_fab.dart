// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/expressive_fab_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Photo, other day, or today (with a shortcut to edit today's entry).
class NewEntryFab extends StatelessWidget {
  const NewEntryFab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = context.watch<EntriesProvider>().getEntryForToday();
    return ExpressiveFabMenu(key: const ValueKey('entry-menu'), items: [
      ExpressiveFabMenuItem(
          icon: Icons.camera_alt_rounded,
          label: l10n.actionTakePhoto,
          onTap: () => EntryNavigation.edit(context, today, openCamera: true)),
      ExpressiveFabMenuItem(
          icon: Icons.event_rounded,
          label: l10n.actionOtherDay,
          onTap: () => EntryNavigation.addForPickedDay(context)),
      ExpressiveFabMenuItem(
          icon: Icons.schedule_rounded,
          label: l10n.actionToday,
          onTap: () => EntryNavigation.edit(context, null),
          secondaryIcon: today != null ? Icons.edit_rounded : null,
          secondaryOnTap: today != null
              ? () => EntryNavigation.edit(context, today)
              : null),
    ]);
  }
}
