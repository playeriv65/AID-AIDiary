// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/color_picker_dialog.dart';
import 'package:aid_diary/widgets/color_swatch_row.dart';
import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/widgets/icon_name_row.dart';
import 'package:aid_diary/widgets/icon_picker_dialog.dart';
import 'package:aid_diary/utils/tag_look.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';

class EditCategory extends StatefulWidget {
  final TagCategory? category;

  const EditCategory({super.key, this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late TagNameEditingController _nameController;
  String? _icon;
  TagIconType _iconType = TagIconType.character;
  int? _color;

  /// The name (lower case) the last save was refused for, as taken.
  String? _refusedName;

  @override
  void initState() {
    super.initState();
    _nameController =
        TagNameEditingController(text: widget.category?.name ?? '');
    _icon = widget.category?.icon;
    _iconType = widget.category?.iconType ?? TagIconType.character;
    _color = widget.category?.color;
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = sanitizeTagName(_nameController.text);
    if (name.isEmpty) return;

    final category = widget.category;
    final look = (color: _color, icon: _icon, iconType: _iconType);
    try {
      if (category == null) {
        await AppActions.instance.run('category.create', {
          'name': name,
          ...tagLookArgs(look),
        });
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
    } on ActionException catch (error) {
      if (error.code != 'exists') rethrow;
      // Names stay unique: say so at the field instead of making a twin.
      if (mounted) setState(() => _refusedName = name.toLowerCase());
      return;
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final category = widget.category;
    if (category == null) return;
    final l10n = AppLocalizations.of(context)!;
    final tagCount = TagsProvider.instance.tags
        .where((tag) => tag.categoryId == category.id)
        .length;
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.deleteCategoryMessage(tagCount, category.name),
    );
    if (confirmed && mounted) {
      await AppActions.instance
          .run('category.delete', {'id': category.id}, confirmed: true);
      if (mounted) Navigator.of(context).pop();
    }
  }

  Color _effectiveColor(BuildContext context) =>
      _color != null ? Color(_color!) : Theme.of(context).colorScheme.onSurface;

  Future<void> _showIconPicker() async {
    final result = await showDialog<IconPickerResult>(
      context: context,
      builder: (context) => IconPickerDialog(
        previewColor: _effectiveColor(context),
      ),
    );
    if (result != null) {
      setState(() {
        _icon = result.value;
        _iconType = result.type;
      });
    }
  }

  Future<void> _showColorPicker() async {
    final result = await showDialog<ColorPickerResult>(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: _color != null ? Color(_color!) : null,
        showNoneOption: true,
      ),
    );
    if (result != null) {
      setState(() => _color = result.color?.toARGB32());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(widget.category == null
                ? l10n.newCategoryTitle
                : l10n.tagCategoryLabel),
          ),
          if (widget.category != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_rounded),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconNameRow(
              icon: _icon,
              iconType: _iconType,
              fallbackIcon: Icons.folder_rounded,
              color: _effectiveColor(context),
              onPickIcon: _showIconPicker,
              onClearIcon: () => setState(() {
                _icon = null;
                _iconType = TagIconType.character;
              }),
              nameController: _nameController,
              nameHint: l10n.nameHint,
              nameError: _refusedName ==
                      sanitizeTagName(_nameController.text).toLowerCase()
                  ? l10n.categoryNameExists
                  : null,
              autofocus: widget.category == null,
              onSubmitted: (_) => sanitizeTagName(_nameController.text).isEmpty
                  ? null
                  : _save(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ColorSwatchRow(
                label: l10n.tagColorLabel,
                color: _effectiveColor(context),
                onTap: _showColorPicker,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed:
              sanitizeTagName(_nameController.text).isEmpty ? null : _save,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
