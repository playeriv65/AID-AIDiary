// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Hidden content is reachable only through a fresh local authentication.
class HiddenEntriesPage extends StatefulWidget {
  const HiddenEntriesPage({super.key});

  @override
  State<HiddenEntriesPage> createState() => _HiddenEntriesPageState();
}

class _HiddenEntriesPageState extends State<HiddenEntriesPage> {
  final _session = HiddenDiarySession();
  bool _authenticating = false;
  List<DeletedEntry> _deleted = const [];

  Future<void> _reloadDeleted() async {
    final deleted = await EntryStore.instance.deleted(includeHidden: true);
    if (mounted) {
      setState(() =>
          _deleted = deleted.where((item) => item.entry.isHidden).toList());
    }
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    var success = false;
    final config = ConfigProvider.instance;
    final l10n = AppLocalizations.of(context)!;
    try {
      if (config.get(Settings.requirePassword)) {
        await showDialog<void>(
            context: context,
            builder: (_) => AuthPopup(
                  mode: AuthPopupMode.unlock,
                  title: l10n.hiddenDiaryTitle,
                  showBiometrics: config.get(Settings.biometricUnlock),
                  dismissable: true,
                  onSuccess: (_) => success = true,
                ));
      } else {
        success = await LocalAuthentication().authenticate(
          localizedReason: l10n.hiddenDiaryUnlock,
          biometricOnly: false,
          persistAcrossBackgrounding: false,
        );
      }
    } on PlatformException {
      success = false;
    } on LocalAuthException {
      success = false;
    } on MissingPluginException {
      success = false;
    }
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (success) {
      await _reloadDeleted();
      if (!mounted) return;
      _session.unlock();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.hiddenDiaryAuthHint)));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<EntriesProvider>();
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: _session,
      builder: (context, _) => HiddenDiaryScope(
        session: _session,
        child: Builder(builder: (context) {
          final entries = EntryStore.instance.hiddenEntries;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.hiddenDiaryTitle)),
            body: !_session.unlocked
                ? Center(
                    child: FilledButton.icon(
                        key: const ValueKey('hidden-unlock'),
                        onPressed: _authenticating ? null : _unlock,
                        icon: const Icon(Icons.lock_open_outlined),
                        label: Text(l10n.hiddenDiaryUnlock)))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(l10n.hiddenDiaryLocalOnly,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 16),
                      if (entries.isEmpty) Text(l10n.hiddenDiaryEmpty),
                      for (final entry in entries)
                        ListTile(
                          key: ValueKey('hidden-entry-${entry.id}'),
                          leading: const Icon(Icons.visibility_off_outlined),
                          title:
                              Text(TimeManager.formatDate(entry.day, context)),
                          subtitle: entry.isSealed
                              ? Text(l10n.capsuleTitle)
                              : Text(
                                  entryPreview(entry.text).title ??
                                      entryPreview(entry.text).snippet,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                          onTap: () async {
                            await EntryNavigation.view(context, entry,
                                entries: () =>
                                    EntryStore.instance.hiddenEntries);
                            await _reloadDeleted();
                          },
                        ),
                      if (_deleted.isNotEmpty) ...[
                        const Divider(),
                        Text(l10n.deletedTitle,
                            style: Theme.of(context).textTheme.titleMedium),
                        for (final item in _deleted)
                          ListTile(
                            title: Text(TimeManager.formatDate(
                                item.entry.day, context)),
                            subtitle: Text(l10n.deletedDaysLeft(item.daysLeft)),
                            trailing: TextButton(
                                onPressed: () async {
                                  await _session.restore(item.entry);
                                  await _reloadDeleted();
                                },
                                child: Text(l10n.deletedRestore)),
                          ),
                      ],
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
