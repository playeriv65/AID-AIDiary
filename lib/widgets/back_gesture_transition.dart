// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Android page transitions with a back gesture that follows the finger.
///
/// While the user swipes, the page shrinks and leans toward the far edge;
/// once let go it keeps that size and slides away as it fades. Flutter's
/// predictive back transition instead springs the page back to full size
/// and drops its opacity within a few frames, so it seems to vanish. Other
/// pushes and pops keep the platform's own transition.
class DiaryPageTransitionsBuilder extends PageTransitionsBuilder {
  const DiaryPageTransitionsBuilder();

  static const _fallback = FadeForwardsPageTransitionsBuilder();

  @override
  Duration get transitionDuration => _fallback.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _fallback.reverseTransitionDuration;

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return _BackGestureDetector(
      route: route,
      builder: (context, gesture) => gesture == null
          ? _fallback.buildTransitions(
              route, context, animation, secondaryAnimation, child)
          : _BackGestureTransition(
              animation: animation, gesture: gesture, child: child),
    );
  }
}

/// A back gesture on one route: where it started and how far it got.
class _Gesture {
  _Gesture(this.edge);

  final SwipeEdge edge;

  /// How far the finger had pulled, 0 to 1, when it let go; null while it
  /// is still down.
  double? releasedAt;
}

/// Routes the platform's back gesture to [route], as Flutter's predictive
/// back builder does, and tells [builder] whether one is under way.
class _BackGestureDetector extends StatefulWidget {
  const _BackGestureDetector({required this.route, required this.builder});

  final PageRoute<dynamic> route;
  final Widget Function(BuildContext context, _Gesture? gesture) builder;

  @override
  State<_BackGestureDetector> createState() => _BackGestureDetectorState();
}

class _BackGestureDetectorState extends State<_BackGestureDetector>
    with WidgetsBindingObserver {
  _Gesture? _gesture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    final route = widget.route;
    if (backEvent.isButtonEvent ||
        !route.isCurrent ||
        !route.popGestureEnabled) {
      return false;
    }
    route.handleStartBackGesture(progress: 1 - backEvent.progress);
    setState(() => _gesture = _Gesture(backEvent.swipeEdge));
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    widget.route
        .handleUpdateBackGestureProgress(progress: 1 - backEvent.progress);
  }

  @override
  void handleCancelBackGesture() {
    widget.route.handleCancelBackGesture();
  }

  @override
  void handleCommitBackGesture() {
    _gesture?.releasedAt = 1 - widget.route.animation!.value;
    widget.route.handleCommitBackGesture();
  }

  @override
  Widget build(BuildContext context) {
    // The route keeps its gesture flag until the closing animation ends.
    if (!widget.route.popGestureInProgress) _gesture = null;
    return widget.builder(context, _gesture);
  }
}

class _BackGestureTransition extends StatelessWidget {
  const _BackGestureTransition(
      {required this.animation, required this.gesture, required this.child});

  final Animation<double> animation;
  final _Gesture gesture;
  final Widget child;

  /// How much the page shrinks at a full pull.
  static const double _shrink = 0.1;

  /// How far it slides away after release, as a share of its width.
  static const double _slideAway = 0.3;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final direction = gesture.edge == SwipeEdge.left ? 1.0 : -1.0;
    final lean = width / 20 - 8;
    final corners = MediaQuery.displayCornerRadiiOf(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final released = gesture.releasedAt;
        // After release the route runs from fully shown to gone again.
        final pull = released ?? 1 - animation.value;
        final leaving = released == null ? 0.0 : 1 - animation.value;
        final radius = 28 * pull;
        return Opacity(
          opacity: 1 - Curves.easeInOut.transform(leaving),
          child: Transform.translate(
            offset: Offset(
                direction *
                    (lean * pull +
                        width *
                            _slideAway *
                            Curves.easeOutCubic.transform(leaving)),
                0),
            child: Transform.scale(
              scale: 1 - _shrink * pull,
              child: ClipRRect(
                borderRadius: corners ?? BorderRadius.circular(radius),
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
