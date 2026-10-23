// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';
import 'dart:ui';

import 'package:aid_diary/actions/app_action.dart';
import 'package:flutter/scheduler.dart';

/// The frames the engine reports between [start] and [stop]: how long each
/// took to build and to rasterize, and when its vsync came.
class FrameMeter {
  final List<FrameTiming> _timings = [];
  bool _running = false;

  void _add(List<FrameTiming> timings) => _timings.addAll(timings);

  void start() {
    _timings.clear();
    if (!_running) SchedulerBinding.instance.addTimingsCallback(_add);
    _running = true;
  }

  /// Stops and summarizes against [targetHz]; a gap between frames longer
  /// than [stillMs] is the screen at rest, not skipped refreshes.
  Future<Map<String, Object>> stop(
      {required double targetHz, required int stillMs}) async {
    if (!_running) {
      throw const ActionException('not_started', 'Run perf.start first');
    }
    // Timings arrive in batches; let the last one come.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance.removeTimingsCallback(_add);
    _running = false;
    final budget = 1000 / targetHz;
    double ms(Duration duration) => duration.inMicroseconds / 1000;
    final build = [for (final t in _timings) ms(t.buildDuration)]..sort();
    final raster = [for (final t in _timings) ms(t.rasterDuration)]..sort();
    double percentile(List<double> sorted, double p) =>
        sorted.isEmpty ? 0 : sorted[((sorted.length - 1) * p).round()];
    final missed = _timings
        .where((t) =>
            ms(t.buildDuration) > budget || ms(t.rasterDuration) > budget)
        .length;
    // A gap of a few refreshes between frames is a skipped refresh the eye
    // sees as judder.
    var moving = 0.0;
    var shown = 0;
    var skipped = 0;
    for (var i = 1; i < _timings.length; i++) {
      final gap = (_timings[i].timestampInMicroseconds(FramePhase.vsyncStart) -
              _timings[i - 1].timestampInMicroseconds(FramePhase.vsyncStart)) /
          1000;
      if (gap > stillMs) continue;
      moving += gap;
      shown++;
      skipped += max(0, (gap / budget).round() - 1);
    }
    double round(double value) => (value * 100).round() / 100;
    double share(int part, int whole) =>
        whole == 0 ? 0 : (part / whole * 10000).round() / 10000;
    return {
      'frames': _timings.length,
      'fps': round(moving == 0 ? 0 : shown / moving * 1000),
      'skippedRefreshes': skipped,
      'skippedShare': share(skipped, shown + skipped),
      'targetHz': targetHz.round(),
      'refreshHz': (PlatformDispatcher.instance.implicitView?.display ??
              PlatformDispatcher.instance.displays.first)
          .refreshRate
          .round(),
      'budgetMs': round(budget),
      'buildP50Ms': round(percentile(build, .5)),
      'buildP90Ms': round(percentile(build, .9)),
      'buildP99Ms': round(percentile(build, .99)),
      'buildWorstMs': round(build.lastOrNull ?? 0),
      'rasterP50Ms': round(percentile(raster, .5)),
      'rasterP90Ms': round(percentile(raster, .9)),
      'rasterP99Ms': round(percentile(raster, .99)),
      'rasterWorstMs': round(raster.lastOrNull ?? 0),
      'missed': missed,
      'missedShare': share(missed, _timings.length),
    };
  }
}

final _meter = FrameMeter();

final List<AppAction> perfActions = [
  AppAction(
    id: 'perf.start',
    describe: 'Starts counting the frames the app draws and how long each '
        'takes, for perf.stop to report. Meaningful in profile and release '
        'builds.',
    risk: ActionRisk.read,
    run: (context, args) async {
      _meter.start();
      final view = PlatformDispatcher.instance.implicitView;
      return {
        'started': true,
        if (view != null) ...{
          'viewWidth': view.physicalSize.width / view.devicePixelRatio,
          'viewHeight': view.physicalSize.height / view.devicePixelRatio,
          'refreshHz': view.display.refreshRate,
        },
      };
    },
  ),
  AppAction(
    id: 'perf.stop',
    describe: 'Stops counting frames and reports them: build and raster '
        'times (median, 90th and 99th percentile, worst), frames over the '
        'budget of the target rate, and refreshes skipped while something '
        'moved.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('hz', ParamType.number,
          "The refresh rate to keep; the display's current one by default",
          required: false),
      ActionParam(
          'still_ms',
          ParamType.integer,
          'A gap between frames longer than this is the screen at rest; '
              '100 by default',
          required: false),
    ],
    run: (context, args) => _meter.stop(
        targetHz: args['hz'] as double? ??
            (PlatformDispatcher.instance.implicitView?.display ??
                    PlatformDispatcher.instance.displays.first)
                .refreshRate,
        stillMs: args['still_ms'] as int? ?? 100),
  ),
];
