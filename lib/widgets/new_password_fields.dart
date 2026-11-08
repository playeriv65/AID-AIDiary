// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// A new password typed twice, the same way for the app lock, the backup
/// password and a sync recovery password. Inside a [Form], it accepts a
/// password of at least [minLength] characters (spaces at either end do
/// not count) typed the same both times.
class NewPasswordFields extends StatelessWidget {
  const NewPasswordFields({
    super.key,
    required this.password,
    required this.repeat,
    required this.minLength,
    required this.label,
    required this.repeatLabel,
    this.obscure = true,
    this.fieldKey,
    this.repeatKey,
  });

  final TextEditingController password;
  final TextEditingController repeat;
  final int minLength;
  final String label;
  final String repeatLabel;

  /// Whether the typed characters are hidden.
  final bool obscure;
  final Key? fieldKey;
  final Key? repeatKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    InputDecoration decoration(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextFormField(
        key: fieldKey,
        controller: password,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        decoration: decoration(label),
        validator: (value) => (value ?? '').trim().length < minLength
            ? l10n.passwordTooShort(minLength)
            : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        key: repeatKey,
        controller: repeat,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        decoration: decoration(repeatLabel),
        validator: (value) => value != password.text
            ? l10n.settingsSecurityPasswordsDoNotMatch
            : null,
      ),
    ]);
  }
}
