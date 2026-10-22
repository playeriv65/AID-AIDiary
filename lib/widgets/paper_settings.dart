// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/letter_paper.dart';
import 'package:aid_diary/widgets/settings_dropdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class PaperSettings extends StatelessWidget {
  const PaperSettings({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = context.watch<ConfigProvider>();
    final styles = {
      'plain': l10n.paperPlain,
      'lined': l10n.paperLined,
      'grid': l10n.paperGrid,
      'tinted': l10n.paperTinted
    };
    final decorations = {
      'none': l10n.paperDecorationNone,
      'botanical': l10n.paperDecorationBotanical,
      'stars': l10n.paperDecorationStars,
      'washi': l10n.paperDecorationWashi
    };
    return Column(children: [
      SettingsDropdown<String>(
          title: l10n.paperTitle,
          value: config.get(Settings.paperStyle),
          options: [
            for (final option in styles.entries)
              DropdownMenuItem(value: option.key, child: Text(option.value))
          ],
          onChanged: (value) {
            if (value != null) changeSetting(Settings.paperStyle, value);
          }),
      SettingsDropdown<String>(
          title: l10n.paperDecorationTitle,
          value: config.get(Settings.paperDecoration),
          options: [
            for (final option in decorations.entries)
              DropdownMenuItem(value: option.key, child: Text(option.value))
          ],
          onChanged: (value) {
            if (value != null) changeSetting(Settings.paperDecoration, value);
          }),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LetterPaper(
                  child: SizedBox(
                      height: 108,
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(l10n.themeColorPreview,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge))))))),
    ]);
  }
}
