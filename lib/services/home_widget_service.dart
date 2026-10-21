// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/stats/streaks.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' show join;

/// What the Android home screen widget shows, as the text it needs.
class HomeWidgetSnapshot {
  const HomeWidgetSnapshot({
    required this.writtenDate,
    required this.dayStartHour,
    required this.snippet,
    required this.streak,
    required this.done,
    required this.pending,
    required this.write,
  });

  /// [entries] must be newest first, as the entries provider keeps them.
  factory HomeWidgetSnapshot.from(List<Entry> entries, AppLocalizations l10n) {
    final latest = entries.firstOrNull;
    final streak = calculateStreaks(entries).current;
    return HomeWidgetSnapshot(
      writtenDate:
          latest == null ? '' : DateFormat('yyyy-MM-dd').format(latest.day),
      dayStartHour: DiaryDay.startHour,
      snippet: latest == null ? '' : firstLine(latest.text),
      streak: streak > 0 ? l10n.streakCurrent(streak) : '',
      done: l10n.widgetDone,
      pending: l10n.widgetPending,
      write: l10n.widgetWrite,
    );
  }

  /// Diary day of the latest entry; the widget compares it with the diary
  /// day now, using [dayStartHour].
  final String writtenDate;

  /// Hours after midnight that still belong to the day before.
  final int dayStartHour;
  final String snippet;
  final String streak;
  final String done;
  final String pending;
  final String write;

  Map<String, String> toWidgetData() => {
        'widget_written_date': writtenDate,
        'widget_day_start_hour': '$dayStartHour',
        'widget_snippet': snippet,
        'widget_streak': streak,
        'widget_done': done,
        'widget_pending': pending,
        'widget_write': write,
      };

  /// The first line with text, without markdown heading or list marks.
  static String firstLine(String text) =>
      text
          .split('\n')
          .map((line) =>
              line.replaceFirst(RegExp(r'^\s*([#>*-]+|\d+\.)\s*'), '').trim())
          .where((line) => line.isNotEmpty)
          .firstOrNull ??
      '';
}

/// A photo the photo widget may show and the entry it belongs to.
typedef PhotoWidgetChoice = ({Entry entry, EntryImage image});

/// Up to [limit] photos for the photo widget, which picks one per day by
/// itself. The sample stays the same while the number of photos does, so
/// pushing it again changes nothing. Sealed capsules are left out.
List<PhotoWidgetChoice> photoCandidates(List<Entry> entries,
    List<EntryImage> Function(Entry entry) imagesOf, int limit) {
  final photos = [
    for (final entry in entries)
      if (!entry.isSealed)
        for (final image in imagesOf(entry))
          if (image.isImage) (entry: entry, image: image),
  ];
  if (photos.length <= limit) return photos;
  return (photos..shuffle(Random(photos.length))).take(limit).toList();
}

/// Keeps the Android widgets in step with the diary and reports their taps.
class HomeWidgetService {
  static const _provider = 'dev.aid.diary.DiaryWidgetProvider';
  static const _photoProvider = 'dev.aid.diary.PhotoWidgetProvider';
  static const _writeHost = 'write';
  static const _newEntryHost = 'new';
  static const _entryHost = 'entry';
  static final _logger = Logger('HomeWidgetService');

  /// What each widget was last given, so unchanged data is not rewritten
  /// on every change to the diary.
  static Map<String, String>? _pushed;
  static Map<String, String>? _photosPushed;

  static bool get supported => Platform.isAndroid;

  static Future<void> push(HomeWidgetSnapshot snapshot) async {
    if (!supported) return;
    final data = snapshot.toWidgetData();
    if (mapEquals(data, _pushed)) return;
    _pushed = data;
    await _save(data, _provider, 'Home widget');
  }

  /// Gives the photo widget [candidates] with [caption] under each and
  /// [empty] for when there is none. The widget picks one per day and
  /// loads the file itself, so it turns over without the app.
  static Future<void> pushPhotos(List<PhotoWidgetChoice> candidates,
      String Function(Entry entry) caption, String empty) async {
    if (!supported) return;
    final folder = await ImageStorage.instance.getInternalFolder();
    final data = {
      'photo_widget_photos': jsonEncode([
        for (final (:entry, :image) in candidates)
          {
            'path': join(folder, image.imgPath),
            'entry': entry.id,
            'caption': caption(entry),
          }
      ]),
      'photo_widget_empty': empty,
    };
    if (mapEquals(data, _photosPushed)) return;
    _photosPushed = data;
    await _save(data, _photoProvider, 'Photo widget');
  }

  static Future<void> _save(
      Map<String, String> data, String provider, String name) async {
    try {
      for (final MapEntry(:key, :value) in data.entries) {
        await HomeWidget.saveWidgetData<String>(key, value);
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: provider);
    } catch (error, stackTrace) {
      _logger.warning('$name update failed', error, stackTrace);
    }
  }

  /// Whether a widget tap asked to write today's entry.
  static bool isWrite(Uri? uri) => uri?.host == _writeHost;

  /// Whether the quick-write notification, as put back natively after a
  /// restart, asked for a new entry.
  static bool isNewEntry(Uri? uri) => uri?.host == _newEntryHost;

  /// The entry a photo widget tap asked to show.
  static int? entryOf(Uri? uri) => uri?.host == _entryHost
      ? int.tryParse(uri!.queryParameters['id'] ?? '')
      : null;

  static Future<Uri?> launchUri() =>
      supported ? HomeWidget.initiallyLaunchedFromHomeWidget() : Future.value();

  static Stream<Uri?> get taps =>
      supported ? HomeWidget.widgetClicked : const Stream.empty();
}
