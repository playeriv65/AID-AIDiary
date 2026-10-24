// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/coach_actions.dart';
import 'package:aid_diary/actions/data_actions.dart';
import 'package:aid_diary/actions/device_sync_actions.dart';
import 'package:aid_diary/actions/drawing_actions.dart';
import 'package:aid_diary/actions/entry_actions.dart';
import 'package:aid_diary/actions/entry_media_actions.dart';
import 'package:aid_diary/actions/flashback_actions.dart';
import 'package:aid_diary/actions/perf_actions.dart';
import 'package:aid_diary/actions/link_actions.dart';
import 'package:aid_diary/actions/place_actions.dart';
import 'package:aid_diary/actions/photo_suggestion_actions.dart';
import 'package:aid_diary/actions/screen_actions.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/actions/sync_actions.dart';
import 'package:aid_diary/actions/tag_actions.dart';
import 'package:aid_diary/actions/template_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Every action of the app, and the one way to run them: buttons, the
/// command palette, the agent API and so the CLI all come here.
class AppActions {
  AppActions({List<AppAction>? actions, this.screen, bool? devBuild})
      : _actions = actions ?? everyAction,
        devBuild = devBuild ??
            (kDebugMode ||
                appFlavor == 'dev' ||
                const bool.fromEnvironment('AID_DEV_BUILD'));

  static final AppActions instance = AppActions();

  static final List<AppAction> everyAction = [
    ...settingsActions,
    ...entryActions,
    ...entryMediaActions,
    ...drawingActions,
    ...tagActions,
    ...linkActions,
    ...templateActions,
    ...coachActions,
    ...flashbackActions,
    ...placeActions,
    ...photoSuggestionActions,
    ...dataActions,
    ...syncActions,
    ...deviceSyncActions,
    ...screenActions,
    ...perfActions,
  ];

  final List<AppAction> _actions;

  /// Set by the GUI once it is up.
  ActionScreen? screen;

  /// Debug builds, the dev flavor, and builds made with
  /// `--dart-define=AID_DEV_BUILD=true` (a profile build on a computer for
  /// a frame-rate run): test data, the agent API always on, `AID_DATA_DIR`.
  final bool devBuild;

  ActionContext get context =>
      ActionContext(screen: screen, devBuild: devBuild);

  /// The actions this build offers.
  List<AppAction> get available => [
        for (final action in _actions)
          if (devBuild || !action.devOnly) action,
      ];

  AppAction find(String id) => available.firstWhere((action) => action.id == id,
      orElse: () =>
          throw ActionException('unknown_action', 'There is no action $id'));

  /// Runs [id] with [args]. A destructive action runs only when [confirmed]:
  /// the caller asked the person first. A long one reports to [progress].
  Future<Object?> run(String id, Map<String, Object?> args,
      {bool confirmed = false, void Function(String status)? progress}) async {
    final action = find(id);
    final parsed = action.parse(args);
    if (action.risk == ActionRisk.destructive && !confirmed) {
      throw ActionException('needs_confirmation',
          '$id cannot be undone simply (${action.describe}) Confirm to go on.');
    }
    return action.run(
        progress == null
            ? context
            : ActionContext(
                screen: screen, devBuild: devBuild, progress: progress),
        parsed);
  }

  List<Map<String, Object?>> describe() =>
      [for (final action in available) action.toJson()];

  /// How an agent uses the app, written from the actions themselves so it
  /// never falls behind them.
  String guide() {
    final buffer = StringBuffer('''
# AID Diary for agents

Everything the app does is an action with an id. The GUI's buttons and its
command palette run the same actions as the `aid` command line, so what an
agent does shows in the app as it happens.

    aid actions                     # every action, with its arguments
    aid entry.list limit=5          # run one; arguments are key=value
    aid entry.delete id=12 --yes    # destructive actions need --yes
    aid -d <adb serial> sync.now    # a phone or tablet over adb

Results are JSON: `{"ok": true, "result": ...}` or
`{"ok": false, "error": {"code": ..., "message": ...}}`.

''');
    String? area;
    for (final action in available) {
      final next = action.id.split('.').first;
      if (next != area) {
        area = next;
        buffer.writeln('## $area\n');
      }
      buffer.writeln('- `${action.id}` (${action.risk.name}'
          '${action.devOnly ? ', development builds' : ''}): ${action.describe}');
      for (final param in action.params) {
        buffer.writeln('  - `${param.name}` ${param.type.name}'
            '${param.required ? '' : ', optional'}: ${param.describe}');
      }
    }
    return buffer.toString();
  }
}
