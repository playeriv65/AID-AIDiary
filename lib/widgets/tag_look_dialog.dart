// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/utils/tag_look.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:aid_diary/widgets/color_picker_dialog.dart';
import 'package:aid_diary/widgets/color_swatch_row.dart';
import 'package:aid_diary/widgets/confirm_dialog.dart';
import 'package:aid_diary/widgets/icon_name_row.dart';
import 'package:aid_diary/widgets/icon_picker_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// How a [TagLookDialog] deletes the item it edits: the question it asks
/// first, then what it runs.
typedef TagLookDelete = ({String message, Future<void> Function() run});

/// The dialog the tag and category editors are: [title] with a delete
/// button for an item that exists, the icon and name, the color, the
/// editor's own [fields], then Cancel and OK.
///
/// OK (or Enter in the name) calls [save] with the sanitized name and the
/// look. Names are unique: when [save] throws an `exists` ActionException,
/// [nameTaken] shows at the field and the dialog stays open.
class TagLookDialog extends StatefulWidget {
  const TagLookDialog({
    super.key,
    required this.title,
    required this.initialName,
    required this.initialLook,
    required this.fallbackIcon,
    required this.noColor,
    required this.nameTaken,
    required this.save,
    this.delete,
    this.fields = const [],
  });

  final Widget title;
  final String initialName;
  final TagLook initialLook;

  /// The icon shown while none is chosen.
  final IconData fallbackIcon;

  /// The color shown while none is chosen.
  final Color noColor;
  final String nameTaken;
  final Future<void> Function(String name, TagLook look) save;

  /// Null for an item that does not exist yet; its name field takes the
  /// focus instead.
  final TagLookDelete? delete;
  final List<Widget> fields;

  @override
  State<TagLookDialog> createState() => _TagLookDialogState();
}

class _TagLookDialogState extends State<TagLookDialog> {
  late final _name = TagNameEditingController(text: widget.initialName)
    ..addListener(() => setState(() {}));
  late String? _icon = widget.initialLook.icon;
  late TagIconType _iconType = widget.initialLook.iconType;
  late int? _color = widget.initialLook.color;

  /// The name (lower case) the last save was refused for, as taken.
  String? _refusedName;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String get _sanitized => sanitizeTagName(_name.text);

  Color get _shownColor => _color != null ? Color(_color!) : widget.noColor;

  Future<void> _save() async {
    final name = _sanitized;
    if (name.isEmpty) return;
    try {
      await widget
          .save(name, (color: _color, icon: _icon, iconType: _iconType));
    } on ActionException catch (error) {
      if (error.code != 'exists') rethrow;
      // Say so at the field instead of making a twin.
      if (mounted) setState(() => _refusedName = name.toLowerCase());
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete(TagLookDelete delete) async {
    final confirmed =
        await showDeleteConfirmDialog(context, message: delete.message);
    if (!confirmed || !mounted) return;
    await delete.run();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickIcon() async {
    final result = await showDialog<IconPickerResult>(
      context: context,
      builder: (_) => IconPickerDialog(previewColor: _shownColor),
    );
    if (result != null) {
      setState(() {
        _icon = result.value;
        _iconType = result.type;
      });
    }
  }

  Future<void> _pickColor() async {
    final result = await showDialog<ColorPickerResult>(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: _color != null ? Color(_color!) : null,
        showNoneOption: true,
      ),
    );
    if (result != null) setState(() => _color = result.color?.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    final delete = widget.delete;
    final width = (MediaQuery.sizeOf(context).width - 80).clamp(280.0, 400.0);
    return Dialog(
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(
                  child: DefaultTextStyle.merge(
                      style: Theme.of(context).textTheme.headlineSmall,
                      child: widget.title),
                ),
                if (delete != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_rounded),
                    tooltip: material.deleteButtonTooltip,
                    onPressed: () => _delete(delete),
                  ),
              ]),
              const SizedBox(height: 12),
              IconNameRow(
                icon: _icon,
                iconType: _iconType,
                fallbackIcon: widget.fallbackIcon,
                color: _shownColor,
                onPickIcon: _pickIcon,
                onClearIcon: () => setState(() {
                  _icon = null;
                  _iconType = TagIconType.character;
                }),
                nameController: _name,
                nameHint: l10n.nameHint,
                nameError: _refusedName == _sanitized.toLowerCase()
                    ? widget.nameTaken
                    : null,
                autofocus: delete == null,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ColorSwatchRow(
                  label: l10n.tagColorLabel,
                  color: _shownColor,
                  onTap: _pickColor,
                ),
              ),
              for (final field in widget.fields) ...[
                const SizedBox(height: 8),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: field),
              ],
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(material.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: _sanitized.isEmpty ? null : _save,
                  child: Text(material.okButtonLabel),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
