// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/widgets/entry_card.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:aid_diary/widgets/hidden_diary_scope.dart';
import 'package:aid_diary/widgets/settings_category.dart';
import 'package:aid_diary/widgets/snack_message.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
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
      success = await authenticateOnDevice(
          reason: l10n.hiddenDiaryUnlock, biometricOnly: false);
    }
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (success) {
      _session.unlock();
    } else {
      showSnackMessage(context, l10n.hiddenDiaryAuthHint);
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
                      if (entries.isEmpty)
                        EmptyState(
                            icon: Icons.visibility_off_outlined,
                            title: l10n.hiddenDiaryEmpty),
                      for (final entry in entries)
                        EntryCard(
                          key: ValueKey('hidden-entry-${entry.id}'),
                          entry: entry,
                          images:
                              EntryImagesProvider.instance.getForEntry(entry),
                          showDate: true,
                          onTap: () => EntryNavigation.view(context, entry,
                              entries: () => EntryStore.instance.hiddenEntries),
                        ),
                      const Divider(),
                      // The same page as the diary's, holding the hidden
                      // diary's deleted entries.
                      SettingsCategory(
                          key: const ValueKey('hidden-deleted'),
                          title: l10n.deletedTitle,
                          icon: Icons.delete_outline_rounded,
                          destination: 'recently_deleted'),
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
