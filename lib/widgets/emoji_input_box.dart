// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Asks for one emoji or character as an icon (moods, tags, categories):
/// the prompt above one large square field.
class EmojiInputBox extends StatelessWidget {
  const EmojiInputBox({
    super.key,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.moodIconPrompt,
            style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card.filled(
          color: theme.colorScheme.surfaceContainerHighest,
          child: SizedBox(
            width: 96,
            height: 96,
            child: Center(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: autofocus,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: theme.textTheme.headlineLarge,
                inputFormatters: [LengthLimitingTextInputFormatter(1)],
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                decoration: const InputDecoration(
                    hintText: '?', border: InputBorder.none),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
