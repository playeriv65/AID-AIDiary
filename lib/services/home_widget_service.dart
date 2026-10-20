// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/stats/streaks.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

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

/// Keeps the Android widget in step with the diary and reports its taps.
class HomeWidgetService {
  static const _provider = 'com.demizo.daily_you.DiaryWidgetProvider';
  static const _writeHost = 'write';
  static final _logger = Logger('HomeWidgetService');

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

  /// Whether a widget tap asked to write today's entry.
  static bool isWrite(Uri? uri) => uri?.host == _writeHost;

  static Future<Uri?> launchUri() =>
      supported ? HomeWidget.initiallyLaunchedFromHomeWidget() : Future.value();

  static Stream<Uri?> get taps =>
      supported ? HomeWidget.widgetClicked : const Stream.empty();
}
