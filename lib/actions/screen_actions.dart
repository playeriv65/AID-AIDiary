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
    describe: 'Says which screen the user is on, and where ui.navigate can go.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final screen = _screen(context);
      return {'current': screen.current, 'destinations': screen.destinations};
    },
  ),
  AppAction(
    id: 'ui.navigate',
    describe: 'Opens a screen, so a person watching sees what an agent works '
        'on.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('to', ParamType.string, 'A destination from ui.screen'),
    ],
    run: (context, args) async {
      final screen = _screen(context);
      final to = args['to'] as String;
      if (!screen.destinations.contains(to)) {
        throw ActionException(
            'bad_args', 'to must be one of ${screen.destinations.join(', ')}');
      }
      await screen.navigate(to);
      return {'current': screen.current};
    },
  ),
];
