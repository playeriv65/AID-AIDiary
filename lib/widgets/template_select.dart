// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/pages/settings/templates_page.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Featured templates as cards, then the user's own templates.
class TemplateSelect extends StatelessWidget {
  final Function(Template template) onTemplatesSelected;

  const TemplateSelect({super.key, required this.onTemplatesSelected});

  void _pick(BuildContext context, Template template) {
    onTemplatesSelected(template);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final templates = context.watch<TemplatesProvider>().templates;
    final featured = BuiltinTemplate.all(l10n);

    return AlertDialog(
      title: Text(l10n.templatePickerTitle),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionLabel(l10n.templateFeatured),
              SizedBox(
                height: 132,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final template = featured[index];
                    return SizedBox(
                      width: 180,
                      child: Card.filled(
                        margin: EdgeInsets.zero,
                        color: cs.secondaryContainer,
                        child: InkWell(
                          key: ValueKey('template-featured-${template.id}'),
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _pick(context, template.toTemplate()),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.description_outlined,
                                    color: cs.onSecondaryContainer),
                                const SizedBox(height: 8),
                                Text(template.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                        color: cs.onSecondaryContainer,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(template.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: cs.onSecondaryContainer)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SectionLabel(l10n.templateMine),
              if (templates.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(l10n.noTemplatesDescription,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: cs.outline)),
                )
              else
                for (final template in templates)
                  ListTile(
                    key: ValueKey('template-mine-${template.id}'),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.article_outlined),
                    title: Text(template.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.add_rounded),
                    onTap: () => _pick(context, template),
                  ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.edit_document),
          label: Text(l10n.manageTemplates),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              allowSnapshotting: false,
              fullscreenDialog: true,
              builder: (context) => const TemplateSettings())),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }
}
