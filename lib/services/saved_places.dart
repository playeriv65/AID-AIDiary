// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/models/entry.dart';

/// Places the user starred in the location picker, newest first.
class SavedPlaces {
  static List<EntryLocation> all() => [
        for (final item in ConfigProvider.instance.get(Settings.savedPlaces))
          if (item is Map)
            EntryLocation(
              name: item['name'] as String?,
              latitude: (item['latitude'] as num?)?.toDouble(),
              longitude: (item['longitude'] as num?)?.toDouble(),
            ),
      ];

  static bool contains(EntryLocation place) => all().contains(place);

  /// Stars [place], or unstars it when already saved.
  static Future<void> toggle(EntryLocation place) =>
      contains(place) ? unsave(place) : save(place);

  /// Stars [place] as the newest, unless it already is.
  static Future<void> save(EntryLocation place) async {
    if (!contains(place)) await _write([place, ...all()]);
  }

  static Future<void> unsave(EntryLocation place) => _write([
        for (final saved in all())
          if (saved != place) saved
      ]);

  static Future<void> _write(List<EntryLocation> places) =>
      ConfigProvider.instance.set(Settings.savedPlaces, [
        for (final p in places)
          {'name': p.name, 'latitude': p.latitude, 'longitude': p.longitude},
      ]);
}
