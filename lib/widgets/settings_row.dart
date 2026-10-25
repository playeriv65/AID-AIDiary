// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// One row of a settings list, as every settings row is laid out: an
/// optional icon, the title with an optional hint below it, and the control
/// at the end. The whole row takes the tap.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.hint,
    this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? hint;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(icon),
            ),
      title: Text(title),
      subtitle: hint == null ? null : Text(hint!),
      minVerticalPadding: icon == null ? null : 18,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
