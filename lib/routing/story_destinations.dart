// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/layouts/adaptive_diary_shell.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/random_review_page.dart';
import 'package:aid_diary/pages/review_story_page.dart';
import 'package:aid_diary/pages/today_story_page.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/widgets/quick_check_in.dart';
import 'package:aid_diary/widgets/story_player.dart';
import 'package:material_ui/material_ui.dart';

/// Plays the stories built by [groups] (which run while the story builds,
/// so they may read providers) as the place [name]. Wide windows show them
/// as a card over the app, phones full screen.
Future<void> _showStory(
  BuildContext context,
  String name, {
  Object? id,
  required List<StoryGroup> Function(BuildContext context) groups,
  String? startAt,
  bool wrapUp = false,
}) {
  Widget player(BuildContext context) =>
      StoryPlayer(groups: groups(context), startAt: startAt, wrapUp: wrapUp);
  // A tip still showing would move onto the story's own scaffold.
  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  final size = MediaQuery.sizeOf(context);
  if (!diarySupportsSplit(size)) {
    return pushPlace(context, name, player, id: id, fullscreenDialog: true);
  }
  return showPlaceDialog(
      context,
      name,
      id: id,
      (context) => Center(
            child: SizedBox(
              width: min(580, size.width - 32),
              height: min(720, size.height - 48),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: player(context)),
            ),
          ));
}

/// The stories row of the journal: the stories, reviews, random entry and
/// check-in.
final List<Destination> storyDestinations = [
  Destination(
      'story',
      'The stories of the journal played as one chain: today, the coach '
          'program, the throwback',
      params: const [
        ActionParam('from', ParamType.string,
            'Where to start: today (default), coach or throwback',
            required: false),
      ], (context, args) {
    final from = args['from'] as String? ?? TodayStory.today;
    final stories = [
      for (final group in TodayStory.groups(context, listen: false)) group.id,
    ];
    if (!stories.contains(from)) {
      throw ActionException('not_found',
          'There is no $from story now; there are: ${stories.join(', ')}');
    }
    return _showStory(context, 'story',
        id: from, groups: TodayStory.groups, startAt: from, wrapUp: true);
  }),
  Destination('review', 'This week or this year in review, as a story',
      params: [
        ActionParam('span', ParamType.string,
            'One of ${ReviewSpan.values.map((span) => span.name).join(', ')}'),
      ], (context, args) {
    final span = enumArg(args, 'span', ReviewSpan.values)!;
    return _showStory(context, 'review',
        id: span.name,
        groups: (context) => [ReviewStoryPage.group(context, span)]);
  }),
  Destination(
      'random',
      'A random past entry, one after another',
      params: [
        ActionParam(
            'filter',
            ParamType.string,
            'Which entries: ${RandomFilter.values.map((f) => f.name).join(', ')}'
                ' (default all)',
            required: false),
      ],
      (context, args) => pushPlace(
          context,
          'random',
          (_) => RandomReviewPage(
              filter: enumArg(args, 'filter', RandomFilter.values) ??
                  RandomFilter.all))),
  Destination(
      'check_in',
      'The quick check-in: a mood and a line, saved as an entry for now',
      (context, args) => showPlaceSheet<Entry>(
          context, 'check_in', (_) => const QuickCheckIn())),
];
