// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/widgets/progress_dialog.dart';
import 'package:aid_diary/utils/tag_category_visuals.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/widgets/expressive_fab_menu.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/widgets/tag_icon_glyph.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

sealed class _ListItem {
  const _ListItem();
}

class _HeaderItem extends _ListItem {
  final TagCategory? category; // null = Uncategorized section
  const _HeaderItem(this.category);
}

class _TagItem extends _ListItem {
  final Tag tag;
  const _TagItem(this.tag);
}

class TagsSettings extends StatefulWidget {
  const TagsSettings({super.key});

  @override
  State<TagsSettings> createState() => _TagsSettingsState();
}

class _TagsSettingsState extends State<TagsSettings> {
  final Set<int?> _manuallyCollapsedIds = {};
  bool _isDraggingCategory = false;

  Future<void> _importFile(BuildContext context) async {
    await runOperation(context, TemplatesTagsTransfer.importTransferFile,
        failureDescription:
            AppLocalizations.of(context)!.importErrorDescription);
  }

  void _toggleCollapse(int? categoryId) {
    setState(() {
      if (_manuallyCollapsedIds.contains(categoryId)) {
        _manuallyCollapsedIds.remove(categoryId);
      } else {
        _manuallyCollapsedIds.add(categoryId);
      }
    });
  }

  List<_ListItem> _buildFlatItems(TagsProvider provider) {
    final items = <_ListItem>[];
    final hasCategories = provider.categories.isNotEmpty;

    // Header only shown when named categories exist, to give uncategorized
    // tags something to collapse under.
    final uncategorizedTags =
        provider.tags.where((tag) => tag.categoryId == null).toList();
    if (hasCategories) {
      items.add(const _HeaderItem(null));
    }
    if (!hasCategories || !_manuallyCollapsedIds.contains(null)) {
      for (final tag in uncategorizedTags) {
        items.add(_TagItem(tag));
      }
    }

    for (final category in provider.categories) {
      items.add(_HeaderItem(category));
      if (!_manuallyCollapsedIds.contains(category.id)) {
        final categoryTags = provider.tags
            .where((tag) => tag.categoryId == category.id)
            .toList();
        for (final tag in categoryTags) {
          items.add(_TagItem(tag));
        }
      }
    }

    return items;
  }

  Future<void> _onReorder(int from, int to, List<_ListItem> items) async {
    if (from == to) return;

    final movedItem = items[from];
    items.removeAt(from);
    items.insert(to, movedItem);

    if (movedItem is _HeaderItem) {
      // Uncategorized header is pinned, no-op if it was somehow moved
      if (movedItem.category == null) return;

      final ordered = items
          .whereType<_HeaderItem>()
          .map((header) => header.category)
          .nonNulls
          .toList();
      await AppActions.instance.run('category.move', {
        'id': movedItem.category!.id,
        'position': ordered.indexOf(movedItem.category!),
      });
    } else if (movedItem is _TagItem) {
      // Where it landed: the category above it, and its place among the
      // tags of that category on screen.
      TagCategory? section;
      var position = 0;
      for (final item in items) {
        if (item is _HeaderItem) {
          section = item.category;
          position = 0;
        } else if (item is _TagItem) {
          if (item.tag.id == movedItem.tag.id) break;
          position++;
        }
      }
      await AppActions.instance.run('tag.move', {
        'id': movedItem.tag.id,
        'category': section == null ? 'none' : '#${section.id}',
        'position': position,
      });
    }
  }

  Widget _buildHeaderRow(
    BuildContext context,
    int index,
    TagCategory? category,
    TagsProvider provider, {
    required Key key,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isUncategorized = category == null;
    final isCollapsed = _manuallyCollapsedIds.contains(category?.id);
    final name =
        isUncategorized ? l10n.tagCategoryUncategorized : category.name;

    return Material(
      key: key,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => _toggleCollapse(category?.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              const SizedBox(height: kMinInteractiveDimension),
              if (!isUncategorized)
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.drag_handle_rounded, size: 20),
                  ),
                )
              else
                const SizedBox(width: 44),
              if (!isUncategorized) ...[
                TagIconGlyph(
                  icon: category.icon,
                  iconType: category.iconType,
                  fallbackIcon: Icons.folder_rounded,
                  color: category.resolvedColor(context),
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (!isUncategorized)
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () =>
                      OrganizeNavigation.editCategory(context, category),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  isCollapsed
                      ? Icons.expand_more_rounded
                      : Icons.expand_less_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagRow(
    BuildContext context,
    int index,
    Tag tag,
    TagsProvider provider, {
    required Key key,
  }) {
    // Hidden while a category header is being dragged
    if (_isDraggingCategory) return SizedBox(key: key);
    return Material(
      key: key,
      color: Colors.transparent,
      child: InkWell(
        onTap: () => OrganizeNavigation.editTag(context, tag),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.drag_handle_rounded, size: 20),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TagChip(tag: tag),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLocalizations.of(context)!
                      .logCount(provider.entryCountForTag(tag.id!)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => OrganizeNavigation.editTag(context, tag),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<TagsProvider>(context);
    final isEmpty = provider.tags.isEmpty && provider.categories.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTagsTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_open_outlined),
            onPressed: () => _importFile(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => OrganizeNavigation.shareTags(context),
          ),
        ],
      ),
      floatingActionButton: ExpressiveFabMenu(items: [
        ExpressiveFabMenuItem(
            icon: Icons.folder_rounded,
            label: l10n.tagCategoryLabel,
            onTap: () => OrganizeNavigation.editCategory(context, null)),
        ExpressiveFabMenuItem(
            icon: Icons.local_offer_rounded,
            label: l10n.tagLabel,
            onTap: () => OrganizeNavigation.editTag(context, null)),
      ]),
      body: isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text(l10n.noResults),
              ),
            )
          : Builder(builder: (context) {
              final allItems = _buildFlatItems(provider);
              // Keep the uncategorized header out of the reorderable range so
              // nothing can be dragged above
              final hasUncategorizedHeader = allItems.isNotEmpty &&
                  allItems[0] is _HeaderItem &&
                  (allItems[0] as _HeaderItem).category == null;
              final items =
                  hasUncategorizedHeader ? allItems.sublist(1) : allItems;

              return CustomScrollView(
                slivers: [
                  if (hasUncategorizedHeader)
                    SliverToBoxAdapter(
                      child: _buildHeaderRow(
                        context,
                        0,
                        null,
                        provider,
                        key: const ValueKey('hdr_null'),
                      ),
                    ),
                  SliverReorderableList(
                    itemCount: items.length,
                    onReorderStart: (index) {
                      if (!_isDraggingCategory &&
                          index < items.length &&
                          items[index] is _HeaderItem &&
                          (items[index] as _HeaderItem).category != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _isDraggingCategory = true);
                          }
                        });
                      }
                    },
                    onReorderEnd: (_) {
                      if (_isDraggingCategory) {
                        setState(() => _isDraggingCategory = false);
                      }
                    },
                    onReorderItem: (from, to) {
                      final snapshot = List<_ListItem>.from(items);
                      _onReorder(from, to, snapshot);
                    },
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item is _HeaderItem) {
                        return _buildHeaderRow(
                          context,
                          index,
                          item.category,
                          provider,
                          key: ValueKey('hdr_${item.category?.id ?? 'null'}'),
                        );
                      } else {
                        final tagItem = item as _TagItem;
                        return _buildTagRow(
                          context,
                          index,
                          tagItem.tag,
                          provider,
                          key: ValueKey('tag_${tagItem.tag.id}'),
                        );
                      }
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 90),
                  ),
                ],
              );
            }),
    );
  }
}
