// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:acpd/acpd.dart';
import 'package:acpd_io/acpd_io.dart';

/// How to start an agent that speaks ACP, with variables of its own.
typedef AcpCommand = ({
  String command,
  List<String> args,
  Map<String, String> env,
});

/// A permission the agent asked for, and the option given.
typedef AcpPermission = ({String tool, String option});

/// What one prompt turn brought back.
typedef AcpReply = ({
  String answer,
  String stopReason,
  List<String> toolCalls,
  List<AcpPermission> permissions,
});

/// An agent on this computer (Claude, Codex, Gemini, …) started by the app
/// over the Agent Client Protocol. It works in [workspace], whose
/// instructions tell it to drive the app with the `aid` command line; its
/// own tools and permission rules decide what else it may touch.
class AcpLink {
  AcpLink._(this._agent, this._connection, this._session, this._permissions);

  final AcpAgent? _agent;
  final ClientConnection _connection;
  final Session _session;
  final List<AcpPermission> _permissions;

  /// Starts [command] in [workspace] with [environment] added.
  static Future<AcpLink> start(AcpCommand command,
      {required String workspace,
      Map<String, String> environment = const {}}) async {
    // npx, npm and friends are .cmd scripts on Windows, which only cmd runs.
    final (executable, args) = Platform.isWindows
        ? ('cmd', ['/c', command.command, ...command.args])
        : (command.command, command.args);
    final agent = await AcpAgent.start(AcpAgentConfig(
      command: executable,
      args: args,
      env: {...command.env, ...environment},
      workingDirectory: workspace,
    ));
    try {
      return await connect(agent.transport, workspace: workspace, agent: agent);
    } catch (_) {
      await agent.close();
      rethrow;
    }
  }

  /// Opens a session with the agent behind [transport].
  static Future<AcpLink> connect(Transport transport,
      {required String workspace, AcpAgent? agent}) async {
    final permissions = <AcpPermission>[];
    final connection =
        ClientRole().onRequestPermission((context, request, cancellation) {
      final option = allowing(request.options);
      permissions.add((
        tool: request.toolCall.title ?? request.toolCall.toolCallId,
        option: option?.name ?? 'none',
      ));
      return RequestPermissionResponse(
          outcome: option == null
              ? const PermissionCancelled()
              : PermissionSelected(optionId: option.optionId));
    }).connect(transport);
    await connection.client.initialize(const InitializeRequest(
      protocolVersion: ProtocolVersion.v1,
      clientInfo: Implementation(name: 'aid-diary', version: '1'),
    ));
    final session =
        await Session.create(connection, NewSessionRequest(cwd: workspace));
    return AcpLink._(agent, connection, session, permissions);
  }

  /// The option that lets a tool run once, else always; null when the
  /// agent offers neither. Asking the user comes with authorization
  /// (TODO.md, "In-app agent").
  static PermissionOption? allowing(List<PermissionOption> options) => options
      .where((option) => option.kind == PermissionOptionKind.allowOnce)
      .followedBy(options
          .where((option) => option.kind == PermissionOptionKind.allowAlways))
      .firstOrNull;

  Future<AcpReply> ask(String prompt) async {
    _permissions.clear();
    final turn = await _session.sendPrompt([TextContentBlock(text: prompt)]);
    return (
      answer: turn.agentText,
      stopReason: turn.stopReason.toJson(),
      toolCalls: [for (final call in turn.toolCalls) call.toolCall.title],
      permissions: List.of(_permissions),
    );
  }

  Future<void> close() async {
    _session.dispose();
    await _connection.close();
    await _agent?.close();
  }
}
