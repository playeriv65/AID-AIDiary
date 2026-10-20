// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/pages/recently_deleted_page.dart';
import 'package:daily_you/pages/settings/backup_restore_settings.dart';
import 'package:daily_you/pages/settings/storage_settings.dart';
import 'package:daily_you/widgets/settings_category.dart';
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
                title: l10n.settingsBackupRestoreTitle,
                icon: Icons.settings_backup_restore_rounded,
                page: const BackupRestoreSettings()),
            SettingsCategory(
                title: l10n.settingsStorageTitle,
                icon: Icons.storage_rounded,
                page: const StorageSettings()),
            SettingsCategory(
                title: l10n.deletedTitle,
                icon: Icons.delete_outline_rounded,
                page: const RecentlyDeletedPage()),
          ]),
        ),
      ),
    );
  }
}
