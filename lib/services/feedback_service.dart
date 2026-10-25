// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Sends what someone writes on the feedback page to the AID Diary server,
/// with the app's version, platform and language and nothing else.
class FeedbackService {
  FeedbackService({http.Client? client}) : _client = client ?? http.Client();

  static final _logger = Logger('FeedbackService');
  final http.Client _client;

  /// Whether the server took [text].
  Future<bool> send(String text, {required String locale}) async {
    final config = AppConfig.instance;
    final app = DeviceInfoService().appInfo;
    try {
      final response = await _client
          .post(config.feedbackSubmitUrl,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'text': text,
                if (app != null) 'version': '${app.version}+${app.buildNumber}',
                'platform': Platform.operatingSystem,
                'locale': locale,
              }))
          .timeout(config.feedbackTimeout);
      if (response.statusCode ~/ 100 == 2) return true;
      _logger.info('Feedback refused: ${response.statusCode}');
    } catch (error, stackTrace) {
      _logger.info('Feedback not sent', error, stackTrace);
    }
    return false;
  }
}
