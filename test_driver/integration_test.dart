// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Host side of integration_test/ runs. Records the app's timeline for the
// whole run (the app cannot reach its own VM service on Android), and saves
// it and what the test reported to build/, whether or not the test passed.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/common.dart';

Future<void> main() async {
  final driver = await FlutterDriver.connect();
  await driver.startTracing(streams: const [
    TimelineStream.dart,
    TimelineStream.embedder,
    TimelineStream.gc,
  ]);
  final response = Response.fromJson(
      await driver.requestData(null, timeout: const Duration(minutes: 10)));
  final timeline = await driver.stopTracingAndDownloadTimeline();
  await driver.close();

  await Directory('build').create();
  await File('build/frame_rate_timeline.json')
      .writeAsString(jsonEncode(timeline.json));
  for (final MapEntry(key: name, value: value)
      in (response.data ?? const {}).entries) {
    await File('build/$name.json')
        .writeAsString(const JsonEncoder.withIndent('  ').convert(value));
  }
  if (!response.allTestsPassed) {
    stderr.writeln(response.formattedFailureDetails);
  }
  exit(response.allTestsPassed ? 0 : 1);
}
