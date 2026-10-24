// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_share.dart';
import 'package:aid_diary/utils/entry_typography.dart';
import 'package:aid_diary/utils/time_capsule.dart';
import 'package:aid_diary/widgets/delete_confirm_dialog.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:aid_diary/widgets/entry_tag_chips.dart';
import 'package:aid_diary/widgets/local_image_loader.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/scaled_markdown.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:intl/intl.dart';
import 'package:aid_diary/widgets/weather_icon.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:aid_diary/widgets/letter_paper.dart';

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
    final visible = context.watch<EntriesProvider>().entries;
    final hiddenSession = HiddenDiaryScope.of(context);
    final entry = (hiddenSession?.unlocked == true
            ? EntryStore.instance.allEntries
            : visible)
        .where((e) => e.id == entryId)
        .firstOrNull;
    if (entry == null) return const Scaffold();
    final images = context.watch<EntryImagesProvider>().getForEntry(entry);
    final tags = context.watch<TagsProvider>();
    final favorite = tags.isFavorite(entryId);
    final l10n = AppLocalizations.of(context)!;
    final sealed = entry.isSealed;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        actions: [
          if (!sealed) ...[
            if (!entry.isHidden)
              IconButton(
                key: const ValueKey('entry-share'),
                tooltip: l10n.entryShare,
                icon: const Icon(Icons.share_rounded),
                onPressed: () => _share(context, entry, images),
              ),
            if (!entry.isHidden)
              IconButton(
                key: const ValueKey('entry-favorite'),
                tooltip: l10n.entryFavorite,
                isSelected: favorite,
                icon: const Icon(Icons.star_outline_rounded),
                selectedIcon: const Icon(Icons.star_rounded),
                onPressed: () => AppActions.instance
                    .run('entry.favorite', {'id': entryId, 'value': !favorite}),
              ),
            IconButton(
              key: const ValueKey('diary-entry-edit'),
              tooltip: l10n.entryEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => _edit(context, entry),
            ),
          ],
          PopupMenuButton<String>(
            key: const ValueKey('entry-more'),
            onSelected: (value) => switch (value) {
              'template' => _saveAsTemplate(context, entry),
              'capsule' => _seal(context, entry),
              'hide' => _hide(context, entry),
              _ => _delete(context, entry),
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  key: const ValueKey('entry-hide'),
                  value: 'hide',
                  child: ListTile(
                      leading: Icon(entry.isHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      title: Text(entry.isHidden
                          ? l10n.hiddenDiaryShow
                          : l10n.hiddenDiaryHide))),
              if (!sealed && !entry.isHidden) ...[
                PopupMenuItem(
                    key: const ValueKey('entry-capsule'),
                    value: 'capsule',
                    child: ListTile(
                        leading: const Icon(Icons.lock_clock_outlined),
                        title: Text(l10n.capsuleSeal))),
                PopupMenuItem(
                    key: const ValueKey('entry-save-template'),
                    value: 'template',
                    child: ListTile(
                        leading: const Icon(Icons.note_add_outlined),
                        title: Text(l10n.entrySaveAsTemplate))),
              ],
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
      body: sealed
          ? _SealedCapsule(entry: entry)
          : LetterPaper(
              child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                if (images.isNotEmpty) _Photos(entry: entry, images: images),
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
            )),
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

  Future<void> _edit(BuildContext context, Entry entry) async {
    await EntryNavigation.edit(context, entry);
    onEntryEdited?.call(entry.id!);
  }

  Future<void> _hide(BuildContext context, Entry entry) async {
    if (entry.isHidden) {
      await HiddenDiaryScope.of(context)!.unhide(entry);
    } else {
      final messenger = ScaffoldMessenger.of(context);
      final l10n = AppLocalizations.of(context)!;
      await AppActions.instance.run('entry.hide', {'id': entry.id});
      // Every time: otherwise a hidden entry seems gone for good.
      messenger.showSnackBar(SnackBar(
          content: Text(l10n.hiddenDiaryWhere([
        l10n.pageSettingsTitle,
        l10n.settingsSecurityTitle,
        l10n.hiddenDiaryTitle,
      ].join(' › ')))));
    }
    if (context.mounted && !embedded && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveAsTemplate(BuildContext context, Entry entry) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fallback = TimeManager.formatDate(entry.day, context);
    await AppActions.instance
        .run('template.create_from_entry', {'id': entry.id, 'name': fallback});
    messenger.showSnackBar(SnackBar(content: Text(l10n.entrySavedAsTemplate)));
  }

  /// Seals the entry until a day the writer picks.
  Future<void> _seal(BuildContext context, Entry entry) async {
    final now = DateTime.now();
    final day = await TimeManager.pickDate(
      context,
      initialDate: CapsuleWindow.suggested(now),
      firstDate: CapsuleWindow.earliest(now),
      lastDate: CapsuleWindow.latest(now),
    );
    if (day == null) return;
    await AppActions.instance
        .run('entry.seal', {'id': entry.id, 'opens': DiaryDay.format(day)});
  }

  Future<void> _delete(BuildContext context, Entry entry) async {
    final navigator = Navigator.of(context);
    final hiddenSession = HiddenDiaryScope.of(context);
    final confirmed = await showDeleteConfirmDialog(context,
        message: AppLocalizations.of(context)!.deleteLogDescription);
    if (!confirmed) return;
    if (!embedded && navigator.canPop()) navigator.pop();
    if (entry.isHidden) {
      await hiddenSession!.delete(entry);
    } else {
      await AppActions.instance
          .run('entry.delete', {'id': entry.id}, confirmed: true);
    }
  }

  /// "Share as…" like Journey: the picture card, a ZIP with the original
  /// media, plain text or an HTML page.
  Future<void> _share(
      BuildContext context, Entry entry, List<EntryImage> images) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<_ShareAs>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(l10n.shareAs,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              for (final (option, icon, label) in [
                (_ShareAs.image, Icons.image_outlined, l10n.shareAsImage),
                (_ShareAs.zip, Icons.folder_zip_outlined, l10n.shareAsZip),
                (_ShareAs.text, Icons.notes_rounded, l10n.shareAsPlainText),
                (_ShareAs.html, Icons.code_rounded, l10n.shareAsHtml),
              ])
                ListTile(
                  key: ValueKey('share-as-${option.name}'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: Icon(icon),
                  title: Text(label),
                  onTap: () => Navigator.of(context).pop(option),
                ),
              const SizedBox(height: 8),
            ]),
      ),
    );
    if (choice == null || !context.mounted) return;
    final heading = EntryShare.heading(
        entry, TimeManager.formatDateWithWeekday(entry.day, context));
    final name =
        'aid-diary-${DateFormat('yyyy-MM-dd-HHmm').format(entry.timeCreate)}';
    Future<void> shareFile(List<int> bytes, String mimeType, String file) =>
        SharePlus.instance.share(ShareParams(files: [
          XFile.fromData(Uint8List.fromList(bytes), mimeType: mimeType)
        ], fileNameOverrides: [
          file
        ]));
    switch (choice) {
      case _ShareAs.image:
        await EntryNavigation.share(context, entry);
      case _ShareAs.text:
        await SharePlus.instance
            .share(ShareParams(text: EntryShare.plainText(entry, heading)));
      case _ShareAs.html:
        await shareFile(utf8.encode(EntryShare.html(entry, heading)),
            'text/html', '$name.html');
      case _ShareAs.zip:
        final bytes = await EntryShare.zip(
            entry, heading, images, ImageStorage.instance.getBytes);
        await shareFile(bytes, 'application/zip', '$name.zip');
    }
  }
}

enum _ShareAs { image, zip, text, html }

class _Photos extends StatefulWidget {
  const _Photos({required this.entry, required this.images});
  final Entry entry;
  final List<EntryImage> images;

  @override
  State<_Photos> createState() => _PhotosState();
}

class _PhotosState extends State<_Photos> {
  int _page = 0;

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
            onTap: () =>
                EntryNavigation.attachment(context, widget.entry, index),
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

/// What a sealed time capsule shows instead of its content.
class _SealedCapsule extends StatelessWidget {
  const _SealedCapsule({required this.entry});
  final Entry entry;

  Future<void> _openEarly(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final open = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.capsuleOpenEarly),
        content: Text(l10n.capsuleOpenEarlyDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            key: const ValueKey('capsule-open-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.capsuleOpenEarly),
          ),
        ],
      ),
    );
    if (open == true) {
      if (entry.isHidden &&
          context.mounted &&
          HiddenDiaryScope.of(context)?.unlocked == true) {
        await HiddenDiaryScope.of(context)!.unseal(entry);
      } else if (!entry.isHidden) {
        await AppActions.instance
            .run('entry.unseal', {'id': entry.id}, confirmed: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_clock_rounded,
              size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(l10n.capsuleTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
              l10n.capsuleOpensOn(
                  TimeManager.formatDate(entry.openAt!, context)),
              style: theme.textTheme.titleMedium),
          Text(
              l10n.capsuleWrittenOn(TimeManager.formatDate(entry.day, context)),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 24),
          TextButton.icon(
            key: const ValueKey('capsule-open-early'),
            onPressed: () => _openEarly(context),
            icon: const Icon(Icons.lock_open_rounded),
            label: Text(l10n.capsuleOpenEarly),
          ),
        ]),
      ),
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
    // The diary day; a late-night entry's clock time follows below.
    final diaryDay = entry.day;
    final day = TimeManager.isJalaliCalendar(context)
        ? TimeManager.jalaliDayNumber(diaryDay)
        : diaryDay.day;
    final detailStyle = theme.textTheme.labelMedium
        ?.copyWith(color: cs.primary, fontWeight: FontWeight.w700);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('$day',
          style: theme.textTheme.displaySmall
              ?.copyWith(color: cs.primary, fontWeight: FontWeight.w700)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(TimeManager.formatDate(diaryDay, context), style: detailStyle),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
              '${DateFormat.EEEE(locale).format(diaryDay)} ${TimeManager.localizedTimeFormat(context, locale).format(entry.timeCreate)}'
              '${entry.otherZoneLabel == null ? '' : ' (${entry.otherZoneLabel})'}',
              key: const ValueKey('entry-time'),
              style: detailStyle),
          if (entry.isLateNight) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: AppLocalizations.of(context)!.lateNightBadge,
              child: Icon(Icons.bedtime_outlined, size: 14, color: cs.primary),
            ),
          ],
        ]),
        // Written later about this day: say when.
        if (entry.isForAnotherDay)
          Text(
              AppLocalizations.of(context)!.editorWrittenAt(
                  TimeManager.formatDate(entry.writtenDate, context)),
              key: const ValueKey('entry-written-at'),
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: cs.onSurfaceVariant)),
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
                glyph: WeatherIcon(entry.weather!.code, size: 16),
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
  const _IconLabel({super.key, this.icon, this.glyph, required this.label});

  /// A plain icon, or [glyph] when it has colours of its own.
  final IconData? icon;
  final Widget? glyph;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      glyph ?? Icon(icon, size: 16, color: color),
      const SizedBox(width: 2),
      Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
    ]);
  }
}
