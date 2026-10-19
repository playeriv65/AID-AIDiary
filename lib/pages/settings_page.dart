// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:daily_you/pages/settings/about_settings.dart';
import 'package:daily_you/pages/settings/appearance_settings.dart';
import 'package:daily_you/pages/settings/data_settings.dart';
import 'package:daily_you/pages/settings/flashback_settings.dart';
import 'package:daily_you/pages/settings/notification_settings.dart';
import 'package:daily_you/pages/settings/security_settings.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/widgets/settings_category.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final entriesProvider = Provider.of<EntriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSettingsTitle),
        centerTitle: true,
      ),
      persistentFooterButtons: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: AppLocalizations.of(context)!.settingsMadeWithLove,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary)),
                if (entriesProvider.entries.length > 30)
                  TextSpan(
                      text: " ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary)),
                if (entriesProvider.entries.length > 30)
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .settingsConsiderSupporting,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launchUrl(
                            Uri(
                                scheme: "https",
                                host: "github.com",
                                path: "/Demizo/Daily_You",
                                queryParameters: {"tab": "readme-ov-file"},
                                fragment: "support-the-app"),
                            mode: LaunchMode.externalApplication);
                      },
                  ),
              ],
            ),
          ),
        )
      ],
      body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                children: [
                  // Grouped like Journey: general, data, stories,
                  // reminders, security, help.
                  SettingsCategory(
                      title: AppLocalizations.of(context)!.settingsGeneralTitle,
                      icon: Icons.tune_rounded,
                      page: const AppearanceSettings()),
                  SettingsCategory(
                      title: AppLocalizations.of(context)!.settingsDataTitle,
                      icon: Icons.storage_rounded,
                      page: const DataSettings()),
                  SettingsCategory(
                      title: AppLocalizations.of(context)!.settingsStoriesTitle,
                      icon: Icons.auto_stories_rounded,
                      page: const FlashbackSettings()),
                  if (Platform.isAndroid)
                    SettingsCategory(
                        title: AppLocalizations.of(context)!
                            .settingsNotificationsTitle,
                        icon: Icons.notifications_rounded,
                        page: const NotificationSettings()),
                  SettingsCategory(
                      title:
                          AppLocalizations.of(context)!.settingsSecurityTitle,
                      icon: Icons.security_rounded,
                      page: const SecuritySettings()),
                  SettingsCategory(
                      title: AppLocalizations.of(context)!.settingsHelpTitle,
                      icon: Icons.help_outline_rounded,
                      page: const AboutSettings()),
                ],
              ))),
    );
  }
}
