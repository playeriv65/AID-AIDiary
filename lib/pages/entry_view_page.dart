// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/entry_share_page.dart';
import 'package:daily_you/pages/image_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/providers/tags_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_actions.dart';
import 'package:daily_you/utils/entry_context_display.dart';
import 'package:daily_you/utils/entry_typography.dart';
import 'package:daily_you/widgets/delete_confirm_dialog.dart';
import 'package:daily_you/widgets/entry_tag_chips.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/media_attachment.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/scaled_markdown.dart';
import 'package:daily_you/widgets/tag_chip.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Reads one entry: photos, date block, metadata, then the text.
class EntryViewPage extends StatelessWidget {
  const EntryViewPage({
    super.key,
    required this.entryId,
    this.onEntryEdited,
    this.embedded = false,
    this.onPrevious,
    this.onNext,
  });

  final int entryId;
  final ValueChanged<int>? onEntryEdited;

  /// In a detail pane rather than its own route: no back button.
  final bool embedded;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final entry = context
        .watch<EntriesProvider>()
        .entries
        .where((e) => e.id == entryId)
        .firstOrNull;
    if (entry == null) return const Scaffold();
    final images = context.watch<EntryImagesProvider>().getForEntry(entry);
    final tags = context.watch<TagsProvider>();
    final favorite = tags.isFavorite(entryId);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        actions: [
          IconButton(
            tooltip: l10n.entryShare,
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _share(context, entry, images),
          ),
          if (tags.favoriteTag != null)
            IconButton(
              key: const ValueKey('entry-favorite'),
              tooltip: l10n.entryFavorite,
              isSelected: favorite,
              icon: const Icon(Icons.star_outline_rounded),
              selectedIcon: const Icon(Icons.star_rounded),
              onPressed: () => tags.setFavorite(entryId, !favorite),
            ),
          IconButton(
            key: const ValueKey('diary-entry-edit'),
            tooltip: l10n.entryEdit,
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => _edit(context, entry, images),
          ),
          PopupMenuButton<String>(
            key: const ValueKey('entry-more'),
            onSelected: (value) => switch (value) {
              'duplicate' => _duplicate(context, entry),
              'template' => _saveAsTemplate(context, entry),
              _ => _delete(context, entry),
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  key: const ValueKey('entry-duplicate'),
                  value: 'duplicate',
                  child: ListTile(
                      leading: const Icon(Icons.copy_rounded),
                      title: Text(l10n.entryDuplicate))),
              PopupMenuItem(
                  key: const ValueKey('entry-save-template'),
                  value: 'template',
                  child: ListTile(
                      leading: const Icon(Icons.note_add_outlined),
                      title: Text(l10n.entrySaveAsTemplate))),
              PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                      leading: const Icon(Icons.delete_outline_rounded),
                      title: Text(MaterialLocalizations.of(context)
                          .deleteButtonTooltip))),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          if (images.isNotEmpty) _Photos(images: images),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntryDateBlock(entry: entry),
                    _Metadata(entry: entry),
                    const SizedBox(height: 16),
                    if (entry.text.isNotEmpty)
                      SelectionArea(
                        child: ScaledMarkdown(
                            data: entry.text,
                            selectable: false,
                            typography: EntryTypography.of(context)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: onPrevious == null && onNext == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(children: [
                  IconButton(
                      key: const ValueKey('entry-previous'),
                      tooltip: l10n.entryPrevious,
                      onPressed: onPrevious,
                      icon: const Icon(Icons.chevron_left_rounded)),
                  const Spacer(),
                  IconButton(
                      key: const ValueKey('entry-next'),
                      tooltip: l10n.entryNext,
                      onPressed: onNext,
                      icon: const Icon(Icons.chevron_right_rounded)),
                ]),
              ),
            ),
    );
  }

  Future<void> _edit(
      BuildContext context, Entry entry, List<EntryImage> images) async {
    await Navigator.of(context).push(PageRouteBuilder(
      allowSnapshotting: false,
      fullscreenDialog: true,
      pageBuilder: (context, _, __) =>
          AddEditEntryPage(entry: entry, images: images),
      transitionsBuilder: (context, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    ));
    onEntryEdited?.call(entry.id!);
  }

  Future<void> _duplicate(BuildContext context, Entry entry) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context)!.entryDuplicated;
    await EntryActions.duplicate(entry);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveAsTemplate(BuildContext context, Entry entry) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fallback = TimeManager.formatDate(entry.timeCreate, context);
    await EntryActions.saveAsTemplate(entry, fallback);
    messenger.showSnackBar(SnackBar(content: Text(l10n.entrySavedAsTemplate)));
  }

  Future<void> _delete(BuildContext context, Entry entry) async {
    final navigator = Navigator.of(context);
    final confirmed = await showDeleteConfirmDialog(context,
        message: AppLocalizations.of(context)!.deleteLogDescription);
    if (!confirmed) return;
    if (!embedded && navigator.canPop()) navigator.pop();
    await EntryStore.instance.delete(entry);
  }

  Future<void> _share(
          BuildContext context, Entry entry, List<EntryImage> images) =>
      Navigator.of(context).push(MaterialPageRoute(
        allowSnapshotting: false,
        fullscreenDialog: true,
        builder: (_) => EntrySharePage(entry: entry, images: images),
      ));
}

class _Photos extends StatefulWidget {
  const _Photos({required this.images});
  final List<EntryImage> images;

  @override
  State<_Photos> createState() => _PhotosState();
}

class _PhotosState extends State<_Photos> {
  int _page = 0;

  /// Photos open in the zoomable viewer among the other photos; videos and
  /// voice notes open in the player.
  void _open(BuildContext context, EntryImage attachment) {
    final photos = widget.images.where((image) => image.isImage).toList();
    Navigator.of(context).push(MaterialPageRoute(
      allowSnapshotting: false,
      fullscreenDialog: true,
      builder: (_) => attachment.isImage
          ? ImageViewPage(images: photos, index: photos.indexOf(attachment))
          : MediaPlayerPage(name: attachment.imgPath),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return SizedBox(
      height: 320,
      child: Stack(children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (page) => setState(() => _page = page),
          itemBuilder: (context, index) => GestureDetector(
            key: ValueKey('entry-attachment-$index'),
            onTap: () => _open(context, images[index]),
            child: LocalImageLoader(
                imagePath: images[index].imgPath, cacheSize: 1200),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < images.length; i++)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                            .withValues(alpha: i == _page ? 1 : .5)),
                  ),
              ],
            ),
          ),
      ]),
    );
  }
}

/// Large day number beside the date, weekday and time.
class EntryDateBlock extends StatelessWidget {
  const EntryDateBlock({super.key, required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final locale = TimeManager.currentLocale(context);
    final day = TimeManager.isJalaliCalendar(context)
        ? TimeManager.jalaliDayNumber(entry.timeCreate)
        : entry.timeCreate.day;
    final detailStyle = theme.textTheme.labelMedium
        ?.copyWith(color: cs.primary, fontWeight: FontWeight.w700);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('$day',
          style: theme.textTheme.displaySmall
              ?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(TimeManager.formatDate(entry.timeCreate, context),
            style: detailStyle),
        Text(
            '${DateFormat.EEEE(locale).format(entry.timeCreate)} ${TimeManager.localizedTimeFormat(context, locale).format(entry.timeCreate)}',
            style: detailStyle),
      ]),
    ]);
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final hasMood = MoodIcon.getMoodIcon(entry.mood).isNotEmpty;
    final location = entry.location;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (hasMood) MoodIcon(moodValue: entry.mood, size: 20),
          if (location != null)
            _IconLabel(icon: Icons.place_rounded, label: location.label),
          if (entry.weather != null)
            _IconLabel(
                key: const ValueKey('entry-weather'),
                icon: weatherIcon(entry.weather!.code),
                label: weatherSummary(
                    entry.weather!, AppLocalizations.of(context)!)),
          if (entry.activity != null)
            _IconLabel(
                key: const ValueKey('entry-activity'),
                icon: activityIcon(entry.activity!),
                label: activityLabel(
                    entry.activity!, AppLocalizations.of(context)!)),
          EntryTagChips(
            entryId: entry.id!,
            chipBuilder: (tag, entryTag) =>
                TagChip(tag: tag, value: entryTag.value),
          ),
        ],
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 2),
      Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
    ]);
  }
}
