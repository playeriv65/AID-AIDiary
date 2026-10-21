// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:math';

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/flashback.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _DailyFlashbackPicks {
  String date;
  int? goodDayEntryId;
  int? randomDayEntryId;

  _DailyFlashbackPicks(this.date, {this.goodDayEntryId, this.randomDayEntryId});

  factory _DailyFlashbackPicks.fromJson(Map<String, dynamic> json) =>
      _DailyFlashbackPicks(
        json['date'] as String,
        goodDayEntryId: json['goodDayEntryId'] as int?,
        randomDayEntryId: json['randomDayEntryId'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'goodDayEntryId': goodDayEntryId,
        'randomDayEntryId': randomDayEntryId,
      };
}

class FlashbackManager {
  static final Logger _logger = Logger('FlashbackManager');

  static const String _dailyPicksPrefsKey = 'flashbackDailyPickCache';

  static _DailyFlashbackPicks _dailyPicks = _DailyFlashbackPicks('');
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_dailyPicksPrefsKey);
    if (raw == null) return;
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        _dailyPicks = _DailyFlashbackPicks.fromJson(decoded);
      }
    } catch (error, stackTrace) {
      _logger.warning(
          'Stored daily flashback picks could not be read', error, stackTrace);
    }
  }

  static void _persistDailyPicks() {
    final encoded = json.encode(_dailyPicks.toJson());
    final prefs = _prefs;
    if (prefs != null) {
      prefs.setString(_dailyPicksPrefsKey, encoded);
    } else {
      SharedPreferences.getInstance()
          .then((p) => p.setString(_dailyPicksPrefsKey, encoded));
    }
  }

  static Entry? _resolveDailyPick({
    required int? cachedId,
    required void Function(int? entryId) setCachedId,
    required List<Entry> pool,
    required Set<Entry> usedEntries,
    required int? seed,
  }) {
    if (cachedId != null) {
      for (final entry in pool) {
        if (entry.id == cachedId && !usedEntries.contains(entry)) {
          return entry;
        }
      }
    }

    if (pool.isEmpty) return null;
    final random = Random(seed);
    for (int attempt = 0; attempt < pool.length; attempt++) {
      final candidate = pool[random.nextInt(pool.length)];
      if (!usedEntries.contains(candidate)) {
        setCachedId(candidate.id);
        _persistDailyPicks();
        return candidate;
      }
    }
    return null;
  }

  static Object? _cacheKey;
  static List<Flashback> _cached = const [];

  /// Today's flashbacks from [entries], which must be newest first. Pages
  /// rebuild often, so the result is kept until the entry list (replaced on
  /// every change), the day, the language or a flashback setting changes.
  static List<Flashback> getFlashbacks(
      BuildContext context, List<Entry> entries) {
    final configProvider = Provider.of<ConfigProvider>(context);
    // Diary days throughout: at 1:00 it is still yesterday's throwbacks.
    final now = DiaryDay.today();
    final key = (
      entries,
      now,
      DiaryDay.startHour,
      Localizations.localeOf(context),
      [
        for (final setting in [
          Settings.excludeBadDaysFromFlashbacks,
          Settings.showflashbackYearsAgo,
          Settings.showflashback6MonthsAgo,
          Settings.showflashback1MonthAgo,
          Settings.showflashback1WeekAgo,
          Settings.showflashbackGoodDay,
          Settings.showflashbackRandomDay,
        ])
          configProvider.get(setting)
      ].join(),
    );
    if (key == _cacheKey) return _cached;
    _cached = _compute(context, configProvider, entries, now);
    _cacheKey = key;
    return _cached;
  }

  static List<Flashback> _compute(BuildContext context,
      ConfigProvider configProvider, List<Entry> entries, DateTime now) {
    // Sealed time capsules must not surface early.
    List<Entry> filteredEntries =
        entries.where((entry) => !entry.isSealed).toList();

    if (configProvider.get(Settings.excludeBadDaysFromFlashbacks)) {
      // Filter out unhappy entries
      filteredEntries =
          filteredEntries.where((entry) => (entry.mood ?? 0) >= 0).toList();
    }

    List<Flashback> flashbacksList = List.empty(growable: true);
    Map<String, List<Entry>> singleFlashbacks = {};
    List<Entry> onThisDayEntries = [];
    List<String> onThisDayLabels = [];

    List<Entry> happyEntries = List.empty(growable: true);
    Set<Entry> usedEntries = {};

    if (filteredEntries.isEmpty) return flashbacksList;

    final locale = TimeManager.currentLocale(context);
    final isJalali = TimeManager.isJalaliCalendar(context);
    final yearsAgo = configProvider.get(Settings.showflashbackYearsAgo);
    final sixMonthsAgo = configProvider.get(Settings.showflashback6MonthsAgo);
    final oneMonthAgo = configProvider.get(Settings.showflashback1MonthAgo);
    final oneWeekAgo = configProvider.get(Settings.showflashback1WeekAgo);
    final weekAgo = DateTime(now.year, now.month, now.day - 7);

    // Time based memories
    for (var entry in filteredEntries.reversed) {
      if (usedEntries.contains(entry)) continue;
      if (yearsAgo &&
          TimeManager.isSameCalendarDayOfYear(entry.day, now, isJalali) &&
          TimeManager.calendarYearOf(entry.day, isJalali) !=
              TimeManager.calendarYearOf(now, isJalali)) {
        final years = TimeManager.calendarYearOf(now, isJalali) -
            TimeManager.calendarYearOf(entry.day, isJalali);
        onThisDayEntries.add(entry);
        onThisDayLabels.add(AppLocalizations.of(context)!.flashbackYear(years));
        usedEntries.add(entry);
        continue;
      }
      if (sixMonthsAgo &&
          TimeManager.datesExactCalendarMonthDiff(entry.day, now, isJalali) ==
              6) {
        final label = AppLocalizations.of(context)!.flashbackMonth(6);
        singleFlashbacks.putIfAbsent(label, () => []).add(entry);
        usedEntries.add(entry);
        continue;
      }
      if (oneMonthAgo &&
          TimeManager.datesExactCalendarMonthDiff(entry.day, now, isJalali) ==
              1) {
        final label = AppLocalizations.of(context)!.flashbackMonth(1);
        singleFlashbacks.putIfAbsent(label, () => []).add(entry);
        usedEntries.add(entry);
        continue;
      }
      if (oneWeekAgo && entry.day == weekAgo) {
        final label = AppLocalizations.of(context)!.flashbackWeek(1);
        singleFlashbacks.putIfAbsent(label, () => []).add(entry);
        usedEntries.add(entry);
        continue;
      }
      if (entry.mood == 1 || entry.mood == 2) {
        happyEntries.add(entry);
        continue;
      }
    }

    if (onThisDayEntries.isNotEmpty) {
      final onThisDayTitle = AppLocalizations.of(context)!.flashbackOnThisDay;
      flashbacksList.add(Flashback(
        title: onThisDayTitle,
        entries: onThisDayEntries.reversed.toList(), // Most recent first
        entryLabels: onThisDayLabels.reversed.toList(), // Most recent first
        isOnThisDay: true,
      ));
    }

    // Random Memories
    if (filteredEntries.length > 7) {
      int? seed = int.tryParse("${now.year}${now.month}${now.day}");
      final todayKey = "${now.year}-${now.month}-${now.day}";
      if (_dailyPicks.date != todayKey) {
        _dailyPicks = _DailyFlashbackPicks(todayKey);
      }

      // A happy memory
      if (configProvider.get(Settings.showflashbackGoodDay)) {
        final goodDayEntry = _resolveDailyPick(
          cachedId: _dailyPicks.goodDayEntryId,
          setCachedId: (id) => _dailyPicks.goodDayEntryId = id,
          pool: happyEntries,
          usedEntries: usedEntries,
          seed: seed,
        );
        if (goodDayEntry != null) {
          final label = AppLocalizations.of(context)!.flashbackGoodDay;
          singleFlashbacks.putIfAbsent(label, () => []).add(goodDayEntry);
          usedEntries.add(goodDayEntry);
        }
      }

      // A random memory
      if (configProvider.get(Settings.showflashbackRandomDay)) {
        final randomDayEntry = _resolveDailyPick(
          cachedId: _dailyPicks.randomDayEntryId,
          setCachedId: (id) => _dailyPicks.randomDayEntryId = id,
          pool: filteredEntries,
          usedEntries: usedEntries,
          seed: seed,
        );
        if (randomDayEntry != null) {
          final label = AppLocalizations.of(context)!.flashbackRandomDay;
          singleFlashbacks.putIfAbsent(label, () => []).add(randomDayEntry);
          usedEntries.add(randomDayEntry);
        }
      }
    }

    singleFlashbacks.forEach((label, entries) {
      flashbacksList.add(Flashback(
        title: label,
        entries: entries,
        entryLabels: entries.length == 1
            ? [label]
            : entries
                .map((e) => TimeManager.localizedTimeFormat(context, locale)
                    .format(e.timeCreate))
                .toList(),
      ));
    });
    return flashbacksList;
  }
}
