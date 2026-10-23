// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:material_ui/material_ui.dart';

/// Help like Journey's: frequently asked questions, the privacy note, then
/// about the app. Everything answers offline.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final faq = [
      (l10n.helpFaq1Q, l10n.helpFaq1A),
      (l10n.helpFaq2Q, l10n.helpFaq2A),
      (l10n.helpFaq3Q, l10n.helpFaq3A),
      (l10n.helpFaq4Q, l10n.helpFaq4A),
      (l10n.helpFaq5Q, l10n.helpFaq5A),
    ];
    Widget header(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(text.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.4, color: theme.colorScheme.primary)),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHelpTitle)),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        ListTile(
          key: const ValueKey('help-feedback'),
          leading: const Icon(Icons.feedback_outlined),
          title: Text(l10n.feedbackTitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openPlace(context, 'settings/feedback'),
        ),
        header(l10n.helpFaq),
        for (final (index, (question, answer)) in faq.indexed)
          ExpansionTile(
            key: ValueKey('help-faq-$index'),
            title: Text(question),
            shape: const Border(),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            children: [Text(answer, style: theme.textTheme.bodyMedium)],
          ),
        header(l10n.helpPrivacy),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(l10n.helpPrivacyText, style: theme.textTheme.bodyMedium),
        ),
        const Divider(),
        ListTile(
          key: const ValueKey('help-about'),
          leading: const Icon(Icons.info_outline_rounded),
          title: Text(l10n.settingsAboutTitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openPlace(context, 'settings/about'),
        ),
      ]),
    );
  }
}
