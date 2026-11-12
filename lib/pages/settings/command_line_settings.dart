// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/mcp_api.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:aid_diary/widgets/settings_row.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:aid_diary/widgets/text_input_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// The `aid` command line, the MCP server and the commands they share with
/// the GUI.
class CommandLineSettings extends StatefulWidget {
  const CommandLineSettings({super.key});

  @override
  State<CommandLineSettings> createState() => _CommandLineSettingsState();
}

class _CommandLineSettingsState extends State<CommandLineSettings> {
  final _api = AgentApiSwitch.instance;
  final _mcp = McpSwitch.instance;

  Future<void> _toggle(bool on) async {
    await changeSetting(Settings.agentApi, on);
    if (mounted) setState(() {});
  }

  Future<void> _toggleMcp(bool on) async {
    await changeSetting(Settings.mcpServer, on);
    if (mounted) setState(() {});
  }

  Future<void> _setMcpToken(AppLocalizations l10n) async {
    final least = AppConfig.instance.mcpMinTokenLength;
    final token = await showTextInputDialog(context,
        title: l10n.mcpToken,
        confirm: l10n.mcpTokenSet,
        plain: true,
        validate: (text) =>
            text.length < least ? l10n.passwordTooShort(least) : null);
    if (token == null || !mounted) return;
    await runWithFailureSnack(context,
        () => AppActions.instance.run('mcp.set_token', {'token': token}),
        failure: l10n.mcpTokenSaveFailed);
    if (mounted) setState(() {});
  }

  /// Asks for the host names a reverse proxy in front of the server sends,
  /// separated by commas or spaces.
  Future<void> _setMcpHosts(AppLocalizations l10n) async {
    List<String> hostsOf(String text) => [
          for (final word in text.toLowerCase().split(RegExp(r'[\s,]+')))
            if (word.isNotEmpty) word,
        ];
    String? refusal(String text) {
      final hosts = hostsOf(text);
      return hosts.length > McpApi.maxAllowedHosts ||
              !hosts.every(McpApi.isHostName)
          ? l10n.mcpAllowedHostsInvalid
          : null;
    }

    final text = await showTextInputDialog(context,
        title: l10n.mcpAllowedHosts,
        confirm: l10n.mcpAllowedHostsSave,
        initial: _mcp.allowedHosts.join(', '),
        hint: 'pc.example.ts.net',
        plain: true,
        confirmKey: const ValueKey('mcp-hosts-save'),
        validate: refusal);
    if (text == null || !mounted) return;
    await runWithFailureSnack(
        context, () => changeSetting(Settings.mcpAllowedHosts, hostsOf(text)),
        failure: l10n.mcpAllowedHostsInvalid);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final devBuild = AppActions.instance.devBuild;
    final port = _api.port;
    final mcpOn = ConfigProvider.instance.get(Settings.mcpServer);
    return Scaffold(
      appBar:
          AppBar(title: Text(l10n.settingsCommandLineTitle), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(children: [
            if (devBuild)
              SettingsRow(
                title: l10n.commandLineToggle,
                hint: l10n.commandLineAlwaysOn,
                trailing: const Switch(value: true, onChanged: null),
              )
            else
              SettingsToggle(
                title: l10n.commandLineToggle,
                hint: l10n.commandLineToggleHint,
                setting: Settings.agentApi,
                onChanged: _toggle,
              ),
            if (port != null)
              SettingsRow(
                icon: Icons.lan_rounded,
                title: l10n.commandLineListening(port),
                hint: 'aid guide',
              ),
            SettingsCategory(
              key: const ValueKey('command-palette-open'),
              icon: Icons.terminal_rounded,
              title: l10n.commandPaletteTitle,
              destination: 'commands',
            ),
            SettingsToggle(
              title: l10n.mcpServerToggle,
              hint: l10n.mcpServerToggleHint,
              setting: Settings.mcpServer,
              onChanged: _toggleMcp,
            ),
            if (mcpOn) ...[
              SettingsRow(
                key: const ValueKey('mcp-token'),
                icon: Icons.key_rounded,
                title: l10n.mcpToken,
                hint: _mcp.hasToken ? l10n.mcpTokenIsSet : l10n.mcpTokenHint,
                onTap: () => _setMcpToken(l10n),
              ),
              SettingsRow(
                key: const ValueKey('mcp-hosts'),
                icon: Icons.dns_rounded,
                title: l10n.mcpAllowedHosts,
                hint: _mcp.allowedHosts.isEmpty
                    ? l10n.mcpAllowedHostsHint
                    : _mcp.allowedHosts.join(', '),
                onTap: () => _setMcpHosts(l10n),
              ),
              if (_mcp.address case final address?)
                SettingsRow(
                  icon: Icons.lan_rounded,
                  title: l10n.mcpListening(address),
                )
              else if (_mcp.problem case final problem?)
                SettingsRow(
                  icon: Icons.error_outline_rounded,
                  title: l10n.mcpNotRunning(problem),
                ),
            ],
          ]),
        ),
      ),
    );
  }
}
