// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Other journals store a UTC moment and the IANA zone it was written in;
// entries here keep the wall-clock time where they were written.

import 'package:aid_diary/models/entry.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

bool _zonesLoaded = false;

tz.Location? _zone(String? name) {
  if (name == null || name.isEmpty) return null;
  if (!_zonesLoaded) {
    tz_data.initializeTimeZones();
    _zonesLoaded = true;
  }
  try {
    return tz.getLocation(name);
  } on tz.LocationNotFoundException {
    return null;
  }
}

/// The wall-clock time and UTC offset in minutes of a UTC moment where the
/// entry was written, in the IANA [zone]. Without a zone it was written in
/// the device's, and the offset is left for the database to fill in.
({DateTime wall, int? utcOffset}) wallClockInZone(
    DateTime instant, String? zone) {
  final location = _zone(zone);
  if (location == null) return (wall: instant.toLocal(), utcOffset: null);
  final offset = tz.TZDateTime.from(instant, location).timeZoneOffset;
  return (
    wall: Entry.wallClockAt(instant, offset),
    utcOffset: offset.inMinutes
  );
}

/// An IANA name for a fixed UTC offset, for formats that want a zone; null
/// for offsets off the hour, which have none.
String? zoneForOffset(Duration offset) {
  if (offset.inMinutes % 60 != 0) return null;
  final hours = offset.inHours;
  // IANA's Etc zones count the other way round: Etc/GMT-8 is UTC+8.
  if (hours == 0) return 'Etc/UTC';
  return 'Etc/GMT${hours > 0 ? '-' : '+'}${hours.abs()}';
}
