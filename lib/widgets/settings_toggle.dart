// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
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
    // Tapping anywhere on the row flips the switch, as in a list tile.
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (hint != null)
                    Text(
                      hint!,
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
            if (secondaryIcon != null && onSecondaryPressed != null)
              IconButton(onPressed: onSecondaryPressed, icon: secondaryIcon!),
            Switch(
              key: ValueKey('${setting.key}-switch'),
              value: value,
              onChanged: onChanged,
            )
          ],
        ),
      ),
    );
  }
}
