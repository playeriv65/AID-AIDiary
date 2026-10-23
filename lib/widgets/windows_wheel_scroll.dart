// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;

import 'package:aid_diary/config/app_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/scheduler.dart' show Ticker, TickerProvider;
import 'package:material_ui/material_ui.dart';

/// One independent Windows list/pane. Other platforms retain their controller.
class WindowsWheelScrollScope extends StatefulWidget {
  const WindowsWheelScrollScope(
      {super.key, required this.child, this.controller});

  final Widget child;
  final WheelScrollController? controller;

  @override
  State<WindowsWheelScrollScope> createState() =>
      _WindowsWheelScrollScopeState();
}

class _WindowsWheelScrollScopeState extends State<WindowsWheelScrollScope> {
  late final _owned = WheelScrollController();

  @override
  void dispose() {
    _owned.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.windows) {
      return widget.child;
    }
    final controller = widget.controller ?? _owned;
    controller.wheelDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppConfig.instance.wheelScrollDuration;
    return Listener(
      // The scrollable resolves its pointer signal after hit-test listeners.
      // Record the input kind without replacing its nested/axis routing.
      onPointerSignal: (event) => controller.mouseWheel =
          event is PointerScrollEvent && event.kind == PointerDeviceKind.mouse,
      child: PrimaryScrollController(
        controller: controller,
        automaticallyInheritForPlatforms: const {TargetPlatform.windows},
        child: widget.child,
      ),
    );
  }
}

/// Smooth only mouse-wheel signals. Drags, keys and programmatic moves use
/// Flutter's normal ScrollPosition lifecycle and interrupt a pending wheel.
class WheelScrollController extends ScrollController {
  bool mouseWheel = false;
  Duration wheelDuration = Duration.zero;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
          ScrollContext context, ScrollPosition? oldPosition) =>
      _WheelScrollPosition(
          controller: this,
          physics: physics,
          context: context,
          oldPosition: oldPosition,
          initialPixels: initialScrollOffset,
          keepScrollOffset: keepScrollOffset);
}

class _WheelScrollPosition extends ScrollPositionWithSingleContext {
  _WheelScrollPosition(
      {required this.controller,
      required super.physics,
      required super.context,
      super.oldPosition,
      super.initialPixels,
      super.keepScrollOffset});

  final WheelScrollController controller;

  @override
  void pointerScroll(double delta) {
    if (!controller.mouseWheel ||
        controller.wheelDuration == Duration.zero ||
        delta == 0) {
      super.pointerScroll(delta);
      return;
    }
    final current = activity;
    // Preserve every notch during a burst. A reversal starts at the visible
    // position so it responds immediately, rather than unwinding old input.
    final base = current is _WheelActivity &&
            (current.target - pixels).sign == delta.sign
        ? current.target
        : pixels;
    final target = (base + delta).clamp(minScrollExtent, maxScrollExtent);
    if (target == pixels) return;
    if (current is _WheelActivity) {
      current.retarget(target, controller.wheelDuration);
    } else {
      beginActivity(_WheelActivity(this,
          target: target,
          duration: controller.wheelDuration,
          vsync: context.vsync));
    }
    updateUserScrollDirection(
        delta > 0 ? ScrollDirection.reverse : ScrollDirection.forward);
  }
}

class _WheelActivity extends ScrollActivity {
  _WheelActivity(super.delegate,
      {required this.target,
      required Duration duration,
      required TickerProvider vsync})
      : _duration = duration {
    _ticker = vsync.createTicker(_tick)..start();
  }

  double target;
  Duration _duration;
  Duration _previous = Duration.zero;
  late final Ticker _ticker;
  double _velocity = 0;

  void retarget(double value, Duration duration) {
    target = value;
    _duration = duration;
  }

  void _tick(Duration elapsed) {
    final dt = elapsed - _previous;
    _previous = elapsed;
    if (dt == Duration.zero) return;
    final position = delegate as ScrollPosition;
    target = target.clamp(position.minScrollExtent, position.maxScrollExtent);
    final remaining = target - position.pixels;
    // Exponential decay is independent of refresh rate. Keep the same ticker
    // across notches: restarting a driven animation inserts a zero-motion
    // frame at every new notch, even when engine frame times are excellent.
    final next =
        remaining.abs() <= position.physics.toleranceFor(position).distance
            ? target
            : position.pixels +
                remaining *
                    (1 -
                        math.exp(
                            -5 * dt.inMicroseconds / _duration.inMicroseconds));
    _velocity = (next - position.pixels) *
        Duration.microsecondsPerSecond /
        dt.inMicroseconds;
    if (delegate.setPixels(next) != 0) {
      delegate.goIdle();
    } else if (next == target) {
      delegate.goBallistic(0);
    }
  }

  @override
  void resetActivity() => delegate.goBallistic(0);

  @override
  bool get isScrolling => true;

  @override
  double get velocity => _velocity;

  // A short wheel tail must not eat taps on diary rows.
  @override
  bool get shouldIgnorePointer => false;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// Give each ordinary Windows route its own primary list controller.
class WindowsWheelPageTransitionsBuilder extends ZoomPageTransitionsBuilder {
  const WindowsWheelPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
          PageRoute<T> route,
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      super.buildTransitions(route, context, animation, secondaryAnimation,
          WindowsWheelScrollScope(child: child));
}
