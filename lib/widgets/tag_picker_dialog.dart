// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/routing/app_navigation.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/widgets/tag_grouped_chip_list.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

enum TagPickerMode { attach, selectSingle }

class TagPickerDialog extends StatefulWidget {
  final TagPickerMode mode;

  // attach
  final TagAttachmentSource? source;

  final TagType? tagTypeFilter;

  const TagPickerDialog({
    super.key,
    required this.mode,
    this.source,
    this.tagTypeFilter,
  });

  @override
  State<TagPickerDialog> createState() => _TagPickerDialogState();
}

class _TagPickerDialogState extends State<TagPickerDialog> {
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

  // attach mode helpers

  Future<void> _createAndAddTagWithName(
      TagsProvider provider, String name) async {
    final tagsBefore = List<Tag>.from(provider.tags);
    await OrganizeNavigation.editTag(context, null, name: name);
    final newTag = provider.tags
        .where((tag) =>
            tagsBefore.every((existingTag) => existingTag.id != tag.id))
        .firstOrNull;
    if (newTag == null) return;

    _searchController.clear();

    if (widget.mode == TagPickerMode.attach) {
      final source = widget.source!;
      if (source.contains(newTag.id!)) return;
      if (mounted) await source.attach(context, newTag);
    }
  }

  // builders

  Widget _buildSearchField(AppLocalizations l10n, TagsProvider provider) {
    final showAdd = _searchText.isNotEmpty &&
        widget.mode == TagPickerMode.attach &&
        !provider.tags
            .any((tag) => tag.name.toLowerCase() == _searchText.toLowerCase());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SearchBar(
        controller: _searchController,
        hintText: l10n.addTagsSearchHint,
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.only(left: 4, right: 4),
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.secondaryContainer,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        trailing: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              final scale = TweenSequence([
                TweenSequenceItem(
                  tween: Tween<double>(begin: 0.0, end: 1.1)
                      .chain(CurveTween(curve: Curves.easeOut)),
                  weight: 60,
                ),
                TweenSequenceItem(
                  tween: Tween<double>(begin: 1.1, end: 1.0)
                      .chain(CurveTween(curve: Curves.easeIn)),
                  weight: 40,
                ),
              ]).animate(animation);
              return ScaleTransition(scale: scale, child: child);
            },
            child: showAdd
                ? IconButton(
                    key: const ValueKey('addButton'),
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () => _createAndAddTagWithName(
                        provider, sanitizeTagName(_searchController.text)),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.source;
    if (source != null) {
      // Rebuild when source mutates
      return ListenableBuilder(
        listenable: source,
        builder: (context, _) => _buildDialog(context),
      );
    }
    return _buildDialog(context);
  }

  Widget _buildDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<TagsProvider>(
      builder: (context, provider, _) {
        // Picked tags stay where they are, highlighted.
        final pool = [
          for (final tag in provider.tags)
            if (widget.tagTypeFilter == null ||
                tag.tagType == widget.tagTypeFilter)
              tag,
        ];
        final sections = provider.buildSections(_searchText, tagPool: pool);

        final title = switch (widget.mode) {
          TagPickerMode.attach => l10n.addTagsTitle,
          TagPickerMode.selectSingle => l10n.selectTagTitle,
        };

        return AlertDialog(
          title: Text(title),
          contentPadding: widget.mode == TagPickerMode.selectSingle
              ? const EdgeInsets.fromLTRB(24, 16, 24, 0)
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: _buildContent(context, l10n, provider, sections),
          ),
          actions: _buildActions(context, l10n, provider),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    TagsProvider provider,
    List<TagSection> sections,
  ) {
    if (widget.mode == TagPickerMode.selectSingle) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(l10n, provider),
          const SizedBox(height: 8),
          if (sections.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l10n.noResults),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: TagGroupedChipList(
                  sections: sections,
                  onMove: _move,
                  chipBuilder: (tag) => TagChip(
                    tag: tag,
                    onTap: () => Navigator.of(context).pop(tag),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    final source = widget.source!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(l10n, provider),
          const SizedBox(height: 8),
          TagGroupedChipList(
            sections: sections,
            onMove: _move,
            chipBuilder: (tag) {
              if (!source.contains(tag.id!)) {
                return TagChip(
                    tag: tag, onTap: () => source.attach(context, tag));
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
            },
          ),
        ],
      ),
    );
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

  List<Widget> _buildActions(
      BuildContext context, AppLocalizations l10n, TagsProvider provider) {
    final close = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(MaterialLocalizations.of(context).closeButtonLabel),
    );

    final manageTags = TextButton(
      onPressed: () => AppNavigation.tags(Navigator.of(context)),
      child: Text(l10n.manageTags),
    );

    return switch (widget.mode) {
      TagPickerMode.attach => [manageTags, close],
      TagPickerMode.selectSingle => [close],
    };
  }
}
