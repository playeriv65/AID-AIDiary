// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/pages/settings/help_page.dart';
import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:aid_diary/pages/settings/data_settings.dart';
import 'package:aid_diary/pages/settings/flashback_settings.dart';
import 'package:aid_diary/pages/settings/notification_settings.dart';
import 'package:aid_diary/pages/settings/security_settings.dart';
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
                      page: const AppearanceSettings()),
                  SettingsCategory(
                      title: l10n.settingsDataTitle,
                      icon: Icons.storage_rounded,
                      page: const DataSettings()),
                  SettingsCategory(
                      title: l10n.settingsStoriesTitle,
                      icon: Icons.auto_stories_rounded,
                      page: const FlashbackSettings()),
                  if (Platform.isAndroid)
                    SettingsCategory(
                        title: l10n.settingsNotificationsTitle,
                        icon: Icons.notifications_rounded,
                        page: const NotificationSettings()),
                  SettingsCategory(
                      title: l10n.settingsSecurityTitle,
                      icon: Icons.security_rounded,
                      page: const SecuritySettings()),
                  SettingsCategory(
                      title: l10n.settingsHelpTitle,
                      icon: Icons.help_outline_rounded,
                      page: const HelpPage()),
                ],
              ))),
    );
  }
}
