// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/editor_action_bar/dock_metrics.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_entry.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_morph.dart';
import 'package:material_ui/material_ui.dart';

class ActionBarPill extends StatelessWidget {
  final DockMetrics metrics;
  final ToolbarEntrySplit split;
  final bool showingMainActions;
  final void Function(BuildContext buttonContext) onShowOverflow;

  const ActionBarPill({
    super.key,
    required this.metrics,
    required this.split,
    required this.showingMainActions,
    required this.onShowOverflow,
  });

  @override
  Widget build(BuildContext context) {
    // Transparent so the buttons' ink shows on the bar surface behind it.
    return Material(
      type: MaterialType.transparency,
      child: AnimatedSize(
        duration: toolbarMorphDuration,
        curve: toolbarMorphCurve,
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: EdgeInsets.all(metrics.pillPadding),
          child: MorphContent(
            child: KeyedSubtree(
              key: ValueKey(showingMainActions),
              // Content fading out after a resize may be wider than the new
              // pill; let it overflow into the pill's clip for that moment.
              child: UnconstrainedBox(
                constrainedAxis: Axis.vertical,
                clipBehavior: Clip.hardEdge,
                alignment: AlignmentDirectional.centerStart,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final entry in split.visible)
                        entry.build(context, null),
                      if (split.hasOverflow)
                        Builder(
                          builder: (buttonContext) => ToolbarIconButton(
                            size: metrics.buttonSize,
                            icon: const Icon(Icons.more_horiz_rounded),
                            tooltip: MaterialLocalizations.of(buttonContext)
                                .moreButtonTooltip,
                            onPressed: () => onShowOverflow(buttonContext),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The full-width bar behind the toolbar buttons.
class DockSurface extends StatelessWidget {
  final DockMetrics metrics;
  final double barWidth;

  const DockSurface({super.key, required this.metrics, required this.barWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: metrics.barHeight,
      child:
          ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHigh),
    );
  }
}

class ToolbarIconButton extends StatelessWidget {
  final double size;
  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const ToolbarIconButton({
    super.key,
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        tooltip: tooltip,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
