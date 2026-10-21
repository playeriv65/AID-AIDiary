// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/flashback.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entries_list_page.dart';
import 'package:aid_diary/pages/entry_timeline_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:material_ui/material_ui.dart';

/// Routes shared by the Today, Journal and Calendar pages.
class EntryNavigation {
  static Future<void> edit(BuildContext context, Entry? entry,
      {bool openCamera = false,
      List<EntryImage>? images,
      DateTime? overrideCreateDate,
      int? initialMood,
      Template? template}) {
    // The editor covers the whole window, rail included, like Journey.
    return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) => AddEditEntryPage(
        entry: entry,
        openCamera: openCamera,
        images: images ??
            (entry != null
                ? EntryImagesProvider.instance.getForEntry(entry)
                : const []),
        overrideCreateDate: overrideCreateDate,
        initialMood: initialMood,
        template: template,
      ),
    ));
  }

  /// Opens a new entry on [day], keeping the current time of day.
  static Future<void> addForDay(BuildContext context, DateTime day,
      {int? initialMood}) {
    return edit(context, null,
        overrideCreateDate: DiaryDay.nowOn(day), initialMood: initialMood);
  }

  static Future<void> addForPickedDay(BuildContext context) async {
    final picked = await TimeManager.pickDate(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null || !context.mounted) return;
    await addForDay(context, picked);
  }

  /// Shows [entry] in a pager over [entries] (all entries by default).
  static Future<void> view(BuildContext context, Entry entry,
      {List<Entry> Function()? entries}) {
    final getEntries = entries ?? () => EntriesProvider.instance.entries;
    final index = getEntries().indexWhere((e) => e.id == entry.id);
    return Navigator.of(context).push(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) =>
          EntriesListPage(index: index < 0 ? 0 : index, getEntries: getEntries),
    ));
  }

  static Future<void> onThisDay(
      BuildContext context, DateTime referenceDate) async {
    final isJalali = TimeManager.isJalaliCalendar(context);
    final refYear = TimeManager.calendarYearOf(referenceDate, isJalali);
    bool matches(Entry e) =>
        TimeManager.isOnThisDayMatch(e.day, referenceDate, isJalali);
    if (!EntriesProvider.instance.entries.any(matches)) return;
    await Navigator.of(context).push(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) => EntryTimelinePage(
        header: AppLocalizations.of(context)!.flashbackOnThisDay,
        getEntries: () =>
            EntriesProvider.instance.entries.where(matches).toList(),
        labelBuilder: (_, e) => AppLocalizations.of(context)!.flashbackYear(
            refYear - TimeManager.calendarYearOf(e.day, isJalali)),
      ),
    ));
  }

  static Future<void> flashback(
      BuildContext context, Flashback flashback) async {
    if (flashback.isMultiEntry && flashback.isOnThisDay) {
      await NotificationManager.instance.dismissOnThisDayNotification();
      if (context.mounted) await onThisDay(context, DiaryDay.today());
    } else if (flashback.isMultiEntry) {
      final ids = flashback.entries.map((e) => e.id).toSet();
      await Navigator.of(context).push(MaterialPageRoute(
        allowSnapshotting: false,
        builder: (context) => EntryTimelinePage(
          header: flashback.title,
          getEntries: () => EntriesProvider.instance.entries
              .where((e) => ids.contains(e.id))
              .toList()
              .reversed
              .toList(),
          labelBuilder: (context, e) => TimeManager.localizedTimeFormat(
                  context, TimeManager.currentLocale(context))
              .format(e.timeCreate),
        ),
      ));
    } else {
      await view(context, flashback.firstEntry);
    }
  }
}
