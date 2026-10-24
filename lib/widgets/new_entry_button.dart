// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/quill_icon.dart';
import 'package:material_ui/material_ui.dart';

/// Starts a new entry: a round button with a quill, which says "write"
/// without words; the words stay as its tooltip.
class NewEntryButton extends StatelessWidget {
  const NewEntryButton(
      {super.key,
      required this.heroTag,
      required this.onPressed,
      this.elevation});

  final Object heroTag;
  final VoidCallback? onPressed;
  final double? elevation;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        key: const ValueKey('diary-new-entry'),
        heroTag: heroTag,
        tooltip: AppLocalizations.of(context)!.adaptiveNewEntry,
        elevation: elevation,
        shape: const CircleBorder(),
        onPressed: onPressed,
        child: const QuillIcon(size: 28),
      );
}
