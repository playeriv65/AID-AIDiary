// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

enum LocationFailure { serviceDisabled, permissionDenied, unavailable }

/// A place search hit: the place to store and its full address to show.
typedef PlaceMatch = ({EntryLocation location, String? detail});

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

  Future<EntryLocation> current({String? languageCode}) async {
    final here = await position();
    final name = await placeName(here.latitude, here.longitude,
        languageCode: languageCode);
    return EntryLocation(
        latitude: here.latitude, longitude: here.longitude, name: name);
  }

  /// The device position, asking for the permission when it is undecided.
  Future<LatLng> position() async {
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
    return LatLng(position.latitude, position.longitude);
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

  /// Places matching [query], best first; empty when the lookup fails.
  Future<List<PlaceMatch>> search(String query, {String? languageCode}) async {
    final config = AppConfig.instance;
    final uri = config.placeSearchUrl.replace(queryParameters: {
      'format': 'jsonv2',
      'q': query,
      'addressdetails': '1',
      'limit': '${config.placeSearchLimit}',
      if (languageCode != null) 'accept-language': languageCode,
    });
    try {
      final response = await _client.get(uri, headers: {
        'User-Agent': config.geocodeUserAgent
      }).timeout(config.geocodeTimeout);
      if (response.statusCode != 200) return const [];
      return parseSearch(jsonDecode(response.body) as List);
    } catch (error, stackTrace) {
      _logger.info('Place search failed', error, stackTrace);
      return const [];
    }
  }

  /// Named places around the coordinates from OpenStreetMap, nearest first;
  /// empty when the lookup fails.
  Future<List<PlaceMatch>> nearby(double latitude, double longitude,
      {String? languageCode}) async {
    final config = AppConfig.instance;
    // Shops, cafés, parks, sights and the like: things people go to.
    final query = '[out:json][timeout:${config.nearbyTimeout.inSeconds}];'
        'nwr(around:${config.nearbyRadiusMeters},$latitude,$longitude)[name]'
        '[~"^(amenity|shop|tourism|leisure|historic|office|craft)\$"~"."];'
        'out center ${config.nearbyLimit * 4};';
    try {
      final response = await _client.post(config.nearbyUrl,
          headers: {'User-Agent': config.geocodeUserAgent},
          body: {'data': query}).timeout(config.nearbyTimeout);
      if (response.statusCode != 200) return const [];
      return parseNearby(jsonDecode(utf8.decode(response.bodyBytes)) as Map,
          latitude, longitude,
          limit: config.nearbyLimit, languageCode: languageCode);
    } catch (error, stackTrace) {
      _logger.info('Nearby places failed', error, stackTrace);
      return const [];
    }
  }

  /// Turns an Overpass answer into places, nearest first, each name once,
  /// with the distance as detail.
  static List<PlaceMatch> parseNearby(
      Map body, double latitude, double longitude,
      {required int limit, String? languageCode}) {
    const distance = Distance();
    final here = LatLng(latitude, longitude);
    final found = <(double, EntryLocation)>[];
    for (final element
        in (body['elements'] as List? ?? const []).whereType<Map>()) {
      final tags = (element['tags'] as Map?)?.cast<String, dynamic>() ?? {};
      final name = (tags['name:$languageCode'] ?? tags['name']) as String?;
      final point = (element['center'] as Map?) ?? element;
      final lat = (point['lat'] as num?)?.toDouble();
      final lon = (point['lon'] as num?)?.toDouble();
      if (name == null || name.isEmpty || lat == null || lon == null) continue;
      found.add((
        distance.as(LengthUnit.Meter, here, LatLng(lat, lon)),
        EntryLocation(latitude: lat, longitude: lon, name: name),
      ));
    }
    found.sort((a, b) => a.$1.compareTo(b.$1));
    final seen = <String>{};
    return [
      for (final (meters, place) in found)
        if (seen.add(place.name!))
          (location: place, detail: '${meters.round()} m'),
    ].take(limit).toList();
  }

  /// Turns Nominatim search results into named places.
  static List<PlaceMatch> parseSearch(List results) => [
        for (final result in results.whereType<Map>())
          if (double.tryParse('${result['lat']}') case final lat?)
            if (double.tryParse('${result['lon']}') case final lon?)
              (
                location: EntryLocation(
                    latitude: lat,
                    longitude: lon,
                    name: shortName(result.cast<String, dynamic>())),
                detail: result['display_name'] as String?,
              ),
      ];

  /// Picks the most specific readable parts of a reverse geocoding result.
  static String? shortName(Map<String, dynamic> result) {
    final address = (result['address'] as Map?)?.cast<String, dynamic>();
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
