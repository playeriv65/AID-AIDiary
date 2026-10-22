// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/pages/settings/security_settings.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/auto_backup_schedule.dart';
import 'package:aid_diary/utils/backup_restore_utils.dart';
import 'package:aid_diary/utils/imports/import_registry.dart';
import 'package:aid_diary/utils/export_utils.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class BackupRestoreSettings extends StatefulWidget {
  const BackupRestoreSettings({super.key});

  @override
  State<BackupRestoreSettings> createState() => _BackupRestoreSettingsState();
}

class _BackupRestoreSettingsState extends State<BackupRestoreSettings> {
  @override
  void initState() {
    super.initState();
  }

  /// Asks which of [options] to use; null when the dialog is dismissed.
  Future<T?> _chooseFormat<T>(
      String description, List<(T, String, Key)> options) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logFormatTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                const Divider(),
                for (final (value, name, key) in options)
                  ListTile(
                      key: key,
                      title: Text(name),
                      onTap: () => Navigator.of(context).pop(value)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showImportSelectionPopup() async {
    final localizations = AppLocalizations.of(context)!;
    final option = await _chooseFormat(localizations.logFormatDescription, [
      for (final option in ImportRegistry.instance.options)
        (
          option,
          option.name(localizations),
          ValueKey('import-${option.format.name}')
        ),
    ]);
    if (option == null || !mounted) return;
    final file = await StoragePicker.pickFile(
        allowedExtensions: option.extensions, mimeTypes: option.mimeTypes);
    if (file == null || !mounted) return;
    await runOperation(
        context, (update) => option.run(file, localizations, update),
        failureDescription: localizations.importErrorDescription);
  }

  Future<void> _showExportSelectionPopup() async {
    final localizations = AppLocalizations.of(context)!;
    final option =
        await _chooseFormat(localizations.settingsExportFormatDescription, [
      for (final option in ExportRegistry.instance.options)
        (
          option,
          option.name(localizations),
          ValueKey('export-${option.format.name}')
        ),
    ]);
    if (option == null || !mounted) return;
    final folder = await StoragePicker.pickDirectory();
    if (folder == null || !mounted) return;
    final locale = Localizations.localeOf(context);
    await runOperation(
        context, (update) => option.run(folder, localizations, locale, update),
        failureDescription: localizations.exportErrorDescription);
  }

  Future<void> _backupData(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final folder = await StoragePicker.pickDirectory();
    if (folder == null || !context.mounted) return;
    await runOperation(
        context,
        (update) =>
            BackupRestoreUtils.backupToZip(folder, localizations, update),
        failureDescription: localizations.backupErrorDescription);
  }

  Future<void> _restoreData(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final archive = await StoragePicker.pickFile(
        allowedExtensions: ['zip', 'enc'],
        mimeTypes: ['application/zip', 'application/octet-stream']);
    if (archive == null || !context.mounted) return;
    await runOperation(
        context,
        (update) => BackupRestoreUtils.restoreFromZip(
            archive, localizations, update,
            askPassword: () => _askBackupPassword(context)),
        failureDescription: localizations.restoreErrorDescription);
  }

  /// The password of an encrypted backup the saved one does not open.
  Future<String?> _askBackupPassword(BuildContext context) async {
    if (!context.mounted) return null;
    String? password;
    await showDialog(
        context: context,
        builder: (context) => AuthPopup(
              mode: AuthPopupMode.enterPassword,
              title: AppLocalizations.of(context)!.backupEncryptedTitle,
              description: AppLocalizations.of(context)!.backupEncryptedContent,
              showBiometrics: false,
              dismissable: true,
              store: const BackupPasswordStore(),
              onSuccess: (entered) => password = entered,
            ));
    return password;
  }

  Future<void> _showRestoreWarning() async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.warningTitle),
          content: Text(
              AppLocalizations.of(context)!.settingsRestorePromptDescription),
          actions: [
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () async {
                confirmed = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    if (confirmed) {
      if (!mounted) return;
      await _restoreData(context);
    }
  }

  String _lastBackupText(String lastBackup) {
    final time = DateTime.tryParse(lastBackup);
    if (time == null) {
      return AppLocalizations.of(context)!.settingsBackupNever;
    }
    return AppLocalizations.of(context)!
        .settingsBackupLast(_dateTimeText(time));
  }

  String _nextAutoBackupText(ConfigProvider configProvider) {
    // Date only since idle/charging-gated scheduling has no guaranteed time
    final next = nextAutoBackupTimeFromConfig(configProvider);
    return AppLocalizations.of(context)!
        .settingsAutoBackupNext(TimeManager.formatDate(next, context));
  }

  String _dateTimeText(DateTime time) =>
      "${TimeManager.formatDate(time, context)} "
      "${TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(time))}";

  Future<void> _showBackupPasswordDialog(String title) async {
    await showDialog(
        context: context,
        builder: (context) => AuthPopup(
              mode: AuthPopupMode.setPassword,
              title: title,
              showBiometrics: false,
              dismissable: true,
              store: const BackupPasswordStore(),
            ));
  }

  // Its settings re-arm the backup work themselves (SettingsService).
  Future<void> _showAutoBackupSettings() =>
      openPlace(context, 'settings/auto_backup');

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsBackupRestoreTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SettingsIconAction(
              title: AppLocalizations.of(context)!.settingsRestore,
              icon: Icon(Icons.restore_rounded),
              onPressed: () async {
                await _showRestoreWarning();
              }),
          SettingsIconAction(
              title: AppLocalizations.of(context)!.settingsBackup,
              hint: _lastBackupText(configProvider.get(Settings.lastBackup)),
              icon: Icon(Icons.backup_rounded),
              onPressed: () async {
                await _backupData(context);
              }),
          if (Platform.isAndroid)
            SettingsToggle(
              title: AppLocalizations.of(context)!.settingsAutoBackup,
              hint: configProvider.get(Settings.autoBackupEnabled)
                  ? _nextAutoBackupText(configProvider)
                  : null,
              setting: Settings.autoBackupEnabled,
              secondaryIcon: configProvider.get(Settings.autoBackupEnabled)
                  ? Icon(Icons.edit_rounded)
                  : null,
              onSecondaryPressed: _showAutoBackupSettings,
              onChanged: (value) async {
                if (value) {
                  if (configProvider.get(Settings.autoBackupLocationUri) ==
                      '') {
                    final directory = await StoragePicker.pickDirectory();
                    if (directory == null) return;
                    await changeSetting(
                        Settings.autoBackupLocationUri, directory.uri);
                  }
                  if (!await changeSetting(Settings.autoBackupEnabled, true)) {
                    return;
                  }
                  await _showAutoBackupSettings();
                  return;
                }
                await changeSetting(Settings.autoBackupEnabled, false);
              },
            ),
          SettingsToggle(
            title: AppLocalizations.of(context)!.settingsBackupPasswordProtect,
            setting: Settings.backupPasswordEnabled,
            secondaryIcon: configProvider.get(Settings.backupPasswordEnabled)
                ? Icon(Icons.edit_rounded)
                : null,
            onSecondaryPressed: () async => _showBackupPasswordDialog(
                AppLocalizations.of(context)!.settingsSecurityChangePassword),
            onChanged: (DeviceInfoService().supportsSecureStorage ?? false)
                ? (value) async {
                    if (value) {
                      await _showBackupPasswordDialog(
                          AppLocalizations.of(context)!
                              .settingsSecuritySetPassword);
                      await updateBackupPassword();
                    } else {
                      await updateBackupPassword(clear: true);
                    }
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(),
          ),
          SettingsIconAction(
              title: AppLocalizations.of(context)!.settingsImportFromAnotherApp,
              icon: Icon(Icons.download_rounded),
              onPressed: () async {
                await _showImportSelectionPopup();
              }),
          SettingsIconAction(
              title:
                  AppLocalizations.of(context)!.settingsExportToAnotherFormat,
              icon: Icon(Icons.upload_rounded),
              onPressed: () async {
                await _showExportSelectionPopup();
              }),
        ],
      ),
    );
  }
}
