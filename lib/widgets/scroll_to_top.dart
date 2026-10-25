// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// A quiet shortcut for long journal browsing; inner/detail scrolling is
/// ignored. It floats centred just below the pinned search card ([top]),
/// over the entries rather than inside the card.
class ScrollToTop extends StatefulWidget {
  const ScrollToTop({super.key, required this.top, required this.child});

  /// Where the pinned header ends.
  final double top;
  final Widget child;

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

  /// Glides back to the top, quickly but visibly, rather than jumping.
  void _toTop() => _position?.animateTo(0,
      duration: Duration(milliseconds: AppConfig.instance.backToTopScrollMs),
      curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    return Stack(children: [
      NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: widget.child,
      ),
      Positioned(
        top: widget.top,
        left: 0,
        right: 0,
        child: Center(
          // Drops in from above so it catches the eye, and goes back up.
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: config.backToTopSlideMs),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween(begin: const Offset(0, -1.5), end: Offset.zero)
                  .animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: _visible
                ? IconButton.filledTonal(
                    key: const ValueKey('journal-scroll-to-top'),
                    tooltip: AppLocalizations.of(context)!.scrollToTop,
                    onPressed: _toTop,
                    icon: const Icon(Icons.arrow_upward_rounded),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ]);
  }
}
