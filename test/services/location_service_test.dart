import 'package:aid_diary/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nearby places come nearest first, named in the app language', () {
    final places = LocationService.parseNearby({
      'elements': [
        {
          'type': 'node',
          'lat': 31.2410,
          'lon': 121.4900,
          'tags': {'name': 'Far Café'},
        },
        {
          'type': 'way',
          'center': {'lat': 31.2401, 'lon': 121.4901},
          'tags': {'name': 'Bund Park', 'name:zh': '外滩公园'},
        },
        {'type': 'node', 'lat': 31.2402, 'lon': 121.49, 'tags': {}},
        {
          'type': 'node',
          'lat': 31.2420,
          'lon': 121.4900,
          'tags': {'name': 'Far Café'},
        },
      ],
    }, 31.2400, 121.4900, limit: 5, languageCode: 'zh');
    expect(places.map((p) => p.location.name), ['外滩公园', 'Far Café']);
    expect(places.first.location.latitude, 31.2401);
    expect(places.first.detail, endsWith(' m'));
  });

  test('nearby places stop at the limit', () {
    final places = LocationService.parseNearby({
      'elements': [
        for (var i = 0; i < 5; i++)
          {
            'lat': 1.0 + i / 1000,
            'lon': 2.0,
            'tags': {'name': 'Place $i'},
          },
      ],
    }, 1.0, 2.0, limit: 2);
    expect(places.map((p) => p.location.name), ['Place 0', 'Place 1']);
  });
}
