// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/tags_provider.dart';

/// What the search screen and `entry.list` narrow the diary down by. An
/// entry must match every filter that is set; within [tagIds], [moods] and
/// [activities] one match is enough.
class EntryFilter {
  EntryFilter({
    String query = '',
    this.tagIds = const {},
    this.starred = false,
    this.moods = const {},
    this.activities = const {},
    this.hasLocation,
    TagsProvider? tags,
  })  : query = query.trim().toLowerCase(),
        _tags = tags ?? TagsProvider.instance;

  /// Text of the entry or the name of its place, in lower case.
  final String query;
  final Set<int> tagIds;
  final bool starred;
  final Set<int> moods;
  final Set<EntryActivity> activities;

  /// Only entries with (true) or without (false) coordinates.
  final bool? hasLocation;

  final TagsProvider _tags;

  bool get isActive =>
      query.isNotEmpty ||
      tagIds.isNotEmpty ||
      starred ||
      moods.isNotEmpty ||
      activities.isNotEmpty ||
      hasLocation != null;

  /// Whether [entry] matches. A sealed time capsule never does: filtering
  /// must not give away what it holds.
  bool matches(Entry entry) {
    if (entry.isSealed || entry.isHidden) return false;
    if (query.isNotEmpty &&
        !entry.text.toLowerCase().contains(query) &&
        !(entry.location?.name?.toLowerCase().contains(query) ?? false)) {
      return false;
    }
    if (starred && !_tags.isFavorite(entry.id!)) return false;
    if (moods.isNotEmpty && !moods.contains(entry.mood)) return false;
    if (activities.isNotEmpty && !activities.contains(entry.activity)) {
      return false;
    }
    if (hasLocation != null &&
        (entry.location?.hasCoordinates ?? false) != hasLocation) {
      return false;
    }
    if (tagIds.isNotEmpty &&
        !_tags
            .getEntryTagsForEntry(entry.id!)
            .any((link) => tagIds.contains(link.tagId))) {
      return false;
    }
    return true;
  }
}
