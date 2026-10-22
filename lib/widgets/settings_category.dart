// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/routing/destinations.dart';
import 'package:material_ui/material_ui.dart';

class SettingsCategory extends StatelessWidget {
  final String title;
  final String? hint;
  final IconData icon;

  /// The place it opens, from `destinations.dart`.
  final String destination;

  const SettingsCategory({
    super.key,
    required this.title,
    this.hint,
    required this.icon,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
      ),
      subtitle: hint != null ? Text(hint!) : null,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
        child: Icon(
          icon,
        ),
      ),
      minVerticalPadding: 18,
      onTap: () => openPlace(context, destination),
    );
  }
}
