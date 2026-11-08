// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/entry_actions.dart' show eraseAllPhrase;
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/widgets/cloud_traffic_notice.dart'
    show formatCloudTrafficBytes;
import 'package:aid_diary/widgets/settings_toggle.dart';
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

  /// Storage access for picking a folder, which Android before 13 asks
  /// for; newer versions grant it through the folder picker.
  Future<bool> _requestStoragePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) return true;
    final status = await Permission.storage.status;
    return status.isGranted || (await Permission.storage.request()).isGranted;
  }

  Future<void> _showChangeLogFolderWarning() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(context,
        title: l10n.warningTitle,
        message: l10n.logFolderWarningDescription,
        confirm: MaterialLocalizations.of(context).okButtonLabel);
    if (!confirmed || !mounted) return;
    await runOperation(context, AppDatabase.instance.selectExternalLocation,
        failureDescription: l10n.logFolderErrorDescription);
  }

  /// Compresses the photos already in the diary, once, after saying that
  /// it cannot be undone.
  Future<void> _compressExisting() async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    Map<String, Object?>? count;
    await runOperation(context, (_) async {
      count = (await AppActions.instance.run('media.photo_count', {}))!
          as Map<String, Object?>;
      return const OperationOutcome.succeeded();
    }, failureDescription: l10n.compressExistingTitle);
    final photos = count;
    if (photos == null || !mounted) return;
    final sure = await showConfirmDialog(context,
        title: l10n.compressExistingTitle,
        message: l10n.compressExistingBody(photos['photos'] as int,
            formatCloudTrafficBytes(photos['bytes'] as int, locale)),
        confirm: l10n.compressExistingAction,
        confirmKey: const ValueKey('compress-existing-confirm'));
    if (!sure || !mounted) return;
    Map<String, Object?>? result;
    await runOperation(context, (update) async {
      result = (await AppActions.instance.run('media.compress_all', {},
          confirmed: true, progress: update))! as Map<String, Object?>;
      return const OperationOutcome.succeeded();
    }, failureDescription: l10n.compressExistingTitle);
    final done = result;
    if (done == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.compressExistingDone(done['compressed'] as int,
            formatCloudTrafficBytes(done['savedBytes'] as int, locale)))));
  }

  Future<void> _attemptImageFolderChange() async {
    await runOperation(context, ImageStorage.instance.selectExternalLocation,
        failureDescription:
            AppLocalizations.of(context)!.imageFolderErrorDescription);
  }

  /// Erases every entry once the person has typed the dialog's title.
  Future<void> _deleteAllLogs(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final phrase = l10n.settingsDeleteAllLogsTitle;
    final confirmed = await showConfirmDialog(context,
        title: phrase,
        message: '${l10n.settingsDeleteAllLogsDescription}\n'
            '${l10n.settingsDeleteAllLogsPrompt(phrase)}',
        confirm: MaterialLocalizations.of(context).deleteButtonTooltip,
        destructive: true,
        confirmKey: const ValueKey('delete-all-logs-confirm'),
        phrase: phrase);
    if (!confirmed || !context.mounted) return;
    await runOperation(context, (update) async {
      // The dialog above asked the person; the action wants it said again.
      await AppActions.instance.run(
          'entry.erase_all', {'confirm': eraseAllPhrase},
          confirmed: true, progress: update);
      return const OperationOutcome.succeeded();
    },
        failureDescription:
            AppLocalizations.of(context)!.settingsDeleteAllLogsTitle);
  }

  /// Keeps the diary ([target] `database`) or its photos (`images`) on the
  /// device only again.
  Future<void> _resetFolder(String target, String failureDescription) =>
      runOperation(context, (_) async {
        await AppActions.instance.run('storage.reset', {'target': target});
        return const OperationOutcome.succeeded();
      }, failureDescription: failureDescription);

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
          SettingsToggle(
            key: const ValueKey('settings-compress-photos'),
            title: AppLocalizations.of(context)!.settingsCompressPhotos,
            hint: AppLocalizations.of(context)!.settingsCompressPhotosHint,
            setting: Settings.compressPhotos,
            onChanged: (value) => changeSetting(Settings.compressPhotos, value),
          ),
          ListTile(
            key: const ValueKey('settings-compress-existing'),
            title: Text(AppLocalizations.of(context)!.compressExistingTitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _compressExisting,
          ),
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
                          !await _requestStoragePermission()) {
                        return;
                      }
                      await _showChangeLogFolderWarning();
                    },
                    onSecondaryPressed: () => _resetFolder(
                        'database',
                        AppLocalizations.of(context)!
                            .logFolderErrorDescription),
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
                          !await _requestStoragePermission()) {
                        return;
                      }
                      await _attemptImageFolderChange();
                    },
                    onSecondaryPressed: () => _resetFolder(
                        'images',
                        AppLocalizations.of(context)!
                            .imageFolderErrorDescription),
                  );
                }
                return const SizedBox();
              }),
          SettingsIconAction(
              title: AppLocalizations.of(context)!.settingsDeleteAllLogsTitle,
              icon: Icon(Icons.delete_forever_rounded),
              onPressed: () => _deleteAllLogs(context)),
        ],
      ),
    );
  }
}
