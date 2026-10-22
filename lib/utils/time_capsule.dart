// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// The days a time capsule may be sealed until, as the date picker offers
/// them and the `entry.seal` action accepts them.
abstract final class CapsuleWindow {
  /// Tomorrow: a capsule opens on a later day than it is sealed.
  static DateTime earliest(DateTime now) =>
      DateTime(now.year, now.month, now.day + 1);

  static DateTime latest(DateTime now) => DateTime(now.year + 50);

  /// What the picker starts on: a year from now.
  static DateTime suggested(DateTime now) =>
      DateTime(now.year + 1, now.month, now.day);

  static bool allows(DateTime day, DateTime now) =>
      !day.isBefore(earliest(now)) && !day.isAfter(latest(now));
}
