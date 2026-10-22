// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/routing/coach_destinations.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/routing/organize_destinations.dart';
import 'package:aid_diary/routing/settings_destinations.dart';
import 'package:aid_diary/routing/story_destinations.dart';
import 'package:material_ui/material_ui.dart';

export 'package:aid_diary/routing/destination.dart' show Destination;

/// Every place the GUI opens besides the tabs. Pages and widgets open
/// screens only through `lib/routing/` (test/architecture/places_test.dart),
/// so `ui.navigate` reaches all of them.
final List<Destination> destinations = [
  ...settingsDestinations,
  ...entryDestinations,
  ...storyDestinations,
  ...organizeDestinations,
  ...coachDestinations,
];

Destination destinationNamed(String name) =>
    destinations.where((destination) => destination.name == name).firstOrNull ??
    (throw ActionException('bad_args', 'There is no place $name'));

/// Opens the place [name] from [context], as `ui.navigate to=name` does.
Future<void> openPlace(BuildContext context, String name,
        [ActionArgs args = const {}]) =>
    destinationNamed(name).open(context, args);
