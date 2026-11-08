// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/routing/drawing_navigation.dart';
import 'package:aid_diary/routing/coach_destinations.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/routing/moments_destinations.dart';
import 'package:aid_diary/routing/settings_destinations.dart';
import 'package:aid_diary/routing/story_destinations.dart';
import 'package:aid_diary/routing/sync_scan_navigation.dart';
import 'package:material_ui/material_ui.dart';

export 'package:aid_diary/routing/destination.dart' show Destination;

/// Every place the GUI opens besides the tabs. Pages and widgets open
/// screens only through `lib/routing/` (test/architecture/places_test.dart),
/// so `ui.navigate` reaches all of them.
final List<Destination> destinations = [
  Destination(
      'calendar',
      "The journal's calendar, unfolded over its entries: a day picked in it "
          'shows that day in the journal',
      (context, args) async => journalCalendar.value = true),
  ...settingsDestinations,
  ...syncScanDestinations,
  ...entryDestinations,
  ...drawingDestinations,
  ...storyDestinations,
  ...organizeDestinations,
  ...momentsDestinations,
  ...coachDestinations,
];

/// Whether the journal's calendar is unfolded: the place `calendar`. The
/// journal shows it over its entries and folds it when a day is picked; the
/// tabs switch to the journal when it unfolds and fold it when they leave.
final journalCalendar = ValueNotifier(false);

Destination destinationNamed(String name) =>
    destinations.where((destination) => destination.name == name).firstOrNull ??
    (throw ActionException('bad_args', 'There is no place $name'));

/// Opens the place [name] from [context], as `ui.navigate to=name` does.
Future<void> openPlace(BuildContext context, String name,
        [ActionArgs args = const {}]) =>
    destinationNamed(name).open(context, args);
