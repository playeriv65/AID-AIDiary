// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/widgets/choice_sheet.dart';
import 'package:aid_diary/widgets/day_picker.dart';
import 'package:aid_diary/widgets/entry_image_actions.dart';
import 'package:aid_diary/widgets/image_grid.dart';
import 'package:aid_diary/widgets/large_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_receiver/share_receiver.dart';

class SharePage extends StatefulWidget {
  final SharePayload payload;

  const SharePage({super.key, required this.payload});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  bool _opening = false;

  @override
  void dispose() {
    widget.payload.deleteImages();
    super.dispose();
  }

  /// Adds the shared content to [day]: to one of its entries, or to a new
  /// one when the person picks that or the day has none.
  Future<void> _addToDay(DateTime day) async {
    if (_opening) return;
    final entries = EntriesProvider.instance.getEntriesForDate(day);
    Entry? entry;
    if (entries.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;
      final timeFormat = TimeManager.localizedTimeFormat(
          context, TimeManager.currentLocale(context));
      final choice = await showChoiceSheet<({Entry? entry})>(
          context,
          [
            for (final entry in entries)
              (
                value: (entry: entry),
                icon: Icons.edit_note_rounded,
                label: timeFormat.format(entry.timeCreate),
                key: ValueKey('share-entry-${entry.id}')
              ),
            (
              value: (entry: null),
              icon: Icons.add_rounded,
              label: l10n.adaptiveNewEntry,
              key: const ValueKey('share-new-entry')
            ),
          ],
          title: TimeManager.formatDate(day, context));
      if (choice == null) return;
      entry = choice.entry;
    }
    if (!mounted) return;
    await _openEditor(day, entry);
  }

  Future<void> _openEditor(DateTime day, Entry? entry) async {
    setState(() => _opening = true);
    final List<String> imageNames;
    try {
      imageNames =
          await EntryImageActions.importSharedImages(widget.payload.imagePaths);
    } catch (_) {
      if (mounted) setState(() => _opening = false);
      rethrow;
    }
    if (!mounted) return;

    final page = entry == null
        ? AddEditEntryPage(
            diaryDay: DiaryDay.forNewEntry(day),
            images: EntryImage.appendRanked(const [], imageNames, entryId: -1),
            sharedText: widget.payload.text,
          )
        : AddEditEntryPage(
            entry: entry,
            images: EntryImage.appendRanked(
                EntryImagesProvider.instance.getForEntry(entry), imageNames,
                entryId: entry.id!),
            sharedText: widget.payload.text,
          );
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) => page,
    ));
  }

  Widget _buildPreview() {
    final text = widget.payload.text;
    final hasText = text != null && text.isNotEmpty;
    final card = LargeCard(
      media: widget.payload.imagePaths.isEmpty
          ? null
          : ImageGrid.fromPaths(
              imagePaths: widget.payload.imagePaths,
              imageBuilder: (path) => Image.file(
                File(path),
                fit: BoxFit.cover,
                cacheWidth: 500,
              ),
            ),
      body: hasText ? LargeCard.markdownBody(text) : null,
    );
    if (widget.payload.imagePaths.isEmpty || hasText) return card;
    return Center(child: AspectRatio(aspectRatio: 1, child: card));
  }

  @override
  Widget build(BuildContext context) {
    final today = DiaryDay.today();
    final calendarToday = DiaryDay.dateOf(DateTime.now());
    final picker = DayPicker(
      initialDay: today,
      firstDay: DateTime(2000),
      lastDay: today.isAfter(calendarToday) ? today : calendarToday,
      confirm: MaterialLocalizations.of(context).continueButtonLabel,
      onPicked: _addToDay,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.shareAddToLogPickerTitle),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                children: [
                  SizedBox(height: 200, child: _buildPreview()),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: DayPicker.width),
                            child: picker),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_opening)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
