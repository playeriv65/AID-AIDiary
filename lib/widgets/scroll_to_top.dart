// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// A quiet shortcut for long journal browsing; inner/detail scrolling is ignored.
class ScrollToTop extends StatefulWidget {
  const ScrollToTop({super.key, required this.child});
  final Widget child;

  /// Reuses the search bar's free center so the shortcut covers no diary text.
  static Widget button(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ScrollToTopScope>();
    if (scope == null || !scope.visible) return const SizedBox.shrink();
    return IconButton.filledTonal(
      key: const ValueKey('journal-scroll-to-top'),
      tooltip: AppLocalizations.of(context)!.scrollToTop,
      onPressed: scope.onPressed,
      icon: const Icon(Icons.arrow_upward_rounded),
    );
  }

  @override
  State<ScrollToTop> createState() => _ScrollToTopState();
}

class _ScrollToTopState extends State<ScrollToTop> {
  ScrollPosition? _position;
  bool _visible = false;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }
    _position = Scrollable.maybeOf(notification.context!)?.position;
    final visible = notification.metrics.pixels >
        notification.metrics.viewportDimension *
            AppConfig.instance.backToTopScreens;
    if (_visible != visible) setState(() => _visible = visible);
    return false;
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: _ScrollToTopScope(
          visible: _visible,
          onPressed: () => _position?.jumpTo(0),
          child: widget.child,
        ),
      );
}

class _ScrollToTopScope extends InheritedWidget {
  const _ScrollToTopScope(
      {required this.visible, required this.onPressed, required super.child});
  final bool visible;
  final VoidCallback onPressed;

  @override
  bool updateShouldNotify(_ScrollToTopScope oldWidget) =>
      visible != oldWidget.visible;
}
