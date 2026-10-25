// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// The editor's rules without its widgets: drafts, leaving, diary days,
// filled-in context and photo suggestions, over real SQLite.

@Tags(['integration'])
library;

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/edit_entry_view_model.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

class _FixedPlace extends LocationService {
  _FixedPlace(this.place);
  final EntryLocation place;
  @override
  Future<EntryLocation> current({String? languageCode}) async => place;
  @override
  Future<String?> placeName(double latitude, double longitude,
          {String? languageCode}) async =>
      'Photo place';
}

class _FixedWeather extends WeatherService {
  @override
  Future<EntryWeather?> at(
          double latitude, double longitude, DateTime time) async =>
      const EntryWeather(code: 1, temperature: 20);
}

void main() {
  DiaryAppHarness().register();
  final store = EntryStore.instance;
  final morning = DateTime(2026, 10, 21, 9, 30);

  EditEntryViewModel model(
          {Entry? entry, DateTime? clock, Future<void> Function()? onToday}) =>
      EditEntryViewModel(
        entry: entry,
        clock: () => clock ?? morning,
        saveDelay: const Duration(milliseconds: 10),
        locationService: _FixedPlace(const EntryLocation(
            latitude: 31.2, longitude: 121.5, name: 'Bund')),
        weatherService: _FixedWeather(),
        onSavedForToday: onToday,
      );

  test('an untouched new entry is never saved and leaves silently', () async {
    final editor = model();
    await editor.save();
    await editor.leave();
    expect(store.entries, isEmpty);
    expect(editor.canLeaveSilently, isTrue);
    editor.dispose();
  });

  test('typing saves a draft on its own, title included', () async {
    final editor = model();
    editor.setText('周末', '去了公园');
    expect(editor.edited, isTrue);
    expect(editor.canLeaveSilently, isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final saved = store.entries.single;
    expect((saved.title, saved.text), ('周末', '去了公园'));
    await editor.leave();
    editor.dispose();
  });

  test('not keeping the changes rolls the draft back', () async {
    final editor = model();
    editor.setText('', '不想留下');
    await editor.save();
    expect(store.entries, hasLength(1));
    await editor.discard();
    await editor.leave();
    expect(store.entries, isEmpty);
    editor.dispose();
  });

  test('the diary day and the written time change apart', () async {
    final editor = model();
    editor.setText('', '回忆');
    editor.setDiaryDay(DateTime(2026, 10, 1, 15));
    await editor.leave();
    final saved = store.entries.single;
    expect(saved.day, DateTime(2026, 10, 1));
    expect(saved.timeCreate, morning);
    editor.dispose();
  });

  test('the asking hours ask until a day is picked', () {
    DiaryDay.startHour = 4;
    DiaryDay.askUntilHour = 6;
    addTearDown(() {
      DiaryDay.startHour = 0;
      DiaryDay.askUntilHour = 0;
    });
    final early = model(clock: DateTime(2026, 10, 21, 5, 10));
    expect(early.askDay, isTrue);
    expect(early.diaryDay, DateTime(2026, 10, 21));
    early.setDiaryDay(DateTime(2026, 10, 20));
    expect(early.askDay, isFalse);
    early.dispose();
    final late = model(clock: DateTime(2026, 10, 21, 2));
    expect(late.askDay, isFalse);
    expect(late.diaryDay, DateTime(2026, 10, 20));
    late.dispose();
  });

  test('filled-in place and weather do not count as writing', () async {
    final editor = model();
    await editor.fillCurrentContext(place: true, weather: true);
    expect(editor.location?.name, 'Bund');
    expect(editor.location?.source, LocationSource.gps);
    // The weather found is the day's at that place, kept at once.
    expect(
        editor.weather?.weather, const EntryWeather(code: 1, temperature: 20));
    expect(editor.weather?.source, WeatherSource.queried);
    expect(editor.edited, isFalse);
    expect(editor.hasContent, isFalse);
    await editor.leave();
    expect(store.entries, isEmpty);
    editor.dispose();
  });

  test('a place found for now leaves when the entry moves to another day',
      () async {
    final editor = model();
    await editor.fillCurrentContext(place: true, weather: false);
    editor.setDiaryDay(DateTime(2026, 10, 1));
    expect(editor.location, isNull);
    editor.dispose();
    final picked = model();
    picked.setLocation(
        const EntryLocation(name: 'Home', source: LocationSource.picked));
    picked.setDiaryDay(DateTime(2026, 10, 1));
    expect(picked.location?.name, 'Home');
    await picked.discard();
    picked.dispose();
  });

  test('a photo suggests its day and place, not a time', () async {
    final editor = model();
    final suggestion = await editor.suggestFromPhoto(PhotoMetadata(
        taken: DateTime(2026, 9, 3, 18), latitude: 1, longitude: 2));
    expect(suggestion?.day, DateTime(2026, 9, 3));
    expect(suggestion?.place?.name, 'Photo place');
    editor.applyPhotoSuggestion(suggestion!);
    expect(editor.diaryDay, DateTime(2026, 9, 3));
    expect(editor.writtenAt, morning);
    // Nothing new once taken.
    expect(
        await editor.suggestFromPhoto(PhotoMetadata(
            taken: DateTime(2026, 9, 3, 20), latitude: 1, longitude: 2)),
        isNull);
    editor.dispose();
  });

  test('saving an entry for today tells about it', () async {
    var told = 0;
    final now = DateTime.now();
    final editor = model(clock: now, onToday: () async => told++);
    editor.setText('', '今天');
    await editor.save();
    expect(told, 1);
    editor.setDiaryDay(DateTime(2020));
    await editor.save();
    expect(told, 1);
    editor.dispose();
  });

  test('editing an entry keeps its id and rolls back to how it was', () async {
    final original = await store.add(
        Entry(text: 'original', timeCreate: morning, timeModified: morning));
    final editor = model(entry: original);
    expect(editor.isNew, isFalse);
    editor.setText('', 'changed');
    await editor.save();
    expect(store.entries.single.text, 'changed');
    await editor.discard();
    expect(store.entries.single.id, original.id);
    expect(store.entries.single.text, 'original');
    editor.dispose();
  });
}
