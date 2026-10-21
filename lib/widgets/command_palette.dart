// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:material_ui/material_ui.dart';

/// Every action of the app, searchable and runnable: the GUI's side of the
/// `aid` command line, so the two always list the same things.
Future<void> showCommandPalette(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const _CommandPalette());

class _CommandPalette extends StatefulWidget {
  const _CommandPalette();

  @override
  State<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<_CommandPalette> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _run(AppAction action) async {
    final args = action.params.isEmpty
        ? <String, Object?>{}
        : await showDialog<Map<String, Object?>>(
            context: context, builder: (_) => _ArgumentsDialog(action));
    if (args == null || !mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (action.risk == ActionRisk.destructive) {
      Haptics.warning();
      final go = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(action.id),
          content: Text(l10n.commandPaletteConfirm),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.commandPaletteRun)),
          ],
        ),
      );
      if (go != true || !mounted) return;
    }
    Object? result;
    try {
      result = {
        'ok': true,
        'result':
            await AppActions.instance.run(action.id, args, confirmed: true),
      };
      Haptics.success();
    } on ActionException catch (error) {
      result = {'ok': false, 'error': error.toJson()};
      Haptics.error();
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.id),
        content: SingleChildScrollView(
          child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(result),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).okButtonLabel)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _query.text.trim().toLowerCase();
    final actions = [
      for (final action in AppActions.instance.available)
        if (query.isEmpty ||
            action.id.contains(query) ||
            action.describe.toLowerCase().contains(query))
          action,
    ];
    return Dialog(
      key: const ValueKey('command-palette'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 560),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const ValueKey('command-palette-search'),
              controller: _query,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: l10n.commandPaletteSearch,
                  border: const OutlineInputBorder()),
            ),
          ),
          Flexible(
            child: ListView(shrinkWrap: true, children: [
              for (final action in actions)
                ListTile(
                  key: ValueKey('command-${action.id}'),
                  title: Text(action.id,
                      style: const TextStyle(fontFamily: 'monospace')),
                  subtitle: Text(action.describe),
                  trailing: action.risk == ActionRisk.destructive
                      ? Icon(Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error)
                      : null,
                  onTap: () => _run(action),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// The arguments of one action, as a form.
class _ArgumentsDialog extends StatefulWidget {
  const _ArgumentsDialog(this.action);

  final AppAction action;

  @override
  State<_ArgumentsDialog> createState() => _ArgumentsDialogState();
}

class _ArgumentsDialogState extends State<_ArgumentsDialog> {
  late final Map<String, TextEditingController> _fields = {
    for (final param in widget.action.params)
      param.name: TextEditingController(),
  };

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.action.id),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final param in widget.action.params)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                key: ValueKey('command-arg-${param.name}'),
                controller: _fields[param.name],
                keyboardType: param.type == ParamType.integer
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                    labelText:
                        '${param.name}${param.required ? '' : ' (optional)'}',
                    helperText: param.describe,
                    helperMaxLines: 3,
                    border: const OutlineInputBorder()),
              ),
            ),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
          key: const ValueKey('command-run'),
          onPressed: () => Navigator.pop(context, {
            for (final MapEntry(key: name, value: field) in _fields.entries)
              if (field.text.isNotEmpty) name: field.text,
          }),
          child: Text(l10n.commandPaletteRun),
        ),
      ],
    );
  }
}
