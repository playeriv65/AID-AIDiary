// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// The UTC offset that made the last local time, in milliseconds.
int _offsetMs = DateTime.now().timeZoneOffset.inMilliseconds;

/// [DateTime.parse] for the stored local times the database holds, a few
/// times faster. Dart turns a wall-clock time into a moment by asking the OS
/// for the time zone several times per value, which dominates loading a
/// large diary. This reads the wall clock as UTC, applies the offset that
/// fitted the previous value and keeps the result only if it shows the
/// same wall clock; otherwise it falls back to [DateTime.parse].
DateTime parseLocalTime(String text) {
  final wall = _isPlainLocal(text) ? DateTime.tryParse('${text}Z') : null;
  if (wall == null) return DateTime.parse(text);
  for (var attempt = 0; attempt < 2; attempt++) {
    final local = DateTime.fromMicrosecondsSinceEpoch(
        wall.microsecondsSinceEpoch - _offsetMs * 1000);
    if (_sameWallClock(local, wall)) return local;
    // Daylight saving moved the offset: retry with the one in force then.
    final offset = local.timeZoneOffset.inMilliseconds;
    if (offset == _offsetMs) break;
    _offsetMs = offset;
  }
  return DateTime.parse(text);
}

/// Without a zone suffix, so the text names a local wall-clock time.
bool _isPlainLocal(String text) {
  // Past the date, whose dashes are not a zone.
  final rest = text.length > 10 ? text.substring(10) : '';
  return !rest.contains(_zone);
}

final _zone = RegExp('[zZ+-]');

bool _sameWallClock(DateTime local, DateTime wall) =>
    local.year == wall.year &&
    local.month == wall.month &&
    local.day == wall.day &&
    local.hour == wall.hour &&
    local.minute == wall.minute &&
    local.second == wall.second &&
    local.millisecond == wall.millisecond &&
    local.microsecond == wall.microsecond;
