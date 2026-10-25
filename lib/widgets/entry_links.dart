// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/link_actions.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_filter.dart';
import 'package:aid_diary/widgets/entry_card.dart';
import 'package:material_ui/material_ui.dart';

/// An entry about an earlier day: read and answered rather than rewritten.
bool isPastEntry(Entry entry) => entry.day.isBefore(DiaryDay.today());

Entry? _openEntry(int? id) => id == null
    ? null
    : EntryStore.instance.entries
        .where((entry) => entry.id == id && !entry.isSealed)
        .firstOrNull;

/// The entry's text, selectable; for a past entry the selection can also be
/// kept as a passage or answered with a comment.
class NotedEntryText extends StatefulWidget {
  const NotedEntryText({super.key, required this.entry, required this.child});

  final Entry entry;
  final Widget child;

  @override
  State<NotedEntryText> createState() => _NotedEntryTextState();
}

class _NotedEntryTextState extends State<NotedEntryText> {
  String _selected = '';

  Future<void> _keep(String quote) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    await AppActions.instance
        .run('passage.keep', {'id': widget.entry.id, 'quote': quote});
    messenger.showSnackBar(SnackBar(content: Text(l10n.noteKept)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final answerable = isPastEntry(widget.entry) && !widget.entry.isHidden;
    return SelectionArea(
      onSelectionChanged: (content) =>
          _selected = content?.plainText.trim() ?? '',
      contextMenuBuilder: (context, state) =>
          AdaptiveTextSelectionToolbar.buttonItems(
        anchors: state.contextMenuAnchors,
        buttonItems: [
          ...state.contextMenuButtonItems,
          if (answerable && _selected.isNotEmpty) ...[
            ContextMenuButtonItem(
              label: l10n.noteKeep,
              onPressed: () {
                final quote = _selected;
                state.hideToolbar();
                _keep(quote);
              },
            ),
            ContextMenuButtonItem(
              label: l10n.noteComment,
              onPressed: () {
                final quote = _selected;
                state.hideToolbar();
                showCommentDialog(this.context, widget.entry, quote: quote);
              },
            ),
          ],
        ],
      ),
      child: widget.child,
    );
  }
}

/// A short comment on [entry] (on [quote] when given): an entry of today
/// citing it, written in a few lines, or carried over to the full editor.
Future<void> showCommentDialog(BuildContext context, Entry entry,
    {String? quote}) async {
  final place = ConfigProvider.instance.get(Settings.autoAddLocation)
      ? LocationService()
          .current(languageCode: Localizations.localeOf(context).languageCode)
          .then<EntryLocation?>((location) => location, onError: (_) => null)
      : Future<EntryLocation?>.value();
  final result = await showDialog<(String, bool)>(
    context: context,
    builder: (context) => _CommentDialog(quote: quote),
  );
  if (result == null || !context.mounted) return;
  final (text, expand) = result;
  if (expand) {
    final citation = await citationOf(entry.id!, quote);
    if (!context.mounted) return;
    await EntryNavigation.edit(context, null, text: text, refs: [citation]);
    return;
  }
  if (text.trim().isEmpty) return;
  // The place, if it came in while writing; the comment does not wait.
  final location = await place.timeout(Duration.zero, onTimeout: () => null);
  await AppActions.instance.run('entry.create', {
    'text': text,
    'cite': entry.id,
    if (quote != null) 'quote': quote,
    if (location?.latitude case final latitude?) 'latitude': latitude,
    if (location?.longitude case final longitude?) 'longitude': longitude,
    if (location?.name case final name?) 'place': name,
  });
}

class _CommentDialog extends StatefulWidget {
  const _CommentDialog({this.quote});

  final String? quote;

  @override
  State<_CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<_CommentDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.noteComment),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.quote case final quote?) ...[
              QuoteBlock(quote, maxLines: 4),
              const SizedBox(height: 12),
            ],
            TextField(
              key: const ValueKey('comment-field'),
              controller: _controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(hintText: l10n.noteCommentHint),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            key: const ValueKey('comment-expand'),
            onPressed: () =>
                Navigator.of(context).pop((_controller.text, true)),
            child: Text(l10n.commentExpand)),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(material.cancelButtonLabel)),
        TextButton(
            key: const ValueKey('comment-save'),
            onPressed: () =>
                Navigator.of(context).pop((_controller.text, false)),
            child: Text(material.saveButtonLabel)),
      ],
    );
  }
}

/// Cited words, set off by a bar.
class QuoteBlock extends StatelessWidget {
  const QuoteBlock(this.text, {super.key, this.maxLines});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 3)),
      ),
      child: Text(text,
          maxLines: maxLines,
          overflow: maxLines == null ? null : TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }
}

/// What an entry cites: each quote with the day of its entry, which opens
/// it; [onRemove] offers to take one out, as the editor does.
class CitationList extends StatelessWidget {
  const CitationList({super.key, required this.refs, this.onRemove});

  final List<EntryRef> refs;
  final void Function(EntryRef ref)? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('entry-citations'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final ref in refs)
          Builder(builder: (context) {
            final cited = _openEntry(ref.targetId);
            return Card.outlined(
              key: ValueKey('citation-${ref.target}'),
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: cited == null
                    ? null
                    : () => EntryNavigation.view(context, cited),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                  child: Row(children: [
                    Icon(Icons.format_quote_rounded,
                        size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ref.quote case final quote?) ...[
                            QuoteBlock(quote, maxLines: 3),
                            const SizedBox(height: 4),
                          ],
                          Text(
                              cited == null
                                  ? l10n.refMissing
                                  : l10n.noteOnEntry(TimeManager.formatDate(
                                      cited.day, context)),
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    if (onRemove case final remove?)
                      IconButton(
                        key: ValueKey('citation-remove-${ref.target}'),
                        tooltip: MaterialLocalizations.of(context)
                            .deleteButtonTooltip,
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => remove(ref),
                      ),
                  ]),
                ),
              ),
            );
          }),
      ],
    );
  }
}

/// Below an entry: the entries answering it, and the passages kept from it.
class EntryLinksSection extends StatelessWidget {
  const EntryLinksSection({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: LinksProvider.instance,
      builder: (context, _) => _links(context));

  Widget _links(BuildContext context) {
    final links = LinksProvider.instance;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final open = openEntryIds();
    final replies = [
      for (final id in links.repliesTo(entry.id!))
        if (open.contains(id)) _openEntry(id)!
    ]..sort((a, b) => a.timeCreate.compareTo(b.timeCreate));
    final passages = links.passagesOf(entry.id!);
    Widget header(String text) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(text, style: theme.textTheme.titleSmall),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (passages.isNotEmpty) ...[
          header(l10n.notesPassages),
          for (final passage in passages)
            Padding(
              key: ValueKey('passage-${passage.id}'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Expanded(child: QuoteBlock(passage.quote)),
                IconButton(
                  key: ValueKey('passage-delete-${passage.id}'),
                  tooltip:
                      MaterialLocalizations.of(context).deleteButtonTooltip,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => _forget(context, passage),
                ),
              ]),
            ),
        ],
        if (replies.isNotEmpty) ...[
          header(l10n.notesComments),
          for (final reply in replies)
            Card.filled(
              key: ValueKey('reply-${reply.id}'),
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.antiAlias,
              child: EntryCard(
                entry: reply,
                showDate: true,
                onTap: () => EntryNavigation.view(context, reply),
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _forget(BuildContext context, KeptPassage passage) async {
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.noteDeleteConfirm),
        content: QuoteBlock(passage.quote, maxLines: 4),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(material.cancelButtonLabel)),
          TextButton(
              key: const ValueKey('passage-delete-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(material.deleteButtonTooltip)),
        ],
      ),
    );
    if (sure != true) return;
    await AppActions.instance
        .run('passage.delete', {'passage': passage.id}, confirmed: true);
  }
}

/// Finds an entry to cite, by its words; null when none was picked.
Future<Entry?> pickEntryToCite(BuildContext context, {int? except}) =>
    showDialog<Entry>(
        context: context, builder: (_) => _EntryPicker(except: except));

class _EntryPicker extends StatefulWidget {
  const _EntryPicker({this.except});

  final int? except;

  @override
  State<_EntryPicker> createState() => _EntryPickerState();
}

class _EntryPickerState extends State<_EntryPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filter = EntryFilter(query: _query);
    final found = [
      for (final entry in EntryStore.instance.entries)
        if (entry.id != widget.except && filter.matches(entry)) entry
    ];
    return AlertDialog(
      title: Text(l10n.refAdd),
      content: SizedBox(
        width: 480,
        height: 420,
        child: Column(children: [
          TextField(
            key: const ValueKey('cite-search'),
            autofocus: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l10n.searchLogsHint),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: found.length,
              itemBuilder: (context, index) {
                final entry = found[index];
                return KeyedSubtree(
                  key: ValueKey('cite-entry-${entry.id}'),
                  child: EntryCard(
                    entry: entry,
                    showDate: true,
                    showDetails: false,
                    highlight: _query,
                    onTap: () => Navigator.of(context).pop(entry),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
      ],
    );
  }
}

/// Asks before rewriting a past entry, unless the user said not to ask;
/// true to go on.
Future<bool> confirmEditPast(BuildContext context, Entry entry) async {
  if (!isPastEntry(entry) ||
      !ConfigProvider.instance.get(Settings.confirmEditPast)) {
    return true;
  }
  final result = await showDialog<(bool, bool)>(
    context: context,
    builder: (context) => const _EditPastDialog(),
  );
  if (result == null || !result.$1) return false;
  if (result.$2) await changeSetting(Settings.confirmEditPast, false);
  return true;
}

class _EditPastDialog extends StatefulWidget {
  const _EditPastDialog();

  @override
  State<_EditPastDialog> createState() => _EditPastDialogState();
}

class _EditPastDialogState extends State<_EditPastDialog> {
  bool _dontAsk = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      key: const ValueKey('edit-past-dialog'),
      title: Text(l10n.editPastTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editPastBody),
          const SizedBox(height: 8),
          CheckboxListTile(
            key: const ValueKey('edit-past-dont-ask'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _dontAsk,
            onChanged: (value) => setState(() => _dontAsk = value ?? false),
            title: Text(l10n.editPastDontAsk),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop((false, false)),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        TextButton(
            key: const ValueKey('edit-past-confirm'),
            onPressed: () => Navigator.of(context).pop((true, _dontAsk)),
            child: Text(l10n.editPastEdit)),
      ],
    );
  }
}
