// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// The diary's day, which may start after midnight.
///
/// Entries written before [startHour] belong to the day before, not only in
/// how they are listed but for everything counted by day: streaks, "today",
/// throwbacks, reviews, charts. Every day-based rule goes through here; an
/// entry's own clock time stays as written. The day is derived, never
/// stored, so changing the setting needs no migration and devices with
/// different settings never disagree about stored data.
abstract final class DiaryDay {
  /// Hours after midnight that still count for the day before; 0 lets days
  /// start at midnight. Set from the user's setting at startup.
  static int startHour = 0;

  /// Local midnight of the diary day [time] belongs to.
  static DateTime of(DateTime time) =>
      DateTime(time.year, time.month, time.day - (isLateNight(time) ? 1 : 0));

  /// The diary day now.
  static DateTime today() => of(DateTime.now());

  /// Whether [time] is in the small hours that count for the day before.
  static bool isLateNight(DateTime time) => time.hour < startHour;

  /// Whether [a] and [b] fall on the same diary day.
  static bool same(DateTime a, DateTime b) => of(a) == of(b);

  /// When a new entry for diary [day] is written now: now itself on today,
  /// else the current time of day on that day.
  static DateTime nowOn(DateTime day) {
    final now = DateTime.now();
    final date = DateTime(day.year, day.month, day.day);
    return of(now) == date ? now : at(date, now.hour, now.minute);
  }

  /// The clock time [hour]:[minute] that belongs to diary [day], which is on
  /// the next calendar day in the small hours.
  static DateTime at(DateTime day, int hour, int minute) => DateTime(
      day.year, day.month, day.day + (hour < startHour ? 1 : 0), hour, minute);
}
