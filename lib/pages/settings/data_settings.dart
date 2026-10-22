// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:material_ui/material_ui.dart';

/// Backups, imports and where the diary is stored.
class DataSettings extends StatelessWidget {
  const DataSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsDataTitle), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(children: [
            SettingsCategory(
                title: l10n.settingsSyncTitle,
                icon: Icons.cloud_sync_rounded,
                destination: 'sync'),
            SettingsCategory(
                title: l10n.settingsBackupRestoreTitle,
                icon: Icons.settings_backup_restore_rounded,
                destination: 'settings/backup'),
            SettingsCategory(
                title: l10n.settingsStorageTitle,
                icon: Icons.storage_rounded,
                destination: 'settings/storage'),
            SettingsCategory(
                title: l10n.deletedTitle,
                icon: Icons.delete_outline_rounded,
                destination: 'recently_deleted'),
          ]),
        ),
      ),
    );
  }
}
