// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// What running an action may do, so every caller can ask first when it
/// should: the GUI with a dialog, the CLI with `--yes`.
enum ActionRisk {
  /// Only reads.
  read,

  /// Writes, and can be undone or written again.
  write,

  /// Removes or replaces something the user may want back.
  destructive,
}

enum ParamType { string, integer, boolean }

/// One argument of an action.
class ActionParam {
  const ActionParam(this.name, this.type, this.describe,
      {this.required = true});

  final String name;
  final ParamType type;
  final String describe;
  final bool required;

  Map<String, Object?> toJson() => {
        'name': name,
        'type': type.name,
        'describe': describe,
        'required': required,
      };
}

/// Why an action did not run; [code] is stable for scripts to test.
class ActionException implements Exception {
  const ActionException(this.code, this.message);

  final String code;
  final String message;

  Map<String, Object?> toJson() => {'code': code, 'message': message};

  @override
  String toString() => '$code: $message';
}

/// The part of the app on screen, for the actions that look at it or move
/// it. The GUI provides it; without a GUI there is none.
abstract interface class ActionScreen {
  /// Where the user is: a route name such as `journal` or `settings/sync`.
  String get current;

  /// The screens [navigate] can open.
  List<String> get destinations;

  Future<void> navigate(String destination);
}

/// What an action runs with.
class ActionContext {
  const ActionContext({this.screen, this.devBuild = false});

  /// Null when no GUI is attached.
  final ActionScreen? screen;

  /// Whether this is a development build, where test-data actions exist.
  final bool devBuild;
}

typedef ActionArgs = Map<String, Object?>;

/// One thing the app can do, defined once. The GUI calls it from buttons
/// and the command palette, and the CLI and the agent API call it by [id];
/// see docs/ARCHITECTURE.md ("Agent-native").
class AppAction {
  const AppAction({
    required this.id,
    required this.describe,
    required this.risk,
    this.params = const [],
    this.devOnly = false,
    required this.run,
  });

  /// `area.verb`, e.g. `entry.create`. Never renamed: scripts depend on it.
  final String id;

  /// One sentence for people and agents, in English.
  final String describe;
  final ActionRisk risk;
  final List<ActionParam> params;

  /// Only in development builds, such as making test data.
  final bool devOnly;

  /// Returns a JSON-encodable result.
  final Future<Object?> Function(ActionContext context, ActionArgs args) run;

  Map<String, Object?> toJson() => {
        'id': id,
        'describe': describe,
        'risk': risk.name,
        'params': [for (final param in params) param.toJson()],
        if (devOnly) 'devOnly': true,
      };

  /// [raw] as this action's arguments: strings from a command line become
  /// the declared types, and missing required ones are reported.
  ActionArgs parse(Map<String, Object?> raw) {
    final unknown = raw.keys.toSet()
      ..removeAll(params.map((param) => param.name));
    if (unknown.isNotEmpty) {
      throw ActionException(
          'bad_args', 'Unknown argument ${unknown.join(', ')} for $id');
    }
    final args = <String, Object?>{};
    for (final param in params) {
      final value = raw[param.name];
      if (value == null) {
        if (param.required) {
          throw ActionException(
              'bad_args', 'Missing argument ${param.name} for $id');
        }
        continue;
      }
      args[param.name] = switch ((param.type, value)) {
        (ParamType.string, final String text) => text,
        (ParamType.integer, final int number) => number,
        (ParamType.integer, final String text)
            when int.tryParse(text) != null =>
          int.parse(text),
        (ParamType.boolean, final bool flag) => flag,
        (ParamType.boolean, 'true' || 'yes' || '1') => true,
        (ParamType.boolean, 'false' || 'no' || '0') => false,
        _ => throw ActionException('bad_args',
            '${param.name} for $id must be a ${param.type.name}, not $value'),
      };
    }
    return args;
  }
}
