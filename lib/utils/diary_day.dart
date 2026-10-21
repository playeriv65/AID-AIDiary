// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// The default diary day for an entry written at a given time.
///
/// Every entry stores its diary day (`Entry.day`) next to the time it was
/// actually written, and the writer may change it at any time. These rules
/// only pick the default for new and imported entries: before [startHour]
/// an entry belongs to the day before, from then until [askUntilHour] the
/// editor asks (counting it for that day until answered), later it belongs
/// to that day. Changing the hours therefore moves no existing entry.
abstract final class DiaryDay {
  /// Before this hour a new entry belongs to the day before; 0 never.
  static int startHour = 0;

  /// From [startHour] until this hour the editor asks which day is meant.
  static int askUntilHour = 0;

  /// The diary day an entry written at [time] gets unless told otherwise.
  static DateTime defaultFor(DateTime time) => DateTime(
      time.year, time.month, time.day - (time.hour < startHour ? 1 : 0));

  /// Whether an entry written at [time] could mean either day, so the
  /// editor asks.
  static bool asks(DateTime time) =>
      time.hour >= startHour && time.hour < askUntilHour;

  /// The diary day a new entry written now gets: what "today" means for
  /// streaks, reminders and the widget.
  static DateTime today() => defaultFor(DateTime.now());

  /// The explicit day for a new entry opened for [day]: none for today, so
  /// the default applies and the editor may still ask.
  static DateTime? forNewEntry(DateTime day) {
    final date = dateOf(day);
    return date == today() ? null : date;
  }

  /// A diary day as stored, `2026-10-20`.
  static String format(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  /// A stored diary day, or null for none or a malformed one.
  static DateTime? parse(String? text) {
    final parts = text?.split('-');
    if (parts == null || parts.length != 3) return null;
    final [year, month, day] = [for (final part in parts) int.tryParse(part)];
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }

  /// Local midnight of [time]'s calendar date; [time] itself when it is one
  /// already, which saves a time zone lookup.
  static DateTime dateOf(DateTime time) => !time.isUtc &&
          time.hour == 0 &&
          time.minute == 0 &&
          time.second == 0 &&
          time.millisecond == 0 &&
          time.microsecond == 0
      ? time
      : DateTime(time.year, time.month, time.day);
}
