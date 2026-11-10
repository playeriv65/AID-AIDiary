// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

/// Judges the enabled Android accessibility services for the host's
/// semantics gate (android/.../SemanticsGate.kt, docs/ARCHITECTURE.md,
/// "Semantics gate"). When every one of them is on the config's list of
/// services that never need this app's content, the host keeps Flutter's
/// semantics tree off for exactly that set; any other service, known or
/// not, turns it back on before Dart hears of the change.
class SemanticsGate {
  SemanticsGate._();

  static const _channel = MethodChannel('$appNamespace/semantics');

  /// Starts judging on Android: now, and whenever the services change.
  static Future<void> start() async {
    if (!Platform.isAndroid) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'changed') {
        await _judge((call.arguments as List).cast<String>());
      }
    });
    await _judge(await _channel.invokeListMethod<String>('services') ?? []);
  }

  static Future<void> _judge(List<String> services) async {
    if (holdsOff(services,
        noContent: AppConfig.instance.noContentAccessibilityServices)) {
      await _channel.invokeMethod<bool>('hold', services);
    }
  }

  /// Whether semantics may stay off with [services] enabled: some service
  /// is on, and each is in [noContent]. Names are whole components.
  @visibleForTesting
  static bool holdsOff(List<String> services,
          {required Set<String> noContent}) =>
      services.isNotEmpty && services.every(noContent.contains);
}
