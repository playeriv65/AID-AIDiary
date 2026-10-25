// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/agent/agent_sessions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';

AgentSessions get _sessions => AgentSessions.instance;

const _session = ActionParam('session', ParamType.string,
    'A conversation agent.ask or agent.shell returned; a new one when left out',
    required: false);

/// The in-app agent and agents on this computer over ACP. Development
/// builds only until asking the user before risky steps is designed
/// (TODO.md, "In-app agent").
final List<AppAction> agentActions = [
  AppAction(
    id: 'agent.configure',
    describe: "Sets the in-app agent's model service (OpenAI-compatible), "
        'model and key, and the aid executable ACP agents run. Empty text '
        'restores a default.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('baseUrl', ParamType.string, 'The service address',
          required: false),
      ActionParam('model', ParamType.string, 'The model name', required: false),
      ActionParam('apiKey', ParamType.string, 'The key, kept in the key store',
          required: false),
      ActionParam('cli', ParamType.string,
          'The aid executable for ACP agents; empty: aid on the PATH',
          required: false),
    ],
    run: (context, args) async {
      final config = ConfigProvider.instance;
      for (final (name, setting) in [
        ('baseUrl', Settings.agentBaseUrl),
        ('model', Settings.agentModel),
        ('apiKey', Settings.agentApiKey),
        ('cli', Settings.agentCliPath),
      ]) {
        if (args[name] case final String value) {
          await config.set(setting, value);
        }
      }
      return _status();
    },
  ),
  AppAction(
    id: 'agent.status',
    describe: 'The model the in-app agent uses, whether it has a key, its '
        'open conversations and the ACP agents it can start.',
    risk: ActionRisk.read,
    devOnly: true,
    run: (context, args) async => _status(),
  ),
  AppAction(
    id: 'agent.ask',
    describe: 'Asks the in-app agent; it works through a sandboxed bash '
        'whose aid and sql commands reach the diary. Returns its answer and '
        'the commands it ran.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('prompt', ParamType.string, 'What to ask'),
      _session,
    ],
    run: (context, args) async {
      final (session, agent) =
          await _sessions.agent(args['session'] as String?);
      final reply = await agent.ask(args['prompt'] as String);
      return {
        'session': session,
        'answer': reply.answer,
        'steps': [
          for (final step in reply.steps)
            {'command': step.command, 'exitCode': step.exitCode},
        ],
      };
    },
  ),
  AppAction(
    id: 'agent.shell',
    describe: "Runs a bash script in the in-app agent's sandboxed shell "
        'without a model, as the agent would: aid and sql reach the diary.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('script', ParamType.string, 'The bash to run'),
      _session,
    ],
    run: (context, args) async {
      final (session, shell) =
          await _sessions.shell(args['session'] as String?);
      final output = await shell.run(args['script'] as String);
      return {
        'session': session,
        'exitCode': output.exitCode,
        'stdout': output.stdout,
        'stderr': output.stderr,
      };
    },
  ),
  AppAction(
    id: 'agent.close',
    describe: 'Ends an in-app agent conversation and its shell.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('session', ParamType.string, 'The conversation'),
    ],
    run: (context, args) async {
      await _sessions.close(args['session'] as String);
      return null;
    },
  ),
  AppAction(
    id: 'acp.ask',
    describe: 'Asks an agent on this computer that speaks ACP (agent.status '
        'lists them), started on first use and kept for follow-ups; it '
        'drives the app with the aid command line. Computers only.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('agent', ParamType.string, 'The agent, such as claude'),
      ActionParam('prompt', ParamType.string, 'What to ask'),
      ActionParam('fresh', ParamType.boolean,
          'Start a new conversation instead of continuing',
          required: false),
    ],
    run: (context, args) async {
      final name = args['agent'] as String;
      final link =
          await _sessions.link(name, fresh: args['fresh'] as bool? ?? false);
      final reply = await link.ask(args['prompt'] as String);
      return {
        'agent': name,
        'answer': reply.answer,
        'stopReason': reply.stopReason,
        'toolCalls': reply.toolCalls,
        'permissions': [
          for (final permission in reply.permissions)
            {'tool': permission.tool, 'option': permission.option},
        ],
      };
    },
  ),
  AppAction(
    id: 'acp.close',
    describe: 'Stops an ACP agent the app started.',
    risk: ActionRisk.write,
    devOnly: true,
    params: const [
      ActionParam('agent', ParamType.string, 'The agent, such as claude'),
    ],
    run: (context, args) async {
      await _sessions.closeLink(args['agent'] as String);
      return null;
    },
  ),
];

Map<String, Object?> _status() {
  final config = ConfigProvider.instance;
  String or(String value, String fallback) => value.isEmpty ? fallback : value;
  return {
    'baseUrl':
        or(config.get(Settings.agentBaseUrl), AppConfig.instance.agentBaseUrl),
    'model': or(config.get(Settings.agentModel), AppConfig.instance.agentModel),
    'hasKey': config.get(Settings.agentApiKey).isNotEmpty,
    'cli': or(config.get(Settings.agentCliPath), 'aid'),
    'sessions': _sessions.open,
    'acpAgents': AppConfig.instance.acpAgents.keys.toList(),
    'acpRunning': _sessions.linked,
  };
}
