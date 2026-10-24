// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/agent/native/api/shell.dart';

/// `aid` inside the agent's shell: the command line's grammar
/// (`aid [--yes] <action> key=value ...`, `aid actions`, `aid guide`) run on
/// this app's actions directly, with the same JSON and exit codes: 0 done,
/// 1 the action failed, 2 the command was wrong.
class AidCommand {
  AidCommand(this._actions);

  /// The app's actions as they are when a command runs, so the GUI's screen
  /// is there once it is up.
  final AppActions Function() _actions;

  /// Areas an agent inside the app does not reach: they would start agents.
  static const closedAreas = {'agent', 'acp'};

  static const usage = '''
aid [--yes] <command> [key=value ...]
  aid guide              how the actions work, as Markdown
  aid actions            every action and its arguments, as JSON
  aid <action> [k=v ...] runs one, e.g. `aid entry.list limit=5`
  --yes, -y              confirms a destructive action
''';

  /// The actions an agent here may run.
  AppActions get actions {
    final app = _actions();
    return AppActions(
      actions: [
        for (final action in app.available)
          if (!closedAreas.contains(action.id.split('.').first)) action,
      ],
      screen: app.screen,
      devBuild: app.devBuild,
    );
  }

  Future<ShellOutput> run(List<String> args) async {
    var confirmed = false;
    final rest = <String>[];
    for (final arg in args) {
      switch (arg) {
        case '--yes' || '-y':
          confirmed = true;
        case '--help' || '-h':
          return const ShellOutput(stdout: usage, stderr: '', exitCode: 0);
        case final option when option.startsWith('-'):
          return ShellOutput(
              stdout: '',
              stderr: '$option: not here; this aid runs in the app itself\n'
                  '$usage',
              exitCode: 2);
        default:
          rest.add(arg);
      }
    }
    if (rest.isEmpty) {
      return const ShellOutput(stdout: '', stderr: usage, exitCode: 2);
    }
    final actions = this.actions;
    final command = rest.first;
    if (command == 'guide') {
      return ShellOutput(stdout: actions.guide(), stderr: '', exitCode: 0);
    }
    final pairs = <String, Object?>{};
    for (final pair in rest.skip(1)) {
      final cut = pair.indexOf('=');
      if (cut <= 0) {
        return ShellOutput(
            stdout: '',
            stderr: 'Arguments are key=value, not "$pair"\n',
            exitCode: 2);
      }
      pairs[pair.substring(0, cut)] = pair.substring(cut + 1);
    }
    if (command == 'actions') {
      return _reply({'ok': true, 'result': actions.describe()}, 0);
    }
    try {
      final result = await actions.run(command, pairs, confirmed: confirmed);
      return _reply({'ok': true, 'result': result}, 0);
    } on ActionException catch (error) {
      return _reply({'ok': false, 'error': error.toJson()}, 1);
    } catch (error) {
      return _reply({
        'ok': false,
        'error': {'code': 'failed', 'message': '$error'},
      }, 1);
    }
  }

  static ShellOutput _reply(Map<String, Object?> reply, int exitCode) =>
      ShellOutput(
          stdout: '${const JsonEncoder.withIndent('  ').convert(reply)}\n',
          stderr: '',
          exitCode: exitCode);
}
