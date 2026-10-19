// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:material_ui/material_ui.dart';

/// A page's list beside its detail pane when there is room, the list alone
/// otherwise. [listBuilder] learns which, so taps can select or navigate.
class ListDetailLayout extends StatelessWidget {
  const ListDetailLayout({
    super.key,
    required this.listBuilder,
    required this.detail,
  });

  final Widget Function(BuildContext context, bool split) listBuilder;

  /// Shown beside the list; null shows the "nothing selected" state.
  final Widget? detail;

  static double listWidth(double available) =>
      (available * .5).clamp(340.0, 640.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (!diarySupportsSplit(constraints.biggest)) {
        return listBuilder(context, false);
      }
      final cs = Theme.of(context).colorScheme;
      return Row(key: const ValueKey('list-detail-split'), children: [
        SizedBox(
            width: listWidth(constraints.maxWidth),
            child: listBuilder(context, true)),
        Expanded(
          child: ColoredBox(
            color: detail == null ? cs.surface : cs.surfaceContainerLowest,
            child: detail ??
                Center(
                  child: Text(AppLocalizations.of(context)!.noEntrySelected,
                      key: const ValueKey('detail-empty'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: cs.outline)),
                ),
          ),
        ),
      ]);
    });
  }
}

/// Icon, headline and hint for a page with nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key, required this.icon, required this.title, this.hint});
  final IconData icon;
  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 56, color: cs.outline),
        const SizedBox(height: 16),
        Text(title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
                color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(hint!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.outline)),
        ],
      ]),
    );
  }
}

/// Small spaced capitals that title a section, like "STORIES".
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Row(children: [
        Expanded(
          child: Text(text.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.6, color: theme.colorScheme.onSurface)),
        ),
        if (trailing != null) trailing!,
      ]),
    );
  }
}
