// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/links_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/providers/weather_provider.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:aid_diary/widgets/entry_draft_dirty_tracker.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';
import 'package:flutter/foundation.dart';

/// A photo's day and place the entry could take; either may be missing.
typedef PhotoSuggestion = ({DateTime? day, EntryLocation? place});

/// The entry editor's state and rules, apart from its widgets.
///
/// It holds what is being edited, saves it as a draft shortly after each
/// change (and whenever asked), and on leaving keeps or rolls back the
/// session. The page owns the text controllers and dialogs and reports
/// edits here; everything here runs without a widget.
class EditEntryViewModel extends ChangeNotifier {
  EditEntryViewModel({
    Entry? entry,
    DateTime? diaryDay,
    List<EntryImage> images = const [],
    String? sharedText,
    int? initialMood,
    Template? template,
    List<EntryRef>? refs,
    EntryStore? store,
    TagsProvider? tags,
    TemplatesProvider? templates,
    EntryImagesProvider? entryImages,
    LocationService? locationService,
    WeatherService? weatherService,
    WeatherProvider? weathers,
    DateTime Function()? clock,
    this.saveDelay = const Duration(seconds: 5),
    this.onSavedForToday,
  })  : _store = store ?? EntryStore.instance,
        _tags = tags ?? TagsProvider.instance,
        _entryImages = entryImages ?? EntryImagesProvider.instance,
        _locationService = locationService,
        _weatherService = weatherService,
        _weathers = weathers ?? WeatherProvider.instance,
        _clock = clock ?? DateTime.now,
        isNew = entry == null,
        _images = [for (final image in images) image.copy()] {
    _draftSession = _store.beginDraft(entry);
    final ({String title, String body}) baseline;
    if (entry == null) {
      final now = _clock();
      // Asking only makes sense when no day was chosen for the entry.
      askDay = diaryDay == null && DiaryDay.asks(now);
      // A comment carried over to the full editor keeps its own words.
      final defaultTemplate = template ??
          (refs != null
              ? null
              : (templates ?? TemplatesProvider.instance).getDefaultTemplate());
      this.refs = [...?refs];
      final templateText = defaultTemplate?.text ?? '';
      // Built-in templates are not stored, so they carry no tags.
      final templateTagIds = [
        if (defaultTemplate?.id case final id?)
          for (final templateTag in _tags.getTemplateTagsForTemplate(id))
            templateTag.tagId
      ];
      // A template that starts with a heading names the entry.
      baseline = splitEntryTitle(templateText);
      final seeded = splitEntryTitle(mergeSharedText(templateText, sharedText));
      tagSource = TagAttachmentSource(
          supportsValues: true, initialTagIds: templateTagIds);
      _entry = Entry(
        title: seeded.title,
        text: seeded.body,
        mood: initialMood,
        timeCreate: now,
        timeModified: now,
        day: diaryDay,
      );
    } else {
      _entry = entry;
      _id = entry.id ?? -1;
      tagSource =
          TagAttachmentSource.fromEntryTags(_tags.getEntryTagsForEntry(_id));
      this.refs = [...LinksProvider.instance.refsOf(_id)];
      baseline = (title: entry.title, body: entry.text);
      if (sharedText != null) {
        _entry = entry.copy(text: mergeSharedText(entry.text, sharedText));
      }
    }
    _unsaved = isNew;
    _dirty = EntryDraftDirtyTracker(
      title: baseline.title,
      text: baseline.body,
      // A preselected mood is a choice the user made, so it is a change.
      mood: isNew ? null : _entry.mood,
      date: _entry.timeCreate,
      day: _entry.day,
      location: isNew ? null : _entry.location,
      seededTagIds: tagSource.attachedTagIds.toSet(),
    );
    mood = _entry.mood;
    location = _entry.location;
    writtenAt = _entry.timeCreate;
    // The parameter of the same name only seeds a new entry.
    this.diaryDay = _entry.day;
    title = _entry.title;
    text = _entry.text;
    tagSource.addListener(_markEdited);
  }

  final EntryStore _store;
  final TagsProvider _tags;
  final EntryImagesProvider _entryImages;
  final LocationService? _locationService;
  final WeatherService? _weatherService;
  final WeatherProvider _weathers;
  final DateTime Function() _clock;

  /// How long after the last change a draft is saved.
  final Duration saveDelay;

  /// Runs when an entry for today is saved, such as clearing today's
  /// writing reminder.
  final Future<void> Function()? onSavedForToday;

  late final EntryDraftSession _draftSession;
  late final EntryDraftDirtyTracker _dirty;
  late Entry _entry;
  int _id = -1;
  List<EntryImage> _images;
  Timer? _saveTimer;

  /// Opened to write a new entry, as opposed to editing one.
  final bool isNew;

  /// Not saved yet: a new entry until its first save.
  bool _unsaved = true;

  /// The entry as last saved, or as opened.
  Entry get entry => _entry;

  /// The title, empty when there is none, and the text below it.
  late String title;
  late String text;
  int? mood;
  EntryLocation? location;

  /// The weather of the diary day at the entry's place, which other entries
  /// of that day and place share.
  DayWeather? get weather => _weathers.of(diaryDay, location);

  /// When the entry was actually written.
  late DateTime writtenAt;

  /// The day it belongs to, chosen apart from [writtenAt].
  late DateTime diaryDay;

  /// Written in the hours that could mean either day: ask until answered.
  bool askDay = false;

  /// Looking up the current place for a new entry.
  bool locating = false;
  late final TagAttachmentSource tagSource;

  /// The entries it cites, in order.
  late List<EntryRef> refs;

  void cite(EntryRef ref) {
    if (refs.any(ref.sameAs)) return;
    refs = [...refs, ref];
    _markEdited();
  }

  void uncite(EntryRef ref) {
    refs = [
      for (final kept in refs)
        if (!kept.sameAs(ref)) kept
    ];
    _markEdited();
  }

  /// Photos, videos and voice notes, in order.
  List<EntryImage> get images => _images;

  /// Changed in this session; going back then asks whether to save.
  bool edited = false;

  /// The writer chose not to keep this session's changes.
  bool discarded = false;

  /// Being deleted; leaving does not save it again.
  bool deleting = false;

  /// Leaving can happen without asking.
  bool get canLeaveSilently => !edited;

  /// Place and weather now belong to a new entry about now, not one
  /// written later about a past day.
  bool get wantsCurrentContext =>
      isNew && diaryDay == DiaryDay.defaultFor(writtenAt);

  // Edits.

  /// The title and body as typed; selection moves are not edits.
  void setText(String title, String body) {
    final line = title.replaceAll('\n', ' ').trim();
    if (line == this.title && body == text) return;
    this.title = line;
    text = body;
    _markEdited();
  }

  void setMood(int? value) => _edit(() => mood = value);
  void setLocation(EntryLocation? value) => _edit(() => location = value);

  /// Sets the weather of the diary day at the entry's place, the writer's
  /// own unless looked up, or removes it with null; it is kept at once.
  Future<void> setWeather(EntryWeather? value,
      [WeatherSource source = WeatherSource.manual]) async {
    await _weathers.set(diaryDay, location, value, source);
    if (!_disposed) notifyListeners();
  }

  /// A place found for now does not belong to another day.
  void setDiaryDay(DateTime day) => _edit(() {
        diaryDay = DiaryDay.dateOf(day);
        askDay = false;
        if (location != null &&
            location == _filledLocation &&
            diaryDay != DiaryDay.defaultFor(writtenAt)) {
          location = null;
        }
      });

  /// Takes the tags of a template inserted into the text.
  void applyTemplateTags(Template template) {
    final id = template.id;
    if (id == null) return;
    for (final templateTag in _tags.getTemplateTagsForTemplate(id)) {
      tagSource.addTagId(templateTag.tagId);
    }
  }

  /// Reordered or removed attachments; saved at once.
  Future<void> setImages(List<EntryImage> images) {
    _images = images;
    notifyListeners();
    return save();
  }

  /// New attachment files; saved at once so they belong to an entry.
  Future<void> addAttachments(List<String> names) {
    _images = EntryImage.appendRanked(_images, names, entryId: _id);
    notifyListeners();
    return save();
  }

  void _edit(void Function() change) {
    change();
    _markEdited();
  }

  void _markEdited() {
    edited = true;
    notifyListeners();
    _saveTimer?.cancel();
    _saveTimer = Timer(saveDelay, save);
  }

  // Filled in, not edited.

  /// Where the device was found to be for this entry, while it is unchanged.
  EntryLocation? _filledLocation;

  /// Fills place and weather for a new entry when the settings ask for it.
  /// Anything set meanwhile is kept, and the filled place counts as
  /// untouched. Weather found is the day's at the entry's place, kept at
  /// once unless the day there already has some.
  Future<void> fillCurrentContext(
      {required bool place,
      required bool weather,
      String? languageCode}) async {
    if (!place && !weather) return;
    var here = location;
    if (here == null) {
      locating = true;
      notifyListeners();
      try {
        here = await (_locationService ?? LocationService())
            .current(languageCode: languageCode);
      } on LocationException {
        here = null;
      }
    }
    locating = false;
    if (place && location == null && here != null) {
      location = _filledLocation = here.withSource(LocationSource.gps);
      if (_unsaved) _dirty.adoptAutoFill(location: location);
    }
    if (weather && this.weather == null && (here?.hasCoordinates ?? false)) {
      final day = diaryDay;
      final at = location;
      final found = await (_weatherService ?? WeatherService())
          .at(here!.latitude!, here.longitude!, weatherTimeFor(day, writtenAt));
      if (found != null) {
        await _weathers.set(day, at, found, WeatherSource.queried);
      }
    }
    if (!_disposed) notifyListeners();
  }

  /// What a picked photo could tell the entry: the diary day it was taken
  /// on when that is another, and its place when the entry has none with
  /// coordinates. Null when it tells nothing new.
  Future<PhotoSuggestion?> suggestFromPhoto(PhotoMetadata photo,
      {String? languageCode}) async {
    final taken = photo.taken;
    final photoDay = taken == null ? null : DiaryDay.defaultFor(taken);
    final day = photoDay != diaryDay ? photoDay : null;
    final wantsPlace = photo.hasPlace && !(location?.hasCoordinates ?? false);
    if (day == null && !wantsPlace) return null;
    EntryLocation? place;
    if (wantsPlace) {
      final name = await (_locationService ?? LocationService()).placeName(
          photo.latitude!, photo.longitude!,
          languageCode: languageCode);
      place = EntryLocation(
          latitude: photo.latitude,
          longitude: photo.longitude,
          name: name,
          source: LocationSource.photo);
    }
    return (day: day, place: place);
  }

  /// Takes what the writer accepted from a photo; when it was written stays.
  void applyPhotoSuggestion(PhotoSuggestion suggestion) => _edit(() {
        if (suggestion.day case final day?) {
          diaryDay = day;
          askDay = false;
        }
        if (suggestion.place case final place?) location = place;
      });

  // Saving.

  /// Saves the draft now; a new entry with nothing in it is not saved.
  Future<void> save() async {
    _saveTimer?.cancel();
    if (_unsaved && !_hasNewEntryChanges()) return;
    final writes = _unsaved || _hasFieldChanges();
    final saved = await _draftSession.save(_buildDraft);
    _adoptSaved(saved);
    if (writes && diaryDay == DiaryDay.defaultFor(_clock())) {
      await onSavedForToday?.call();
    }
    if (!_disposed) notifyListeners();
  }

  /// Saves on the way out, unless discarded, and keeps the session.
  Future<void> leave() async {
    if (discarded) return;
    if (!deleting) await save();
    await _draftSession.commit();
  }

  /// Drops every change of this session, saved or not.
  Future<void> discard() async {
    discarded = true;
    _saveTimer?.cancel();
    await _draftSession.discard();
  }

  /// The app went to the background: keep what is written so far.
  Future<void> saveForBackground() => discarded ? Future.value() : save();

  /// Whether a new entry has anything worth keeping yet.
  bool get hasContent => !_unsaved || _hasNewEntryChanges();

  /// Readies the entry for deletion and returns it: a new one is saved
  /// first so its attachments go with it.
  Future<Entry> prepareDelete() async {
    deleting = true;
    _saveTimer?.cancel();
    if (_unsaved) await save();
    return _entry;
  }

  EntryDraft _buildDraft(Entry? saved) {
    if (saved != null) _adoptEntry(saved);
    final entry = _hasFieldChanges()
        ? _entry.copy(
            title: title,
            text: text,
            mood: mood,
            timeCreate: writtenAt,
            day: diaryDay,
            timeModified: _clock(),
            location: location,
          )
        : _entry;
    return EntryDraft(
      entry: entry,
      tags: tagSource.toEntryTags(_id),
      images: [for (final image in _images) image.copy()],
      refs: refs,
    );
  }

  void _adoptSaved(Entry saved) {
    _adoptEntry(saved);
    final persistedIds = {
      for (final image in _entryImages.getForEntry(saved))
        image.imgPath: image.id
    };
    _images = [
      for (final image in _images)
        image.copy(id: persistedIds[image.imgPath], entryId: saved.id)
    ];
  }

  void _adoptEntry(Entry saved) {
    _entry = saved;
    _id = saved.id!;
    _unsaved = false;
    _dirty.markSaved(
      title: saved.title,
      text: saved.text,
      mood: saved.mood,
      date: saved.timeCreate,
      day: saved.day,
      location: saved.location,
    );
  }

  bool _hasFieldChanges() => _dirty.hasFieldChanges(
      title: title,
      text: text,
      mood: mood,
      date: writtenAt,
      day: diaryDay,
      location: location);

  bool _hasNewEntryChanges() => _dirty.hasUnsavedChanges(
        title: title,
        text: text,
        mood: mood,
        date: writtenAt,
        day: diaryDay,
        tagSource: tagSource,
        hasImages: _images.isNotEmpty,
        location: location,
      );

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _saveTimer?.cancel();
    tagSource.removeListener(_markEdited);
    tagSource.dispose();
    super.dispose();
  }
}

/// Reads the auto-fill settings for [EditEntryViewModel.fillCurrentContext].
({bool place, bool weather}) autoFillSettings(ConfigProvider config) => (
      place: config.get(Settings.autoAddLocation),
      weather: config.get(Settings.autoAddWeather),
    );
