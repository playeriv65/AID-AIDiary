// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/agent/aid_command.dart';
import 'package:aid_diary/agent/diary_sql.dart';
import 'package:aid_diary/agent/native/api/shell.dart';
import 'package:aid_diary/agent/native/frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// The agent's bash: bashkit (in Rust, `rust/`), with an in-memory file
/// system, no processes, host files or network. Its only way to the diary
/// is the two commands answered here, `aid` and `sql`.
class AidShell {
  AidShell._(this._shell, this._sql);

  final AgentShell _shell;
  final DiarySql _sql;

  static Future<void>? _loaded;

  /// Loads the Rust library once; tests pass the one they built.
  static Future<void> load({ExternalLibrary? library}) =>
      _loaded ??= RustLib.init(externalLibrary: library);

  static Future<AidShell> open(
      {required AidCommand aid, required DiarySql sql}) async {
    await load();
    final shell = AgentShell(
      commands: const ['aid', 'sql'],
      host: (name, args, stdin) async => switch (name) {
        'aid' => await aid.run(args),
        'sql' => await sql.run(args, stdin),
        _ => ShellOutput(
            stdout: '', stderr: '$name: not a command\n', exitCode: 127),
      },
    );
    return AidShell._(shell, sql);
  }

  /// Runs [script]; files and variables it leaves stay for the next one.
  Future<ShellOutput> run(String script) => _shell.exec(script: script);

  Future<void> close() async {
    await _sql.close();
    _shell.dispose();
  }
}
