// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

/// Keeps the backup password's switch in step with the password: on when
/// one is set. With [clear] it forgets the password and turns the switch
/// off. Like the app lock, only the person at the device does this, so no
/// action stands in for it (docs/ARCHITECTURE.md).
Future<void> updateBackupPassword({bool clear = false}) async {
  final config = ConfigProvider.instance;
  if (clear) await config.set(Settings.backupPassword, '');
  await config.set(Settings.backupPasswordEnabled,
      !clear && BackupPasswordStore.password.isNotEmpty);
}

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => SecuritySettingsPageState();
}

class SecuritySettingsPageState extends State<SecuritySettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsSecurityTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(AppLocalizations.of(context)!.hiddenDiaryTitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => openPlace(context, 'hidden_entries')),
          SettingsToggle(
              title:
                  AppLocalizations.of(context)!.settingsSecurityRequirePassword,
              setting: Settings.requirePassword,
              onChanged: (DeviceInfoService().supportsSecureStorage ?? false)
                  ? (value) async {
                      if (!configProvider.get(Settings.requirePassword)) {
                        bool setPassword = false;
                        await showDialog(
                            context: context,
                            builder: (context) => AuthPopup(
                                  mode: AuthPopupMode.setPassword,
                                  title: AppLocalizations.of(context)!
                                      .settingsSecuritySetPassword,
                                  showBiometrics: false,
                                  dismissable: true,
                                  onSuccess: (_) {
                                    setPassword = true;
                                  },
                                ));
                        await configProvider.set(
                            Settings.requirePassword, setPassword);
                      } else {
                        await showDialog(
                            context: context,
                            builder: (context) => AuthPopup(
                                  mode: AuthPopupMode.unlock,
                                  title: AppLocalizations.of(context)!
                                      .settingsSecurityEnterPassword,
                                  showBiometrics: false,
                                  dismissable: true,
                                  onSuccess: (_) {
                                    configProvider.set(
                                        Settings.requirePassword, false);
                                  },
                                ));
                      }
                    }
                  : null),
          if (configProvider.get(Settings.requirePassword))
            SettingsIconAction(
                title: AppLocalizations.of(context)!
                    .settingsSecurityChangePassword,
                icon: Icon(Icons.edit_rounded),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                            mode: AuthPopupMode.changePassword,
                            title: AppLocalizations.of(context)!
                                .settingsSecurityChangePassword,
                            showBiometrics: false,
                            dismissable: true,
                            onSuccess: (_) {},
                          ));
                }),
          if (configProvider.get(Settings.requirePassword) &&
              (DeviceInfoService().supportsBiometrics ?? false))
            SettingsToggle(
                title: AppLocalizations.of(context)!
                    .settingsSecurityBiometricUnlock,
                setting: Settings.biometricUnlock,
                onChanged: (value) async {
                  final reason = AppLocalizations.of(context)!.unlockAppPrompt;
                  var unlocked = false;
                  await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                            mode: AuthPopupMode.unlock,
                            title: AppLocalizations.of(context)!
                                .settingsSecurityEnterPassword,
                            showBiometrics: false,
                            dismissable: true,
                            onSuccess: (_) => unlocked = true,
                          ));
                  // Turning biometric unlock on checks the biometrics too.
                  if (unlocked &&
                      (!value || await authenticateOnDevice(reason: reason))) {
                    await configProvider.set(Settings.biometricUnlock, value);
                  }
                }),
        ],
      ),
    );
  }
}
