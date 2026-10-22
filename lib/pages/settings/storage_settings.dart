// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/entry_actions.dart' show eraseAllPhrase;
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/widgets/settings_dropdown.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StorageSettings extends StatefulWidget {
  const StorageSettings({super.key});

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> requestStoragePermission() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    if (androidInfo.version.sdkInt < 33) {
      //Legacy Permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        return true;
      }
      return false;
    }

    //Modern Permission
    return true;
  }

  Future<bool> requestPhotosPermission() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    if (androidInfo.version.sdkInt < 33) {
      //Legacy Permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        return true;
      }
      return false;
    } else {
      //Modern Photos Permission
      return true;
    }
  }

  Future<void> _showChangeLogFolderWarning() async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.warningTitle),
          content:
              Text(AppLocalizations.of(context)!.logFolderWarningDescription),
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
      await runOperation(context, AppDatabase.instance.selectExternalLocation,
          failureDescription:
              AppLocalizations.of(context)!.logFolderErrorDescription);
    }
  }

  Future<void> _attemptImageFolderChange() async {
    await runOperation(context, ImageStorage.instance.selectExternalLocation,
        failureDescription:
            AppLocalizations.of(context)!.imageFolderErrorDescription);
  }

  void _showDeleteAllLogsDialog(
      BuildContext context, String requiredText, VoidCallback onConfirm) {
    ThemeData theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();
    final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsDeleteAllLogsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!
                  .settingsDeleteAllLogsDescription),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(AppLocalizations.of(context)!
                    .settingsDeleteAllLogsPrompt(requiredText)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          hintText: requiredText,
                          border: InputBorder.none),
                      controller: controller,
                      onChanged: (value) {
                        isButtonEnabled.value = value.toLowerCase().trim() ==
                            requiredText.toLowerCase().trim();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  onPressed: isEnabled
                      ? () {
                          Navigator.of(context).pop();
                          onConfirm();
                        }
                      : null,
                  child: Text(
                      style: TextStyle(
                          color: isEnabled ? null : theme.disabledColor),
                      MaterialLocalizations.of(context).deleteButtonTooltip),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllLogs(BuildContext context) async {
    // The dialog above asked the person; the action wants it said again.
    await runWithProgress(
        context,
        (update) => AppActions.instance.run(
            'entry.erase_all', {'confirm': eraseAllPhrase},
            confirmed: true, progress: update));
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsStorageTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SettingsDropdown<String>(
              title: AppLocalizations.of(context)!.settingsImageQuality,
              value: configProvider.get(Settings.imageQualityLevel),
              options: [
                DropdownMenuItem<String>(
                    value: ImageQuality.noCompression,
                    child: Text(AppLocalizations.of(context)!
                        .imageQualityNoCompression)),
                DropdownMenuItem<String>(
                    value: ImageQuality.high,
                    child:
                        Text(AppLocalizations.of(context)!.imageQualityHigh)),
                DropdownMenuItem<String>(
                    value: ImageQuality.medium,
                    child:
                        Text(AppLocalizations.of(context)!.imageQualityMedium)),
                DropdownMenuItem<String>(
                    value: ImageQuality.low,
                    child: Text(AppLocalizations.of(context)!.imageQualityLow)),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  changeSetting(Settings.imageQualityLevel, newValue);
                }
              }),
          FutureBuilder(
              future: AppDatabase.instance.getInternalPath(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var folderText = snapshot.data!;
                  if (AppDatabase.instance.usingExternalLocation()) {
                    folderText = StoragePicker.displayName(
                        configProvider.get(Settings.externalDbUri));
                  }
                  return SettingsIconAction(
                    title: AppLocalizations.of(context)!.settingsLogFolder,
                    hint: folderText,
                    icon: Icon(Icons.folder_rounded),
                    secondaryIcon: Icon(Icons.refresh_rounded),
                    onPressed: () async {
                      if (Platform.isAndroid &&
                          !await requestStoragePermission()) {
                        return;
                      }
                      await _showChangeLogFolderWarning();
                    },
                    onSecondaryPressed: () async {
                      await AppDatabase.instance.resetExternalLocation();
                    },
                  );
                }
                return const SizedBox();
              }),
          FutureBuilder(
              future: ImageStorage.instance.getInternalFolder(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var folderText = snapshot.data!;
                  if (ImageStorage.instance.usingExternalLocation()) {
                    folderText = StoragePicker.displayName(
                        configProvider.get(Settings.externalImgUri));
                  }
                  return SettingsIconAction(
                    title: AppLocalizations.of(context)!.settingsImageFolder,
                    hint: folderText,
                    icon: Icon(Icons.folder_rounded),
                    secondaryIcon: Icon(Icons.refresh_rounded),
                    onPressed: () async {
                      if (Platform.isAndroid &&
                          !await requestPhotosPermission()) {
                        return;
                      }
                      await _attemptImageFolderChange();
                    },
                    onSecondaryPressed: () async {
                      await ImageStorage.instance.resetImageFolderLocation();
                    },
                  );
                }
                return const SizedBox();
              }),
          SettingsIconAction(
              title: AppLocalizations.of(context)!.settingsDeleteAllLogsTitle,
              icon: Icon(Icons.delete_forever_rounded),
              onPressed: () => _showDeleteAllLogsDialog(
                  context,
                  AppLocalizations.of(context)!.settingsDeleteAllLogsTitle,
                  () => _deleteAllLogs(context))),
        ],
      ),
    );
  }
}
