// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Imports a file of tags and templates that [ShareSelectionPage] saved.
Future<void> importTransferFile(BuildContext context) => runOperation(
    context, TemplatesTagsTransfer.importTransferFile,
    failureDescription: AppLocalizations.of(context)!.importErrorDescription);

/// Picks some of the tags or templates and saves them to a file or shares
/// them: select all and none at the top, Save and Share at the bottom.
class ShareSelectionPage extends StatefulWidget {
  const ShareSelectionPage({
    super.key,
    required this.ids,
    required this.emptyIcon,
    required this.empty,
    required this.fileKind,
    required this.export,
    required this.list,
  });

  /// Everything that can be picked.
  final Set<int> ids;

  /// Shown when there is nothing to pick.
  final IconData emptyIcon;
  final String empty;

  /// What the file holds, in its name: `aid_diary_<fileKind>_<time>.json`.
  final String fileKind;
  final Uint8List Function(Set<int> ids) export;

  /// The items, showing [selected] and calling [toggle] with an id.
  final Widget Function(Set<int> selected, ValueChanged<int> toggle) list;

  @override
  State<ShareSelectionPage> createState() => _ShareSelectionPageState();
}

class _ShareSelectionPageState extends State<ShareSelectionPage> {
  final Set<int> _selected = {};

  String _fileName() {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    return 'aid_diary_${widget.fileKind}_$timestamp.json';
  }

  Future<void> _save() async {
    final bytes = widget.export(_selected);
    final fileName = _fileName();
    await runOperation(
        context,
        (update) =>
            TemplatesTagsTransfer.saveBytesToFile(bytes, fileName, update),
        failureDescription:
            AppLocalizations.of(context)!.exportErrorDescription);
  }

  Future<void> _share() =>
      TemplatesTagsTransfer.shareBytes(widget.export(_selected), _fileName());

  void _toggle(int id) =>
      setState(() => _selected.remove(id) || _selected.add(id));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSelection = _selected.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shareButtonLabel),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all_rounded),
            onPressed: () => setState(() => _selected.addAll(widget.ids)),
          ),
          IconButton(
            icon: const Icon(Icons.deselect_rounded),
            onPressed: () => setState(_selected.clear),
          ),
        ],
      ),
      body: widget.ids.isEmpty
          ? Align(
              alignment: Alignment.topCenter,
              child: EmptyState(icon: widget.emptyIcon, title: widget.empty))
          : widget.list(_selected, _toggle),
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.save_alt_rounded),
                    label:
                        Text(MaterialLocalizations.of(context).saveButtonLabel),
                    onPressed: hasSelection ? _save : null,
                  ),
                ),
                if (Platform.isAndroid) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.share_rounded),
                      label: Text(l10n.shareButtonLabel),
                      onPressed: hasSelection ? _share : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
