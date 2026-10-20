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
  static Future<void> toggle(EntryLocation place) async {
    final places = all();
    if (!places.remove(place)) places.insert(0, place);
    await ConfigProvider.instance.set(Settings.savedPlaces, [
      for (final p in places)
        {'name': p.name, 'latitude': p.latitude, 'longitude': p.longitude},
    ]);
  }
}
