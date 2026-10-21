// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';

/// Tracks saved vs current entry fields and attachments
class EntryDraftDirtyTracker {
  EntryDraftDirtyTracker({
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    required Set<int> seededTagIds,
    EntryLocation? location,
    EntryWeather? weather,
    EntryActivity? activity,
  })  : _lastText = text,
        _lastMood = mood,
        _lastDate = date,
        _lastDay = day,
        _lastLocation = location,
        _lastWeather = weather,
        _lastActivity = activity,
        _seededTagIds = seededTagIds;

  String _lastText;
  int? _lastMood;
  DateTime _lastDate;

  /// The diary day, kept apart from the written time.
  DateTime _lastDay;
  EntryLocation? _lastLocation;
  EntryWeather? _lastWeather;
  EntryActivity? _lastActivity;

  /// Tag ids seeded from the default template, or already on the entry
  final Set<int> _seededTagIds;

  void markSaved({
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    EntryLocation? location,
    EntryWeather? weather,
    EntryActivity? activity,
  }) {
    _lastText = text;
    _lastMood = mood;
    _lastDate = date;
    _lastDay = day;
    _lastLocation = location;
    _lastWeather = weather;
    _lastActivity = activity;
  }

  /// Takes values filled in automatically as the baseline, so a new entry
  /// with nothing but auto-filled context is still untouched.
  void adoptAutoFill({
    EntryLocation? location,
    EntryWeather? weather,
    EntryActivity? activity,
  }) {
    _lastLocation = location;
    _lastWeather = weather;
    _lastActivity = activity;
  }

  bool hasFieldChanges({
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    EntryLocation? location,
    EntryWeather? weather,
    EntryActivity? activity,
  }) {
    return text != _lastText ||
        mood != _lastMood ||
        date != _lastDate ||
        day != _lastDay ||
        location != _lastLocation ||
        weather != _lastWeather ||
        activity != _lastActivity;
  }

  bool hasUnsavedChanges({
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    required TagAttachmentSource tagSource,
    required bool hasImages,
    EntryLocation? location,
    EntryWeather? weather,
    EntryActivity? activity,
  }) {
    return hasFieldChanges(
            text: text,
            mood: mood,
            date: date,
            day: day,
            location: location,
            weather: weather,
            activity: activity) ||
        _tagsExceedSeed(tagSource) ||
        hasImages;
  }

  bool _tagsExceedSeed(TagAttachmentSource tagSource) {
    for (final tagId in tagSource.attachedTagIds) {
      if (!_seededTagIds.contains(tagId)) return true;
      if (tagSource.valueFor(tagId) != null) return true;
    }
    return false;
  }
}
