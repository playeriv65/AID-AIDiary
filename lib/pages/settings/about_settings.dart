// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/services/app_updates.dart';
import 'package:aid_diary/widgets/app_update_prompt.dart';
import 'package:aid_diary/widgets/settings_row.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Version and updates, the notice the license asks for (a modified version
/// of Daily You, not the official app), and the license texts.
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
          const _UpdateSettings(),
          SettingsRow(
              key: const ValueKey('about-license'),
              title: l10n.settingsLicense,
              hint: l10n.licenseGPLv3,
              onTap: () => openPlace(context, 'settings/license')),
          SettingsRow(
              title: l10n.settingsOpenSourceLicenses,
              onTap: () => openPlace(context, 'settings/licenses')),
        ],
      ),
    );
  }
}

/// Checking for updates, where this build can install them
/// (docs/UPDATES.md).
class _UpdateSettings extends StatefulWidget {
  const _UpdateSettings();

  @override
  State<_UpdateSettings> createState() => _UpdateSettingsState();
}

class _UpdateSettingsState extends State<_UpdateSettings> {
  /// Whether this build updates itself, and whether it can without asking.
  final _abilities = () async {
    final updates = AppUpdates.instance;
    final enabled = await updates.enabled();
    return (
      enabled: enabled,
      silent: enabled && await updates.silentSupported()
    );
  }();
  bool _checking = false;

  Future<void> _checkNow() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _checking = true);
    try {
      final updates = AppUpdates.instance;
      final update = await updates.check();
      if (!mounted) return;
      if (update == null) {
        showSnackMessage(context, l10n.updateNewest);
      } else {
        // Asked for, so the dialog comes at once; the package downloads
        // meanwhile, and Update waits only for what is left of it.
        unawaited(updates.prefetch(update));
        await showUpdateDialog(context, update);
      }
    } catch (error) {
      if (mounted) showSnackMessage(context, l10n.updateFailed('$error'));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<({bool enabled, bool silent})>(
      future: _abilities,
      builder: (context, snapshot) => snapshot.data?.enabled != true
          ? const SizedBox.shrink()
          : Column(children: [
              SettingsRow(
                key: const ValueKey('about-check-update'),
                icon: Icons.system_update_rounded,
                title: l10n.updateCheckNow,
                trailing: _checking
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : null,
                onTap: _checking ? null : _checkNow,
              ),
              SettingsToggle(
                  title: l10n.updateAutoCheck,
                  setting: Settings.updateChecks,
                  onChanged: (value) =>
                      changeSetting(Settings.updateChecks, value)),
              // HyperOS and MIUI always ask before an install.
              if (snapshot.data!.silent)
                SettingsToggle(
                    title: l10n.updateSilent,
                    hint: l10n.updateSilentHint,
                    setting: Settings.silentUpdates,
                    onChanged: (value) =>
                        changeSetting(Settings.silentUpdates, value)),
            ]),
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
