// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
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
    EntryStore? store,
    TagsProvider? tags,
    TemplatesProvider? templates,
    EntryImagesProvider? entryImages,
    LocationService? locationService,
    WeatherService? weatherService,
    DateTime Function()? clock,
    this.saveDelay = const Duration(seconds: 5),
    this.onSavedForToday,
  })  : _store = store ?? EntryStore.instance,
        _tags = tags ?? TagsProvider.instance,
        _entryImages = entryImages ?? EntryImagesProvider.instance,
        _locationService = locationService,
        _weatherService = weatherService,
        _clock = clock ?? DateTime.now,
        isNew = entry == null,
        _images = [for (final image in images) image.copy()] {
    _draftSession = _store.beginDraft(entry);
    final String baselineText;
    if (entry == null) {
      final now = _clock();
      // Asking only makes sense when no day was chosen for the entry.
      askDay = diaryDay == null && DiaryDay.asks(now);
      final defaultTemplate = template ??
          (templates ?? TemplatesProvider.instance).getDefaultTemplate();
      final templateText = defaultTemplate?.text ?? '';
      // Built-in templates are not stored, so they carry no tags.
      final templateTagIds = [
        if (defaultTemplate?.id case final id?)
          for (final templateTag in _tags.getTemplateTagsForTemplate(id))
            templateTag.tagId
      ];
      baselineText = templateText;
      tagSource = TagAttachmentSource(
          supportsValues: true, initialTagIds: templateTagIds);
      _entry = Entry(
        text: mergeSharedText(templateText, sharedText),
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
      baselineText = entry.text;
      if (sharedText != null) {
        _entry = entry.copy(text: mergeSharedText(entry.text, sharedText));
      }
    }
    _unsaved = isNew;
    _dirty = EntryDraftDirtyTracker(
      text: baselineText,
      // A preselected mood is a choice the user made, so it is a change.
      mood: isNew ? null : _entry.mood,
      date: _entry.timeCreate,
      day: _entry.day,
      location: isNew ? null : _entry.location,
      weather: isNew ? null : _entry.weather,
      activity: isNew ? null : _entry.activity,
      seededTagIds: tagSource.attachedTagIds.toSet(),
    );
    mood = _entry.mood;
    location = _entry.location;
    weather = _entry.weather;
    activity = _entry.activity;
    writtenAt = _entry.timeCreate;
    // The parameter of the same name only seeds a new entry.
    this.diaryDay = _entry.day;
    final (:title, :body) = splitEntryTitle(_entry.text);
    initialTitle = title;
    initialBody = body;
    text = joinEntryTitle(title, body);
    tagSource.addListener(_markEdited);
  }

  /// Shared text goes below the entry's own, after a blank line.
  static String mergeSharedText(String baseText, String? sharedText) {
    if (sharedText == null) return baseText;
    return baseText.isEmpty ? sharedText : '$baseText\n\n$sharedText';
  }

  final EntryStore _store;
  final TagsProvider _tags;
  final EntryImagesProvider _entryImages;
  final LocationService? _locationService;
  final WeatherService? _weatherService;
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

  /// The title and body the editor's fields start with.
  late final String initialTitle;
  late final String initialBody;

  /// The whole text: the title, if any, above the body.
  late String text;
  int? mood;
  EntryLocation? location;
  EntryWeather? weather;

  /// Only imported entries still carry one.
  EntryActivity? activity;

  /// When the entry was actually written.
  late DateTime writtenAt;

  /// The day it belongs to, chosen apart from [writtenAt].
  late DateTime diaryDay;

  /// Written in the hours that could mean either day: ask until answered.
  bool askDay = false;

  /// Looking up the current place for a new entry.
  bool locating = false;
  late final TagAttachmentSource tagSource;

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
    final joined = joinEntryTitle(title, body);
    if (joined == text) return;
    text = joined;
    _markEdited();
  }

  void setMood(int? value) => _edit(() => mood = value);
  void setLocation(EntryLocation? value) => _edit(() => location = value);
  void setWeather(EntryWeather? value) => _edit(() => weather = value);
  void setActivity(EntryActivity? value) => _edit(() => activity = value);
  void setWrittenAt(DateTime value) => _edit(() => writtenAt = value);

  void setDiaryDay(DateTime day) => _edit(() {
        diaryDay = DiaryDay.dateOf(day);
        askDay = false;
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

  /// Fills place and weather for a new entry when the settings ask for it.
  /// Anything set meanwhile is kept, and filled values count as untouched.
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
    EntryWeather? found;
    if (weather && this.weather == null && (here?.hasCoordinates ?? false)) {
      found = await (_weatherService ?? WeatherService())
          .at(here!.latitude!, here.longitude!, writtenAt);
    }
    locating = false;
    if (place && location == null) location = here;
    this.weather ??= found;
    if (_unsaved) {
      _dirty.adoptAutoFill(
          location: location, weather: this.weather, activity: activity);
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
          latitude: photo.latitude, longitude: photo.longitude, name: name);
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
            text: text,
            mood: mood,
            timeCreate: writtenAt,
            day: diaryDay,
            timeModified: _clock(),
            location: location,
            weather: weather,
            activity: activity,
          )
        : _entry;
    return EntryDraft(
      entry: entry,
      tags: tagSource.toEntryTags(_id),
      images: [for (final image in _images) image.copy()],
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
      text: saved.text,
      mood: saved.mood,
      date: saved.timeCreate,
      day: saved.day,
      location: saved.location,
      weather: saved.weather,
      activity: saved.activity,
    );
  }

  bool _hasFieldChanges() => _dirty.hasFieldChanges(
      text: text,
      mood: mood,
      date: writtenAt,
      day: diaryDay,
      location: location,
      weather: weather,
      activity: activity);

  bool _hasNewEntryChanges() => _dirty.hasUnsavedChanges(
        text: text,
        mood: mood,
        date: writtenAt,
        day: diaryDay,
        tagSource: tagSource,
        hasImages: _images.isNotEmpty,
        location: location,
        weather: weather,
        activity: activity,
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
