// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/settings_row.dart';
import 'package:material_ui/material_ui.dart';

class SettingsDropdown<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<DropdownMenuItem<T>> options;
  final Function(T?) onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final IconData? leadingIcon;

  const SettingsDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    this.selectedItemBuilder,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Beside an icon and title, a button as wide as its widest choice (a
    // long language name) would leave the title too little room.
    final dropdown = DropdownButton<T>(
        underline: Container(),
        elevation: 1,
        isDense: true,
        isExpanded: leadingIcon != null,
        alignment: AlignmentDirectional.centerEnd,
        borderRadius: BorderRadius.circular(20),
        value: value,
        items: options,
        selectedItemBuilder: selectedItemBuilder ??
            (leadingIcon == null
                ? null
                : (_) => [
                      for (final option in options)
                        Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: option.child),
                    ]),
        onChanged: onChanged);

    // Beside an icon the choice gets a bounded width, as in a category row.
    return SettingsRow(
      title: title,
      icon: leadingIcon,
      trailing: leadingIcon == null
          ? dropdown
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: dropdown),
    );
  }
}
