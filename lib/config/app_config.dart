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

  /// Markers closer than this many logical pixels merge into a cluster.
  double get mapClusterRadius =>
      (_section('map')['clusterRadius'] as num).toDouble();

  Uri get reverseGeocodeUrl =>
      Uri.parse(_section('geocoding')['reverseUrl'] as String);
  Uri get placeSearchUrl =>
      Uri.parse(_section('geocoding')['searchUrl'] as String);
  int get placeSearchLimit => _section('geocoding')['searchLimit'] as int;
  String get geocodeUserAgent => _section('geocoding')['userAgent'] as String;
  Duration get geocodeTimeout =>
      Duration(seconds: _section('geocoding')['timeoutSeconds'] as int);

  /// Overpass endpoint and bounds for named places around a position.
  Uri get nearbyUrl => Uri.parse(_section('nearby')['url'] as String);
  int get nearbyRadiusMeters => _section('nearby')['radiusMeters'] as int;
  int get nearbyLimit => _section('nearby')['limit'] as int;
  Duration get nearbyTimeout =>
      Duration(seconds: _section('nearby')['timeoutSeconds'] as int);

  Map<String, double> get fontSizes => _numbers('typography', 'fontSizes');
  Map<String, double> get lineSpacings =>
      _numbers('typography', 'lineSpacings');

  /// Font family names per choice, first preferred; empty means the theme's.
  Map<String, List<String>> get fontFamilies => {
        for (final MapEntry(:key, :value)
            in (_section('typography')['fontFamilies'] as Map).entries)
          key as String: (value as List).cast<String>(),
      };

  List<String> get videoExtensions =>
      (_section('media')['videoExtensions'] as List).cast<String>();
  List<String> get audioExtensions =>
      (_section('media')['audioExtensions'] as List).cast<String>();
  String get recordingExtension =>
      _section('media')['recordingExtension'] as String;
  Duration get maxVideoDuration =>
      Duration(minutes: _section('media')['maxVideoMinutes'] as int);

  /// Attachments are held in memory while stored and synced, so videos
  /// above this size are refused.
  int get maxVideoBytes =>
      (_section('media')['maxVideoMegabytes'] as int) * 1024 * 1024;

  /// The morning prompt shows before this hour, the evening one from the
  /// other on.
  int get morningEndsHour => _section('routine')['morningEndsHour'] as int;
  int get eveningStartsHour => _section('routine')['eveningStartsHour'] as int;

  /// Hour of the day a coach program's new prompt is announced.
  int get coachPromptHour => _section('coach')['promptHour'] as int;

  /// Entries in Recently deleted are erased after this long.
  Duration get deletedRetention =>
      Duration(days: _section('recentlyDeleted')['retentionDays'] as int);

  /// Share cards are laid out this wide and rendered at [sharePixelRatio].
  double get shareCardWidth =>
      (_section('share')['cardWidth'] as num).toDouble();
  double get sharePixelRatio =>
      (_section('share')['pixelRatio'] as num).toDouble();
  int get shareMaxCharacters => _section('share')['maxCharacters'] as int;

  String get wallpaperDirectory => _section('wallpaper')['directory'] as String;
  double get wallpaperScrimOpacity =>
      (_section('wallpaper')['photoScrimOpacity'] as num).toDouble();
  double get wallpaperPatternSpacing =>
      (_section('wallpaper')['patternSpacing'] as num).toDouble();

  Map<String, double> _numbers(String section, String name) => {
        for (final MapEntry(:key, :value)
            in (_section(section)[name] as Map).entries)
          key as String: (value as num).toDouble(),
      };

  Duration get locationTimeout =>
      Duration(seconds: _section('location')['timeoutSeconds'] as int);
  int get recentPlacesLimit => _section('location')['recentPlaces'] as int;

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
