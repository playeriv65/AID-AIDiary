// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/utils/tag_look.dart';
import 'package:aid_diary/widgets/connected_button_group.dart';
import 'package:aid_diary/widgets/tag_look_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Makes a tag, or changes or deletes [tag]: besides the name and look,
/// its kind (chosen once, when it is made) and its category.
class EditTag extends StatefulWidget {
  final Tag? tag;
  final String? initialName;

  const EditTag({super.key, this.tag, this.initialName});

  @override
  State<EditTag> createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  late TagType _tagType = widget.tag?.tagType ?? TagType.label;
  late int? _categoryId = widget.tag?.categoryId;

  Future<void> _save(String name, TagLook look) async {
    final tag = widget.tag;
    if (tag == null) {
      await AppActions.instance.run('tag.create', {
        'name': name,
        'type': _tagType.name,
        ...tagLookArgs(look),
        if (_categoryId != null) 'category': '$_categoryId',
      });
    } else {
      await AppActions.instance.run('tag.update', {
        'id': tag.id,
        'name': name,
        ...tagLookArgs(look,
            before: (color: tag.color, icon: tag.icon, iconType: tag.iconType)),
        // A tag may leave its category, which a missing argument would not.
        'category': _categoryId == null ? 'none' : '$_categoryId',
      });
    }
  }

  Future<void> _createCategory(BuildContext context) async {
    final before = {for (final c in TagsProvider.instance.categories) c.id};
    await OrganizeNavigation.editCategory(context, null);
    final made = TagsProvider.instance.categories
        .where((c) => !before.contains(c.id))
        .firstOrNull;
    if (made != null && mounted) setState(() => _categoryId = made.id);
  }

  /// The kind: chosen while the tag is new, shown once it exists.
  Widget _type(AppLocalizations l10n) {
    final tag = widget.tag;
    if (tag == null) {
      return ConnectedButtonGroup(
        labels: [l10n.tagTypeLabelTitle, l10n.tagTypeTrackerTitle],
        selectedIndex: _tagType == TagType.label ? 0 : 1,
        onSelectionChanged: (index) => setState(
            () => _tagType = index == 0 ? TagType.label : TagType.tracker),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        side: BorderSide.none,
        label: Text(switch (tag.tagType) {
          TagType.label => l10n.tagTypeLabelTitle,
          TagType.tracker => l10n.tagTypeTrackerTitle,
        }),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _category(BuildContext context, List<TagCategory> categories) {
    final l10n = AppLocalizations.of(context)!;
    DropdownMenuItem<int?> item(int? value, Widget child) => DropdownMenuItem(
        value: value, alignment: AlignmentDirectional.centerEnd, child: child);
    Text name(String text) =>
        Text(text, overflow: TextOverflow.fade, softWrap: false, maxLines: 1);
    return Row(children: [
      Text(l10n.tagCategoryLabel,
          style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(width: 8),
      Expanded(
        child: DropdownButton<int?>(
          value: _categoryId,
          isDense: true,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          elevation: 1,
          borderRadius: BorderRadius.circular(20),
          alignment: AlignmentDirectional.centerEnd,
          onChanged: (value) async {
            if (value == -1) {
              await _createCategory(context);
            } else {
              setState(() => _categoryId = value);
            }
          },
          items: [
            item(null, name(l10n.noTemplateTitle)),
            for (final c in categories) item(c.id, name(c.name)),
            item(
                -1,
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.add, size: 16),
                  const SizedBox(width: 6),
                  name(l10n.newCategoryTitle),
                ])),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tag = widget.tag;
    return TagLookDialog(
      title: _type(l10n),
      initialName: tag?.name ?? widget.initialName ?? '',
      initialLook: (
        color: tag?.color,
        icon: tag?.icon,
        iconType: tag?.iconType ?? TagIconType.character
      ),
      fallbackIcon: _tagType == TagType.tracker
          ? Icons.timeline_rounded
          : Icons.label_rounded,
      noColor: Theme.of(context).colorScheme.secondary,
      nameTaken: l10n.tagNameExists,
      save: _save,
      delete: tag == null
          ? null
          : (
              message: l10n.deleteTagMessage(
                  TagsProvider.instance.entryCountForTag(tag.id!), tag.name),
              run: () => AppActions.instance
                  .run('tag.delete', {'id': tag.id}, confirmed: true),
            ),
      fields: [_category(context, TagsProvider.instance.categories)],
    );
  }
}
