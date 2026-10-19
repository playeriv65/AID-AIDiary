// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:flutter/services.dart';

/// Network endpoints and map settings from `assets/config/app_config.json`.
class AppConfig {
  AppConfig._(this._json);

  static const assetPath = 'assets/config/app_config.json';

  static AppConfig? _instance;
  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('AppConfig.load() must run before use');
    }
    return config;
  }

  static Future<AppConfig> load({AssetBundle? bundle}) async {
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    return _instance = AppConfig._(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Replaces the loaded config, for tests.
  static void setForTesting(Map<String, dynamic> json) =>
      _instance = AppConfig._(json);

  final Map<String, dynamic> _json;

  Map<String, dynamic> _section(String name) =>
      _json[name] as Map<String, dynamic>;

  String get tileUrlTemplate => _section('map')['tileUrlTemplate'] as String;
  String get mapAttribution => _section('map')['attribution'] as String;
  String get mapAttributionUrl => _section('map')['attributionUrl'] as String;
  String get userAgentPackageName =>
      _section('map')['userAgentPackageName'] as String;
  double get mapDefaultZoom =>
      (_section('map')['defaultZoom'] as num).toDouble();
  double get mapEntryZoom => (_section('map')['entryZoom'] as num).toDouble();
  double get mapMaxZoom => (_section('map')['maxZoom'] as num).toDouble();

  Uri get reverseGeocodeUrl =>
      Uri.parse(_section('geocoding')['reverseUrl'] as String);
  String get geocodeUserAgent => _section('geocoding')['userAgent'] as String;
  Duration get geocodeTimeout =>
      Duration(seconds: _section('geocoding')['timeoutSeconds'] as int);

  Duration get locationTimeout =>
      Duration(seconds: _section('location')['timeoutSeconds'] as int);

  Duration get activityTimeout =>
      Duration(seconds: _section('activity')['timeoutSeconds'] as int);

  Uri get weatherForecastUrl =>
      Uri.parse(_section('weather')['forecastUrl'] as String);
  Uri get weatherArchiveUrl =>
      Uri.parse(_section('weather')['archiveUrl'] as String);

  /// Dates within this many days use the forecast endpoint; older ones the
  /// archive, which lags a few days behind.
  int get weatherRecentDays => _section('weather')['recentDays'] as int;
  Duration get weatherTimeout =>
      Duration(seconds: _section('weather')['timeoutSeconds'] as int);
  String get weatherAttribution => _section('weather')['attribution'] as String;
  String get weatherAttributionUrl =>
      _section('weather')['attributionUrl'] as String;
}
