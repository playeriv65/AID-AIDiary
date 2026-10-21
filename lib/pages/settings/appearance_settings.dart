// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/widgets/color_picker_dialog.dart';
import 'package:aid_diary/widgets/diary_wallpaper.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/settings_dropdown.dart';
import 'package:aid_diary/widgets/settings_header.dart';
import 'package:aid_diary/widgets/settings_icon_action.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aid_diary/theme_mode_provider.dart';
import 'package:aid_diary/widgets/theme_color_presets.dart';
import 'package:aid_diary/pages/settings/language_settings.dart';
import 'package:aid_diary/pages/settings/tags_settings.dart';
import 'package:aid_diary/pages/settings/templates_page.dart';
import 'package:aid_diary/widgets/settings_category.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettings> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showAccentColorPopup(ThemeModeProvider themeProvider) async {
    final initialColor =
        Color(ConfigProvider.instance.get(Settings.accentColor));
    final result = await showDialog<ColorPickerResult>(
      context: context,
      builder: (context) => ColorPickerDialog(initialColor: initialColor),
    );
    if (result?.color != null) {
      await themeProvider.selectAccentColor(result!.color!);
    }
  }

  void _showMoodEmojiPopup(int? value) {
    String newEmoji = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: MoodIcon(
              moodValue: value,
              size: 32,
            ),
          ),
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
                if (newEmoji.isNotEmpty) {
                  if (value != null) {
                    await ConfigProvider.instance
                        .set(Settings.moodIcons[value]!, newEmoji);
                  }
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.moodIconPrompt,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Card.filled(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Center(
                    child: TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            1), // Limit to one character
                      ],
                      onChanged: (value) {
                        newEmoji = value;
                      },
                      decoration: const InputDecoration(
                        hintText: '?',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _resetMoodIcons() async {
    for (final setting in Settings.moodIcons.values) {
      await ConfigProvider.instance.set(setting, setting.defaultValue);
    }
  }

  Widget moodIconButton(int? index) {
    return GestureDetector(
      child: Card.filled(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                constraints: const BoxConstraints(minWidth: 32),
                child: Center(child: MoodIcon(moodValue: index, size: 24))),
          )),
      onTap: () => _showMoodEmojiPopup(index),
    );
  }

  List<DropdownMenuItem<String>> _buildFirstDayOfWeekDropdownItems(
      BuildContext context) {
    final dayLabels = TimeManager.daysOfWeekLabels(context);
    List<DropdownMenuItem<String>> dropdownItems = List.empty(growable: true);
    dropdownItems.add(DropdownMenuItem<String>(
      value: "system",
      child: Text(AppLocalizations.of(context)!.themeSystem),
    ));

    var dropdownDays = List.generate(7, (index) {
      return DropdownMenuItem<String>(
        value: TimeManager.dayOfWeekIndexMapping[index],
        child: Text(
          dayLabels[index],
        ),
      );
    });
    dropdownItems.addAll(dropdownDays);
    return dropdownItems;
  }

  /// A dropdown over a string setting whose options are [labels]' keys.
  Widget _choice(ConfigProvider configProvider, String key, String title,
      Setting<String> setting, Map<String, String> labels,
      {Future<void> Function(String value)? onChanged}) {
    return SettingsDropdown<String>(
      key: ValueKey(key),
      title: title,
      value: configProvider.get(setting),
      options: [
        for (final MapEntry(key: value, value: label) in labels.entries)
          DropdownMenuItem(value: value, child: Text(label)),
      ],
      onChanged: (value) async {
        if (value == null) return;
        await (onChanged?.call(value) ?? configProvider.set(setting, value));
      },
    );
  }

  List<Widget> _customizeSettings(
      BuildContext context, ConfigProvider configProvider) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _choice(configProvider, 'settings-wallpaper', l10n.settingsWallpaper,
          Settings.wallpaper, {
        WallpaperKind.none.name: l10n.wallpaperNone,
        WallpaperKind.dots.name: l10n.wallpaperDots,
        WallpaperKind.grid.name: l10n.wallpaperGrid,
        WallpaperKind.lines.name: l10n.wallpaperLines,
        WallpaperKind.photo.name: l10n.wallpaperPhoto,
      }, onChanged: (value) async {
        if (value == WallpaperKind.photo.name) {
          await DiaryWallpaper.pickPhoto();
        } else {
          await configProvider.set(Settings.wallpaper, value);
        }
      }),
      _choice(configProvider, 'settings-font-family', l10n.settingsFontFamily,
          Settings.entryFontFamily, {
        'system': l10n.fontSystem,
        'serif': l10n.fontSerif,
        'mono': l10n.fontMono,
      }),
      _choice(configProvider, 'settings-font-size', l10n.settingsFontSize,
          Settings.entryFontSize, {
        'small': l10n.fontSizeSmall,
        'medium': l10n.fontSizeMedium,
        'large': l10n.fontSizeLarge,
        'extraLarge': l10n.fontSizeExtraLarge,
      }),
      _choice(configProvider, 'settings-line-spacing', l10n.settingsLineSpacing,
          Settings.entryLineSpacing, {
        'compact': l10n.lineSpacingCompact,
        'normal': l10n.lineSpacingNormal,
        'relaxed': l10n.lineSpacingRelaxed,
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsGeneralTitle),
        centerTitle: true,
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                children: [
                  SettingsDropdown<String>(
                      title: AppLocalizations.of(context)!.settingsTheme,
                      value: configProvider.get(Settings.theme),
                      options: [
                        DropdownMenuItem<String>(
                            value: "system",
                            child: Text(
                                AppLocalizations.of(context)!.themeSystem)),
                        DropdownMenuItem<String>(
                            value: "dark",
                            child:
                                Text(AppLocalizations.of(context)!.themeDark)),
                        DropdownMenuItem<String>(
                            value: "light",
                            child:
                                Text(AppLocalizations.of(context)!.themeLight)),
                        DropdownMenuItem<String>(
                            value: "amoled",
                            child: Text(
                                AppLocalizations.of(context)!.themeAmoled)),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        ThemeMode themeMode = ThemeMode.system;
                        switch (newValue) {
                          case "system":
                            themeMode = ThemeMode.system;
                            break;
                          case "light":
                            themeMode = ThemeMode.light;
                            break;
                          case "dark":
                          case "amoled":
                            themeMode = ThemeMode.dark;
                            break;
                          default:
                            themeMode = ThemeMode.system;
                            break;
                        }
                        themeProvider.themeMode = themeMode;
                        configProvider.set(Settings.theme, newValue);
                      }),
                  SettingsToggle(
                      title: AppLocalizations.of(context)!
                          .settingsUseSystemAccentColor,
                      setting: Settings.followSystemColor,
                      onChanged: (value) {
                        configProvider.set(Settings.followSystemColor, value);
                        themeProvider.updateAccentColor();
                      }),
                  const ThemeColorPresets(),
                  SettingsIconAction(
                    title:
                        AppLocalizations.of(context)!.settingsCustomAccentColor,
                    icon: Icon(Icons.colorize_rounded),
                    onPressed: () async {
                      _showAccentColorPopup(themeProvider);
                    },
                  ),
                  SettingsToggle(
                    key: const ValueKey('tint-theme-background'),
                    title:
                        AppLocalizations.of(context)!.themeTintBackgroundTitle,
                    hint: AppLocalizations.of(context)!.themeTintBackgroundHint,
                    setting: Settings.tintThemeBackground,
                    onChanged: (value) =>
                        configProvider.set(Settings.tintThemeBackground, value),
                  ),
                  ..._customizeSettings(context, configProvider),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SettingsDropdown<String>(
                        title: AppLocalizations.of(context)!
                            .settingsFirstDayOfWeek,
                        value: configProvider.get(Settings.startingDayOfWeek),
                        options: _buildFirstDayOfWeekDropdownItems(context),
                        onChanged: (String? newValue) async {
                          if (newValue == null) return;
                          await configProvider.set(
                              Settings.startingDayOfWeek, newValue);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SettingsDropdown<String>(
                        title: AppLocalizations.of(context)!
                            .settingsCalendarSystem,
                        value: configProvider.get(Settings.calendarSystem),
                        options: [
                          DropdownMenuItem<String>(
                              value: "system",
                              child: Text(
                                  AppLocalizations.of(context)!.themeSystem)),
                          DropdownMenuItem<String>(
                              value: "gregorian",
                              child: Text(AppLocalizations.of(context)!
                                  .calendarSystemGregorian)),
                          DropdownMenuItem<String>(
                              value: "jalali",
                              child: Text(AppLocalizations.of(context)!
                                  .calendarSystemJalali)),
                        ],
                        onChanged: (String? newValue) async {
                          if (newValue == null) return;
                          await configProvider.set(
                              Settings.calendarSystem, newValue);
                        }),
                  ),
                  SettingsToggle(
                    title: AppLocalizations.of(context)!.settingsHideImages,
                    setting: Settings.hideImagesInGallery,
                    onChanged: (value) =>
                        configProvider.set(Settings.hideImagesInGallery, value),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.settingsChangeMoodIcons,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            moodIconButton(-2),
                            moodIconButton(-1),
                            moodIconButton(0),
                            moodIconButton(1),
                            moodIconButton(2),
                          ],
                        ),
                        IconButton(
                            onPressed: _resetMoodIcons,
                            icon: const Icon(Icons.refresh_rounded))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SettingsDropdown<String>(
                        title: AppLocalizations.of(context)!
                            .settingsTemperatureUnit,
                        value: configProvider.get(Settings.temperatureUnit),
                        options: [
                          DropdownMenuItem<String>(
                              value: 'celsius',
                              child: Text(AppLocalizations.of(context)!
                                  .settingsCelsius)),
                          DropdownMenuItem<String>(
                              value: 'fahrenheit',
                              child: Text(AppLocalizations.of(context)!
                                  .settingsFahrenheit)),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            configProvider.set(Settings.temperatureUnit, value);
                          }
                        }),
                  ),
                  _choice(
                      configProvider,
                      'settings-time-format',
                      AppLocalizations.of(context)!.settingsTimeFormat,
                      Settings.timeFormat, {
                    'system': AppLocalizations.of(context)!.themeSystem,
                    '12': AppLocalizations.of(context)!.timeFormat12,
                    '24': AppLocalizations.of(context)!.timeFormat24,
                  }),
                  SettingsToggle(
                    title: AppLocalizations.of(context)!.settingsLateNight,
                    hint: AppLocalizations.of(context)!.settingsLateNightHint(
                        AppConfig.instance.lateNightUntilHour),
                    setting: Settings.lateNightPreviousDay,
                    onChanged: (value) async {
                      await configProvider.set(
                          Settings.lateNightPreviousDay, value);
                      EntryStore.instance.applyLateNightSetting();
                    },
                  ),
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SettingsHeader(
                        text:
                            AppLocalizations.of(context)!.settingsAutoAddTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: Text(
                        AppLocalizations.of(context)!.settingsAutoAddHint,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  for (final (setting, title) in [
                    (
                      Settings.autoAddLocation,
                      AppLocalizations.of(context)!.settingsAutoAddLocation
                    ),
                    (
                      Settings.autoAddWeather,
                      AppLocalizations.of(context)!.settingsAutoAddWeather
                    ),
                  ])
                    SettingsToggle(
                      title: title,
                      setting: setting,
                      onChanged: (value) => configProvider.set(setting, value),
                    ),
                  const Divider(height: 32),
                  SettingsCategory(
                      title:
                          AppLocalizations.of(context)!.settingsLanguageTitle,
                      icon: Icons.language_rounded,
                      page: const LanguageSettings()),
                  SettingsCategory(
                      title: AppLocalizations.of(context)!.settingsTagsTitle,
                      icon: Icons.local_offer_rounded,
                      page: const TagsSettings()),
                  SettingsCategory(
                      title:
                          AppLocalizations.of(context)!.settingsTemplatesTitle,
                      icon: Icons.description_rounded,
                      page: const TemplateSettings()),
                ],
              ))),
    );
  }
}
