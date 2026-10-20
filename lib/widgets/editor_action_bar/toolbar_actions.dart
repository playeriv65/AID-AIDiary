// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/text_editing.dart';
import 'package:aid_diary/widgets/icons/svg_icon.dart';
import 'package:material_ui/material_ui.dart';

@immutable
class ToolbarAction {
  final Widget icon;

  /// Shown on hover and long press, and read out by screen readers.
  final String tooltip;
  final FutureOr<void> Function() onPressed;

  /// For actions that may launch an external activity. Focus must be manually restored
  final bool mayLeaveApp;

  const ToolbarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.mayLeaveApp = false,
  });
}

List<ToolbarAction> markdownActions(
    BuildContext context, TextEditingController controller) {
  final l10n = AppLocalizations.of(context)!;
  return [
    ToolbarAction(
      icon: const Icon(Icons.format_list_bulleted_rounded),
      tooltip: l10n.toolbarBulletList,
      onPressed: () => insertLinePrefix(controller, '-'),
    ),
    ToolbarAction(
      icon: const Icon(Icons.text_fields_rounded),
      tooltip: l10n.toolbarHeading,
      onPressed: () => _insertHeader(context, controller),
    ),
    ToolbarAction(
      icon: const Icon(Icons.format_bold_rounded),
      tooltip: l10n.toolbarBold,
      onPressed: () => wrapSelection(controller, '**'),
    ),
    ToolbarAction(
      icon: const Icon(Icons.format_italic_rounded),
      tooltip: l10n.toolbarItalic,
      onPressed: () => wrapSelection(controller, '_'),
    ),
    ToolbarAction(
      icon: const SvgIcon('assets/icons/format_ink_highlighter.svg'),
      tooltip: l10n.toolbarHighlight,
      onPressed: () => wrapSelection(controller, '=='),
    ),
    ToolbarAction(
      icon: const Icon(Icons.format_strikethrough_rounded),
      tooltip: l10n.toolbarStrikethrough,
      onPressed: () => wrapSelection(controller, '~~'),
    ),
    ToolbarAction(
      icon: const Icon(Icons.format_quote_rounded),
      tooltip: l10n.toolbarQuote,
      onPressed: () => insertLinePrefix(controller, '>'),
    ),
    ToolbarAction(
      icon: const Icon(Icons.link_rounded),
      tooltip: l10n.toolbarLink,
      onPressed: () => wrapSelection(controller, '[', ']()'),
    ),
    ToolbarAction(
      icon: const Icon(Icons.add_box_outlined),
      tooltip: l10n.toolbarInsert,
      onPressed: () => _insertBlock(context, controller),
    ),
  ];
}

/// Markdown blocks offered by the insert menu: icon, label, text, and where
/// the cursor lands inside it.
List<(IconData, String, String, int)> _blocks(AppLocalizations l10n) => [
      (Icons.checklist_rounded, l10n.insertChecklist, '- [ ] ', 6),
      (Icons.format_list_numbered_rounded, l10n.insertNumberedList, '1. ', 3),
      (
        Icons.table_chart_outlined,
        l10n.insertTable,
        '|  |  |\n| --- | --- |\n|  |  |\n',
        2
      ),
      (Icons.horizontal_rule_rounded, l10n.insertDivider, '---\n', 4),
      (Icons.code_rounded, l10n.insertCodeBlock, '```\n\n```\n', 4),
    ];

Future<void> _insertBlock(
    BuildContext context, TextEditingController controller) async {
  final l10n = AppLocalizations.of(context)!;
  final chosen = await showModalBottomSheet<(String, int)>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final (icon, label, block, cursor) in _blocks(l10n))
          ListTile(
            key: ValueKey('insert-$label'),
            leading: Icon(icon),
            title: Text(label),
            onTap: () => Navigator.pop(context, (block, cursor)),
          ),
      ]),
    ),
  );
  if (chosen == null) return;
  insertBlock(controller, chosen.$1, cursorOffset: chosen.$2);
}

Future<void> _insertHeader(
    BuildContext context, TextEditingController controller) async {
  final level = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var level = 1; level <= 6; level++)
            ListTile(
              title: Text('H$level',
                  style: TextStyle(fontSize: 28 - 2 * level.toDouble())),
              onTap: () => Navigator.pop(context, level),
            ),
        ],
      ),
    ),
  );
  if (level != null) insertLinePrefix(controller, '#' * level);
}
