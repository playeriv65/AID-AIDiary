// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/color_picker_dialog.dart';
import 'package:aid_diary/widgets/color_swatch_row.dart';
import 'package:aid_diary/widgets/connected_button_group.dart';
import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/widgets/icon_name_row.dart';
import 'package:aid_diary/widgets/icon_picker_dialog.dart';
import 'package:aid_diary/utils/tag_look.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';

class EditTag extends StatefulWidget {
  final Tag? tag;
  final String? initialName;

  const EditTag({super.key, this.tag, this.initialName});

  @override
  State<EditTag> createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  late TagNameEditingController _nameController;
  late TagType _tagType;
  String? _icon;
  TagIconType _iconType = TagIconType.character;
  int? _color;
  int? _categoryId;

  /// The name (lower case) the last save was refused for, as taken.
  String? _refusedName;

  bool _colorInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TagNameEditingController(
        text: widget.tag?.name ?? widget.initialName ?? '');
    _icon = widget.tag?.icon;
    _iconType = widget.tag?.iconType ?? TagIconType.character;
    _tagType = widget.tag?.tagType ?? TagType.label;
    _categoryId = widget.tag?.categoryId;
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_colorInitialized) {
      _color = widget.tag?.color;
      _colorInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _effectiveColor(BuildContext context) =>
      _color != null ? Color(_color!) : Theme.of(context).colorScheme.secondary;

  Future<void> _save() async {
    final name = sanitizeTagName(_nameController.text);
    if (name.isEmpty) return;

    final tag = widget.tag;
    final look = (color: _color, icon: _icon, iconType: _iconType);
    try {
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
          ...tagLookArgs(look, before: (
            color: tag.color,
            icon: tag.icon,
            iconType: tag.iconType
          )),
          // A tag may leave its category, which a missing argument would not.
          'category': _categoryId == null ? 'none' : '$_categoryId',
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
    final tag = widget.tag;
    if (tag == null) return;
    final l10n = AppLocalizations.of(context)!;
    final entryCount = TagsProvider.instance.entryCountForTag(tag.id!);
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.deleteTagMessage(entryCount, tag.name),
    );
    if (confirmed && mounted) {
      await AppActions.instance
          .run('tag.delete', {'id': tag.id}, confirmed: true);
      if (mounted) Navigator.of(context).pop();
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

  Future<void> _showIconPicker() async {
    final result = await showDialog<IconPickerResult>(
      context: context,
      builder: (context) =>
          IconPickerDialog(previewColor: _effectiveColor(context)),
    );
    if (result != null) {
      setState(() {
        _icon = result.value;
        _iconType = result.type;
      });
    }
  }

  Widget _buildTypeSection(BuildContext context, AppLocalizations l10n) {
    if (widget.tag != null) {
      final typeLabel = switch (widget.tag!.tagType) {
        TagType.label => l10n.tagTypeLabelTitle,
        TagType.tracker => l10n.tagTypeTrackerTitle,
      };
      return Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                side: BorderSide.none,
                label: Text(typeLabel),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_rounded),
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            onPressed: _confirmDelete,
          ),
        ],
      );
    }
    return ConnectedButtonGroup(
      labels: [l10n.tagTypeLabelTitle, l10n.tagTypeTrackerTitle],
      selectedIndex: _tagType == TagType.label ? 0 : 1,
      onSelectionChanged: (selectedIndex) => setState(() =>
          _tagType = selectedIndex == 0 ? TagType.label : TagType.tracker),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final tagColor = _effectiveColor(context);
    final fallbackIcon = _tagType == TagType.tracker
        ? Icons.timeline_rounded
        : Icons.label_rounded;
    return IconNameRow(
      icon: _icon,
      iconType: _iconType,
      fallbackIcon: fallbackIcon,
      color: tagColor,
      onPickIcon: _showIconPicker,
      onClearIcon: () => setState(() {
        _icon = null;
        _iconType = TagIconType.character;
      }),
      nameController: _nameController,
      nameHint: AppLocalizations.of(context)!.nameHint,
      nameError:
          _refusedName == sanitizeTagName(_nameController.text).toLowerCase()
              ? AppLocalizations.of(context)!.tagNameExists
              : null,
      autofocus: widget.tag == null,
    );
  }

  Widget _buildColorRow(BuildContext context) {
    return ColorSwatchRow(
      label: AppLocalizations.of(context)!.tagColorLabel,
      color: _effectiveColor(context),
      onTap: _showColorPicker,
    );
  }

  Future<void> _createCategory(BuildContext context) async {
    final categoriesBefore =
        List<TagCategory>.from(TagsProvider.instance.categories);
    await OrganizeNavigation.editCategory(context, null);
    final newCategory = TagsProvider.instance.categories
        .where((c) => categoriesBefore.every((b) => b.id != c.id))
        .firstOrNull;
    if (newCategory != null && mounted) {
      setState(() => _categoryId = newCategory.id);
    }
  }

  Widget _buildCategoryRow(BuildContext context, List<TagCategory> categories) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(
          l10n.tagCategoryLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
              DropdownMenuItem<int?>(
                value: null,
                alignment: AlignmentDirectional.centerEnd,
                child: Text(l10n.noTemplateTitle,
                    overflow: TextOverflow.fade, softWrap: false, maxLines: 1),
              ),
              ...categories.map(
                (c) => DropdownMenuItem<int?>(
                  value: c.id,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(c.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1),
                ),
              ),
              DropdownMenuItem<int?>(
                value: -1,
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16),
                    const SizedBox(width: 6),
                    Text(l10n.newCategoryTitle,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = TagsProvider.instance.categories;
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = (screenWidth - 80).clamp(280.0, 400.0);
    return Dialog(
      child: SizedBox(
        width: dialogWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSection(context, l10n),
              const SizedBox(height: 12),
              _buildTopRow(context),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildColorRow(context),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildCategoryRow(context, categories),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    onPressed: sanitizeTagName(_nameController.text).isEmpty
                        ? null
                        : _save,
                    child:
                        Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
