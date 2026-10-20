// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;

import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/tag.dart';
import 'package:word_count/word_count.dart';

const List<String> _weekdayKeys = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

int totalWordCount(List<Entry> entries) {
  var total = 0;
  for (final entry in entries) {
    total += wordsCount(entry.text);
  }
  return total;
}

int greatDayCount(List<Entry> entries) {
  final greatDays = <DateTime>{};
  for (final entry in entries) {
    if (entry.mood == null || entry.mood! < 1) continue;
    final date = entry.timeCreate;
    greatDays.add(DateTime(date.year, date.month, date.day));
  }
  return greatDays.length;
}

Map<int, int> moodTotals(List<Entry> entries) {
  final totals = {-2: 0, -1: 0, 0: 0, 1: 0, 2: 0};
  for (final entry in entries) {
    if (entry.mood == null) continue;
    totals.update(entry.mood!, (count) => count + 1);
  }
  return totals;
}

/// Averages [valueOf] per weekday. A weekday with no contributing entries
/// resolves to [emptyDayValue] so charts can tell "no data that day" apart from
/// a genuine zero average.
Map<String, double?> averageByDayOfWeek(
  List<Entry> entries,
  double? Function(Entry entry) valueOf, {
  double? emptyDayValue,
}) {
  final valuesByDay = <String, List<double>>{};
  for (final entry in entries) {
    final value = valueOf(entry);
    if (value == null) continue;
    (valuesByDay[_weekdayKeyOf(entry)] ??= []).add(value);
  }

  double? average(String dayKey) {
    final values = valuesByDay[dayKey];
    if (values == null || values.isEmpty) return emptyDayValue;
    return values.reduce((a, b) => a + b) / values.length;
  }

  return {for (final dayKey in _weekdayKeys) dayKey: average(dayKey)};
}

Map<String, double> countByDayOfWeek(
  List<Entry> entries,
  bool Function(Entry entry) matches,
) {
  final counts = {for (final dayKey in _weekdayKeys) dayKey: 0};
  for (final entry in entries) {
    if (!matches(entry)) continue;
    final dayKey = _weekdayKeyOf(entry);
    counts[dayKey] = (counts[dayKey] ?? 0) + 1;
  }
  return counts.map((key, value) => MapEntry(key, value.toDouble()));
}

Map<int, double> trackerValuesByEntry(
  List<Entry> entries,
  List<EntryTag> entryTags,
  int tagId,
) {
  final entryIds = entries.map((entry) => entry.id).toSet();
  final valueByEntryId = <int, double>{};
  for (final entryTag in entryTags) {
    if (entryTag.tagId != tagId) continue;
    if (!entryIds.contains(entryTag.entryId)) continue;
    final value = double.tryParse(entryTag.value ?? '');
    if (value == null) continue;
    valueByEntryId[entryTag.entryId] = value;
  }
  return valueByEntryId;
}

Set<int> entryIdsWithTag(List<EntryTag> entryTags, int tagId) {
  return entryTags
      .where((entryTag) => entryTag.tagId == tagId)
      .map((entryTag) => entryTag.entryId)
      .toSet();
}

(double minY, double maxY) trackerYRange(List<double> values) {
  if (values.isEmpty) return (0, 10);
  final dataMin = values.reduce(math.min);
  final dataMax = values.reduce(math.max);
  return (dataMin >= 0 ? 0 : dataMin, dataMax);
}

/// How often entries with a factor (an activity, a tag) had a given mood.
typedef MoodAssociation<K> = ({K factor, int matching, int total});

/// Factors most tied to [mood]: the share of each factor's rated entries
/// that had it, highest first. Factors seen on fewer than [minEntries] rated
/// entries, or never with [mood], are left out.
List<MoodAssociation<K>> moodAssociations<K>(
    List<Entry> entries, int mood, Iterable<K> Function(Entry entry) factorsOf,
    {int minEntries = 2}) {
  final totals = <K, int>{};
  final matching = <K, int>{};
  for (final entry in entries.where((e) => e.mood != null)) {
    for (final factor in factorsOf(entry).toSet()) {
      totals[factor] = (totals[factor] ?? 0) + 1;
      if (entry.mood == mood) matching[factor] = (matching[factor] ?? 0) + 1;
    }
  }
  final result = [
    for (final MapEntry(key: factor, value: total) in totals.entries)
      if (total >= minEntries && (matching[factor] ?? 0) > 0)
        (factor: factor, matching: matching[factor]!, total: total),
  ];
  result.sort((a, b) {
    final byShare = (b.matching / b.total).compareTo(a.matching / a.total);
    return byShare != 0 ? byShare : b.matching.compareTo(a.matching);
  });
  return result;
}

String _weekdayKeyOf(Entry entry) =>
    _weekdayKeys[entry.timeCreate.weekday - DateTime.monday];
