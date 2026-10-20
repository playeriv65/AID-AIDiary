// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/widgets/entry_draft_dirty_tracker.dart';
import 'package:aid_diary/widgets/tag_attachment_source.dart';
import 'package:aid_diary/widgets/tag_picker_dialog.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:provider/provider.dart';
import 'package:aid_diary/pages/full_screen_text_editor_page.dart';
import 'package:aid_diary/widgets/editor_action_bar.dart';
import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:aid_diary/widgets/entry_image_editable_list.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/widgets/entry_image_actions.dart';
import 'package:aid_diary/widgets/entry_mood_picker.dart';
import 'package:aid_diary/widgets/location_dialog.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:aid_diary/widgets/context_dialogs.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/services/activity_service.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/entry_text_edit.dart';
import 'package:aid_diary/widgets/template_select_popup.dart';
import 'package:aid_diary/widgets/markdown_preview_controller.dart';

class AddEditEntryPage extends StatefulWidget {
  final Entry? entry;
  final DateTime? overrideCreateDate;
  final bool openCamera;
  final List<EntryImage> images;
  final String? sharedText;

  /// Mood preselected for a new entry, e.g. from the Today page.
  final int? initialMood;

  /// Template for a new entry in place of the default one.
  final Template? template;

  const AddEditEntryPage({
    super.key,
    this.entry,
    this.overrideCreateDate,
    this.openCamera = false,
    this.images = const <EntryImage>[],
    this.sharedText,
    this.initialMood,
    this.template,
  });

  static String mergeSharedText(String baseText, String? sharedText) {
    if (sharedText == null) return baseText;
    return baseText.isEmpty ? sharedText : '$baseText\n\n$sharedText';
  }

  @override
  State<AddEditEntryPage> createState() => _AddEditEntryPageState();
}

class _AddEditEntryPageState extends State<AddEditEntryPage>
    with WidgetsBindingObserver {
  static const double _pageWidth = 800;

  late Entry _entry;
  int id = -1;
  String text = "";
  int? mood;
  EntryLocation? location;
  EntryWeather? weather;
  EntryActivity? activity;
  DateTime? entryDate;
  late List<EntryImage> _currentImages;
  bool _loadingEntry = true;
  bool _openedCamera = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final MarkdownPreviewController _textEditingController =
      MarkdownPreviewController();
  final UndoHistoryController _undoController = UndoHistoryController();
  bool _deletingEntry = false;
  bool _newEntry = false;
  bool _creatingNewEntry = false;

  /// Whether anything changed in this session; the close button then reads
  /// as "done". Leaving saves either way.
  bool _edited = false;
  late TagAttachmentSource _tagSource;
  late EntryDraftDirtyTracker _dirtyTracker;
  late final EntryDraftSession _draftSession = EntryStore.instance.beginDraft();

  Future<void> _initEntry() async {
    String dirtyTrackerBaselineText;
    if (widget.entry == null) {
      var createTime =
          (TimeManager.isToday(widget.overrideCreateDate ?? DateTime.now()))
              ? DateTime.now()
              : (widget.overrideCreateDate ?? DateTime.now());
      var templateText = "";
      final defaultTemplate =
          widget.template ?? TemplatesProvider.instance.getDefaultTemplate();
      final defaultTagIds = <int>[];
      if (defaultTemplate != null) {
        templateText = defaultTemplate.text ?? "";
        // Built-in templates are not stored, so they carry no tags.
        if (defaultTemplate.id != null) {
          defaultTagIds.addAll(TagsProvider.instance
              .getTemplateTagsForTemplate(defaultTemplate.id!)
              .map((templateTag) => templateTag.tagId));
        }
      }
      dirtyTrackerBaselineText = templateText;
      _tagSource = TagAttachmentSource(
          supportsValues: true, initialTagIds: defaultTagIds);
      _entry = Entry(
        text: AddEditEntryPage.mergeSharedText(templateText, widget.sharedText),
        mood: widget.initialMood,
        timeCreate: createTime,
        timeModified: DateTime.now(),
      );
      _newEntry = true;
      _creatingNewEntry = true;
      id = -1;
    } else {
      _entry = widget.entry!;
      id = _entry.id ?? -1;
      _tagSource = TagAttachmentSource.fromEntryTags(
          TagsProvider.instance.getEntryTagsForEntry(id));
      dirtyTrackerBaselineText = _entry.text;
      if (widget.sharedText != null) {
        _entry = _entry.copy(
          text:
              AddEditEntryPage.mergeSharedText(_entry.text, widget.sharedText),
        );
      }
    }
    _dirtyTracker = EntryDraftDirtyTracker(
      text: dirtyTrackerBaselineText,
      // A preselected mood is a choice the user made, so it is a change.
      mood: widget.entry == null ? null : _entry.mood,
      date: _entry.timeCreate,
      location: widget.entry == null ? null : _entry.location,
      weather: widget.entry == null ? null : _entry.weather,
      activity: widget.entry == null ? null : _entry.activity,
      seededTagIds: _tagSource.attachedTagIds.toSet(),
    );
    _tagSource.addListener(_onTagsChanged);
    mood = _entry.mood;
    location = _entry.location;
    weather = _entry.weather;
    activity = _entry.activity;
    entryDate = _entry.timeCreate;
    text = _entry.text;
    _textEditingController.addListener(() {
      text = _textEditingController.text;
      _scheduleSave();
    });
    setState(() {
      _loadingEntry = false;
    });

    if (widget.sharedText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _textEditingController.selection =
            TextSelection.collapsed(offset: _textEditingController.text.length);
      });
    }

    if (widget.openCamera && !_openedCamera) {
      _openedCamera = true;
      EntryImageActions.takePhoto(_addImage);
    }

    if (_newEntry && TimeManager.isToday(entryDate!)) _autoFillContext();
  }

  /// Fills place, weather and activity for a new entry when the settings
  /// ask for it. Anything the user set meanwhile is left alone, and filled
  /// values count as the untouched baseline.
  Future<void> _autoFillContext() async {
    final config = ConfigProvider.instance;
    final wantLocation = config.get(Settings.autoAddLocation);
    final wantWeather = config.get(Settings.autoAddWeather);
    final wantActivity = config.get(Settings.autoAddActivity);
    if (!wantLocation && !wantWeather && !wantActivity) return;

    var place = location;
    if ((wantLocation || wantWeather) && place == null) {
      try {
        final language = mounted
            ? TimeManager.currentLocale(context).split('_').first
            : null;
        place = await LocationService().current(languageCode: language);
      } on LocationException {
        place = null;
      }
    }
    EntryWeather? found;
    if (wantWeather && weather == null && (place?.hasCoordinates ?? false)) {
      found = await WeatherService()
          .at(place!.latitude!, place.longitude!, entryDate!);
    }
    EntryActivity? detected;
    if (wantActivity && activity == null && ActivityService.supported) {
      detected = await ActivityService().current();
    }
    if (!mounted) return;
    setState(() {
      if (wantLocation && location == null) location = place;
      weather ??= found;
      activity ??= detected;
    });
    if (_newEntry) {
      _dirtyTracker.adoptAutoFill(
          location: location, weather: weather, activity: activity);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentImages = List.empty(growable: true);
    for (var image in widget.images) {
      _currentImages.add(image.copy());
    }
    _initEntry();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
    _undoController.dispose();
    EasyDebounce.cancel("save-entry");
    _tagSource.removeListener(_onTagsChanged);
    _tagSource.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      _saveEntry();
    }
  }

  Future<void> _openFullScreenEditor() async {
    final result =
        await Navigator.of(context, rootNavigator: true).push<String>(
      MaterialPageRoute(
        allowSnapshotting: false,
        builder: (context) => FullScreenTextEditorPage(
          initialText: _textEditingController.text,
        ),
      ),
    );
    if (result != null) {
      _textEditingController.text = result;
    }
  }

  void _showDeleteEntryPopup() {
    if (_newEntry && !_hasNewEntryChanges()) {
      Navigator.of(context).pop();
      return;
    }
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteLogTitle),
          actions: [
            TextButton(
              child:
                  Text(MaterialLocalizations.of(context).deleteButtonTooltip),
              onPressed: () async {
                _deletingEntry = true;
                EasyDebounce.cancel("save-entry");
                final navigator = Navigator.of(context);
                if (_newEntry) {
                  // Persist so there is a saved entry (and any images) to delete
                  await _saveEntry();
                }
                final entryToDelete = _entry;
                // Pop dialog
                navigator.pop();
                // Pop edit page
                navigator.pop();
                if (!_creatingNewEntry && navigator.canPop()) {
                  // Pop view page
                  navigator.pop();
                }
                await EntryStore.instance.delete(entryToDelete);
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
          content: Text(AppLocalizations.of(context)!.deleteLogDescription),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardInset = EditorActionBarOverlay.keyboardInsetOf(context);

    return _loadingEntry
        ? Scaffold()
        : PopScope(
            onPopInvokedWithResult: (didPop, result) async {
              if (!_deletingEntry) {
                await _saveEntry();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: _buildDateTitle(context, theme),
                  leading: _closeButton(),
                  actions: [if (!_creatingNewEntry) _deleteButton()]),
              body: EditorActionBarOverlay(
                keyboardInset: keyboardInset,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final sidePadding =
                        ((constraints.maxWidth - _pageWidth) / 2)
                            .clamp(0.0, double.infinity);
                    final capPadding =
                        EdgeInsets.symmetric(horizontal: sidePadding);
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: capPadding,
                          sliver: SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (_currentImages.isNotEmpty)
                                    EntryImageEditableList(
                                        images: _currentImages,
                                        onImagesChanged: (images) async {
                                          _currentImages = images;
                                          await _saveEntry();
                                        }),
                                  _buildMetaStrip(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: capPadding,
                          sliver: _buildTextEditorSliver(context),
                        ),
                      ],
                    );
                  },
                ),
                actionBar: EditorActionBar(
                  controller: _textEditingController,
                  undoController: _undoController,
                  focusNode: _focusNode,
                  onTemplateInserted: _applyInsertedTemplateTags,
                  mainActions: _buildMainActions(context),
                ),
              ),
            ),
          );
  }

  /// Mood, place and tags already set, as removable chips.
  Widget _buildMetaStrip(BuildContext context) {
    return ListenableBuilder(
      listenable: _tagSource,
      builder: (context, _) {
        final attachedIds = _tagSource.attachedTagIds.toSet();
        final tagsProvider = Provider.of<TagsProvider>(context);
        final tags =
            tagsProvider.tags.where((t) => attachedIds.contains(t.id)).toList();
        final hasMood = MoodIcon.getMoodIcon(mood).isNotEmpty;
        if (!hasMood &&
            location == null &&
            weather == null &&
            activity == null &&
            tags.isEmpty) {
          return const SizedBox(height: 8);
        }
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            if (hasMood)
              InputChip(
                key: const ValueKey('editor-mood-chip'),
                avatar: MoodIcon(moodValue: mood, size: 16),
                label: Text(AppLocalizations.of(context)!.tagMoodTitle),
                onPressed: _chooseMood,
                onDeleted: () => _setMood(null),
              ),
            if (location != null)
              InputChip(
                key: const ValueKey('editor-location-chip'),
                avatar: const Icon(Icons.place_rounded, size: 16),
                label: Text(location!.label),
                onPressed: _chooseLocation,
                onDeleted: () => _setLocation(null),
              ),
            if (weather != null)
              InputChip(
                key: const ValueKey('editor-weather-chip'),
                avatar: Icon(weatherIcon(weather!.code), size: 16),
                label: Text(weatherSummary(weather!, l10n)),
                onPressed: _chooseWeather,
                onDeleted: () => _setWeather(null),
              ),
            if (activity != null)
              InputChip(
                key: const ValueKey('editor-activity-chip'),
                avatar: Icon(activityIcon(activity!), size: 16),
                label: Text(activityLabel(activity!, l10n)),
                onPressed: _chooseActivity,
                onDeleted: () => _setActivity(null),
              ),
            for (final tag in tags)
              TagChip(
                tag: tag,
                value: _tagSource.valueFor(tag.id!),
                onTap: tag.tagType == TagType.tracker
                    ? () => _tagSource.editValue(context, tag)
                    : null,
                onRemove: () => _tagSource.detach(tag.id!),
              ),
          ]),
        );
      },
    );
  }

  /// The entry date as the page title; tapping it changes date and time.
  Widget _buildDateTitle(BuildContext context, ThemeData theme) {
    return TextButton(
      key: const ValueKey('editor-date'),
      onPressed: () async {
        if (await _chooseDate()) await _chooseTime();
      },
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
          child: Text(
            TimeManager.formatDate(entryDate!, context).toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700),
          ),
        ),
        Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.primary),
      ]),
    );
  }

  void _setMood(int? value) {
    setState(() => mood = value);
    _scheduleSave();
  }

  Future<void> _chooseMood() async {
    var picked = mood;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.tagMoodTitle),
        content: SizedBox(
          width: 320,
          child: EntryMoodPicker(
              moodValue: picked, onChangedMood: (value) => picked = value),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          FilledButton(
              key: const ValueKey('editor-mood-ok'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(MaterialLocalizations.of(context).okButtonLabel)),
        ],
      ),
    );
    if (confirmed == true) _setMood(picked);
  }

  void _setLocation(EntryLocation? value) {
    setState(() => location = value);
    _scheduleSave();
  }

  Future<void> _chooseLocation() async {
    final choice = await showLocationDialog(context, location);
    if (choice != null) _setLocation(choice.location);
  }

  /// Like Journey, offers a picked photo's time and place for the entry:
  /// the time when it is over an hour off, the place when the entry has
  /// none with coordinates.
  Future<void> _offerPhotoMetadata(PhotoMetadata photo) async {
    final l10n = AppLocalizations.of(context)!;
    final taken = photo.taken;
    final newDate = taken != null &&
            taken.difference(entryDate!).abs() > const Duration(hours: 1)
        ? taken
        : null;
    final newPlace = photo.hasPlace && !(location?.hasCoordinates ?? false);
    if (newDate == null && !newPlace) return;
    final language = TimeManager.currentLocale(context).split('_').first;
    String? placeLabel;
    EntryLocation? place;
    if (newPlace) {
      final name = await LocationService()
          .placeName(photo.latitude!, photo.longitude!, languageCode: language);
      place = EntryLocation(
          latitude: photo.latitude, longitude: photo.longitude, name: name);
      placeLabel = place.label;
    }
    if (!mounted) return;
    final dateLabel = newDate == null
        ? null
        : '${TimeManager.formatDate(newDate, context)} '
            '${TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(newDate))}';
    final message = switch ((dateLabel, placeLabel)) {
      (final date?, final where?) => l10n.photoMetaDateAndPlace(date, where),
      (final date?, null) => l10n.photoMetaDate(date),
      (null, final where?) => l10n.photoMetaPlace(where),
      (null, null) => '',
    };
    final apply = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.photoMetaTitle),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          FilledButton(
              key: const ValueKey('photo-meta-apply'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.photoMetaApply)),
        ],
      ),
    );
    if (apply != true || !mounted) return;
    setState(() {
      if (newDate != null) entryDate = newDate;
      if (place != null) location = place;
    });
    _scheduleSave();
  }

  void _setWeather(EntryWeather? value) {
    setState(() => weather = value);
    _scheduleSave();
  }

  Future<void> _chooseWeather() async {
    final choice =
        await showWeatherDialog(context, weather, location, entryDate!);
    if (choice != null) _setWeather(choice.weather);
  }

  void _setActivity(EntryActivity? value) {
    setState(() => activity = value);
    _scheduleSave();
  }

  Future<void> _chooseActivity() async {
    final choice = await showActivityDialog(context, activity);
    if (choice != null) _setActivity(choice.activity);
  }

  /// Offers ways to add a video or voice note, then runs the chosen one.
  Future<void> _chooseAttachment(
      List<(IconData, String, Future<void> Function())> options) async {
    final chosen = await showModalBottomSheet<Future<void> Function()>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final (icon, label, action) in options)
            ListTile(
              key: ValueKey('attachment-$label'),
              leading: Icon(icon),
              title: Text(label),
              onTap: () => Navigator.of(context).pop(action),
            ),
        ]),
      ),
    );
    await chosen?.call();
  }

  List<ToolbarAction> _buildMainActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Same order as Journey: media, place, weather, activity, mood, tags.
    return [
      ToolbarAction(
        icon: const Icon(Icons.photo),
        mayLeaveApp: true,
        onPressed: () => EntryImageActions.pickFromGallery(_addImage,
            onMetadata: _offerPhotoMetadata),
      ),
      if (Platform.isAndroid)
        ToolbarAction(
          icon: const Icon(Icons.photo_camera_rounded),
          mayLeaveApp: true,
          onPressed: () => EntryImageActions.takePhoto(_addImage),
        ),
      ToolbarAction(
        icon: const Icon(Icons.videocam_outlined),
        mayLeaveApp: true,
        onPressed: () => _chooseAttachment([
          if (Platform.isAndroid)
            (
              Icons.videocam_rounded,
              l10n.videoRecord,
              () => MediaActions.pickVideo(context, _addImage, camera: true)
            ),
          (
            Icons.video_library_outlined,
            l10n.videoChoose,
            () => MediaActions.pickVideo(context, _addImage)
          ),
        ]),
      ),
      ToolbarAction(
        icon: const Icon(Icons.mic_none_rounded),
        mayLeaveApp: true,
        onPressed: () => _chooseAttachment([
          (
            Icons.mic_rounded,
            l10n.audioRecordTitle,
            () => MediaActions.recordAudio(context, _addImage)
          ),
          (
            Icons.audio_file_outlined,
            l10n.audioChoose,
            () => MediaActions.pickAudio(_addImage)
          ),
        ]),
      ),
      ToolbarAction(
        icon: const Icon(Icons.place_outlined),
        onPressed: _chooseLocation,
      ),
      ToolbarAction(
        icon: const Icon(Icons.wb_sunny_outlined),
        onPressed: _chooseWeather,
      ),
      ToolbarAction(
        icon: const Icon(Icons.directions_walk_rounded),
        onPressed: _chooseActivity,
      ),
      ToolbarAction(
        icon: const Icon(Icons.mood_rounded),
        onPressed: _chooseMood,
      ),
      ToolbarAction(
        icon: const Icon(Icons.local_offer_rounded),
        onPressed: () => showDialog(
          context: context,
          builder: (_) =>
              TagPickerDialog(mode: TagPickerMode.attach, source: _tagSource),
        ),
      ),
    ];
  }

  Widget _buildTextEditorSliver(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            EditorKeyboardSessionScope.maybeOf(context)?.resume();
            _focusNode.requestFocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) => EntryTextEditor(
                      text: text,
                      focusNode: _focusNode,
                      textEditingController: _textEditingController,
                      undoHistoryController: _undoController,
                      onExpand: _openFullScreenEditor,
                      onChooseTemplate: () => showTemplateSelectPopup(
                          context, _textEditingController,
                          hasFocus: _focusNode.hasFocus,
                          onTemplateSelected: _applyInsertedTemplateTags),
                    ),
                  ),
                ),
                SizedBox(height: 16 + EditorActionBar.reservedHeight(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteButton() => IconButton(
        key: const ValueKey('entry-delete'),
        tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
        icon: const Icon(Icons.delete_outline_rounded),
        onPressed: () => _showDeleteEntryPopup(),
      );

  // Leaving saves (see PopScope), so close and done are one button.
  Widget _closeButton() => IconButton(
        key: const ValueKey('entry-close'),
        tooltip: _edited
            ? MaterialLocalizations.of(context).saveButtonLabel
            : MaterialLocalizations.of(context).closeButtonTooltip,
        icon: Icon(_edited ? Icons.check_rounded : Icons.close_rounded),
        onPressed: () => Navigator.of(context).pop(),
      );

  Future<bool> _chooseDate() async {
    DateTime? pickedDate = await TimeManager.pickDate(
      context,
      initialDate: entryDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return false;

    entryDate = entryDate!.copyWith(
      year: pickedDate.year,
      month: pickedDate.month,
      day: pickedDate.day,
    );
    await _saveEntry();
    return true;
  }

  Future<void> _chooseTime() async {
    if (!mounted) return;
    final pickedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(entryDate!));
    if (pickedTime == null) return;

    entryDate = entryDate!.copyWith(
      hour: pickedTime.hour,
      minute: pickedTime.minute,
    );
    await _saveEntry();
  }

  void _scheduleSave() {
    // Every edit lands here; auto-filled context does not. Text set while
    // the editor builds also lands here, so redraw after the frame.
    if (!_edited) {
      _edited = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
      WidgetsBinding.instance.scheduleFrame();
    }
    EasyDebounce.debounce("save-entry", const Duration(seconds: 5), _saveEntry);
  }

  Future<void> _saveEntry() async {
    if (_newEntry && !_hasNewEntryChanges()) return;

    if ((_newEntry || _hasEntryFieldChanges()) &&
        Platform.isAndroid &&
        TimeManager.isSameDay(DateTime.now(), entryDate!)) {
      await NotificationManager.instance.dismissReminderNotification();
    }

    final saved = await _draftSession.save(_buildDraft);
    _adoptSavedEntry(saved);
    _adoptSavedImages(saved);
    if (mounted) {
      setState(() {});
    }
  }

  EntryDraft _buildDraft(Entry? saved) {
    if (saved != null) _adoptSavedEntry(saved);
    final entry = _hasEntryFieldChanges()
        ? _entry.copy(
            text: text,
            mood: mood,
            timeCreate: entryDate,
            timeModified: DateTime.now(),
            location: location,
            weather: weather,
            activity: activity,
          )
        : _entry;
    return EntryDraft(
      entry: entry,
      tags: _tagSource.toEntryTags(id),
      images: [for (final image in _currentImages) image.copy()],
    );
  }

  void _adoptSavedEntry(Entry saved) {
    _entry = saved;
    id = saved.id!;
    _newEntry = false;
    _dirtyTracker.markSaved(
      text: saved.text,
      mood: saved.mood,
      date: saved.timeCreate,
      location: saved.location,
      weather: saved.weather,
      activity: saved.activity,
    );
  }

  void _adoptSavedImages(Entry saved) {
    final persistedIds = {
      for (final image in EntryImagesProvider.instance.getForEntry(saved))
        image.imgPath: image.id
    };
    _currentImages = [
      for (final image in _currentImages)
        image.copy(id: persistedIds[image.imgPath], entryId: saved.id)
    ];
  }

  bool _hasEntryFieldChanges() {
    return _dirtyTracker.hasFieldChanges(
        text: text,
        mood: mood,
        date: entryDate!,
        location: location,
        weather: weather,
        activity: activity);
  }

  void _onTagsChanged() {
    _scheduleSave();
  }

  bool _hasNewEntryChanges() {
    return _dirtyTracker.hasUnsavedChanges(
      text: text,
      mood: mood,
      date: entryDate!,
      tagSource: _tagSource,
      hasImages: _currentImages.isNotEmpty,
      location: location,
      weather: weather,
      activity: activity,
    );
  }

  void _applyInsertedTemplateTags(Template template) {
    if (template.id == null) return;
    final templateTagIds = TagsProvider.instance
        .getTemplateTagsForTemplate(template.id!)
        .map((templateTag) => templateTag.tagId);
    for (final tagId in templateTagIds) {
      _tagSource.addTagId(tagId);
    }
  }

  Future<void> _addImage(List<String> imgPaths) async {
    _currentImages =
        EntryImage.appendRanked(_currentImages, imgPaths, entryId: id);
    await _saveEntry();
  }
}
