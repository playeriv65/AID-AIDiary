// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// One row of [showChoiceSheet]: what choosing it returns, how it looks
/// and the key tests find it by.
typedef Choice<T> = ({T value, IconData icon, String label, Key? key});

/// Asks which of [choices] to take, the same way everywhere: a bottom sheet
/// with an optional [title] and one row per choice. Null when dismissed.
Future<T?> showChoiceSheet<T>(BuildContext context, List<Choice<T>> choices,
        {String? title}) =>
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child:
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
              ),
            for (final choice in choices)
              ListTile(
                key: choice.key,
                leading: Icon(choice.icon),
                title: Text(choice.label),
                onTap: () => Navigator.of(context).pop(choice.value),
              ),
          ],
        ),
      ),
    );
