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
    this.prompts = const [],
    this.zeroStreak = '',
  });

  /// [entries] must be newest first, as the entries provider keeps them.
  factory HomeWidgetSnapshot.from(List<Entry> entries, AppLocalizations l10n) {
    final visible = entries.where((entry) => !entry.isSealed).toList()
      ..sort((a, b) => b.day.compareTo(a.day));
    final latest = visible.firstOrNull;
    final streak = calculateStreaks(visible).current;
    return HomeWidgetSnapshot(
      writtenDate:
          latest == null ? '' : DateFormat('yyyy-MM-dd').format(latest.day),
      dayStartHour: DiaryDay.startHour,
      snippet: latest == null ? '' : firstLine(latest.text),
      streak: streak > 0 ? l10n.streakCurrent(streak) : '',
      done: l10n.widgetDone,
      pending: l10n.widgetPending,
      write: l10n.widgetWrite,
      prompts: dailyWidgetPrompts(l10n),
      zeroStreak: l10n.streakCurrent(0),
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
  final List<String> prompts;
  final String zeroStreak;

  Map<String, String> toWidgetData() => {
        'widget_written_date': writtenDate,
        'widget_day_start_hour': '$dayStartHour',
        'widget_snippet': snippet,
        'widget_streak': streak,
        'widget_done': done,
        'widget_pending': pending,
        'widget_write': write,
        'widget_prompts': jsonEncode(prompts),
        'widget_streak_zero': zeroStreak,
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
    if (await _save(data, _provider, 'Home widget', additionalProviders: [
      for (final kind in ['Streak', 'Prompt', 'Mood'])
        'dev.aid.diary.${kind}WidgetProvider'
    ])) {
      _pushed = data;
    }
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
    if (await _save(data, _photoProvider, 'Photo widget')) _photosPushed = data;
  }

  static Future<bool> _save(
      Map<String, String> data, String provider, String name,
      {List<String> additionalProviders = const []}) async {
    try {
      for (final MapEntry(:key, :value) in data.entries) {
        await HomeWidget.saveWidgetData<String>(key, value);
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: provider);
      for (final extra in additionalProviders) {
        await HomeWidget.updateWidget(qualifiedAndroidName: extra);
      }
      return true;
    } catch (error, stackTrace) {
      _logger.warning('$name update failed', error, stackTrace);
      return false;
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

  static int? moodOf(Uri? uri) {
    if (uri?.host != 'mood') return null;
    final value = int.tryParse(uri!.queryParameters['value'] ?? '');
    return value != null && value >= -2 && value <= 2 ? value : null;
  }

  static int? promptOf(Uri? uri) {
    if (uri?.host != 'prompt') return null;
    final value = int.tryParse(uri!.queryParameters['index'] ?? '');
    return value != null && value >= 0 && value < 10 ? value : null;
  }

  static Future<Uri?> launchUri() =>
      supported ? HomeWidget.initiallyLaunchedFromHomeWidget() : Future.value();

  static Stream<Uri?> get taps =>
      supported ? HomeWidget.widgetClicked : const Stream.empty();
}

List<String> dailyWidgetPrompts(AppLocalizations l10n) => [
      l10n.coachPrompt1,
      l10n.coachPrompt2,
      l10n.coachPrompt3,
      l10n.coachPrompt4,
      l10n.coachPrompt5,
      l10n.coachPrompt6,
      l10n.coachPrompt7,
      l10n.coachPrompt8,
      l10n.coachPrompt9,
      l10n.coachPrompt10,
    ];
