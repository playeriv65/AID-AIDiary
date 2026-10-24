// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/agent/aid_shell.dart';
import 'package:dart_agent_core/dart_agent_core.dart';

/// The model service the user chose: OpenAI-compatible.
typedef AgentModel = ({String baseUrl, String model, String apiKey});

/// One command the agent ran, and how it ended.
typedef AgentStep = ({String command, int exitCode});

/// The in-app agent: a model working through [AidShell]'s bash, one
/// conversation per instance.
class DiaryAgent {
  DiaryAgent(
      {required AgentModel model,
      required AidShell shell,
      required String systemPrompt,
      required this.outputChars,
      required this.maxTurns,
      LLMClient? client})
      : _shell = shell {
    _agent = StatefulAgent(
      name: 'aid_diary',
      systemPrompts: [systemPrompt],
      client: client ??
          OpenAIClient(apiKey: model.apiKey, baseUrl: model.baseUrl),
      modelConfig: ModelConfig(model: model.model),
      state: AgentState.empty(),
      tools: [_bash],
      withGeneralPrinciples: false,
      disableSubAgents: true,
      maxTurns: maxTurns,
    );
  }

  final AidShell _shell;

  /// The most characters of one command's output the model sees.
  final int outputChars;
  final int maxTurns;
  late final StatefulAgent _agent;
  final List<AgentStep> _steps = [];

  late final _bash = Tool(
    name: 'bash',
    description: 'Runs a bash script in the sandboxed shell and returns its '
        'exit code, standard output and standard error. `aid` and `sql` '
        'reach the diary; see the system prompt.',
    parameterMode: ToolParameterMode.object,
    // `command`, as bash tools elsewhere call it: models reach for that name.
    parameters: {
      'type': 'object',
      'properties': {
        'command': {'type': 'string', 'description': 'The bash to run.'},
      },
      'required': ['command'],
    },
    executable: (Map<String, dynamic> args) async {
      final script = args['command'];
      if (script is! String) {
        return 'No command: call bash with {"command": "<bash>"}.';
      }
      final output = await _shell.run(script);
      _steps.add((command: script, exitCode: output.exitCode));
      return 'exit code: ${output.exitCode}\n'
          'stdout:\n${_clip(output.stdout)}\n'
          'stderr:\n${_clip(output.stderr)}';
    },
  );

  String _clip(String text) => text.length <= outputChars
      ? text
      : '${text.substring(0, outputChars)}\n'
          '[cut: ${text.length - outputChars} more characters; '
          'narrow the command]';

  /// Answers [prompt] in this conversation, with the commands it ran.
  Future<({String answer, List<AgentStep> steps})> ask(String prompt) async {
    _steps.clear();
    final messages =
        await _agent.run([UserMessage.text(prompt)], maxTurns: maxTurns);
    final answer = messages
        .whereType<ModelMessage>()
        .map((message) => message.textOutput)
        .whereType<String>()
        .lastOrNull;
    return (answer: answer ?? '', steps: List.of(_steps));
  }
}
