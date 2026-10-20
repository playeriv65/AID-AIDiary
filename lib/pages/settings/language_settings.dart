// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/language_option.dart';
import 'package:aid_diary/widgets/settings_dropdown.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsLanguageTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          if (Platform.isAndroid &&
              DeviceInfoService().androidSdk != null &&
              DeviceInfoService().androidSdk! >= 33)
            SettingsIconAction(
                title: AppLocalizations.of(context)!.settingsAppLanguageTitle,
                icon: Icon(Icons.language_rounded),
                onPressed: () => AppSettings.openAppSettings(
                    type: AppSettingsType.appLocale)),
          SettingsDropdown<LanguageOption?>(
              title: (Platform.isAndroid &&
                      DeviceInfoService().androidSdk != null &&
                      DeviceInfoService().androidSdk! >= 33)
                  ? AppLocalizations.of(context)!
                      .settingsOverrideAppLanguageTitle
                  : AppLocalizations.of(context)!.settingsAppLanguageTitle,
              value: LanguageOption.fromJsonOrNull(
                  configProvider.get(Settings.overrideLanguage)),
              options: [
                DropdownMenuItem(
                    value: null,
                    child: Text(AppLocalizations.of(context)!.themeSystem)),
                for (var locale in AppLocalizations.supportedLocales)
                  DropdownMenuItem(
                      value: LanguageOption.fromLocale(locale),
                      child:
                          Text(LanguageOption.fromLocale(locale).displayName()))
              ],
              onChanged: (LanguageOption? newValue) {
                configProvider.set(
                    Settings.overrideLanguage, newValue?.toJson());
              }),
        ],
      ),
    );
  }
}
