// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Frame rate with a large diary, in profile mode (compiled the way release
// builds are), on Windows in the hidden background window or on a phone or
// tablet:
//
//   ./scripts/dev.ps1 frame-rate -Device windows
//   ./scripts/dev.ps1 frame-rate -Device <adb serial>
//
// Each scenario must keep the refresh rate the user allows: at 120 Hz a
// frame has 8.3 ms to build and 8.3 ms to rasterize. A first pass marks the
// journal scroll on the timeline with every build, layout and paint, to see
// what a slow frame did; the measured passes run without that. The host
// saves the numbers to build/frame_rate.json and the timeline to
// build/frame_rate_timeline.json, whether or not the test passes.

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/main.dart' as app;
import 'package:aid_diary/pages/media_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const _entries = 4000;

/// Share of frames allowed over budget per scenario: the first frame of a
/// new screen may build its layout once.
const _allowedMissed = 0.01;

/// A gap between frames longer than this is the screen at rest, not a
/// skipped refresh.
const _stillMs = 100;

/// App folders in a scratch directory, so a run on Windows leaves the
/// diary there alone. (On Android the dev flavor is an app of its own.)
class _ScratchFolders extends PathProviderPlatform {
  _ScratchFolders(this.root);

  final String root;

  @override
  Future<String?> getApplicationSupportPath() async => root;
  @override
  Future<String?> getApplicationDocumentsPath() async => root;
  @override
  Future<String?> getApplicationCachePath() async => root;
  @override
  Future<String?> getTemporaryPath() async => root;
}

/// Runs [action] with every widget build, layout and paint on the
/// timeline, between two
/// markers the host's timeline summary looks for. The host records the
/// timeline (test_driver/integration_test.dart): from inside the app the VM
/// service cannot be reached on Android.
Future<void> _traced(Future<void> Function() action) async {
  developer.Timeline.instantSync('frame_rate trace start');
  debugProfileBuildsEnabled = true;
  debugProfileLayoutsEnabled = true;
  debugProfilePaintsEnabled = true;
  try {
    await action();
  } finally {
    debugProfileBuildsEnabled = false;
    debugProfileLayoutsEnabled = false;
    debugProfilePaintsEnabled = false;
    developer.Timeline.instantSync('frame_rate trace end');
  }
}

/// The highest rate the user allows, which `dev.ps1` reads from the
/// device's peak refresh rate setting; 0 when not given.
const _allowedHz = int.fromEnvironment('AID_TARGET_HZ');

/// The rate to keep: the user's setting, else the display's fastest mode.
/// Not the current rate: a system that holds the app at a slower mode
/// fails the test.
Future<double> _targetRefresh() async {
  if (_allowedHz > 0) return _allowedHz.toDouble();
  final current = PlatformDispatcher.instance.displays.first.refreshRate;
  if (!Platform.isAndroid) return current;
  final modes = await FlutterDisplayMode.supported;
  return modes.fold<double>(
      current, (fastest, mode) => max(fastest, mode.refreshRate));
}

class _FrameMeter {
  _FrameMeter(this.targetHz);

  final double targetHz;
  final List<FrameTiming> _timings = [];

  void _add(List<FrameTiming> timings) => _timings.addAll(timings);

  void start() {
    _timings.clear();
    SchedulerBinding.instance.addTimingsCallback(_add);
  }

  /// Stops and summarizes what was drawn since [start].
  Future<Map<String, Object>> stop() async {
    // Timings arrive in batches; let the last one come.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance.removeTimingsCallback(_add);
    final refresh = PlatformDispatcher.instance.displays.first.refreshRate;
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
    // Frames per second while something moved: a gap of a few refreshes
    // between frames is a skipped refresh the eye sees as judder; a longer
    // one is the screen standing still.
    var moving = 0.0;
    var shown = 0;
    var skipped = 0;
    for (var i = 1; i < _timings.length; i++) {
      final gap = (_timings[i].timestampInMicroseconds(FramePhase.vsyncStart) -
              _timings[i - 1].timestampInMicroseconds(FramePhase.vsyncStart)) /
          1000;
      if (gap > _stillMs) continue;
      moving += gap;
      shown++;
      skipped += (gap / budget).round() - 1;
    }
    String round(double value) => value.toStringAsFixed(2);
    return {
      'frames': _timings.length,
      'fps': round(moving == 0 ? 0 : shown / moving * 1000),
      'skippedRefreshes': skipped,
      'skippedShare': shown == 0 ? 0 : skipped / (shown + skipped),
      'targetHz': targetHz.round(),
      'refreshHz': refresh.round(),
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
      'missedShare': _timings.isEmpty ? 0 : missed / _timings.length,
    };
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('a large diary scrolls and switches at the display refresh rate',
      (tester) async {
    final results = <String, Object>{};
    late final _FrameMeter meter;

    Future<void> wait(int milliseconds) =>
        tester.pump(Duration(milliseconds: milliseconds));

    Future<void> until(bool Function() done) async {
      for (var i = 0; i < 300 && !done(); i++) {
        await wait(100);
      }
    }

    Future<void> measure(String name, Future<void> Function() scenario) async {
      await wait(500);
      meter.start();
      await scenario();
      results[name] = await meter.stop();
      // Reported as it goes, so a later failure keeps what was measured.
      binding.reportData = {'frame_rate': results};
    }

    Future<void> goTo(int index) async {
      final bar = find.byKey(const ValueKey('diary-bottom-navigation'));
      await tester.tap(bar.evaluate().isNotEmpty
          ? find
              .descendant(of: bar, matching: find.byType(NavigationDestination))
              .at(index)
          : find.byKey(ValueKey('diary-destination-$index')));
      await wait(700);
    }

    Future<void> fling(Finder list, int times) async {
      for (var i = 0; i < times; i++) {
        await tester.fling(list, const Offset(0, -1600), 5000,
            warnIfMissed: false);
        await wait(900);
      }
      for (var i = 0; i < times; i++) {
        await tester.fling(list, const Offset(0, 1600), 5000,
            warnIfMissed: false);
        await wait(900);
      }
    }

    if (Platform.isWindows) {
      PathProviderPlatform.instance = _ScratchFolders(
          (await Directory.systemTemp.createTemp('aid_frame_rate')).path);
    }
    app.main();
    final skip = find.byKey(const ValueKey('onboard-skip'));
    final journal = find.byKey(const PageStorageKey('journal-list'));
    await until(
        () => skip.evaluate().isNotEmpty || journal.evaluate().isNotEmpty);
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await until(() => journal.evaluate().isNotEmpty);
    }
    await EntryStore.instance.complete;
    final missing = _entries - EntryStore.instance.entries.length;
    if (missing > 0) {
      // Test data is a development action; builds without the dev flavor,
      // such as on Windows, get it here too.
      await AppActions(devBuild: true).run('entry.seed', {'count': missing});
    }
    await wait(2000);
    meter = _FrameMeter(await _targetRefresh());

    await _traced(() => fling(journal.first, 2));
    await measure('journal_scroll', () => fling(journal.first, 5));
    await measure('tab_switch', () async {
      for (final tab in [1, 2, 3, 4, 0, 1, 2, 0]) {
        await goTo(tab);
      }
    });
    await goTo(2);
    await measure(
        'media_scroll',
        () => fling(
            find
                .descendant(
                    of: find.byType(MediaPage),
                    matching: find.byType(Scrollable))
                .first,
            4));
    await goTo(0);
    final rows = find.byWidgetPredicate((widget) =>
        widget.key is ValueKey<String> &&
        (widget.key! as ValueKey<String>).value.startsWith('journal-entry-'));
    await measure('open_entry', () async {
      for (var i = 0; i < 3; i++) {
        await tester.tap(rows.at(i));
        await wait(900);
        // On a phone the entry opens on its own page; on a wide window it
        // shows beside the list, and the next tap opens another.
        if (find.byType(BackButton).evaluate().isNotEmpty) {
          await tester.pageBack();
          await wait(900);
        }
      }
    });

    final slow = {
      for (final MapEntry(key: name, value: result) in results.entries)
        if ((result as Map<String, Object>)['missedShare'] as num >
                _allowedMissed ||
            result['skippedShare'] as num > _allowedMissed)
          name: result,
    };
    for (final MapEntry(key: name, value: result) in results.entries) {
      debugPrint('frame_rate $name: $result');
    }
    expect(slow, isEmpty, reason: 'Scenarios that missed frames');
    // Semantics as the device has them: on only while an accessibility
    // service runs, which Flutter follows.
  }, semanticsEnabled: false);
}
