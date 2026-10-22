// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Version, the notice the license asks for (a modified version of Daily
/// You, not the official app), and the license texts. All offline.
class AboutSettings extends StatelessWidget {
  const AboutSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final version = DeviceInfoService().appInfo?.version ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAboutTitle), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            key: const ValueKey('about-app'),
            title: Text(l10n.appTitle),
            subtitle: Text(l10n.aboutModifiedNotice),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n.settingsVersion),
            subtitle: Text(version),
          ),
          SettingsIconAction(
              key: const ValueKey('about-license'),
              title: l10n.settingsLicense,
              hint: l10n.licenseGPLv3,
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () => openPlace(context, 'settings/license')),
          SettingsIconAction(
              title: l10n.settingsOpenSourceLicenses,
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () => openPlace(context, 'settings/licenses')),
        ],
      ),
    );
  }
}

/// The GPL and its additional terms, as shipped with the app.
class LicenseTextPage extends StatelessWidget {
  const LicenseTextPage({super.key});

  static Future<String> _load() async =>
      '${await rootBundle.loadString('ADDITIONAL_TERMS.md')}\n\n'
      '${await rootBundle.loadString('LICENSE.txt')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsLicense)),
      body: FutureBuilder<String>(
        future: _load(),
        builder: (context, snapshot) => snapshot.hasData
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(snapshot.data!,
                    style: Theme.of(context).textTheme.bodySmall),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
