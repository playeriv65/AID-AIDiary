// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';

const _batchId = 'actions.batch';

/// Many steps in one call: a large change runs inside the app instead of
/// crossing adb or the agent API once per step.
final batchActions = [
  AppAction(
    id: _batchId,
    describe: 'Runs the steps of a JSON file in order inside the app: a list '
        'of {"action": id, "args": {...}}, each with the arguments it takes '
        'on the command line. Destructive actions are refused. A failing '
        'step is reported and the rest still run.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('path', ParamType.string, 'The JSON file on this device'),
    ],
    run: (context, args) async {
      final file = File(args['path'] as String);
      if (!await file.exists()) {
        throw const ActionException('not_found', 'There is no such file');
      }
      final steps = switch (jsonDecode(await file.readAsString())) {
        final List list
            when list.every((step) =>
                step is Map &&
                step['action'] is String &&
                (step['args'] ?? const {}) is Map) =>
          [for (final step in list) step as Map],
        _ => throw const ActionException('bad_args',
            'The file must hold a list of {"action": id, "args": {...}}'),
      };
      final actions = AppActions.instance;
      final failures = <Map<String, Object?>>[];
      for (final (index, step) in steps.indexed) {
        final id = step['action'] as String;
        try {
          if (id == _batchId ||
              actions.find(id).risk == ActionRisk.destructive) {
            throw ActionException(
                'refused', '$id cannot run in a batch: it is destructive');
          }
          await actions.run(id, {
            for (final MapEntry(:key, :value)
                in ((step['args'] ?? const {}) as Map).entries)
              '$key': value,
          });
        } on ActionException catch (error) {
          failures.add({'step': index, 'action': id, ...error.toJson()});
        }
        context.progress('${index + 1}/${steps.length}');
      }
      return {
        'steps': steps.length,
        'failed': failures.length,
        'failures': failures,
      };
    },
  ),
];
