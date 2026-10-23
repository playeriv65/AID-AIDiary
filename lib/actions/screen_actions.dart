// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:aid_diary/actions/app_action.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

ActionScreen _screen(ActionContext context) =>
    context.screen ??
    (throw const ActionException(
        'no_screen', 'No GUI is attached to show or move'));

var _nextPointer = 1 << 20;

RenderViewportBase? _verticalViewport(RenderObject node) {
  if (node is RenderViewportBase &&
      axisDirectionToAxis(node.axisDirection) == Axis.vertical) {
    return node;
  }
  RenderViewportBase? found;
  node.visitChildren((child) {
    found ??= _verticalViewport(child);
  });
  return found;
}

/// A finger put down at [from], moved in a straight line to [to] over
/// [duration] and lifted, as touch events through the gesture system: a
/// list under it scrolls and flings on as under a real finger.
Future<void> _swipe(Offset from, Offset to, Duration duration,
    {PointerDeviceKind kind = PointerDeviceKind.touch}) async {
  final binding = GestureBinding.instance;
  final view = PlatformDispatcher.instance.implicitView!;
  final pointer = _nextPointer++;
  // This is a synthetic trajectory: timestamps describe its requested duration,
  // independent of host timer jitter. Real delays still pace event delivery.
  var time = Duration.zero;
  var position = from;
  void send(PointerEvent Function(Duration time) event) =>
      binding.handlePointerEvent(event(time));
  if (kind == PointerDeviceKind.mouse) {
    send((time) => PointerAddedEvent(
        timeStamp: time,
        viewId: view.viewId,
        pointer: pointer,
        device: pointer,
        kind: kind,
        position: from));
    send((time) => PointerHoverEvent(
        timeStamp: time,
        viewId: view.viewId,
        pointer: pointer,
        device: pointer,
        kind: kind,
        position: from));
    // Let desktop hover reveal a scrollbar before pressing its thumb.
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
  }
  send((time) => PointerDownEvent(
      timeStamp: time,
      viewId: view.viewId,
      pointer: pointer,
      device: pointer,
      kind: kind,
      buttons: kPrimaryButton,
      position: from));
  void move(double fraction, Duration timestamp) {
    time = timestamp;
    final next = Offset.lerp(from, to, fraction)!;
    final delta = next - position;
    position = next;
    send((time) => PointerMoveEvent(
        timeStamp: time,
        viewId: view.viewId,
        pointer: pointer,
        device: pointer,
        kind: kind,
        buttons: kPrimaryButton,
        position: position,
        delta: delta));
  }

  if (kind == PointerDeviceKind.mouse) {
    // Mouse events coalesce at display cadence. A chain of 8 ms timers can
    // itself limit Windows input to ~100 Hz even when rendering is fast.
    final finished = Completer<void>();
    late final Ticker ticker;
    ticker = Ticker((elapsed) {
      final fraction =
          (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
      move(fraction, elapsed);
      if (fraction == 1) {
        ticker.stop();
        finished.complete();
      }
    })
      ..start();
    try {
      await finished.future;
    } finally {
      ticker.dispose();
    }
  } else {
    // Touch keeps the requested sample timestamps independent of timer jitter.
    final steps = max(2, duration.inMilliseconds ~/ 8);
    for (var step = 1; step <= steps; step++) {
      await Future<void>.delayed(duration ~/ steps);
      move(step / steps,
          Duration(microseconds: duration.inMicroseconds * step ~/ steps));
    }
  }
  send((time) => PointerUpEvent(
      timeStamp: time,
      viewId: view.viewId,
      pointer: pointer,
      device: pointer,
      kind: kind,
      position: position));
  if (kind == PointerDeviceKind.mouse) {
    send((time) => PointerRemovedEvent(
        timeStamp: time,
        viewId: view.viewId,
        pointer: pointer,
        device: pointer,
        kind: kind,
        position: position));
  }
}

double _fraction(ActionArgs args, String name, double fallback) {
  final value = args[name] as double? ?? fallback;
  if (value < 0 || value > 1) {
    throw ActionException(
        'bad_args', '$name is a share of the window from 0 to 1, not $value');
  }
  return value;
}

final List<AppAction> screenActions = [
  AppAction(
    id: 'ui.screen',
    describe: 'Says which screen the user is on, and every place ui.navigate '
        'can open with the arguments each takes.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final screen = _screen(context);
      return {
        'current': screen.current,
        'destinations': [
          for (final destination in screen.destinations) destination.toJson(),
        ],
      };
    },
  ),
  AppAction(
    id: 'ui.navigate',
    describe: 'Opens a screen or an item on it, as a tap would, so a person '
        'watching sees what an agent works on. Takes the arguments of the '
        'destination, e.g. to=entry id=12.',
    risk: ActionRisk.read,
    moreArgs: true,
    params: const [
      ActionParam('to', ParamType.string, 'A destination from ui.screen'),
    ],
    run: (context, args) async {
      final screen = _screen(context);
      final to = args['to'] as String;
      final destination = screen.destinations
              .where((destination) => destination.name == to)
              .firstOrNull ??
          (throw ActionException(
              'bad_args',
              'to must be one of ${[
                for (final d in screen.destinations) d.name
              ].join(', ')}'));
      await screen.navigate(
          to,
          parseArgs(destination.params, {...args}..remove('to'),
              'ui.navigate to=$to'));
      return {'current': screen.current};
    },
  ),
  AppAction(
    id: 'ui.back',
    describe: 'Closes the screen or dialog on top, as the back gesture does.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final screen = _screen(context);
      final closed = await screen.back();
      return {'closed': closed, 'current': screen.current};
    },
  ),
  AppAction(
    id: 'ui.wheel',
    describe: 'Sends mouse-wheel notches through the GUI pointer-signal path. '
        'Reports actual scroll positions, including the settling tail.',
    risk: ActionRisk.read,
    params: const [
      ActionParam(
          'x', ParamType.number, 'Window fraction across; 0.25 by default',
          required: false),
      ActionParam('y', ParamType.number, 'Window fraction down; 0.5 by default',
          required: false),
      ActionParam(
          'delta', ParamType.number, 'Logical pixels per notch; 60 by default',
          required: false),
      ActionParam('count', ParamType.integer,
          'Number of notches, 1 to 100; 20 by default',
          required: false),
      ActionParam('interval_ms', ParamType.integer,
          'Spacing of notches, 1 to 1000 ms; 60 by default',
          required: false),
      ActionParam('settle_ms', ParamType.integer,
          'Tail observation, 0 to 2000 ms; 300 by default',
          required: false),
    ],
    run: (context, args) async {
      _screen(context);
      final count = args['count'] as int? ?? 20;
      final interval = args['interval_ms'] as int? ?? 60;
      final settle = args['settle_ms'] as int? ?? 300;
      final delta = (args['delta'] as num? ?? 60).toDouble();
      if (count < 1 ||
          count > 100 ||
          interval < 1 ||
          interval > 1000 ||
          settle < 0 ||
          settle > 2000 ||
          !delta.isFinite ||
          delta.abs() > 10000) {
        throw const ActionException(
            'bad_args', 'Invalid wheel count, timing or distance');
      }
      final binding = GestureBinding.instance;
      final view = PlatformDispatcher.instance.implicitView!;
      final size = view.physicalSize / view.devicePixelRatio;
      final at = Offset(_fraction(args, 'x', .25) * size.width,
          _fraction(args, 'y', .5) * size.height);
      final hit = HitTestResult();
      binding.hitTestInView(hit, at, view.viewId);
      final viewport = hit.path
          .map((entry) => entry.target)
          .whereType<RenderObject>()
          .map(_verticalViewport)
          .whereType<RenderViewportBase>()
          .firstOrNull;
      if (viewport == null) {
        throw const ActionException(
            'no_scroll', 'No vertical list at the wheel position');
      }
      final start = viewport.offset.pixels;
      final samples = <double>[];
      var sampling = true;
      void sample(Duration _) {
        if (!sampling) return;
        samples.add(viewport.offset.pixels);
        // Observe frames that the app actually requests. A diagnostic ticker
        // would keep producing frames after motion stops and inflate fps.
        SchedulerBinding.instance.addPostFrameCallback(sample);
      }

      SchedulerBinding.instance.addPostFrameCallback(sample);
      try {
        for (var i = 0; i < count; i++) {
          binding.handlePointerEvent(PointerScrollEvent(
              viewId: view.viewId,
              kind: PointerDeviceKind.mouse,
              position: at,
              scrollDelta: Offset(0, delta)));
          await Future<void>.delayed(Duration(milliseconds: interval));
        }
        final beforeTail = viewport.offset.pixels;
        await Future<void>.delayed(Duration(milliseconds: settle));
        return {
          'scrollStart': start,
          'scrollBeforeTail': beforeTail,
          'scrollEnd': viewport.offset.pixels,
          'frameOffsets': samples,
          'count': count,
          'delta': delta
        };
      } finally {
        sampling = false;
      }
    },
  ),
  AppAction(
    id: 'ui.fling',
    describe:
        'Drags a finger or mouse straight up or down the window and lifts '
        'it, so the list under it scrolls on as after a real swipe; for '
        'driving the GUI where no touch screen is, such as a frame-rate run '
        'on a computer. Returns as the finger lifts.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('mouse', ParamType.boolean,
          'Use a primary-button mouse drag, e.g. on a scrollbar; false by default',
          required: false),
      ActionParam('x', ParamType.number,
          'Where across the window, from 0 (left) to 1; 0.5 by default',
          required: false),
      ActionParam(
          'from',
          ParamType.number,
          'Where down the window the finger starts, 0 (top) to 1; 0.75 by '
              'default',
          required: false),
      ActionParam('to', ParamType.number,
          'Where it lifts; 0.25 by default, which scrolls down the list',
          required: false),
      ActionParam('duration_ms', ParamType.integer,
          'How long the swipe takes; 80 by default, a quick flick',
          required: false),
    ],
    run: (context, args) async {
      _screen(context);
      final view = PlatformDispatcher.instance.implicitView!;
      final size = view.physicalSize / view.devicePixelRatio;
      final x = _fraction(args, 'x', .5) * size.width;
      final hit = HitTestResult();
      GestureBinding.instance.hitTestInView(hit,
          Offset((x - 12).clamp(0, size.width), size.height / 2), view.viewId);
      final viewport = hit.path
          .map((entry) => entry.target)
          .whereType<RenderObject>()
          .map(_verticalViewport)
          .whereType<RenderViewportBase>()
          .firstOrNull;
      final scrollStart = viewport?.offset.pixels;
      final duration = args['duration_ms'] as int? ?? 80;
      if (duration < 1 || duration > 60000) {
        throw const ActionException(
            'bad_args', 'duration_ms must be 1 to 60000');
      }
      await _swipe(
          Offset(x, _fraction(args, 'from', .75) * size.height),
          Offset(x, _fraction(args, 'to', .25) * size.height),
          Duration(milliseconds: duration),
          kind: args['mouse'] == true
              ? PointerDeviceKind.mouse
              : PointerDeviceKind.touch);
      return {
        'current': _screen(context).current,
        if (viewport != null) ...{
          'scrollStart': scrollStart,
          'scrollEnd': viewport.offset.pixels,
          'scrollViewport': {
            'left': viewport.localToGlobal(Offset.zero).dx,
            'top': viewport.localToGlobal(Offset.zero).dy,
            'width': viewport.size.width,
            'height': viewport.size.height,
          },
        },
      };
    },
  ),
];
