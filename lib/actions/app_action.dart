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

enum ParamType { string, integer, number, boolean }

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

/// A place the GUI can open, and what it needs to open there: a screen
/// such as `settings/data`, or one item such as `entry` with an `id`.
class ScreenDestination {
  const ScreenDestination(this.name, this.describe, {this.params = const []});

  final String name;
  final String describe;
  final List<ActionParam> params;

  Map<String, Object?> toJson() => {
        'name': name,
        'describe': describe,
        'params': [for (final param in params) param.toJson()],
      };
}

/// The part of the app on screen, for the actions that look at it or move
/// it. The GUI provides it; without a GUI there is none.
abstract interface class ActionScreen {
  /// Where the user is: a route name such as `journal`, `settings/data` or
  /// `entry/12`.
  String get current;

  /// Every place [navigate] can open: each one the GUI can.
  List<ScreenDestination> get destinations;

  /// Opens [destination] with [args], already checked against its params.
  Future<void> navigate(String destination, ActionArgs args);

  /// Closes the screen or dialog on top; false when only a tab is left.
  Future<bool> back();
}

/// What an action runs with.
class ActionContext {
  const ActionContext(
      {this.screen, this.devBuild = false, this.progress = _quiet});

  /// Null when no GUI is attached.
  final ActionScreen? screen;

  /// Whether this is a development build, where test-data actions exist.
  final bool devBuild;

  /// Tells how far a long action has got, such as `40%`; the GUI shows it
  /// in its progress dialog.
  final void Function(String status) progress;

  static void _quiet(String status) {}
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
    this.moreArgs = false,
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
        if (moreArgs) 'moreArgs': true,
      };

  /// Whether arguments beyond [params] are passed on unchecked, for an
  /// action that checks them itself (`ui.navigate`, against the place it
  /// opens).
  final bool moreArgs;

  /// [raw] as this action's arguments: strings from a command line become
  /// the declared types, and missing required ones are reported.
  ActionArgs parse(Map<String, Object?> raw) {
    final declared = {for (final param in params) param.name};
    if (!moreArgs) return parseArgs(params, raw, id);
    return {
      ...parseArgs(
          params,
          {
            for (final MapEntry(:key, :value) in raw.entries)
              if (declared.contains(key)) key: value
          },
          id),
      for (final MapEntry(:key, :value) in raw.entries)
        if (!declared.contains(key)) key: value,
    };
  }
}

/// [raw] checked against [params] for [owner]: strings from a command line
/// become the declared types; unknown and missing required arguments are
/// reported.
ActionArgs parseArgs(
    List<ActionParam> params, Map<String, Object?> raw, String owner) {
  final unknown = raw.keys.toSet()
    ..removeAll(params.map((param) => param.name));
  if (unknown.isNotEmpty) {
    throw ActionException(
        'bad_args', 'Unknown argument ${unknown.join(', ')} for $owner');
  }
  final args = <String, Object?>{};
  for (final param in params) {
    final value = raw[param.name];
    if (value == null) {
      if (param.required) {
        throw ActionException(
            'bad_args', 'Missing argument ${param.name} for $owner');
      }
      continue;
    }
    args[param.name] = switch ((param.type, value)) {
      (ParamType.string, final String text) => text,
      (ParamType.integer, final int number) => number,
      (ParamType.integer, final String text) when int.tryParse(text) != null =>
        int.parse(text),
      (ParamType.number, final num number) => number.toDouble(),
      (ParamType.number, final String text)
          when double.tryParse(text)?.isFinite ?? false =>
        double.parse(text),
      (ParamType.boolean, final bool flag) => flag,
      (ParamType.boolean, 'true' || 'yes' || '1') => true,
      (ParamType.boolean, 'false' || 'no' || '0') => false,
      _ => throw ActionException('bad_args',
          '${param.name} for $owner must be a ${param.type.name}, not $value'),
    };
  }
  return args;
}
