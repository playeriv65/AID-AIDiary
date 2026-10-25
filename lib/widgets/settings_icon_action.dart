// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/settings_row.dart';
import 'package:material_ui/material_ui.dart';

class SettingsIconAction extends StatelessWidget {
  final String title;
  final String? hint;
  final Icon icon;
  final Icon? secondaryIcon;
  final Function() onPressed;
  final Function()? onSecondaryPressed;

  const SettingsIconAction(
      {super.key,
      required this.title,
      this.hint,
      required this.icon,
      this.secondaryIcon,
      required this.onPressed,
      this.onSecondaryPressed});

  @override
  Widget build(BuildContext context) {
    // The whole row is the target; the icon only marks the action.
    return SettingsRow(
      title: title,
      hint: hint,
      onTap: onPressed,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: onPressed, icon: icon),
        if (secondaryIcon != null && onSecondaryPressed != null)
          IconButton(onPressed: onSecondaryPressed, icon: secondaryIcon!),
      ]),
    );
  }
}
