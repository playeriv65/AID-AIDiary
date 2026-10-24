// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

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

    // Laid out as a SettingsCategory row, so a list of both lines up.
    if (leadingIcon != null) {
      return ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(leadingIcon),
        ),
        title: Text(title),
        minVerticalPadding: 18,
        trailing: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140), child: dropdown),
      );
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          dropdown,
        ],
      ),
    );
  }
}
