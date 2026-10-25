// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// How every statistics card looks: a filled card with its title centred
/// on top, an optional [action] at the title's end, and its [child] below,
/// faded under "not enough data" while [hasData] is false.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.child,
    this.hasData = true,
    this.action,
  });

  final String title;
  final Widget child;
  final bool hasData;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heading = Text(title,
        textAlign: TextAlign.center,
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
    return Card.filled(
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: action == null
              ? Center(child: heading)
              // The action's width on the left too keeps the title centred.
              : Row(children: [
                  const SizedBox(width: 48),
                  Expanded(child: heading),
                  SizedBox(width: 48, child: action),
                ]),
        ),
        Stack(alignment: Alignment.center, children: [
          Opacity(opacity: hasData ? 1 : 0.3, child: child),
          if (!hasData) const StatNoData(),
        ]),
      ]),
    );
  }
}

/// "Not enough data", as statistics say it.
class StatNoData extends StatelessWidget {
  const StatNoData({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(AppLocalizations.of(context)!.statisticsNotEnoughData,
        key: const ValueKey('stat-no-data'),
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, color: theme.disabledColor));
  }
}
