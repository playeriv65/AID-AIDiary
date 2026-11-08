// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// One row of [showChoiceSheet]: what choosing it returns, how it looks
/// (an [icon] only where the choices have one each) and the key tests find
/// it by.
typedef Choice<T> = ({T value, IconData? icon, String label, Key? key});

/// Asks which of [choices] to take, the same way everywhere: a bottom sheet
/// with an optional [title] and [message] above one row per choice; the
/// rows scroll when there are many. Null when dismissed.
Future<T?> showChoiceSheet<T>(BuildContext context, List<Choice<T>> choices,
        {String? title, String? message}) =>
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(title, style: theme.textTheme.titleLarge),
                ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final choice in choices)
                      ListTile(
                        key: choice.key,
                        leading: choice.icon == null ? null : Icon(choice.icon),
                        title: Text(choice.label),
                        onTap: () => Navigator.of(context).pop(choice.value),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
