// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/tag_look.dart';
import 'package:aid_diary/widgets/tag_look_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Makes a category, or changes or deletes [category].
class EditCategory extends StatelessWidget {
  const EditCategory({super.key, this.category});

  final TagCategory? category;

  Future<void> _save(String name, TagLook look) async {
    final category = this.category;
    if (category == null) {
      await AppActions.instance
          .run('category.create', {'name': name, ...tagLookArgs(look)});
    } else {
      await AppActions.instance.run('category.update', {
        'id': category.id,
        'name': name,
        ...tagLookArgs(look, before: (
          color: category.color,
          icon: category.icon,
          iconType: category.iconType
        )),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final category = this.category;
    return TagLookDialog(
      title: Text(
          category == null ? l10n.newCategoryTitle : l10n.tagCategoryLabel),
      initialName: category?.name ?? '',
      initialLook: (
        color: category?.color,
        icon: category?.icon,
        iconType: category?.iconType ?? TagIconType.character
      ),
      fallbackIcon: Icons.folder_rounded,
      noColor: Theme.of(context).colorScheme.onSurface,
      nameTaken: l10n.categoryNameExists,
      save: _save,
      delete: category == null
          ? null
          : (
              message: l10n.deleteCategoryMessage(
                  TagsProvider.instance.tags
                      .where((tag) => tag.categoryId == category.id)
                      .length,
                  category.name),
              run: () => AppActions.instance
                  .run('category.delete', {'id': category.id}, confirmed: true),
            ),
    );
  }
}
