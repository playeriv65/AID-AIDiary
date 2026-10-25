import 'package:acpd/acpd.dart';
import 'package:acpd_test/acpd_test.dart';
import 'package:aid_diary/agent/acp_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('relays a prompt turn and allows a tool once', () async {
    final pair = MemoryTransportPair();
    String? workspace;
    RequestPermissionOutcome? outcome;
    AgentRole()
        .onInitialize((context, request, cancellation) =>
            const InitializeResponse(protocolVersion: ProtocolVersion.v1))
        .onNewSession((context, request, cancellation) {
      workspace = request.cwd;
      return const NewSessionResponse(sessionId: 's1');
    }).onPrompt((context, request, cancellation) async {
      outcome = await context.requestPermission(const RequestPermissionRequest(
        sessionId: 's1',
        toolCall: ToolCallUpdate(toolCallId: 't1', title: 'aid entry.list'),
        options: [
          PermissionOption(
              optionId: 'no',
              name: 'Reject',
              kind: PermissionOptionKind.rejectOnce),
          PermissionOption(
              optionId: 'always',
              name: 'Always',
              kind: PermissionOptionKind.allowAlways),
          PermissionOption(
              optionId: 'once',
              name: 'Allow',
              kind: PermissionOptionKind.allowOnce),
        ],
      ));
      context.sessionUpdate(
          sessionId: 's1',
          update: AgentMessageChunk(
              chunk: const ContentChunk(
                  content: TextContentBlock(text: 'Two entries.'))));
      return const PromptResponse(stopReason: StopReason.endTurn);
    }).connect(pair.right);

    final link = await AcpLink.connect(pair.left, workspace: '/work');
    final reply = await link.ask('How many entries?');

    expect(workspace, '/work');
    expect(reply.answer, 'Two entries.');
    expect(reply.stopReason, 'end_turn');
    expect((outcome as PermissionSelected).optionId, 'once');
    expect(reply.permissions.single, (tool: 'aid entry.list', option: 'Allow'));
    await link.close();
    await pair.close();
  });

  test('refuses when the agent offers no way to allow', () {
    expect(
        AcpLink.allowing(const [
          PermissionOption(
              optionId: 'no',
              name: 'Reject',
              kind: PermissionOptionKind.rejectOnce),
        ]),
        isNull);
  });
}
