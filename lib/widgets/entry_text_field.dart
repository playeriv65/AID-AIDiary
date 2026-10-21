// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/entry_typography.dart';
import 'package:aid_diary/utils/markdown_preview_styles.dart';
import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:aid_diary/widgets/markdown_preview_controller.dart';
import 'package:aid_diary/widgets/markdown_preview_decorations.dart';
import 'package:material_ui/material_ui.dart';

class EntryTextField extends StatefulWidget {
  final MarkdownPreviewController controller;
  final FocusNode focusNode;
  final UndoHistoryController undoController;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final EdgeInsets contentPadding;
  final TextAlignVertical? textAlignVertical;

  /// Fills its parent and scrolls itself; otherwise it grows with its text
  /// inside the page's scroll view.
  final bool expands;

  /// When set, an empty field invites choosing a template instead of the
  /// plain hint.
  final VoidCallback? onChooseTemplate;

  const EntryTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.undoController,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    this.textAlignVertical,
    this.expands = true,
    this.onChooseTemplate,
  });

  @override
  State<EntryTextField> createState() => _EntryTextFieldState();
}

class _EntryTextFieldState extends State<EntryTextField> {
  ScrollController? _ownedScrollController;

  ScrollController get _scrollController =>
      widget.scrollController ??
      (_ownedScrollController ??= ScrollController());

  @override
  void dispose() {
    _ownedScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styles = MarkdownPreviewStyles.fromTheme(context);
    final baseStyle = EntryTypography.of(context).apply(theme
        .textTheme.bodyLarge!
        .copyWith(color: theme.colorScheme.onSurface));
    final strutStyle = StrutStyle.fromTextStyle(baseStyle);

    final field = TextField(
      onTap: () => EditorKeyboardSessionScope.read(context)?.resume(),
      controller: widget.controller,
      undoController: widget.undoController,
      focusNode: widget.focusNode,
      scrollController: _scrollController,
      maxLines: null,
      expands: widget.expands,
      selectionWidthStyle: BoxWidthStyle.tight,
      selectionHeightStyle: MarkdownPreviewDecorations.heightStyle,
      scrollPadding: widget.scrollPadding,
      strutStyle: strutStyle,
      spellCheckConfiguration: SpellCheckConfiguration(
          spellCheckService: widget.controller.spellCheckService),
      contextMenuBuilder: (context, editor) {
        final suggestions = widget.controller.spellCheckMenuItems(editor);
        if (suggestions.isEmpty) {
          return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editor);
        }
        return SpellCheckSuggestionsToolbar(
          anchor: SpellCheckSuggestionsToolbar.getToolbarAnchor(
              editor.contextMenuAnchors),
          buttonItems: suggestions,
        );
      },
      textCapitalization: TextCapitalization.sentences,
      textAlignVertical: widget.textAlignVertical,
      style: baseStyle,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: widget.contentPadding,
        hintText: widget.onChooseTemplate == null
            ? AppLocalizations.of(context)!.writeSomethingHint
            : null,
      ),
    );

    final decorated = MarkdownPreviewDecorations(
      controller: widget.controller,
      scrollController: _scrollController,
      barColor: styles.quote,
      panelColor: styles.codeBackground,
      child: field,
    );
    if (widget.onChooseTemplate == null) return decorated;
    return Stack(children: [
      decorated,
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, value, _) => value.text.isNotEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: widget.contentPadding,
                child: _TemplateHint(
                    style: baseStyle, onChoose: widget.onChooseTemplate!),
              ),
      ),
    ]);
  }
}

/// "Start writing or choose a [Template]." Only the link takes taps; the
/// words let them through to the field underneath.
class _TemplateHint extends StatelessWidget {
  const _TemplateHint({required this.style, required this.onChoose});
  final TextStyle style;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final hint = style.copyWith(color: Theme.of(context).hintColor);
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
      IgnorePointer(child: Text(l10n.editorStartWriting, style: hint)),
      Material(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: const ValueKey('editor-template-link'),
          borderRadius: BorderRadius.circular(16),
          onTap: onChoose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.grid_view_rounded,
                  size: 16, color: cs.onSecondaryContainer),
              const SizedBox(width: 4),
              Text(l10n.editorTemplateLink,
                  style: style.copyWith(color: cs.onSecondaryContainer)),
            ]),
          ),
        ),
      ),
      IgnorePointer(child: Text(l10n.editorStartWritingEnd, style: hint)),
    ]);
  }
}
