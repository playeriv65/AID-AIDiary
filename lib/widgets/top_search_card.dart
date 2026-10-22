// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/routing/app_navigation.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/app_logo.dart';
import 'package:material_ui/material_ui.dart';

/// Floating card at the top of each page: app name, search and the menu
/// sheet.
class TopSearchCard extends StatelessWidget {
  const TopSearchCard({super.key, this.showSearch = true});

  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: cs.surfaceContainerLowest,
      elevation: 1,
      shadowColor: cs.shadow.withValues(alpha: .2),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(children: [
            const AppLogo(),
            const SizedBox(width: 10),
            Expanded(
              child: Text(l10n.appTitle.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600)),
            ),
            if (showSearch) ...[
              const VerticalDivider(indent: 16, endIndent: 16),
              IconButton(
                key: const ValueKey('journal-search'),
                tooltip: l10n.searchLogsHint,
                icon: const Icon(Icons.search_rounded),
                onPressed: () => AppNavigation.search(Navigator.of(context)),
              ),
            ],
            IconButton(
              key: const ValueKey('journal-menu'),
              tooltip: l10n.pageSettingsTitle,
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => showMenuSheet(context),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Bottom sheet with the app's secondary destinations.
Future<void> showMenuSheet(BuildContext context) {
  final navigator = Navigator.of(context);
  final l10n = AppLocalizations.of(context)!;
  void open(Future<void> Function(NavigatorState navigator) screen) {
    navigator.pop();
    screen(navigator);
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      final cs = theme.colorScheme;
      Widget row(String key, IconData icon, String title, VoidCallback onTap) =>
          ListTile(
            key: ValueKey(key),
            leading: Icon(icon),
            title: Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: onTap,
          );

      // Close, then the destinations grouped in one card.
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    key: const ValueKey('menu-close'),
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 4),
                Card.filled(
                  margin: EdgeInsets.zero,
                  color: cs.surfaceContainerHigh,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    row(
                        'diary-settings',
                        Icons.settings_rounded,
                        l10n.pageSettingsTitle,
                        () => open(AppNavigation.settings)),
                    const Divider(height: 1),
                    row(
                        'menu-statistics',
                        Icons.insights_rounded,
                        l10n.pageStatisticsTitle,
                        () => open(AppNavigation.statistics)),
                    const Divider(height: 1),
                    row(
                        'menu-templates',
                        Icons.description_outlined,
                        l10n.settingsTemplatesTitle,
                        () => open(AppNavigation.templates)),
                  ]),
                ),
                const SizedBox(height: 24),
                Text(l10n.appTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(letterSpacing: 2, color: cs.outline)),
              ]),
        ),
      );
    },
  );
}
