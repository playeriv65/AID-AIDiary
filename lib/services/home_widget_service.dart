// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/stats/streaks.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

/// What the Android home screen widget shows, as the text it needs.
class HomeWidgetSnapshot {
  const HomeWidgetSnapshot({
    required this.writtenDate,
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
      writtenDate: latest == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(latest.timeCreate),
      snippet: latest == null ? '' : firstLine(latest.text),
      streak: streak > 0 ? l10n.streakCurrent(streak) : '',
      done: l10n.widgetDone,
      pending: l10n.widgetPending,
      write: l10n.widgetWrite,
    );
  }

  /// Local date of the latest entry; the widget compares it with today.
  final String writtenDate;
  final String snippet;
  final String streak;
  final String done;
  final String pending;
  final String write;

  Map<String, String> toWidgetData() => {
        'widget_written_date': writtenDate,
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

/// The photo the photo widget shows today and the entry it belongs to.
typedef PhotoWidgetChoice = ({Entry entry, EntryImage image});

/// One photo for [day], the same all day so the widget does not flicker as
/// entries change; null when no entry has a photo. Sealed capsules are
/// left out.
PhotoWidgetChoice? photoForDay(List<Entry> entries,
    List<EntryImage> Function(Entry entry) imagesOf, DateTime day) {
  final photos = [
    for (final entry in entries)
      if (!entry.isSealed)
        for (final image in imagesOf(entry))
          if (image.isImage) (entry: entry, image: image),
  ];
  if (photos.isEmpty) return null;
  final seed = day.year * 10000 + day.month * 100 + day.day;
  return photos[Random(seed).nextInt(photos.length)];
}

/// Keeps the Android widgets in step with the diary and reports their taps.
class HomeWidgetService {
  static const _provider = 'com.demizo.daily_you.DiaryWidgetProvider';
  static const _photoProvider = 'com.demizo.daily_you.PhotoWidgetProvider';
  static const _writeHost = 'write';
  static const _entryHost = 'entry';
  static final _logger = Logger('HomeWidgetService');

  /// The photo last copied for the widget, so it is not redone each time.
  static String? _photoShown;

  static bool get supported => Platform.isAndroid;

  static Future<void> push(HomeWidgetSnapshot snapshot) async {
    if (!supported) return;
    try {
      for (final MapEntry(:key, :value) in snapshot.toWidgetData().entries) {
        await HomeWidget.saveWidgetData<String>(key, value);
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: _provider);
    } catch (error, stackTrace) {
      _logger.warning('Home widget update failed', error, stackTrace);
    }
  }

  /// Gives the photo widget [choice], scaled down into a file the widget
  /// reads, with [caption] under it; [empty] shows when there is none.
  static Future<void> pushPhoto(
      PhotoWidgetChoice? choice, String caption, String empty) async {
    if (!supported) return;
    try {
      final file = File(join(
          (await getApplicationSupportDirectory()).path, 'widget_photo.jpg'));
      var path = '';
      if (choice != null) {
        if (_photoShown != choice.image.imgPath || !file.existsSync()) {
          final bytes =
              await ImageStorage.instance.getBytes(choice.image.imgPath);
          final scaled =
              bytes == null ? null : await Isolate.run(() => _scale(bytes));
          if (scaled != null) {
            await file.writeAsBytes(scaled, flush: true);
            _photoShown = choice.image.imgPath;
          }
        }
        if (_photoShown == choice.image.imgPath) path = file.path;
      }
      await HomeWidget.saveWidgetData<String>('photo_widget_path', path);
      await HomeWidget.saveWidgetData<String>(
          'photo_widget_entry', path.isEmpty ? '' : '${choice!.entry.id}');
      await HomeWidget.saveWidgetData<String>('photo_widget_caption', caption);
      await HomeWidget.saveWidgetData<String>('photo_widget_empty', empty);
      await HomeWidget.updateWidget(qualifiedAndroidName: _photoProvider);
    } catch (error, stackTrace) {
      _logger.warning('Photo widget update failed', error, stackTrace);
    }
  }

  /// Upright and at most 720 px on the long side: widget bitmaps travel
  /// through a size-limited channel.
  static Uint8List? _scale(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final upright = img.bakeOrientation(decoded);
    final landscape = upright.width >= upright.height;
    final scaled = (landscape ? upright.width : upright.height) <= 720
        ? upright
        : img.copyResize(upright,
            width: landscape ? 720 : null,
            height: landscape ? null : 720,
            interpolation: img.Interpolation.average);
    return img.encodeJpg(scaled, quality: 85);
  }

  /// Whether a widget tap asked to write today's entry.
  static bool isWrite(Uri? uri) => uri?.host == _writeHost;

  /// The entry a photo widget tap asked to show.
  static int? entryOf(Uri? uri) => uri?.host == _entryHost
      ? int.tryParse(uri!.queryParameters['id'] ?? '')
      : null;

  static Future<Uri?> launchUri() =>
      supported ? HomeWidget.initiallyLaunchedFromHomeWidget() : Future.value();

  static Stream<Uri?> get taps =>
      supported ? HomeWidget.widgetClicked : const Stream.empty();
}
