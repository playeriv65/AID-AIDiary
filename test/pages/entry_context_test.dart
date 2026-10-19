import 'dart:convert';

import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/services/location_service.dart';
import 'package:daily_you/services/weather_service.dart';
import 'package:daily_you/utils/map_clusters.dart';
import 'package:daily_you/widgets/context_dialogs.dart';
import 'package:daily_you/widgets/entry_draft_dirty_tracker.dart';
import 'package:daily_you/widgets/location_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

Map<String, dynamic> _hourly(List<int> codes, List<double> temperatures) => {
      'hourly': {'weather_code': codes, 'temperature_2m': temperatures}
    };

void main() {
  final harness = DiaryAppHarness()..register();

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

  test('auto-filled context keeps a new entry untouched', () {
    final tracker = EntryDraftDirtyTracker(
        text: '', mood: null, date: DateTime(2026, 10, 19), seededTagIds: {});
    const weather = EntryWeather(code: 0, temperature: 20);
    tracker.adoptAutoFill(weather: weather, activity: EntryActivity.walking);
    expect(
        tracker.hasFieldChanges(
            text: '',
            mood: null,
            date: DateTime(2026, 10, 19),
            weather: weather,
            activity: EntryActivity.walking),
        isFalse);
    expect(
        tracker.hasFieldChanges(
            text: '',
            mood: null,
            date: DateTime(2026, 10, 19),
            weather: weather,
            activity: EntryActivity.running),
        isTrue);
  });

  testWidgets('weather dialog fetches for the place and returns it',
      (tester) async {
    final service = WeatherService(
        client: MockClient((_) async => http.Response(
            jsonEncode(_hourly(List.filled(24, 71), List.filled(24, -2.6))),
            200)));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    WeatherChoice? choice;
    showWeatherDialog(
            context,
            null,
            const EntryLocation(name: '家', latitude: 1, longitude: 2),
            DateTime.now(),
            service: service)
        .then((value) => choice = value);
    await tester.pumpAndSettle();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('weather-fetch'))),
        () => find.text('雪').evaluate().isNotEmpty);
    expect(find.text('-3°C'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('weather-save')));
    await tester.pumpAndSettle();
    expect(choice?.weather, const EntryWeather(code: 71, temperature: -2.6));
  });

  testWidgets('weather dialog asks for a place without coordinates',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    showWeatherDialog(
        context, null, const EntryLocation(name: '家'), DateTime.now());
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('weather-fetch')), findsNothing);
  });

  testWidgets('location dialog searches places by name', (tester) async {
    late Uri requested;
    final service = LocationService(client: MockClient((request) async {
      requested = request.url;
      return http.Response(
          jsonEncode([
            {
              'lat': '48.8584',
              'lon': '2.2945',
              'display_name': 'Tour Eiffel, Paris, France',
              'address': {'tourism': 'Tour Eiffel', 'city': 'Paris'}
            },
            {'lat': 'bad', 'lon': '1'},
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'});
    }));
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    LocationChoice? choice;
    showLocationDialog(context, null, service: service)
        .then((value) => choice = value);
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('location-name')), 'eiffel');
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('location-search'))),
        () => find
            .byKey(const ValueKey('location-match-0'))
            .evaluate()
            .isNotEmpty);
    expect(requested.queryParameters['q'], 'eiffel');
    expect(find.byKey(const ValueKey('location-match-1')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('location-match-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('location-save')));
    await tester.pumpAndSettle();
    expect(
        choice?.location,
        const EntryLocation(
            latitude: 48.8584, longitude: 2.2945, name: 'Tour Eiffel, Paris'));
  });

  test('clusterByDistance groups items near the first of each cluster', () {
    final clusters = clusterByDistance(
        const [Offset(0, 0), Offset(30, 0), Offset(70, 0), Offset(200, 0)],
        (offset) => offset,
        50);
    expect(clusters, [
      [const Offset(0, 0), const Offset(30, 0)],
      [const Offset(70, 0)],
      [const Offset(200, 0)],
    ]);
  });

  testWidgets('activity dialog returns the chosen activity', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    ActivityChoice? choice;
    showActivityDialog(context, null).then((value) => choice = value);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('activity-cycling')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('activity-save')));
    await tester.pumpAndSettle();
    expect(choice?.activity, EntryActivity.cycling);
  });

  testWidgets('entry details show weather and activity', (tester) async {
    final entry = await DiaryAppHarness.addEntry(
        tester, '下雨天', DateTime(2026, 10, 18, 9),
        weather: const EntryWeather(code: 63, temperature: 12.2),
        activity: EntryActivity.walking);
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(EntryViewPage(entryId: entry.id!)));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('entry-weather')),
            matching: find.text('雨, 12°C')),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('entry-activity')),
            matching: find.text('步行')),
        findsOneWidget);
  });
}
