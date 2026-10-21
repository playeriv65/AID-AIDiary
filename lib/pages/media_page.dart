// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/top_search_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Every attached photo, newest entry first.
class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  int? _selectedId;

  @override
  bool get wantKeepAlive => true;

  /// Photos paired with their entries, in timeline order.
  static List<(Entry, EntryImage)> mediaItems() {
    final images = EntryImagesProvider.instance;
    return [
      for (final entry in EntriesProvider.instance.entries)
        if (!entry.isSealed)
          for (final image in images.getForEntry(entry)) (entry, image),
    ];
  }

  List<Entry> _entriesWithMedia() {
    final seen = <int>{};
    return [
      for (final (entry, _) in mediaItems())
        if (seen.add(entry.id!)) entry,
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    context.watch<EntriesProvider>();
    context.watch<EntryImagesProvider>();
    final items = mediaItems();
    final selected = items.any((item) => item.$1.id == _selectedId);

    return ListDetailLayout(
      detail: selected
          ? EntryViewPage(
              key: ValueKey('media-detail-$_selectedId'),
              entryId: _selectedId!,
              embedded: true)
          : null,
      listBuilder: (context, split) => CustomScrollView(slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(child: TopSearchCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(child: SectionLabel(l10n.mediaFiles)),
        ),
        if (items.isEmpty)
          SliverToBoxAdapter(
            child: EmptyState(
                icon: Icons.photo_library_outlined,
                title: l10n.mediaEmpty,
                hint: l10n.mediaEmptyHint),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final (entry, image) = items[index];
                return ClipRRect(
                  key: ValueKey('media-${image.id ?? image.imgPath}'),
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(fit: StackFit.expand, children: [
                    LocalImageLoader(imagePath: image.imgPath, cacheSize: 300),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () => split
                            ? setState(() => _selectedId = entry.id)
                            : EntryNavigation.view(context, entry,
                                entries: _entriesWithMedia),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
      ]),
    );
  }
}
