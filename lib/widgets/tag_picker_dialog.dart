// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/routing/app_navigation.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/widgets/tag_grouped_chip_list.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// What picking a tag does: put it on (or take it off) an entry or
/// template, choose one tag, or narrow a search to some tags.
enum TagPickerMode { attach, selectSingle, filter }

/// How tags are picked everywhere: a search with a button to make a tag
/// beside it, the tags used lately, then every tag by category, in an order
/// changed by dragging.
class TagPicker extends StatefulWidget {
  const TagPicker({
    super.key,
    required this.mode,
    this.source,
    this.selected = const {},
    this.onToggle,
    this.onPick,
    this.tagTypeFilter,
    this.hideFavorite = false,
  });

  final TagPickerMode mode;

  /// Leaves out the favorite tag, where the star is picked on its own.
  final bool hideFavorite;

  /// The tags on the entry or template, for [TagPickerMode.attach].
  final TagAttachmentSource? source;

  /// The tags picked so far and what a tap does, for
  /// [TagPickerMode.filter].
  final Set<int> selected;
  final void Function(Tag tag)? onToggle;

  /// The one tag chosen, for [TagPickerMode.selectSingle].
  final void Function(Tag tag)? onPick;

  final TagType? tagTypeFilter;

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  final TagNameEditingController _searchController = TagNameEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Makes a tag, named as searched when something was, and picks it.
  Future<void> _create(TagsProvider provider) async {
    final before = {for (final tag in provider.tags) tag.id};
    await OrganizeNavigation.editTag(context, null,
        name: sanitizeTagName(_searchController.text));
    final made =
        provider.tags.where((tag) => !before.contains(tag.id)).firstOrNull;
    if (made == null || !mounted) return;
    _searchController.clear();
    switch (widget.mode) {
      case TagPickerMode.attach:
        final source = widget.source!;
        if (!source.contains(made.id!)) await source.attach(context, made);
      case TagPickerMode.selectSingle:
        widget.onPick!(made);
      case TagPickerMode.filter:
        widget.onToggle!(made);
    }
  }

  Widget _chip(BuildContext context, Tag tag) {
    switch (widget.mode) {
      case TagPickerMode.selectSingle:
        return TagChip(tag: tag, onTap: () => widget.onPick!(tag));
      case TagPickerMode.filter:
        final on = widget.selected.contains(tag.id);
        return TagChip(
            key: ValueKey('tag-pick-${tag.id}'),
            tag: tag,
            selected: on,
            onTap: () => widget.onToggle!(tag));
      case TagPickerMode.attach:
        final source = widget.source!;
        if (!source.contains(tag.id!)) {
          return TagChip(tag: tag, onTap: () => source.attach(context, tag));
        }
        final tracker = tag.tagType == TagType.tracker;
        return TagChip(
          tag: tag,
          selected: true,
          value: source.valueFor(tag.id!),
          // A tracker's value is edited by tapping; its cross removes it.
          onTap: tracker && source.supportsValues
              ? () => source.editValue(context, tag)
              : () => source.detach(tag.id!),
          onRemove: tracker ? () => source.detach(tag.id!) : null,
        );
    }
  }

  /// Puts [moved] where [target] is, in [target]'s category.
  Future<void> _move(Tag moved, Tag target) async {
    final section = [
      for (final tag in TagsProvider.instance.tags)
        if (tag.categoryId == target.categoryId && tag.id != moved.id) tag,
    ];
    final at = section.indexWhere((tag) => tag.id == target.id);
    final forward = moved.categoryId == target.categoryId &&
        TagsProvider.instance.tags.indexOf(moved) <
            TagsProvider.instance.tags.indexOf(target);
    await AppActions.instance.run('tag.move', {
      'id': moved.id,
      'category': target.categoryId == null ? 'none' : '#${target.categoryId}',
      'position': forward ? at + 1 : at,
    });
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.source;
    return source == null
        ? _build(context)
        // Rebuild when the attached tags change.
        : ListenableBuilder(
            listenable: source, builder: (context, _) => _build(context));
  }

  Widget _build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<TagsProvider>();
    final config = AppConfig.instance;
    final hidden = widget.hideFavorite ? provider.favoriteTag?.id : null;
    bool offered(Tag tag) =>
        tag.id != hidden &&
        (widget.tagTypeFilter == null || tag.tagType == widget.tagTypeFilter);
    final sections = provider.buildSections(_searchText,
        tagPool: provider.tags.where(offered).toList());
    final recent = _searchText.isEmpty
        ? provider
            .recentlyUsed(
                limit: config.recentTagsLimit, days: config.recentTagsDays)
            .where(offered)
            .toList()
        : const <Tag>[];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Expanded(
              child: SearchBar(
                key: const ValueKey('tag-search'),
                controller: _searchController,
                hintText: l10n.addTagsSearchHint,
                elevation: const WidgetStatePropertyAll(0),
                constraints: const BoxConstraints(minHeight: 48),
                padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 4)),
                backgroundColor: WidgetStatePropertyAll(cs.secondaryContainer),
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.search_rounded, color: cs.secondary),
                ),
              ),
            ),
            if (widget.mode != TagPickerMode.filter) ...[
              const SizedBox(width: 8),
              IconButton.filledTonal(
                key: const ValueKey('tag-new'),
                tooltip: l10n.tagNew,
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _create(provider),
              ),
            ],
          ]),
        ),
        if (recent.isNotEmpty) ...[
          SectionLabel(l10n.tagsRecent),
          Wrap(
            key: const ValueKey('tags-recent'),
            spacing: 6,
            runSpacing: 6,
            children: [for (final tag in recent) _chip(context, tag)],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
        if (sections.isEmpty && _searchText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(l10n.noResults),
          )
        else
          TagGroupedChipList(
            sections: sections,
            onMove: _move,
            chipBuilder: (tag) => _chip(context, tag),
          ),
      ],
    );
  }
}

/// [TagPicker] in a dialog, for the editor, templates and statistics.
class TagPickerDialog extends StatelessWidget {
  final TagPickerMode mode;
  final TagAttachmentSource? source;
  final TagType? tagTypeFilter;

  const TagPickerDialog({
    super.key,
    required this.mode,
    this.source,
    this.tagTypeFilter,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(switch (mode) {
        TagPickerMode.selectSingle => l10n.selectTagTitle,
        _ => l10n.addTagsTitle,
      }),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: TagPicker(
            mode: mode,
            source: source,
            tagTypeFilter: tagTypeFilter,
            onPick: (tag) => Navigator.of(context).pop(tag),
          ),
        ),
      ),
      actions: [
        if (mode == TagPickerMode.attach)
          TextButton(
            onPressed: () => AppNavigation.tags(Navigator.of(context)),
            child: Text(l10n.manageTags),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}
