// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:aid_diary/widgets/settings_row.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class SettingsToggle extends StatelessWidget {
  final String title;
  final String? hint;
  final Setting<bool> setting;
  final Function(bool)? onChanged;
  final Icon? secondaryIcon;
  final Function()? onSecondaryPressed;

  const SettingsToggle({
    super.key,
    required this.title,
    this.hint,
    required this.setting,
    required this.onChanged,
    this.secondaryIcon,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final value = configProvider.get(setting);
    final change = onChanged;
    final toggle = change == null
        ? null
        : (bool to) {
            Haptics.selection();
            change(to);
          };
    // Tapping anywhere on the row flips the switch.
    return SettingsRow(
      title: title,
      hint: hint,
      onTap: toggle == null ? null : () => toggle(!value),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (secondaryIcon != null && onSecondaryPressed != null)
          IconButton(onPressed: onSecondaryPressed, icon: secondaryIcon!),
        Switch(
          key: ValueKey('${setting.key}-switch'),
          value: value,
          onChanged: toggle,
        ),
      ]),
    );
  }
}
