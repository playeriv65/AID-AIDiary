// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/tag.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/widgets/tag_picker_dialog.dart';
import 'package:daily_you/widgets/hiding_widget.dart';
import 'package:daily_you/widgets/large_entry_card_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/widgets/entry_card_widget.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/entry_timeline_tile.dart';
import 'package:daily_you/widgets/new_entry_fab.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _focusNode = FocusNode();
  double _searchElevation = 0.0;

  List<int> _filterTagIds = [];
  TagFilterMode _filterTagMode = TagFilterMode.any;
  bool _filterNoTags = false;

  bool get _hasTagFilter => _filterTagIds.isNotEmpty || _filterNoTags;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.text = EntriesProvider.instance.searchText;
    _scrollController.addListener(() {
      final elevation = _scrollController.position.pixels > 0 ? 1.0 : 0.0;

      if (_searchElevation != elevation) {
        setState(() {
          _searchElevation = elevation;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Entry> _getVisibleEntries(
      EntriesProvider entriesProvider, TagsProvider tagsProvider) {
    final filtered =
        _applyTagFilter(entriesProvider.getFilteredEntries(), tagsProvider);
    return _applyTrackerSort(filtered, entriesProvider, tagsProvider);
  }

  List<Entry> _applyTagFilter(List<Entry> entries, TagsProvider tagsProvider) {
    if (_filterNoTags) {
      return entries
          .where((entry) =>
              tagsProvider.getEntryTagsForEntry(entry.id ?? -1).isEmpty)
          .toList();
    }
    if (_filterTagIds.isEmpty) return entries;
    return entries.where((entry) {
      final entryTagIds = tagsProvider
          .getEntryTagsForEntry(entry.id ?? -1)
          .map((entryTag) => entryTag.tagId)
          .toSet();
      return _filterTagMode == TagFilterMode.all
          ? _filterTagIds.every((tagId) => entryTagIds.contains(tagId))
          : _filterTagIds.any((tagId) => entryTagIds.contains(tagId));
    }).toList();
  }

  List<Entry> _applyTrackerSort(List<Entry> entries,
      EntriesProvider entriesProvider, TagsProvider tagsProvider) {
    final trackerTagId = entriesProvider.trackerSortTagId;
    if (entriesProvider.orderBy != OrderBy.tracker || trackerTagId == null) {
      return entries;
    }
    final ascending = entriesProvider.sortOrder == SortOrder.ascending;

    double? trackerValue(Entry entry) {
      final rawValue = tagsProvider
          .getEntryTagsForEntry(entry.id ?? -1)
          .where((entryTag) => entryTag.tagId == trackerTagId)
          .firstOrNull
          ?.value;
      return double.tryParse(rawValue ?? '');
    }

    final valuesByEntryId = {
      for (final entry in entries) entry.id: trackerValue(entry)
    };

    final withValue =
        entries.where((entry) => valuesByEntryId[entry.id] != null).toList();
    final withoutValue =
        entries.where((entry) => valuesByEntryId[entry.id] == null).toList();

    withValue.sort((a, b) {
      final comparison = ascending
          ? valuesByEntryId[a.id]!.compareTo(valuesByEntryId[b.id]!)
          : valuesByEntryId[b.id]!.compareTo(valuesByEntryId[a.id]!);
      if (comparison != 0) return comparison;
      return ascending
          ? a.timeCreate.compareTo(b.timeCreate)
          : b.timeCreate.compareTo(a.timeCreate);
    });

    withoutValue.sort((a, b) => ascending
        ? a.timeCreate.compareTo(b.timeCreate)
        : b.timeCreate.compareTo(a.timeCreate));

    // Entries without a numeric tracker value are always listed after those
    // with one, regardless of sort direction.
    return [...withValue, ...withoutValue];
  }

  void _showTagFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TagPickerDialog(
        mode: TagPickerMode.filter,
        initialSelectedTagIds: List.from(_filterTagIds),
        initialFilterMode: _filterTagMode,
        initialNoTagsOnly: _filterNoTags,
        onFilterChanged: (tagIds, mode, noTagsOnly) {
          setState(() {
            _filterTagIds = tagIds;
            _filterTagMode = mode;
            _filterNoTags = noTagsOnly;
          });
        },
      ),
    );
  }

  void _showSortSelectionPopup(BuildContext context) {
    final entriesProvider =
        Provider.of<EntriesProvider>(context, listen: false);
    final tagsProvider = Provider.of<TagsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          final trackerTag = entriesProvider.trackerSortTagId != null
              ? tagsProvider.tags
                  .where((tag) => tag.id == entriesProvider.trackerSortTagId)
                  .firstOrNull
              : null;

          Future<void> handleTrackerTap() async {
            final previousOrderBy = entriesProvider.orderBy;
            setDialogState(() => entriesProvider.orderBy = OrderBy.tracker);

            final tag = await showDialog<Tag>(
              context: context,
              builder: (_) => TagPickerDialog(
                mode: TagPickerMode.selectSingle,
                tagTypeFilter: TagType.tracker,
              ),
            );

            if (tag != null) {
              setDialogState(() => entriesProvider.trackerSortTagId = tag.id);
            } else if (previousOrderBy != OrderBy.tracker) {
              setDialogState(() => entriesProvider.orderBy = previousOrderBy);
            }
          }

          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioGroup<OrderBy>(
                  groupValue: entriesProvider.orderBy,
                  onChanged: (value) {
                    final tappedTracker = value == OrderBy.tracker ||
                        (value == null &&
                            entriesProvider.orderBy == OrderBy.tracker);
                    if (tappedTracker) {
                      handleTrackerTap();
                    } else if (value != null) {
                      setDialogState(() {
                        entriesProvider.orderBy = value;
                        entriesProvider.trackerSortTagId = null;
                      });
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<OrderBy>(
                        value: OrderBy.date,
                        title:
                            Text(AppLocalizations.of(context)!.sortDateTitle),
                      ),
                      RadioListTile<OrderBy>(
                        value: OrderBy.mood,
                        title: Text(AppLocalizations.of(context)!.tagMoodTitle),
                      ),
                      RadioListTile<OrderBy>(
                        value: OrderBy.tracker,
                        toggleable: true,
                        title: Text(
                            AppLocalizations.of(context)!.tagTypeTrackerTitle),
                        subtitle: trackerTag != null
                            ? Text(
                                trackerTag.name,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                RadioGroup<SortOrder>(
                  groupValue: entriesProvider.sortOrder,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => entriesProvider.sortOrder = value);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<SortOrder>(
                        value: SortOrder.ascending,
                        title: Text(AppLocalizations.of(context)!
                            .sortOrderAscendingTitle),
                      ),
                      RadioListTile<SortOrder>(
                        value: SortOrder.descending,
                        title: Text(AppLocalizations.of(context)!
                            .sortOrderDescendingTitle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final tagsProvider = Provider.of<TagsProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    String viewMode = configProvider.get(Settings.galleryPageViewMode);
    var entries = _getVisibleEntries(entriesProvider, tagsProvider);
    final bool showClear = _searchController.text.isNotEmpty || _hasTagFilter;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
        child: SearchBar(
          focusNode: _focusNode,
          controller: _searchController,
          elevation: WidgetStatePropertyAll(_searchElevation),
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final rotationAnimation =
                    Tween<double>(begin: 0.0, end: 0.5).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );

                final scaleAnimation = TweenSequence([
                  TweenSequenceItem(
                    tween: Tween<double>(begin: 0.0, end: 1.1)
                        .chain(CurveTween(curve: Curves.easeOut)),
                    weight: 50,
                  ),
                  TweenSequenceItem(
                    tween: Tween<double>(begin: 1.1, end: 1.0)
                        .chain(CurveTween(curve: Curves.easeIn)),
                    weight: 50,
                  ),
                ]).animate(animation);

                return RotationTransition(
                  turns: rotationAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: showClear
                  ? IconButton(
                      visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity),
                      key: ValueKey('clearButton'),
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        entriesProvider.searchText = "";
                        setState(() {
                          _filterTagIds = [];
                          _filterTagMode = TagFilterMode.any;
                          _filterNoTags = false;
                        });
                      },
                    )
                  : SizedBox.shrink(key: ValueKey('empty')),
            ),
            if (entriesProvider.searchText.isNotEmpty || _hasTagFilter)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                    AppLocalizations.of(context)!.logCount(entries.length)),
              ),
            IconButton(
              icon: Icon(
                Icons.filter_list_rounded,
                color: _hasTagFilter
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: () => _showTagFilterDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.sort_rounded),
              onPressed: () => _showSortSelectionPopup(context),
            ),
            _viewModeMenu(context, configProvider, viewMode),
          ],
          hintText: AppLocalizations.of(context)!.searchLogsHint,
          padding:
              WidgetStateProperty.all(const EdgeInsets.only(left: 4, right: 4)),
          backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.secondaryContainer),
          onChanged: (queryText) => EasyDebounce.debounce(
              'search-debounce', const Duration(milliseconds: 300), () {
            entriesProvider.searchText = queryText;
          }),
        ),
      ),
      Expanded(
        child: Stack(children: [
          Positioned.fill(
              child: buildEntries(context, viewMode, entries, tagsProvider)),
          if (entries.isNotEmpty)
            PositionedDirectional(
              start: 0,
              bottom: 0,
              child: HidingWidget(
                scrollController: _scrollController,
                duration: const Duration(milliseconds: 200),
                hideDirection: HideDirection.down,
                shouldShow: () => _scrollController.position.pixels >= 500,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.small(
                    heroTag: "gallery-jump-to-top-button",
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    elevation: 1,
                    child: Icon(Icons.arrow_upward_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () => _scrollController.position.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut),
                  ),
                ),
              ),
            ),
          const PositionedDirectional(
              end: 16, bottom: 16, child: NewEntryFab()),
        ]),
      ),
    ]);
  }

  Widget _viewModeMenu(
      BuildContext context, ConfigProvider configProvider, String viewMode) {
    final l10n = AppLocalizations.of(context)!;
    final modes = [
      ('timeline', Icons.view_timeline_outlined, l10n.viewLayoutTimeline),
      ('list', Icons.view_agenda_outlined, l10n.viewLayoutList),
      ('grid', Icons.grid_view_rounded, l10n.viewLayoutGrid),
    ];
    final current =
        modes.where((m) => m.$1 == viewMode).firstOrNull ?? modes.first;
    return PopupMenuButton<String>(
      key: const ValueKey('journal-view-mode'),
      tooltip: l10n.settingsGalleryViewLayout,
      icon: Icon(current.$2),
      initialValue: current.$1,
      onSelected: (mode) =>
          configProvider.set(Settings.galleryPageViewMode, mode),
      itemBuilder: (context) => [
        for (final mode in modes)
          PopupMenuItem(
              value: mode.$1,
              child: Row(children: [
                Icon(mode.$2, size: 20),
                const SizedBox(width: 12),
                Text(mode.$3),
              ])),
      ],
    );
  }

  Future<void> _openEntry(BuildContext context, Entry entry) =>
      EntryNavigation.view(context, entry,
          entries: () => _getVisibleEntries(
              EntriesProvider.instance, TagsProvider.instance));

  Widget buildEntries(BuildContext context, String viewMode,
      List<Entry> entries, TagsProvider tagsProvider) {
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final hideImages = configProvider.get(Settings.hideImagesInGallery);
    if (entries.isEmpty) {
      final searching = _searchController.text.isNotEmpty || _hasTagFilter;
      final cs = Theme.of(context).colorScheme;
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(
              searching
                  ? Icons.search_off_rounded
                  : Icons.auto_stories_outlined,
              size: 48,
              color: cs.outline),
          const SizedBox(height: 12),
          Text(
            searching
                ? AppLocalizations.of(context)!.noResults
                : AppLocalizations.of(context)!.noLogs,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ]),
      );
    }
    if (viewMode != 'list' && viewMode != 'grid') {
      return _buildTimeline(context, entries, entryImagesProvider, hideImages);
    }
    final listView = viewMode == 'list';
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 88),
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: listView ? 500 : 300,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          childAspectRatio: listView ? 2.0 : 1.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return GestureDetector(
          onTap: () => _openEntry(context, entry),
          child: listView
              ? LargeEntryCardWidget(
                  entry: entry,
                  images: entryImagesProvider.getForEntry(entry),
                  hideImage: hideImages,
                )
              : EntryCardWidget(
                  entry: entry,
                  images: entryImagesProvider.getForEntry(entry),
                  hideImage: hideImages,
                ),
        );
      },
    );
  }

  /// Day One style list. Date order groups entries under sticky month
  /// headers; mood or tracker order is a flat ranking.
  Widget _buildTimeline(BuildContext context, List<Entry> entries,
      EntryImagesProvider images, bool hideImages) {
    final byDate = EntriesProvider.instance.orderBy == OrderBy.date;
    final background = Theme.of(context).colorScheme.surface;

    Widget tile(List<Entry> group, int i) => EntryTimelineTile(
          entry: group[i],
          images: images.getForEntry(group[i]),
          hideImage: hideImages,
          background: background,
          isFirst: i == 0,
          isLast: i == group.length - 1,
          showDate: !byDate ||
              i == 0 ||
              !TimeManager.isSameDay(
                  group[i - 1].timeCreate, group[i].timeCreate),
          onTap: () => _openEntry(context, group[i]),
        );

    Widget list(List<Entry> group) => SliverList.builder(
        itemCount: group.length,
        itemBuilder: (context, i) => Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: tile(group, i)))));

    final slivers = <Widget>[];
    if (!byDate) {
      slivers.add(list(entries));
    } else {
      final months = <DateTime, List<Entry>>{};
      for (final entry in entries) {
        months
            .putIfAbsent(
                DateTime(entry.timeCreate.year, entry.timeCreate.month),
                () => [])
            .add(entry);
      }
      for (final month in months.entries) {
        slivers.add(SliverMainAxisGroup(slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: _MonthHeaderDelegate(
                  month: month.key,
                  entries: month.value,
                  background: background)),
          list(month.value),
        ]));
      }
    }
    return CustomScrollView(
      key: const PageStorageKey('journal-timeline'),
      controller: _scrollController,
      slivers: [
        ...slivers,
        const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
      ],
    );
  }
}

class _MonthHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MonthHeaderDelegate(
      {required this.month, required this.entries, required this.background});

  final DateTime month;
  final List<Entry> entries;
  final Color background;

  static const double _height = 48;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final elapsed = TimeManager.isSameMonth(month, now) ? now.day : daysInMonth;
    final activeDays = entries.map((e) => e.timeCreate.day).toSet().length;
    return Material(
      color: background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: Text(TimeManager.formatMonthYear(month, context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Text(
                  '${l10n.todayEntryCount(entries.length)} · ${l10n.journalActiveDays(activeDays, elapsed)}',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: cs.onSurfaceVariant)),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_MonthHeaderDelegate oldDelegate) =>
      oldDelegate.month != month ||
      oldDelegate.entries.length != entries.length ||
      oldDelegate.background != background;
}
