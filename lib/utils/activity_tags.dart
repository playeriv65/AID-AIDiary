// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';

/// What older versions of this diary, Journey and Day One recorded as the
/// activity when an entry was written. Entries no longer have one: it comes
/// in as a tag of this name.
enum ActivityTag {
  still,
  walking,
  running,
  cycling,
  vehicle,
  flying,
  exercise;

  static ActivityTag? byName(String? name) =>
      values.where((activity) => activity.name == name).firstOrNull;

  String label(AppLocalizations l10n) => switch (this) {
        still => l10n.activityStill,
        walking => l10n.activityWalking,
        running => l10n.activityRunning,
        cycling => l10n.activityCycling,
        vehicle => l10n.activityVehicle,
        flying => l10n.activityFlying,
        exercise => l10n.activityExercise,
      };
}
