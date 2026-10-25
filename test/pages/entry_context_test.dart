@Tags(['widget'])
library;

import 'dart:convert';

import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/widgets/context_dialogs.dart';
import 'package:aid_diary/widgets/location_dialog.dart';
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
    final temperature = tester
        .widget<TextField>(find.byKey(const ValueKey('weather-temperature')))
        .controller!;
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('weather-fetch'))),
        () => temperature.text == '-3');
    expect(
        tester
            .widget<ChoiceChip>(find.byKey(const ValueKey('weather-kind-snow')))
            .selected,
        isTrue);
    await tester.tap(find.byKey(const ValueKey('weather-save')));
    await tester.pumpAndSettle();
    expect(choice?.weather, const EntryWeather(code: 71, temperature: -2.6));
    expect(choice?.source, WeatherSource.queried);
  });

  testWidgets('weather can be set by hand without a place', (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    WeatherChoice? choice;
    showWeatherDialog(context, null, null, DateTime.now())
        .then((value) => choice = value);
    await tester.pumpAndSettle();
    final save = find.byKey(const ValueKey('weather-save'));
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    await tester.tap(find.byKey(const ValueKey('weather-kind-rain')));
    await tester.enterText(
        find.byKey(const ValueKey('weather-temperature')), '18');
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(choice?.weather, const EntryWeather(code: 63, temperature: 18));
    expect(choice?.source, WeatherSource.manual);
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
    await tester.tap(find.byKey(const ValueKey('location-pick')));
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
    expect(
        choice?.location,
        const EntryLocation(
            latitude: 48.8584, longitude: 2.2945, name: 'Tour Eiffel, Paris'));
  });

  testWidgets('location sheet renames and removes the entry place',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox).first);
    const place = EntryLocation(name: '家', latitude: 1, longitude: 2);
    LocationChoice? choice;
    showLocationDialog(context, place).then((value) => choice = value);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('location-rename')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('location-rename-field')), '老家');
    await tester.tap(find.byKey(const ValueKey('location-rename-ok')));
    await tester.pumpAndSettle();
    expect(choice?.location,
        const EntryLocation(name: '老家', latitude: 1, longitude: 2));

    showLocationDialog(context, place).then((value) => choice = value);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('location-remove')));
    await tester.pumpAndSettle();
    expect(choice, isNotNull);
    expect(choice!.location, isNull);
  });

  testWidgets('entry details show the title and the day\'s weather',
      (tester) async {
    const place = EntryLocation(latitude: 31.23, longitude: 121.47);
    final entry = await DiaryAppHarness.addEntry(
        tester, '下雨天', DateTime(2026, 10, 18, 9),
        title: '周六',
        location: place,
        weather: const EntryWeather(code: 63, temperature: 12.2));
    // Another entry of that day nearby shares the weather.
    final later = await DiaryAppHarness.addEntry(
        tester, '晚上', DateTime(2026, 10, 18, 21),
        location: const EntryLocation(latitude: 31.24, longitude: 121.48));
    DiaryAppHarness.size(tester, const Size(390, 844));
    for (final (id, title) in [(entry.id!, '周六'), (later.id!, null)]) {
      await tester.pumpWidget(harness.app(EntryViewPage(entryId: id)));
      await tester.pumpAndSettle();
      expect(
          find.descendant(
              of: find.byKey(const ValueKey('entry-weather')),
              matching: find.text('雨, 12°C')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('entry-title')),
          title == null ? findsNothing : findsOneWidget);
    }
  });
}
