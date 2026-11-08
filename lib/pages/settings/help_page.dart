// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:material_ui/material_ui.dart';

/// Help: frequently asked questions, the privacy note, then
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: SectionLabel(text));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHelpTitle)),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        SettingsCategory(
          key: const ValueKey('help-feedback'),
          icon: Icons.feedback_outlined,
          title: l10n.feedbackTitle,
          destination: 'settings/feedback',
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
        SettingsCategory(
          key: const ValueKey('help-about'),
          icon: Icons.info_outline_rounded,
          title: l10n.settingsAboutTitle,
          destination: 'settings/about',
        ),
      ]),
    );
  }
}
