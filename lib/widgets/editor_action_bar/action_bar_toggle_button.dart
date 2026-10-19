// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class ActionBarToggle extends StatefulWidget {
  final double size;

  final bool visible;
  final bool isShowingMainActions;
  final VoidCallback onPressed;

  const ActionBarToggle({
    super.key,
    required this.size,
    required this.visible,
    required this.isShowingMainActions,
    required this.onPressed,
  });

  @override
  State<ActionBarToggle> createState() => _ActionBarToggleState();
}

class _ActionBarToggleState extends State<ActionBarToggle>
    with SingleTickerProviderStateMixin {
  static const double _iconSize = 24.0;

  late final AnimationController _controller;
  late final Animation<double> _iconProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: widget.isShowingMainActions ? 1.0 : 0.0,
    );
    _iconProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant ActionBarToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShowingMainActions != oldWidget.isShowingMainActions) {
      widget.isShowingMainActions
          ? _controller.forward()
          : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final borderRadius = BorderRadius.circular(widget.size / 2);
        return Material(
          color: colorScheme.primary,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPressed,
            canRequestFocus: false,
            customBorder: RoundedRectangleBorder(borderRadius: borderRadius),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: _buildIcons(colorScheme, _iconProgress.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcons(ColorScheme colorScheme, double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: progress * math.pi / 4,
          child: Transform.scale(
            scale: 1.0 - (progress * 0.5),
            child: Icon(Icons.add_rounded,
                size: _iconSize, color: colorScheme.onPrimary),
          ),
        ),
        Transform.rotate(
          angle: -(1.0 - progress) * math.pi / 4,
          child: Transform.scale(
            scale: 0.5 + (progress * 0.5),
            child: Icon(Icons.close_rounded,
                size: _iconSize, color: colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }
}
