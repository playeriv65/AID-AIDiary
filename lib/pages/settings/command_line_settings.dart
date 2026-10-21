// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/command_palette.dart';
import 'package:aid_diary/widgets/settings_toggle.dart';
import 'package:material_ui/material_ui.dart';

/// The `aid` command line and the commands it shares with the GUI.
class CommandLineSettings extends StatefulWidget {
  const CommandLineSettings({super.key});

  @override
  State<CommandLineSettings> createState() => _CommandLineSettingsState();
}

class _CommandLineSettingsState extends State<CommandLineSettings> {
  final _api = AgentApiSwitch.instance;

  Future<void> _toggle(bool on) async {
    await ConfigProvider.instance.set(Settings.agentApi, on);
    await _api.apply();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final devBuild = AppActions.instance.devBuild;
    final port = _api.port;
    return Scaffold(
      appBar:
          AppBar(title: Text(l10n.settingsCommandLineTitle), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(children: [
            if (devBuild)
              ListTile(
                title: Text(l10n.commandLineToggle),
                subtitle: Text(l10n.commandLineAlwaysOn),
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
              ListTile(
                leading: const Icon(Icons.lan_rounded),
                title: Text(l10n.commandLineListening(port)),
                subtitle: const Text('aid guide'),
              ),
            ListTile(
              key: const ValueKey('command-palette-open'),
              leading: const Icon(Icons.terminal_rounded),
              title: Text(l10n.commandPaletteTitle),
              onTap: () => showCommandPalette(context),
            ),
          ]),
        ),
      ),
    );
  }
}
