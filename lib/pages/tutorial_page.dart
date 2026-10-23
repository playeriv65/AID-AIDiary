// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Read-only help, shared by first-run setup and the settings destination.
class TutorialPage extends StatelessWidget {
  const TutorialPage(
      {super.key, this.onBack, this.onComplete, this.busy = false});

  final VoidCallback? onBack;
  final VoidCallback? onComplete;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = [
      (
        Icons.edit_note_rounded,
        l10n.tutorialWriteTitle,
        l10n.tutorialWriteText
      ),
      (
        Icons.add_photo_alternate_outlined,
        l10n.tutorialMediaTitle,
        l10n.tutorialMediaText
      ),
      (Icons.search_rounded, l10n.tutorialReviewTitle, l10n.tutorialReviewText),
      (Icons.sync_rounded, l10n.tutorialSyncTitle, l10n.tutorialSyncText),
      (
        Icons.lock_outline_rounded,
        l10n.tutorialPrivacyTitle,
        l10n.tutorialPrivacyText
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tutorialTitle),
        leading: onBack == null
            ? null
            : IconButton(
                key: const ValueKey('tutorial-back'),
                onPressed: busy ? null : onBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const BackButtonIcon(),
              ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            key: const ValueKey('tutorial-content'),
            padding: const EdgeInsets.all(16),
            children: [
              for (final (icon, title, text) in sections)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(icon,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)),
                        ]),
                        const SizedBox(height: 12),
                        Text(text,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: onComplete == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const ValueKey('tutorial-start'),
                        onPressed: busy ? null : onComplete,
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(l10n.onboardStart)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
