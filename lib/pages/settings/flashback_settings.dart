// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/widgets/settings_header.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class FlashbackSettings extends StatefulWidget {
  const FlashbackSettings({super.key});

  @override
  State<FlashbackSettings> createState() => _FlashbackSettingsPageState();
}

class _FlashbackSettingsPageState extends State<FlashbackSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsStoriesTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SettingsToggle(
              key: const ValueKey('settings-routine-prompts'),
              title: AppLocalizations.of(context)!.settingsRoutinePrompts,
              hint: AppLocalizations.of(context)!.settingsRoutinePromptsHint,
              setting: Settings.routinePrompts,
              onChanged: (value) =>
                  changeSetting(Settings.routinePrompts, value)),
          SettingsToggle(
              title: AppLocalizations.of(context)!.settingsShowFlashbacks,
              setting: Settings.showFlashbacks,
              onChanged: (value) =>
                  changeSetting(Settings.showFlashbacks, value)),
          if (configProvider.get(Settings.showFlashbacks))
            SettingsToggle(
                title: AppLocalizations.of(context)!
                    .settingsFlashbacksExcludeBadDays,
                setting: Settings.excludeBadDaysFromFlashbacks,
                onChanged: (value) => changeSetting(
                    Settings.excludeBadDaysFromFlashbacks, value)),
          if (configProvider.get(Settings.showFlashbacks))
            ...buildFlashbackOptions(configProvider),
        ],
      ),
    );
  }

  List<Widget> buildFlashbackOptions(ConfigProvider configProvider) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child:
            SettingsHeader(text: AppLocalizations.of(context)!.flashbacksTitle),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Divider(),
      ),
      for (final (setting, title) in [
        (
          Settings.showflashbackYearsAgo,
          AppLocalizations.of(context)!.flashbackOnThisDay
        ),
        (
          Settings.showflashback6MonthsAgo,
          AppLocalizations.of(context)!.flashbackMonth(6)
        ),
        (
          Settings.showflashback1MonthAgo,
          AppLocalizations.of(context)!.flashbackMonth(1)
        ),
        (
          Settings.showflashback1WeekAgo,
          AppLocalizations.of(context)!.flashbackWeek(1)
        ),
        (
          Settings.showflashbackGoodDay,
          AppLocalizations.of(context)!.flashbackGoodDay
        ),
        (
          Settings.showflashbackRandomDay,
          AppLocalizations.of(context)!.flashbackRandomDay
        ),
      ])
        SettingsToggle(
            title: title,
            setting: setting,
            onChanged: (value) => changeSetting(setting, value)),
    ];
  }
}
