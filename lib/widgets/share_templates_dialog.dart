// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:aid_diary/widgets/share_selection_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Saves or shares some of the templates.
class ShareTemplatesDialog extends StatelessWidget {
  const ShareTemplatesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = Provider.of<TemplatesProvider>(context).templates;
    return ShareSelectionPage(
      ids: {for (final template in templates) template.id!},
      emptyIcon: Icons.description_outlined,
      empty: AppLocalizations.of(context)!.noTemplatesDescription,
      fileKind: 'templates',
      export: TemplatesTagsTransfer.exportTemplates,
      list: (selected, toggle) => ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return CheckboxListTile(
            title: Text(template.name, overflow: TextOverflow.ellipsis),
            value: selected.contains(template.id),
            onChanged: (_) => toggle(template.id!),
          );
        },
      ),
    );
  }
}
