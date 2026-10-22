// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Android page transitions with a back gesture that follows the finger.
///
/// While the user swipes, the page shrinks and leans toward the far edge;
/// once let go it keeps that size and slides away as it fades. Flutter's
/// predictive back transition instead springs the page back to full size
/// and drops its opacity within a few frames, so it seems to vanish. Other
/// pushes and pops slide and fade as the platform's do
/// ([_FadeThroughPageTransition]).
class DiaryPageTransitionsBuilder extends PageTransitionsBuilder {
  const DiaryPageTransitionsBuilder();

  static const _duration = Duration(
      milliseconds: FadeForwardsPageTransitionsBuilder.kTransitionMilliseconds);

  @override
  Duration get transitionDuration => _duration;

  @override
  Duration get reverseTransitionDuration => _duration;

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
          ? _FadeThroughPageTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              opaque: route.opaque,
              child: child)
          : _BackGestureTransition(
              animation: animation, gesture: gesture, child: child),
    );
  }
}

/// Android's slide-and-fade between pages, as
/// [FadeForwardsPageTransitionsBuilder] does it, without offscreen layers.
///
/// A page fading out over the background colour looks the same as the page
/// drawn whole with that colour laid over it, growing from clear to solid;
/// [_FadeToColor] draws it so. A fade by opacity would draw each page into
/// a layer of its own and blend that, a full-screen pass per page per frame
/// that makes Impeller drop frames on large screens. Only two pages
/// fading at once need such layers, so the new page waits for the old one
/// to fade out before it fades in (Material's fade through), instead of
/// both fading together for the first quarter.
class _FadeThroughPageTransition extends StatelessWidget {
  const _FadeThroughPageTransition(
      {required this.animation,
      required this.secondaryAnimation,
      required this.opaque,
      required this.child});

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool opaque;
  final Widget child;

  static const Curve _curve = Curves.easeInOutCubicEmphasized;

  // Shares of the transition: the leaving page is gone after a quarter,
  // the arriving one shown from then until three quarters.
  static final _fadeOut = Tween<double>(begin: 1, end: 0)
      .chain(CurveTween(curve: const Interval(0, .25)));
  static final _fadeIn = Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: const Interval(.25, .75)));

  static Animatable<Offset> _slide(double from, double to) =>
      Tween(begin: Offset(from, 0), end: Offset(to, 0))
          .chain(CurveTween(curve: _curve));

  static final _enter = _slide(.25, 0);
  static final _exit = _slide(0, .25);
  static final _cover = _slide(0, -.25);
  static final _uncover = _slide(-.25, 0);

  @override
  Widget build(BuildContext context) {
    final background = ColorScheme.of(context).surface;
    Widget fade(Animation<double> opacity, Animatable<Offset> slide,
            Animation<double> by, Widget? child) =>
        // Inside the slide, so the colour moves with the page.
        SlideTransition(
          position: slide.animate(by),
          child:
              _FadeToColor(opacity: opacity, color: background, child: child),
        );

    // As a page above it comes and goes, this page leaves and comes back.
    Widget covered = DualTransitionBuilder(
      animation: ReverseAnimation(secondaryAnimation),
      forwardBuilder: (context, animation, child) =>
          fade(_fadeIn.animate(animation), _uncover, animation, child),
      reverseBuilder: (context, animation, child) =>
          fade(_fadeOut.animate(animation), _cover, animation, child),
      child: child,
    );
    // The background shows where neither page is, as either moves.
    if (opaque) {
      covered = ColoredBox(
          color:
              secondaryAnimation.isAnimating ? background : Colors.transparent,
          child: covered);
    }
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) =>
          fade(_fadeIn.animate(animation), _enter, animation, child),
      reverseBuilder: (context, animation, child) => IgnorePointer(
        ignoring: animation.status == AnimationStatus.forward,
        child: fade(_fadeOut.animate(animation), _exit, animation, child),
      ),
      child: covered,
    );
  }
}

/// [child] faded toward [color] by [opacity]: drawn, then [color] laid
/// over it at the rest of the opacity, which on an opaque page looks as a
/// fade over that colour does without a layer to blend. At no opacity the
/// child is not drawn at all.
class _FadeToColor extends SingleChildRenderObjectWidget {
  const _FadeToColor({required this.opacity, required this.color, super.child});

  final Animation<double> opacity;
  final Color color;

  @override
  _RenderFadeToColor createRenderObject(BuildContext context) =>
      _RenderFadeToColor(opacity, color);

  @override
  void updateRenderObject(
      BuildContext context, _RenderFadeToColor renderObject) {
    renderObject
      ..opacity = opacity
      ..color = color;
  }
}

class _RenderFadeToColor extends RenderProxyBox {
  _RenderFadeToColor(this._opacity, this._color);

  Animation<double> _opacity;
  set opacity(Animation<double> value) {
    if (value == _opacity) return;
    if (attached) _opacity.removeListener(markNeedsPaint);
    _opacity = value;
    if (attached) _opacity.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  Color _color;
  set color(Color value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _opacity.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _opacity.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final shown = _opacity.value;
    if (shown <= 0 || child == null) return;
    context.paintChild(child!, offset);
    if (shown < 1) {
      context.canvas.drawRect(offset & size,
          Paint()..color = _color.withValues(alpha: _color.a * (1 - shown)));
    }
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
