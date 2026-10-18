// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/image_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/scaled_markdown.dart';
import 'package:daily_you/widgets/entry_tag_chips.dart';
import 'package:daily_you/widgets/tag_chip.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:word_count/word_count.dart';
import 'package:share_plus/share_plus.dart';

class EntryViewPage extends StatefulWidget {
  const EntryViewPage({
    super.key,
    required this.entryId,
    required this.onEntryEdited,
    this.embedded = false,
  });

  final int entryId;
  final Function(int entryId) onEntryEdited;
  final bool embedded;

  @override
  State<EntryViewPage> createState() => _EntryViewPageState();
}

class _EntryViewPageState extends State<EntryViewPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);

    final entry = entriesProvider.entries
        .where((e) => e.id == widget.entryId)
        .firstOrNull;
    if (entry == null) return const Scaffold();

    final images = entryImagesProvider.getForEntry(entry);

    final locale = TimeManager.currentLocale(context);
    final words = wordsCount(entry.text);
    // Roughly 300 characters or 200 words a minute.
    final minutes = (words / 250).ceil();
    final metaStyle = theme.textTheme.bodyMedium
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        actions: [
          _shareButton(context, entry, images),
          _editButton(context, entry, images),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                TimeManager.formatMonthDay(
                                    entry.timeCreate, context),
                                style: theme.textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                [
                                  DateFormat.EEEE(locale)
                                      .format(entry.timeCreate),
                                  TimeManager.formatYear(
                                      entry.timeCreate, context),
                                  TimeManager.localizedTimeFormat(
                                          context, locale)
                                      .format(entry.timeCreate),
                                ].join(' · '),
                                style: metaStyle,
                              ),
                            ],
                          ),
                        ),
                        MoodIcon(moodValue: entry.mood, size: 36),
                      ],
                    ),
                    if (words > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${AppLocalizations.of(context)!.wordCount(words)} · ${AppLocalizations.of(context)!.entryReadingTime(minutes)}',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                      ),
                    EntryTagChips(
                      entryId: entry.id!,
                      padding: const EdgeInsets.only(top: 12),
                      chipBuilder: (tag, entryTag) =>
                          TagChip(tag: tag, value: entryTag.value),
                    ),
                    const SizedBox(height: 16),
                    if (images.length > 1) _imagesList(context, images),
                    if (images.length == 1)
                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 360),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: LocalImageLoader(
                                  imagePath: images.first.imgPath,
                                  cacheSize: 1000),
                            ),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            allowSnapshotting: false,
                            fullscreenDialog: true,
                            builder: (context) => ImageViewPage(
                              images: images,
                              index: 0,
                            ),
                          ));
                        },
                      ),
                    if (images.isNotEmpty) const SizedBox(height: 16),
                    if (entry.text.isNotEmpty)
                      ScaledMarkdown(
                        data: entry.text,
                        selectable: false,
                        scaleFactor: 1.05,
                      ),
                    const SizedBox(height: 24),
                    Divider(color: theme.colorScheme.outlineVariant),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "${AppLocalizations.of(context)!.lastModified}: ${TimeManager.formatDateWithWeekday(entry.timeModified, context)} ${TimeManager.localizedTimeFormat(context, locale).format(entry.timeModified)}",
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editButton(BuildContext context, entry, List<EntryImage> images) {
    return IconButton(
        key: const ValueKey('diary-entry-edit'),
        icon: const Icon(Icons.edit_rounded),
        onPressed: () async {
          await Navigator.of(context).push(PageRouteBuilder(
            allowSnapshotting: false,
            fullscreenDialog: true,
            pageBuilder: (context, _, __) =>
                AddEditEntryPage(entry: entry, images: images),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
          ));

          widget.onEntryEdited(entry.id);
        });
  }

  Widget _shareButton(BuildContext context, entry, List<EntryImage> images) {
    if (Platform.isAndroid && (images.isNotEmpty || entry.text.isNotEmpty)) {
      return IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () async {
            String sharedText = "";
            if (entry.mood != null) {
              sharedText = "${MoodIcon.getMoodIcon(entry.mood)} ";
            }
            sharedText =
                "$sharedText${TimeManager.formatDateWithWeekday(entry.timeCreate, context)}\n${entry.text}";

            if (images.isNotEmpty) {
              var bytes =
                  await ImageStorage.instance.getBytes(images.first.imgPath);
              if (bytes != null) {
                await SharePlus.instance.share(ShareParams(
                    files: [XFile.fromData(bytes, mimeType: "images/*")],
                    fileNameOverrides: [images.first.imgPath],
                    text: sharedText));
              }
            } else {
              SharePlus.instance.share(ShareParams(text: sharedText));
            }
          });
    }
    return Container();
  }

  Widget _imagesList(BuildContext context, List<EntryImage> images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const imageSize = 160.0;
        final fits = images.length * imageSize <= constraints.maxWidth;

        if (fits) {
          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: images
                  .map(
                    (image) => SizedBox(
                      width: imageSize,
                      child: GestureDetector(
                        child: Center(
                          child: SizedBox(
                            height: imageSize,
                            width: imageSize,
                            child: Card.filled(
                                clipBehavior: Clip.antiAlias,
                                child:
                                    LocalImageLoader(imagePath: image.imgPath)),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            allowSnapshotting: false,
                            fullscreenDialog: true,
                            builder: (context) => ImageViewPage(
                              images: images,
                              index: images.indexWhere((x) => x.id == image.id),
                            ),
                          ));
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return SizedBox(
          height: imageSize,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Center(
                    child: SizedBox(
                      height: imageSize,
                      width: imageSize,
                      child: Card.filled(
                          clipBehavior: Clip.antiAlias,
                          child: LocalImageLoader(
                              imagePath: images[index].imgPath)),
                    ),
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      allowSnapshotting: false,
                      fullscreenDialog: true,
                      builder: (context) => ImageViewPage(
                        images: images,
                        index: index,
                      ),
                    ));
                  },
                );
              }),
        );
      },
    );
  }
}
