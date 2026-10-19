// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/models/entry.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

/// Hourly weather from Open-Meteo for a place and time; past dates use the
/// historical archive. Only coordinates and a date leave the device.
class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static final _logger = Logger('WeatherService');
  final http.Client _client;

  /// Weather nearest the hour of [time], or null when unavailable.
  Future<EntryWeather?> at(
      double latitude, double longitude, DateTime time) async {
    final config = AppConfig.instance;
    final day = DateFormat('yyyy-MM-dd').format(time);
    final recent =
        DateTime.now().difference(time).inDays <= config.weatherRecentDays;
    final uri = (recent ? config.weatherForecastUrl : config.weatherArchiveUrl)
        .replace(queryParameters: {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'hourly': 'temperature_2m,weather_code',
      'start_date': day,
      'end_date': day,
      'timezone': 'auto',
    });
    try {
      final response = await _client.get(uri).timeout(config.weatherTimeout);
      if (response.statusCode != 200) {
        _logger.info('Weather request failed: ${response.statusCode}');
        return null;
      }
      return parseHourly(
          jsonDecode(response.body) as Map<String, dynamic>, time.hour);
    } catch (error, stackTrace) {
      _logger.info('Weather request failed', error, stackTrace);
      return null;
    }
  }

  /// Picks the reading for [hour] from an Open-Meteo hourly response.
  static EntryWeather? parseHourly(Map<String, dynamic> body, int hour) {
    final hourly = body['hourly'] as Map?;
    final codes = hourly?['weather_code'] as List?;
    final temperatures = hourly?['temperature_2m'] as List?;
    if (codes == null || temperatures == null || codes.isEmpty) return null;
    final index = hour.clamp(0, codes.length - 1);
    final code = codes[index] as num?;
    final temperature = temperatures[index] as num?;
    if (code == null || temperature == null) return null;
    return EntryWeather(
        code: code.toInt(), temperature: temperature.toDouble());
  }
}
