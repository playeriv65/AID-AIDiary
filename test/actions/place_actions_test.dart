// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/place_actions.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../support/diary_app_harness.dart';

void main() {
  DiaryAppHarness().register();

  var online = true;
  final requested = <Uri>[];
  late AppActions actions;

  setUp(() {
    online = true;
    requested.clear();
    // The places and the weather come from fake servers.
    final client = MockClient((request) async {
      requested.add(request.url);
      if (!online) return http.Response('down', 503);
      if (request.url.host.contains('open-meteo')) {
        return http.Response(
            jsonEncode({
              'hourly': {
                'weather_code': List.filled(24, 61),
                'temperature_2m': List.filled(24, 7.5),
              }
            }),
            200);
      }
      if (request.method == 'POST') {
        return http.Response(
            jsonEncode({
              'elements': [
                {
                  'lat': 48.1352,
                  'lon': 11.5822,
                  'tags': {'name': 'Cafe Frischhut', 'amenity': 'cafe'}
                },
                {
                  'lat': 48.1360,
                  'lon': 11.5700,
                  'tags': {'name': 'Viktualienmarkt', 'shop': 'marketplace'}
                },
              ]
            }),
            200);
      }
      return http.Response(
          jsonEncode([
            {
              'lat': '48.1371',
              'lon': '11.5754',
              'display_name': 'Marienplatz, Munich, Bavaria, Germany',
              'address': {'tourism': 'Marienplatz', 'city': 'Munich'},
            }
          ]),
          200);
    });
    actions = AppActions(
        actions: buildPlaceActions(
            location: LocationService(client: client),
            weather: WeatherService(client: client)),
        devBuild: true);
  });

  Future<Map<String, Object?>> run(String id,
          [Map<String, Object?> args = const {}]) async =>
      (await actions.run(id, args)) as Map<String, Object?>;

  Matcher refused(String code) =>
      throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

  Future<Entry> write(String text, {EntryLocation? place, DateTime? openAt}) {
    final time = DateTime(2026, 10, 20, 15);
    return EntryStore.instance.add(Entry(
        text: text,
        timeCreate: time,
        timeModified: time,
        location: place,
        openAt: openAt));
  }

  test('places are found by name, and by position, nearest first', () async {
    final found = await run('place.search', {'query': 'Marienplatz'});
    expect(found['places'], [
      {
        'name': 'Marienplatz, Munich',
        'latitude': 48.1371,
        'longitude': 11.5754,
        'detail': 'Marienplatz, Munich, Bavaria, Germany',
      }
    ]);
    expect(requested.single.queryParameters['q'], 'Marienplatz');

    final nearby = await run(
        'place.nearby', {'latitude': '48.1351', 'longitude': '11.5820'});
    expect(
        [for (final place in nearby['places'] as List) (place as Map)['name']],
        ['Cafe Frischhut', 'Viktualienmarkt']);

    expect(() => run('place.nearby', {'latitude': 'far', 'longitude': '1'}),
        refused('bad_args'));
    expect(() => run('place.nearby', {'latitude': '91', 'longitude': '1'}),
        refused('bad_args'));

    online = false;
    expect((await run('place.search', {'query': 'Marienplatz'}))['places'],
        isEmpty);
  });

  test('places are starred and unstarred as the picker does', () async {
    expect((await run('place.saved'))['places'], isEmpty);
    final home = {'name': 'Home', 'latitude': '1.5', 'longitude': '2.5'};
    expect((await run('place.save', home))['count'], 1);
    // Starring again keeps one.
    expect((await run('place.save', home))['count'], 1);
    await run(
        'place.save', {'name': 'Work', 'latitude': '3.5', 'longitude': '4.5'});
    expect([
      for (final place in (await run('place.saved'))['places'] as List)
        (place as Map)['name']
    ], [
      'Work',
      'Home'
    ]);

    expect((await run('place.unsave', home))['count'], 1);
    expect(() => run('place.unsave', home), refused('not_found'));
    expect((await run('place.saved'))['places'], hasLength(1));
  });

  test('the device position needs location to be on', () async {
    // The harness answers that location services are off.
    expect(() => run('place.current'), refused('location_off'));
  });

  test('the weather is looked up for the entry place and time and stored',
      () async {
    final entry = await write('Rain',
        place: const EntryLocation(
            latitude: 48.1, longitude: 11.6, name: 'Munich'));
    final fetched = await run('weather.fetch', {'id': entry.id});
    expect((fetched['weather'] as Map)['code'], 61);
    expect((fetched['weather'] as Map)['temperature'], 7.5);
    expect((fetched['weather'] as Map)['description'], isNotEmpty);
    expect(EntryStore.instance.entries.single.weather,
        const EntryWeather(code: 61, temperature: 7.5));
    // The day of the entry went to the archive: a day in the past.
    expect(requested.single.queryParameters['start_date'], '2026-10-20');

    online = false;
    expect(
        () => run('weather.fetch', {'id': entry.id}), refused('unavailable'));
    expect(EntryStore.instance.entries.single.weather!.code, 61);
  });

  test('weather needs an entry that is open and has a place', () async {
    final bare = await write('Nowhere');
    expect(
        () => run('weather.fetch', {'id': bare.id}), refused('needs_location'));
    expect(() => run('weather.fetch', {'id': 404}), refused('not_found'));
    final sealed = await write('For later',
        place: const EntryLocation(latitude: 1, longitude: 2),
        openAt: DateTime.now().add(const Duration(days: 30)));
    expect(() => run('weather.fetch', {'id': sealed.id}), refused('sealed'));
    expect(requested, isEmpty);
  });
}
