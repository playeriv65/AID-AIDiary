// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';

ActionScreen _screen(ActionContext context) =>
    context.screen ??
    (throw const ActionException(
        'no_screen', 'No GUI is attached to show or move'));

final List<AppAction> screenActions = [
  AppAction(
    id: 'ui.screen',
    describe: 'Says which screen the user is on, and every place ui.navigate '
        'can open with the arguments each takes.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final screen = _screen(context);
      return {
        'current': screen.current,
        'destinations': [
          for (final destination in screen.destinations) destination.toJson(),
        ],
      };
    },
  ),
  AppAction(
    id: 'ui.navigate',
    describe: 'Opens a screen or an item on it, as a tap would, so a person '
        'watching sees what an agent works on. Takes the arguments of the '
        'destination, e.g. to=entry id=12.',
    risk: ActionRisk.read,
    moreArgs: true,
    params: const [
      ActionParam('to', ParamType.string, 'A destination from ui.screen'),
    ],
    run: (context, args) async {
      final screen = _screen(context);
      final to = args['to'] as String;
      final destination = screen.destinations
              .where((destination) => destination.name == to)
              .firstOrNull ??
          (throw ActionException(
              'bad_args',
              'to must be one of ${[
                for (final d in screen.destinations) d.name
              ].join(', ')}'));
      await screen.navigate(
          to,
          parseArgs(destination.params, {...args}..remove('to'),
              'ui.navigate to=$to'));
      return {'current': screen.current};
    },
  ),
  AppAction(
    id: 'ui.back',
    describe: 'Closes the screen or dialog on top, as the back gesture does.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final screen = _screen(context);
      final closed = await screen.back();
      return {'closed': closed, 'current': screen.current};
    },
  ),
];
