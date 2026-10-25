// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/agent/acp_link.dart';
import 'package:aid_diary/agent/aid_command.dart';
import 'package:aid_diary/agent/aid_shell.dart';
import 'package:aid_diary/agent/diary_agent.dart';
import 'package:aid_diary/agent/diary_sql.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// The agent conversations open in the app: in-app ones by id, each with
/// its own shell, and agents started over ACP by name. They live in memory;
/// closing the app ends them.
class AgentSessions {
  AgentSessions._();

  static final AgentSessions instance = AgentSessions._();

  final Map<String, AidShell> _shells = {};
  final Map<String, DiaryAgent> _agents = {};
  final Map<String, AcpLink> _links = {};
  int _made = 0;

  List<String> get open => _shells.keys.toList();
  List<String> get linked => _links.keys.toList();

  /// The model service to use: the user's choice, else the defaults.
  static AgentModel model() {
    final config = ConfigProvider.instance;
    String or(String value, String fallback) =>
        value.isEmpty ? fallback : value;
    final apiKey = config.get(Settings.agentApiKey);
    if (apiKey.isEmpty) {
      throw const ActionException(
          'not_configured', 'No model key yet: agent.configure apiKey=<key>');
    }
    return (
      baseUrl: or(
          config.get(Settings.agentBaseUrl), AppConfig.instance.agentBaseUrl),
      model: or(config.get(Settings.agentModel), AppConfig.instance.agentModel),
      apiKey: apiKey,
    );
  }

  /// [id]'s shell, or a new conversation's when [id] is null.
  Future<(String, AidShell)> shell(String? id) async {
    if (id != null) {
      final shell = _shells[id];
      if (shell == null) {
        throw ActionException('not_found', 'No agent session $id');
      }
      return (id, shell);
    }
    final made = 's${++_made}';
    final path = await AppDatabase.instance.getInternalPath();
    final shell = await AidShell.open(
      aid: AidCommand(() => AppActions.instance),
      sql: DiarySql(
          () => openDatabase(path, readOnly: true, singleInstance: false),
          rowLimit: AppConfig.instance.agentSqlRows),
    );
    return (made, _shells[made] = shell);
  }

  /// [id]'s agent, or a new conversation's when [id] is null.
  Future<(String, DiaryAgent)> agent(String? id) async {
    final model = AgentSessions.model();
    final (session, shell) = await this.shell(id);
    final agent = _agents[session] ??= DiaryAgent(
      model: model,
      shell: shell,
      systemPrompt: await _systemPrompt(),
      outputChars: AppConfig.instance.agentOutputChars,
      maxTurns: AppConfig.instance.agentMaxTurns,
    );
    return (session, agent);
  }

  static Future<String> _systemPrompt() async =>
      (await rootBundle.loadString('assets/agent/system_prompt.md'))
          .replaceAll(
              '{today}', DateFormat('yyyy-MM-dd, EEEE').format(DateTime.now()))
          .replaceAll('{sqlRows}', '${AppConfig.instance.agentSqlRows}');

  Future<void> close(String id) async {
    _agents.remove(id);
    await _shells.remove(id)?.close();
  }

  /// The ACP agent called [name], started on first use; [fresh] starts a
  /// new conversation.
  Future<AcpLink> link(String name, {bool fresh = false}) async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
      throw const ActionException(
          'unsupported', 'ACP agents run on computers only');
    }
    final command = AppConfig.instance.acpAgents[name];
    if (command == null) {
      throw ActionException('bad_args',
          'No ACP agent $name; there are ${AppConfig.instance.acpAgents.keys.join(', ')}');
    }
    if (fresh) await closeLink(name);
    final info = (await AgentApiSwitch.infoFile()).path;
    return _links[name] ??= await AcpLink.start(command,
        workspace: await _workspace(info), environment: {'AID_API_INFO': info});
  }

  Future<void> closeLink(String name) async => _links.remove(name)?.close();

  /// The folder ACP agents work in: instructions on driving the app with
  /// `aid`, under the names Codex, Claude and Gemini read. The command
  /// names this app's [info] file itself: agents' shells need not pass the
  /// environment on.
  static Future<String> _workspace(String info) async {
    final folder = Directory(
        p.join((await getApplicationSupportDirectory()).path, 'agent'));
    await folder.create(recursive: true);
    final cli = ConfigProvider.instance.get(Settings.agentCliPath);
    String quoted(String path) => path.contains(' ') ? '"$path"' : path;
    final text = (await rootBundle.loadString('assets/agent/workspace.md'))
        .replaceAll('{aid}',
            '${cli.isEmpty ? 'aid' : quoted(cli)} --info ${quoted(info)}');
    for (final name in ['AGENTS.md', 'CLAUDE.md', 'GEMINI.md']) {
      await File(p.join(folder.path, name)).writeAsString(text);
    }
    return folder.path;
  }
}
