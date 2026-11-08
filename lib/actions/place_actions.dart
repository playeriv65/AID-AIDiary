// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/saved_places.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/l10n/shown_language.dart';
import 'package:aid_diary/utils/entry_context_display.dart';

Map<String, Object?> _place(EntryLocation place, {String? detail}) => {
      if (place.name != null) 'name': place.name,
      if (place.latitude != null) 'latitude': place.latitude,
      if (place.longitude != null) 'longitude': place.longitude,
      if (detail != null) 'detail': detail,
    };

/// [args]' latitude or longitude [name], checked against [limit] degrees.
double degreesArg(ActionArgs args, String name, double limit) {
  final value = args[name] as double;
  if (value.abs() > limit) {
    throw ActionException(
        'bad_args', '$name must be from -$limit to $limit, not $value');
  }
  return value;
}

const _coordinates = [
  ActionParam('latitude', ParamType.number, 'Degrees north, from -90 to 90'),
  ActionParam('longitude', ParamType.number, 'Degrees east, from -180 to 180'),
];

/// What `place.save` and `place.unsave` take: a name, a position or both,
/// as the location picker stars them.
const _starredPlace = [
  ActionParam('name', ParamType.string, 'What the place is called',
      required: false),
  ActionParam('latitude', ParamType.number,
      'Degrees north, from -90 to 90; goes with longitude',
      required: false),
  ActionParam('longitude', ParamType.number,
      'Degrees east, from -180 to 180; goes with latitude',
      required: false),
];

/// The place [_starredPlace] describes.
EntryLocation _starred(ActionArgs args) {
  final name = (args['name'] as String?)?.trim();
  final latitude =
      args['latitude'] == null ? null : degreesArg(args, 'latitude', 90);
  final longitude =
      args['longitude'] == null ? null : degreesArg(args, 'longitude', 180);
  if ((latitude == null) != (longitude == null)) {
    throw const ActionException(
        'bad_args', 'latitude and longitude go together');
  }
  final place = EntryLocation(
      name: name == null || name.isEmpty ? null : name,
      latitude: latitude,
      longitude: longitude);
  if (place.isEmpty) {
    throw const ActionException('bad_args', 'Give a name or a position');
  }
  return place;
}

/// The places and weather actions, over the services that look them up;
/// tests pass services that answer without the network.
List<AppAction> buildPlaceActions(
    {LocationService? location, WeatherService? weather}) {
  // Made on first use: a service holds an HTTP client.
  late final locations = location ?? LocationService();
  late final weathers = weather ?? WeatherService();
  return [
    AppAction(
      id: 'place.search',
      describe: 'Looks up places by name or address, best match first. An '
          'empty list means nothing matched or the lookup failed.',
      risk: ActionRisk.read,
      params: const [
        ActionParam('query', ParamType.string, 'A name or an address'),
      ],
      run: (context, args) async => {
        'places': [
          for (final match in await locations.search(args['query'] as String,
              languageCode: shownLocale().languageCode))
            _place(match.location, detail: match.detail),
        ],
      },
    ),
    AppAction(
      id: 'place.nearby',
      describe: 'Lists named places such as shops, cafés and sights around '
          'a position, nearest first.',
      risk: ActionRisk.read,
      params: _coordinates,
      run: (context, args) async => {
        'places': [
          for (final match in await locations.nearby(
              degreesArg(args, 'latitude', 90),
              degreesArg(args, 'longitude', 180),
              languageCode: shownLocale().languageCode))
            _place(match.location, detail: match.detail),
        ],
      },
    ),
    AppAction(
      id: 'place.current',
      describe: "Finds where this device is and names the place. Needs the "
          'device to have location on and allowed for the app.',
      risk: ActionRisk.read,
      run: (context, args) async {
        try {
          return _place(await locations.current(
              languageCode: shownLocale().languageCode));
        } on LocationException catch (error) {
          throw ActionException(
              switch (error.reason) {
                LocationFailure.serviceDisabled => 'location_off',
                LocationFailure.permissionDenied => 'needs_permission',
                LocationFailure.unavailable => 'unavailable',
              },
              switch (error.reason) {
                LocationFailure.serviceDisabled =>
                  'Location is off on this device',
                LocationFailure.permissionDenied =>
                  'The app may not use the location of this device',
                LocationFailure.unavailable => 'The position could not be read',
              });
        }
      },
    ),
    AppAction(
      id: 'place.saved',
      describe: 'Lists the starred places of the location picker, newest '
          'first.',
      risk: ActionRisk.read,
      run: (context, args) async => {
        'places': [for (final place in SavedPlaces.all()) _place(place)],
      },
    ),
    AppAction(
      id: 'place.save',
      describe: 'Stars a place for the location picker: a name, a position '
          'or both.',
      risk: ActionRisk.write,
      params: _starredPlace,
      run: (context, args) async {
        final place = _starred(args);
        await SavedPlaces.save(place);
        return {'saved': _place(place), 'count': SavedPlaces.all().length};
      },
    ),
    AppAction(
      id: 'place.unsave',
      describe: 'Removes a place from the starred ones, given as '
          'place.saved lists it.',
      risk: ActionRisk.write,
      params: _starredPlace,
      run: (context, args) async {
        final place = _starred(args);
        if (!SavedPlaces.contains(place)) {
          throw const ActionException('not_found', 'That place is not saved');
        }
        await SavedPlaces.unsave(place);
        return {'removed': _place(place), 'count': SavedPlaces.all().length};
      },
    ),
    AppAction(
      id: 'weather.fetch',
      describe: "Looks up the weather of an entry's diary day at its place "
          'and keeps it as that day and place\'s weather; weather set by '
          'hand or imported still counts first. The entry needs a place '
          'with a position.',
      risk: ActionRisk.write,
      params: const [ActionParam('id', ParamType.integer, 'The entry id')],
      run: (context, args) async {
        final store = EntryStore.instance;
        await store.complete;
        final id = args['id'] as int;
        final entry =
            store.entries.where((entry) => entry.id == id).firstOrNull;
        if (entry == null) {
          throw ActionException('not_found', 'There is no entry $id');
        }
        if (entry.isSealed) {
          throw ActionException(
              'sealed', 'Entry $id is sealed until ${entry.openAt}');
        }
        final place = entry.location;
        if (place == null || !place.hasCoordinates) {
          throw const ActionException(
              'needs_location', 'The entry has no place with a position');
        }
        final found = await weathers.at(
            place.latitude!, place.longitude!, weatherTimeOf(entry));
        if (found == null) {
          throw const ActionException(
              'unavailable', 'The weather could not be looked up');
        }
        final days = WeatherProvider.instance;
        await days.set(entry.day, place, found, WeatherSource.queried);
        final shown = days.of(entry.day, place)!;
        return {
          'id': id,
          'weather': {
            'code': shown.weather.code,
            'temperature': shown.weather.temperature,
            'description':
                weatherLabel(shown.weather.code, shownLocalizations()),
            'source': shown.source.name,
          },
        };
      },
    ),
  ];
}

final List<AppAction> placeActions = buildPlaceActions();
