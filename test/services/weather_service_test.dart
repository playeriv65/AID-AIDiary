import 'dart:convert';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _hourly(List<int> codes, List<double> temperatures) => {
      'hourly': {'weather_code': codes, 'temperature_2m': temperatures}
    };

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  test('parseHourly picks the reading for the hour', () {
    final body = _hourly(List.generate(24, (h) => h < 12 ? 0 : 61),
        List.generate(24, (h) => h + 0.4));
    expect(WeatherService.parseHourly(body, 15),
        const EntryWeather(code: 61, temperature: 15.4));
    expect(WeatherService.parseHourly(body, 3)!.code, 0);
    expect(WeatherService.parseHourly({'hourly': {}}, 3), isNull);
    expect(WeatherService.parseHourly(_hourly([1], [2]), 30)!.temperature, 2);
  });

  test('recent dates use the forecast endpoint, old ones the archive',
      () async {
    final hosts = <String>[];
    final service = WeatherService(client: MockClient((request) async {
      hosts.add(request.url.host);
      expect(
          request.url.queryParameters['hourly'], 'temperature_2m,weather_code');
      return http.Response(
          jsonEncode(_hourly(List.filled(24, 3), List.filled(24, 8))), 200);
    }));
    final now = DateTime.now();
    expect(await service.at(48.1, 11.6, now),
        const EntryWeather(code: 3, temperature: 8));
    await service.at(48.1, 11.6, now.subtract(const Duration(days: 400)));
    expect(hosts, ['api.open-meteo.com', 'archive-api.open-meteo.com']);

    final failing = WeatherService(
        client: MockClient((_) async => http.Response('nope', 500)));
    expect(await failing.at(0, 0, now), isNull);
  });
}
