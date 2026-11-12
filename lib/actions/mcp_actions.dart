// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/mcp_api.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';

/// The MCP server's state and its token. It is turned on and off with the
/// `mcpServer` setting, and `mcpAllowedHosts` names the hosts a reverse proxy
/// in front of it may send; both change through `settings.set`.
final List<AppAction> mcpActions = [
  AppAction(
    id: 'mcp.status',
    describe: 'Whether the MCP server is on, where it listens, whether it '
        'has a token, the host names beyond this device it accepts, the '
        'tools it offers and why it is not running when it should be.',
    risk: ActionRisk.read,
    run: (context, args) async => mcpStatus(),
  ),
  AppAction(
    id: 'mcp.set_token',
    describe: 'Sets the token MCP clients must send as '
        '"Authorization: Bearer <token>", kept in the key store; the server '
        'starts when it is on and has one.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('token', ParamType.string, 'The token'),
    ],
    run: (context, args) async {
      final token = (args['token'] as String).trim();
      final least = AppConfig.instance.mcpMinTokenLength;
      if (token.length < least) {
        throw ActionException(
            'bad_args', 'The token needs at least $least characters');
      }
      await ConfigProvider.instance.set(Settings.mcpToken, token);
      await McpSwitch.instance.apply();
      return mcpStatus();
    },
  ),
];

Map<String, Object?> mcpStatus() {
  final server = McpSwitch.instance;
  final config = AppConfig.instance;
  return {
    'on': server.wanted,
    'hasToken': server.hasToken,
    'allowedHosts': server.allowedHosts,
    if (server.address case final address?)
      'listening': 'http://$address${config.mcpPath}',
    if (server.problem case final problem?) 'problem': problem,
    'tools': [
      for (final action
          in McpApi.offeredTools(AppActions.instance, config.mcpTools))
        McpApi.toolName(action),
    ],
  };
}
