// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/photo_suggestion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LocalPhoto photo(String id, int hour, {int day = 20, double? latitude}) =>
      LocalPhoto(
          id: id,
          taken: DateTime(2026, 10, day, hour),
          latitude: latitude,
          longitude: latitude == null ? null : 120);
  test('date, time gaps and measured locations define local sessions', () {
    final grouped = groupPhotoSuggestions([
      photo('a', 8, latitude: 30),
      photo('b', 9, latitude: 30.0001),
      photo('c', 10, latitude: 31),
      photo('d', 11, latitude: 31),
      photo('e', 19),
      photo('f', 20),
      photo('g', 8, day: 21),
      photo('h', 9, day: 21)
    ]);
    expect(grouped, hasLength(4));
    expect(grouped.first.day, DateTime(2026, 10, 21));
    expect(grouped[1].placed, isNull);
    expect(grouped.last.placed!.latitude, 30);
  });
  test('card identities are stable across query order and cards are bounded',
      () {
    final photos = [for (var i = 0; i < 40; i++) photo('$i', 12)];
    final a = groupPhotoSuggestions(photos);
    final b = groupPhotoSuggestions(photos.reversed.toList());
    expect(a.map((card) => card.id), b.map((card) => card.id));
    expect(a, hasLength(2));
    expect(a.every((card) => card.photos.length == 20), isTrue);
    expect(groupPhotoSuggestions([photo('single', 12)]), isEmpty);
  });
  test('invalid or missing geotags never become an inferred place', () {
    final card =
        PhotoSuggestion([photo('a', 1), photo('b', 2, latitude: double.nan)]);
    expect(card.placed, isNull);
    expect(card.toJson()['latitude'], isNull);
    expect(photoDistance(30, 120, 30, 120), 0);
  });
}
