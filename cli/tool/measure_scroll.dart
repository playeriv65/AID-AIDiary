// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_cli/aid_cli.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1 || Platform.environment['AID_API_INFO'] == null) {
    throw ArgumentError(
      'Set AID_API_INFO to an isolated dev app and pass a report directory.',
    );
  }
  final data = Platform.environment['AID_DATA_DIR'];
  final info = File(Platform.environment['AID_API_INFO']!);
  if (data == null ||
      info.parent.absolute.path != Directory(data).absolute.path) {
    throw StateError(
      'AID_API_INFO must belong to the explicit AID_DATA_DIR scratch store.',
    );
  }
  final output = Directory(args.single)..createSync(recursive: true);
  final config =
      jsonDecode(File('../scripts/frame_rate.json').readAsStringSync()) as Map;
  final client = AidClient(launch: false);
  final collectCpu = Platform.environment['AID_PROFILE_CPU'] == '1';
  VmService? cpuService;
  Future<Map> run(String action, [Map<String, Object?> args = const {}]) async {
    final reply = await client.run(
      action,
      args.map((key, value) => MapEntry(key, '$value')),
    );
    if (reply['ok'] != true) throw StateError('$action: ${reply['error']}');
    return reply['result'] as Map;
  }

  try {
    final status = await run('app.status');
    if (status['devBuild'] != true || status['mode'] != 'profile') {
      throw StateError(
        'An isolated Windows profile development build is required.',
      );
    }
    if (status['entries'] == 0) {
      await run('entry.seed', {
        'count': config['entries'],
        'photos': config['photos'],
      });
    }
    final seeded = await run('app.status');
    if (seeded['entries'] != config['entries']) {
      throw StateError('Unexpected fixture size.');
    }
    final vmUri = Uri.parse(seeded['vmService'] as String);
    cpuService = await vmServiceConnectUri(
      vmUri.replace(scheme: 'ws', path: '${vmUri.path}ws').toString(),
    );
    final isolates = (await cpuService.getVM()).isolates!;
    if (collectCpu) await cpuService.setFlag('profiler', 'true');
    final mainIsolate = isolates
        .firstWhere(
          (isolate) => isolate.name == 'main',
          orElse: () => isolates.first,
        )
        .id!;
    await run('ui.navigate', {'to': 'journal'});
    await Future<void>.delayed(const Duration(seconds: 1));
    final viewport = await run('perf.start');
    await run('perf.stop');
    final width = (viewport['viewWidth'] as num).toDouble();
    final results = <String, Object?>{
      'complete': false,
      'cpuProfiler': collectCpu,
      'startedAt': DateTime.now().toUtc().toIso8601String(),
      'fixture': {...seeded}..remove('vmService'),
      'viewport': viewport,
    };
    void writeReport() => File(
      '${output.path}/summary.json',
    ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));
    writeReport();
    Future<void> measure(String name, Map<String, Object?> gesture) async {
      await client.traceStart(widgets: false);
      if (collectCpu) await cpuService!.clearCpuSamples(mainIsolate);
      final origin = collectCpu
          ? (await cpuService!.getVMTimelineMicros()).timestamp!
          : 0;
      await run('perf.start');
      final timer = Stopwatch()..start();
      final motion = await run('ui.fling', gesture);
      final report = await run('perf.stop', {'still_ms': 60000});
      report['motion'] = motion;
      report['wallMs'] = timer.elapsedMilliseconds;
      report['withinLimits'] =
          (report['missedShare'] as num) <=
              (config['allowedMissedShare'] as num) &&
          (report['skippedShare'] as num) <=
              (config['allowedSkippedShare'] as num);
      results[name] = report;
      writeReport();
      if ((report['frames'] as int) < 10) {
        throw StateError('$name did not produce enough frames.');
      }
      await client.traceStop('${output.path}/$name.json');
      if (collectCpu) {
        final end = (await cpuService!.getVMTimelineMicros()).timestamp!;
        final samples = await cpuService!.getCpuSamples(
          mainIsolate,
          origin,
          end - origin,
        );
        // AOT returns a table of all compiled functions, including unused ones.
        // Preserve sampled stacks without writing that large unrelated table.
        final used = {
          for (final sample in samples.samples!) ...?sample.stack,
        }.toList()..sort();
        final remap = {for (var i = 0; i < used.length; i++) used[i]: i};
        File('${output.path}/$name-cpu.json').writeAsStringSync(
          jsonEncode({
            'samplePeriod': samples.samplePeriod,
            'sampleCount': samples.sampleCount,
            'timeOriginMicros': samples.timeOriginMicros,
            'timeExtentMicros': samples.timeExtentMicros,
            'functions': [
              for (final index in used) samples.functions![index].toJson(),
            ],
            'samples': [
              for (final sample in samples.samples!)
                {
                  ...sample.toJson(),
                  'stack': [
                    for (final index in sample.stack ?? <int>[]) remap[index],
                  ],
                },
            ],
          }),
        );
      }
      if (gesture['mouse'] == true &&
          ((motion['scrollEnd'] as num? ?? 0) -
                      (motion['scrollStart'] as num? ?? 0))
                  .abs() <
              10000) {
        throw StateError('$name did not traverse the diary: $motion');
      }
      stdout.writeln('$name: ${jsonEncode(report)}');
    }

    await measure('touch_scroll', {
      'x': .25,
      'from': .8,
      'to': .2,
      'duration_ms': 600,
    });
    final scrollRect =
        ((results['touch_scroll'] as Map)['motion'] as Map)['scrollViewport']
            as Map;
    final thumbX =
        ((scrollRect['left'] as num) + (scrollRect['width'] as num) - 3) /
        width;
    results['thumbX'] = thumbX;
    await Future<void>.delayed(const Duration(seconds: 2));
    // Return near the top and reveal the thumb before its long traversal.
    await run('ui.fling', {'x': .25, 'from': .2, 'to': .8, 'duration_ms': 80});
    await Future<void>.delayed(const Duration(seconds: 2));
    // A shorter scrub (~3% of the track) and a whole-history traversal are
    // different workloads; retain both rather than declaring one universal fps.
    await measure('thumb_local_down', {
      'mouse': true,
      'x': thumbX,
      'from': .012,
      'to': .042,
      'duration_ms': 1500,
    });
    await measure('thumb_local_up', {
      'mouse': true,
      'x': thumbX,
      'from': .042,
      'to': .012,
      'duration_ms': 1500,
    });
    await measure('thumb_down', {
      'mouse': true,
      'x': thumbX,
      'from': .012,
      'to': .8,
      'duration_ms': 5000,
    });
    await measure('thumb_up', {
      'mouse': true,
      'x': thumbX,
      'from': .8,
      'to': .012,
      'duration_ms': 5000,
    });
    results['complete'] = true;
    writeReport();
  } finally {
    if (collectCpu && cpuService != null) {
      await cpuService.setFlag('profiler', 'false');
    }
    await cpuService?.dispose();
    await client.close();
  }
}
