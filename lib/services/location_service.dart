// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/models/entry.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

enum LocationFailure { serviceDisabled, permissionDenied, unavailable }

class LocationException implements Exception {
  const LocationException(this.reason);
  final LocationFailure reason;
  @override
  String toString() => 'LocationException($reason)';
}

/// Reads the device position and names it. Coordinates stay on the device;
/// only the reverse geocoding request leaves it.
class LocationService {
  LocationService({http.Client? client}) : _client = client ?? http.Client();

  static final _logger = Logger('LocationService');
  final http.Client _client;

  Future<EntryLocation> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.permissionDenied);
    }
    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: AppConfig.instance.locationTimeout));
    } catch (error, stackTrace) {
      _logger.warning('Position unavailable', error, stackTrace);
      throw const LocationException(LocationFailure.unavailable);
    }
    final name = await placeName(position.latitude, position.longitude);
    return EntryLocation(
        latitude: position.latitude, longitude: position.longitude, name: name);
  }

  /// A short place name for the coordinates, or null when the lookup fails.
  Future<String?> placeName(double latitude, double longitude,
      {String? languageCode}) async {
    final config = AppConfig.instance;
    final uri = config.reverseGeocodeUrl.replace(queryParameters: {
      'format': 'jsonv2',
      'lat': '$latitude',
      'lon': '$longitude',
      'zoom': '16',
      if (languageCode != null) 'accept-language': languageCode,
    });
    try {
      final response = await _client.get(uri, headers: {
        'User-Agent': config.geocodeUserAgent
      }).timeout(config.geocodeTimeout);
      if (response.statusCode != 200) return null;
      return shortName(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (error, stackTrace) {
      _logger.info('Reverse geocoding failed', error, stackTrace);
      return null;
    }
  }

  /// Picks the most specific readable parts of a reverse geocoding result.
  static String? shortName(Map<String, dynamic> result) {
    final address = result['address'] as Map<String, dynamic>?;
    if (address == null) return result['name'] as String?;
    String? first(List<String> keys) => keys
        .map((k) => address[k] as String?)
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .firstOrNull;
    final place = first([
      'amenity',
      'building',
      'tourism',
      'leisure',
      'road',
      'neighbourhood',
      'suburb'
    ]);
    final area = first(['city', 'town', 'village', 'county', 'state']);
    final parts = [place, area].whereType<String>().toSet().toList();
    if (parts.isEmpty) return result['display_name'] as String?;
    return parts.join(', ');
  }
}
