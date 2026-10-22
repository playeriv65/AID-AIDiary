// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';
import 'dart:ui';

import 'package:aid_diary/actions/app_action.dart';
import 'package:flutter/gestures.dart';

ActionScreen _screen(ActionContext context) =>
    context.screen ??
    (throw const ActionException(
        'no_screen', 'No GUI is attached to show or move'));

var _nextPointer = 1 << 20;

/// A finger put down at [from], moved in a straight line to [to] over
/// [duration] and lifted, as touch events through the gesture system: a
/// list under it scrolls and flings on as under a real finger.
Future<void> _swipe(Offset from, Offset to, Duration duration) async {
  final binding = GestureBinding.instance;
  final view = PlatformDispatcher.instance.implicitView!;
  final pointer = _nextPointer++;
  // This is a synthetic trajectory: timestamps describe its requested duration,
  // independent of host timer jitter. Real delays still pace event delivery.
  var time = Duration.zero;
  var position = from;
  void send(PointerEvent Function(Duration time) event) =>
      binding.handlePointerEvent(event(time));
  send((time) => PointerDownEvent(
      timeStamp: time,
      viewId: view.viewId,
      pointer: pointer,
      kind: PointerDeviceKind.touch,
      position: from));
  // A move a frame at 120 Hz, as a touch screen reports them.
  final steps = max(2, duration.inMilliseconds ~/ 8);
  for (var step = 1; step <= steps; step++) {
    await Future<void>.delayed(duration ~/ steps);
    time = Duration(microseconds: duration.inMicroseconds * step ~/ steps);
    final next = Offset.lerp(from, to, step / steps)!;
    final delta = next - position;
    position = next;
    send((time) => PointerMoveEvent(
        timeStamp: time,
        viewId: view.viewId,
        pointer: pointer,
        kind: PointerDeviceKind.touch,
        position: position,
        delta: delta));
  }
  send((time) => PointerUpEvent(
      timeStamp: time,
      viewId: view.viewId,
      pointer: pointer,
      kind: PointerDeviceKind.touch,
      position: position));
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
    id: 'ui.fling',
    describe: 'Swipes a finger straight up or down the window and lifts '
        'it, so the list under it scrolls on as after a real swipe; for '
        'driving the GUI where no touch screen is, such as a frame-rate run '
        'on a computer. Returns as the finger lifts.',
    risk: ActionRisk.read,
    params: const [
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
      await _swipe(
          Offset(x, _fraction(args, 'from', .75) * size.height),
          Offset(x, _fraction(args, 'to', .25) * size.height),
          Duration(milliseconds: args['duration_ms'] as int? ?? 80));
      return {'current': _screen(context).current};
    },
  ),
];
