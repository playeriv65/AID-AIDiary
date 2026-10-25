// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';

/// Tracks saved vs current entry fields and attachments
class EntryDraftDirtyTracker {
  EntryDraftDirtyTracker({
    required String title,
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    required Set<int> seededTagIds,
    EntryLocation? location,
  })  : _lastTitle = title,
        _lastText = text,
        _lastMood = mood,
        _lastDate = date,
        _lastDay = day,
        _lastLocation = location,
        _seededTagIds = seededTagIds;

  String _lastTitle;
  String _lastText;
  int? _lastMood;
  DateTime _lastDate;

  /// The diary day, kept apart from the written time.
  DateTime _lastDay;
  EntryLocation? _lastLocation;

  /// Tag ids seeded from the default template, or already on the entry
  final Set<int> _seededTagIds;

  void markSaved({
    required String title,
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    EntryLocation? location,
  }) {
    _lastTitle = title;
    _lastText = text;
    _lastMood = mood;
    _lastDate = date;
    _lastDay = day;
    _lastLocation = location;
  }

  /// Takes values filled in automatically as the baseline, so a new entry
  /// with nothing but auto-filled context is still untouched.
  void adoptAutoFill({EntryLocation? location}) {
    _lastLocation = location;
  }

  bool hasFieldChanges({
    required String title,
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    EntryLocation? location,
  }) {
    return title != _lastTitle ||
        text != _lastText ||
        mood != _lastMood ||
        date != _lastDate ||
        day != _lastDay ||
        location != _lastLocation;
  }

  bool hasUnsavedChanges({
    required String title,
    required String text,
    required int? mood,
    required DateTime date,
    required DateTime day,
    required TagAttachmentSource tagSource,
    required bool hasImages,
    EntryLocation? location,
  }) {
    return hasFieldChanges(
            title: title,
            text: text,
            mood: mood,
            date: date,
            day: day,
            location: location) ||
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
