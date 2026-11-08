// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:aid_diary/widgets/share_selection_page.dart';
import 'package:aid_diary/widgets/tag_picker_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Saves or shares some of the tags.
class ShareTagsDialog extends StatelessWidget {
  const ShareTagsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<TagsProvider>(context).tags;
    return ShareSelectionPage(
      ids: {for (final tag in tags) tag.id!},
      emptyIcon: Icons.local_offer_outlined,
      empty: AppLocalizations.of(context)!.noResults,
      fileKind: 'tags',
      export: TemplatesTagsTransfer.exportTags,
      list: (selected, toggle) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TagPicker(
          mode: TagPickerMode.filter,
          selected: selected,
          onToggle: (tag) => toggle(tag.id!),
        ),
      ),
    );
  }
}
