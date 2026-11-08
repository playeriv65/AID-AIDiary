// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:aid_diary/widgets/settings_row.dart';
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
    await changeSetting(Settings.agentApi, on);
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
          ]),
        ),
      ),
    );
  }
}
