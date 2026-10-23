// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageSettingsTitle),
        centerTitle: true,
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                children: [
                  // Grouped like Journey: general, data, stories,
                  // reminders, security, help.
                  SettingsCategory(
                      title: l10n.settingsGeneralTitle,
                      icon: Icons.tune_rounded,
                      destination: 'settings/appearance'),
                  SettingsCategory(
                      title: l10n.settingsDataTitle,
                      icon: Icons.storage_rounded,
                      destination: 'settings/data'),
                  SettingsCategory(
                      title: l10n.settingsStoriesTitle,
                      icon: Icons.auto_stories_rounded,
                      destination: 'settings/stories'),
                  if (Platform.isAndroid)
                    SettingsCategory(
                        title: l10n.settingsNotificationsTitle,
                        icon: Icons.notifications_rounded,
                        destination: 'settings/notifications'),
                  SettingsCategory(
                      title: l10n.settingsSecurityTitle,
                      icon: Icons.security_rounded,
                      destination: 'settings/security'),
                  SettingsCategory(
                      title: l10n.settingsCommandLineTitle,
                      icon: Icons.terminal_rounded,
                      destination: 'settings/command_line'),
                  SettingsCategory(
                      title: l10n.tutorialTitle,
                      icon: Icons.menu_book_outlined,
                      destination: 'settings/tutorial'),
                  SettingsCategory(
                      title: l10n.settingsHelpTitle,
                      icon: Icons.help_outline_rounded,
                      destination: 'settings/help'),
                ],
              ))),
    );
  }
}
