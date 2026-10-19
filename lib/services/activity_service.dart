// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/models/entry.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:logging/logging.dart';

/// Motion activity from Android's activity recognition. Other platforms
/// have no motion sensors, so they always return null and rely on picking.
class ActivityService {
  static final _logger = Logger('ActivityService');

  static bool get supported => Platform.isAndroid;

  Future<EntryActivity?> current() async {
    if (!supported) return null;
    final recognition = FlutterActivityRecognition.instance;
    try {
      var permission = await recognition.checkPermission();
      if (permission == ActivityPermission.DENIED) {
        permission = await recognition.requestPermission();
      }
      if (permission != ActivityPermission.GRANTED) return null;
      final activity = await recognition.activityStream
          .firstWhere((a) => a.type != ActivityType.UNKNOWN)
          .timeout(AppConfig.instance.activityTimeout);
      return fromDetected(activity.type);
    } on TimeoutException {
      return null;
    } catch (error, stackTrace) {
      _logger.info('Activity detection failed', error, stackTrace);
      return null;
    }
  }

  static EntryActivity? fromDetected(ActivityType type) => switch (type) {
        ActivityType.STILL => EntryActivity.still,
        ActivityType.WALKING => EntryActivity.walking,
        ActivityType.RUNNING => EntryActivity.running,
        ActivityType.ON_BICYCLE => EntryActivity.cycling,
        ActivityType.IN_VEHICLE => EntryActivity.vehicle,
        ActivityType.UNKNOWN => null,
      };
}
