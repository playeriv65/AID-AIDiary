// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/flashback.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/pages/edit_entry_page.dart';
import 'package:aid_diary/pages/entries_list_page.dart';
import 'package:aid_diary/pages/entry_share_page.dart';
import 'package:aid_diary/pages/entry_timeline_page.dart';
import 'package:aid_diary/pages/image_view_page.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:material_ui/material_ui.dart';

/// Routes shared by the Today, Journal and Calendar pages.
class EntryNavigation {
  static Future<void> edit(BuildContext context, Entry? entry,
      {bool openCamera = false,
      List<EntryImage>? images,
      DateTime? diaryDay,
      int? initialMood,
      Template? template,
      String? text,
      List<EntryRef>? refs}) {
    // The editor covers the whole window, rail included, like Journey.
    return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      settings: routeFor('editor', entry?.id),
      allowSnapshotting: false,
      builder: HiddenDiaryScope.protectRoute(
          context,
          (_) => AddEditEntryPage(
                entry: entry,
                openCamera: openCamera,
                images: images ??
                    (entry != null
                        ? EntryImagesProvider.instance.getForEntry(entry)
                        : const []),
                diaryDay: diaryDay,
                initialMood: initialMood,
                template: template,
                sharedText: text,
                refs: refs,
              )),
    ));
  }

  /// Opens a new entry for diary [day], written now.
  static Future<void> addForDay(BuildContext context, DateTime day,
      {int? initialMood}) {
    return edit(context, null,
        diaryDay: DiaryDay.forNewEntry(day), initialMood: initialMood);
  }

  /// Shows [entry] in a pager over [entries] (all entries by default).
  static Future<void> view(BuildContext context, Entry entry,
      {List<Entry> Function()? entries}) {
    final getEntries = entries ?? () => EntriesProvider.instance.entries;
    final index = getEntries().indexWhere((e) => e.id == entry.id);
    return pushPlace(
        context,
        'entry',
        id: entry.id,
        HiddenDiaryScope.protectRoute(
            context,
            (_) => EntriesListPage(
                index: index < 0 ? 0 : index, getEntries: getEntries)));
  }

  /// Every entry of [date], newest first.
  static Future<void> day(BuildContext context, DateTime date) => pushPlace(
      context,
      'day',
      id: DiaryDay.format(date),
      (context) => EntryTimelinePage(
            header: TimeManager.formatDate(date, context),
            getEntries: () => EntriesProvider.instance.getEntriesForDate(date),
            labelBuilder: (context, entry) => TimeManager.localizedTimeFormat(
                    context, TimeManager.currentLocale(context))
                .format(entry.timeCreate),
          ));

  /// A batch of entries picked out together, such as one point on the map,
  /// as a list of their own under [header].
  static Future<void> group(
          BuildContext context, List<int> ids, String header) =>
      pushPlace(
          context,
          'entries',
          id: ids.join(','),
          (context) => EntryTimelinePage(
                header: header,
                getEntries: () => EntriesProvider.instance.entries
                    .where((entry) => ids.contains(entry.id))
                    .toList(),
                labelBuilder: (context, entry) =>
                    TimeManager.formatDate(entry.day, context),
              ));

  static Future<void> onThisDay(
      BuildContext context, DateTime referenceDate) async {
    final isJalali = TimeManager.isJalaliCalendar(context);
    final refYear = TimeManager.calendarYearOf(referenceDate, isJalali);
    bool matches(Entry e) =>
        TimeManager.isOnThisDayMatch(e.day, referenceDate, isJalali);
    if (!EntriesProvider.instance.entries.any(matches)) return;
    await pushPlace(
        context,
        'on_this_day',
        id: DiaryDay.format(referenceDate),
        (context) => EntryTimelinePage(
              header: AppLocalizations.of(context)!.flashbackOnThisDay,
              getEntries: () =>
                  EntriesProvider.instance.entries.where(matches).toList(),
              labelBuilder: (_, e) => AppLocalizations.of(context)!
                  .flashbackYear(
                      refYear - TimeManager.calendarYearOf(e.day, isJalali)),
            ));
  }

  /// [entry] as a picture to share.
  static Future<void> share(BuildContext context, Entry entry) => pushPlace(
      context,
      'entry_share',
      id: entry.id,
      fullscreenDialog: true,
      (context) => EntrySharePage(
          entry: entry,
          images: EntryImagesProvider.instance.getForEntry(entry)));

  /// Attachment [index] of [entry]: a photo opens among its other photos,
  /// a video or voice note in the player.
  static Future<void> attachment(BuildContext context, Entry entry, int index) {
    final attachments = EntryImagesProvider.instance.getForEntry(entry);
    final attachment = attachments[index];
    final photos = attachments.where((image) => image.isImage).toList();
    return pushPlace(
        context,
        'attachment',
        id: '${entry.id}/$index',
        fullscreenDialog: true,
        HiddenDiaryScope.protectRoute(
            context,
            (_) => attachment.isImage
                ? ImageViewPage(
                    images: photos, index: photos.indexOf(attachment))
                : MediaPlayerPage(name: attachment.imgPath)));
  }

  /// Today's flashback number [index], as `flashback.list` counts them.
  static Future<void> flashback(
      BuildContext context, Flashback flashback, int index) async {
    if (flashback.isMultiEntry && flashback.isOnThisDay) {
      await NotificationManager.instance.dismissOnThisDayNotification();
      if (context.mounted) await onThisDay(context, DiaryDay.today());
    } else if (flashback.isMultiEntry) {
      final ids = flashback.entries.map((e) => e.id).toSet();
      await pushPlace(
          context,
          'flashback',
          id: index,
          (context) => EntryTimelinePage(
                header: flashback.title,
                getEntries: () => EntriesProvider.instance.entries
                    .where((e) => ids.contains(e.id))
                    .toList()
                    .reversed
                    .toList(),
                labelBuilder: (context, e) => TimeManager.localizedTimeFormat(
                        context, TimeManager.currentLocale(context))
                    .format(e.timeCreate),
              ));
    } else {
      await view(context, flashback.firstEntry);
    }
  }
}

Entry _entry(ActionArgs args) {
  final id = intArg(args, 'id');
  return EntriesProvider.instance.entries
          .where((entry) => entry.id == id)
          .firstOrNull ??
      (throw ActionException('not_found', 'There is no entry $id'));
}

/// The entry [args] names, for places that would show what a sealed time
/// capsule keeps back.
Entry _openEntry(ActionArgs args) {
  final entry = _entry(args);
  if (entry.isSealed) {
    throw ActionException('sealed',
        'Entry ${entry.id} is a time capsule sealed until ${entry.openAt}');
  }
  return entry;
}

const _dayParam =
    ActionParam('day', ParamType.string, 'The diary day, yyyy-MM-dd');

/// The entry screens, for `ui.navigate`.
final List<Destination> entryDestinations = [
  Destination(
      'entry',
      'One entry, in the pager over all entries',
      params: const [ActionParam('id', ParamType.integer, 'The entry')],
      (context, args) => EntryNavigation.view(context, _entry(args))),
  Destination('editor',
      'The editor: an entry by id, or a new one for a day, mood or template',
      params: const [
        ActionParam('id', ParamType.integer, 'An entry to edit',
            required: false),
        ActionParam('day', ParamType.string,
            'For a new entry: its diary day, yyyy-MM-dd',
            required: false),
        ActionParam('mood', ParamType.integer, 'For a new entry: -2 to 2',
            required: false),
        ActionParam(
            'template', ParamType.integer, 'For a new entry: a template',
            required: false),
      ], (context, args) {
    if (args['id'] != null) return EntryNavigation.edit(context, _entry(args));
    final day = dateArg(args, 'day');
    final templateId = intArg(args, 'template');
    final template = templateId == null
        ? null
        : TemplatesProvider.instance.templates
                .where((template) => template.id == templateId)
                .firstOrNull ??
            (throw ActionException(
                'not_found', 'There is no template $templateId'));
    return EntryNavigation.edit(context, null,
        diaryDay: day == null ? null : DiaryDay.forNewEntry(day),
        initialMood: intArg(args, 'mood'),
        template: template);
  }),
  Destination(
      'day',
      'Every entry of one diary day',
      params: const [_dayParam],
      (context, args) => EntryNavigation.day(context, dateArg(args, 'day')!)),
  Destination('entries',
      'Some entries as a list of their own, as a point on the map opens them',
      params: const [
        ActionParam('ids', ParamType.string, 'Entry ids, comma separated'),
      ], (context, args) {
    final ids = [
      for (final id in (args['ids'] as String).split(','))
        if (int.tryParse(id.trim()) case final value?) value,
    ];
    return EntryNavigation.group(
        context, ids, AppLocalizations.of(context)!.logCount(ids.length));
  }),
  Destination(
      'on_this_day',
      'Entries from this day in earlier years',
      params: const [
        ActionParam('day', ParamType.string, 'yyyy-MM-dd; today by default',
            required: false),
      ],
      (context, args) => EntryNavigation.onThisDay(
          context, dateArg(args, 'day') ?? DiaryDay.today())),
  Destination(
      'flashback', "One of today's flashbacks, numbered as flashback.list does",
      params: const [
        ActionParam('index', ParamType.integer, 'Its index in flashback.list'),
      ], (context, args) {
    final flashbacks = FlashbackManager.getFlashbacks(
        context, EntriesProvider.instance.entries,
        listen: false);
    final index = intArg(args, 'index')!;
    if (index < 0 || index >= flashbacks.length) {
      throw ActionException('not_found',
          'There is no flashback $index; today has ${flashbacks.length}');
    }
    return EntryNavigation.flashback(context, flashbacks[index], index);
  }),
  Destination(
      'entry_share',
      'An entry as a picture to share',
      params: const [ActionParam('id', ParamType.integer, 'The entry')],
      (context, args) => EntryNavigation.share(context, _openEntry(args))),
  Destination(
      'attachment', 'A photo, video or voice note of an entry, full screen',
      params: const [
        ActionParam('id', ParamType.integer, 'The entry'),
        ActionParam('index', ParamType.integer,
            'Which attachment of the entry, counting from 0, as shown'),
      ], (context, args) {
    final entry = _openEntry(args);
    final index = intArg(args, 'index')!;
    final count = EntryImagesProvider.instance.getForEntry(entry).length;
    if (index < 0 || index >= count) {
      throw ActionException('not_found',
          'Entry ${entry.id} has $count attachments, not an index $index');
    }
    return EntryNavigation.attachment(context, entry, index);
  }),
];
