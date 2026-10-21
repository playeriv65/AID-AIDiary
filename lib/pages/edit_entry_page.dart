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
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/widgets/entry_image_actions.dart';
import 'package:aid_diary/widgets/entry_mood_picker.dart';
import 'package:aid_diary/widgets/location_dialog.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:aid_diary/widgets/context_dialogs.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:aid_diary/config_provider.dart';
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

  /// The text below the title, as the editor first shows it.
  String _body = "";
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

  /// The optional title, kept as the text's first line (see
  /// [splitEntryTitle]); [_textEditingController] holds the rest.
  final TextEditingController _titleController = TextEditingController();
  bool _locating = false;
  final UndoHistoryController _undoController = UndoHistoryController();
  bool _deletingEntry = false;

  /// Set once the user chose not to keep this session's changes.
  bool _discarded = false;
  bool _newEntry = false;
  bool _creatingNewEntry = false;

  /// Whether anything changed in this session; the close button then reads
  /// as "done". Leaving saves either way.
  bool _edited = false;
  late TagAttachmentSource _tagSource;
  late EntryDraftDirtyTracker _dirtyTracker;
  late final EntryDraftSession _draftSession =
      EntryStore.instance.beginDraft(widget.entry);

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
    final (:title, :body) = splitEntryTitle(text);
    _titleController.text = title;
    _body = body;
    text = joinEntryTitle(title, body);
    // Selection moves notify too; only text changes are edits.
    void textChanged() {
      final joined =
          joinEntryTitle(_titleController.text, _textEditingController.text);
      if (joined == text) return;
      text = joined;
      _scheduleSave();
    }

    _titleController.addListener(textChanged);
    _textEditingController.addListener(textChanged);
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

    if (_newEntry && TimeManager.isToday(entryDate!)) {
      // Needs the locale, which initState may not read yet.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _autoFillContext();
      });
    }
  }

  /// Fills place and weather for a new entry when the settings ask for it.
  /// Anything the user set meanwhile is left alone, and filled values count
  /// as the untouched baseline.
  Future<void> _autoFillContext() async {
    final config = ConfigProvider.instance;
    final wantLocation = config.get(Settings.autoAddLocation);
    final wantWeather = config.get(Settings.autoAddWeather);
    if (!wantLocation && !wantWeather) return;

    var place = location;
    if (place == null) {
      setState(() => _locating = true);
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
    if (!mounted) return;
    setState(() {
      _locating = false;
      if (wantLocation && location == null) location = place;
      weather ??= found;
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
    _titleController.dispose();
    _undoController.dispose();
    EasyDebounce.cancel("save-entry");
    _tagSource.removeListener(_onTagsChanged);
    _tagSource.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden && !_discarded) {
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

  /// Asks whether to keep the changes when going back over them.
  Future<void> _confirmLeave() async {
    final l10n = AppLocalizations.of(context)!;
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editorLeaveTitle),
        actions: [
          TextButton(
              key: const ValueKey('editor-leave-discard'),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.editorLeaveDiscard)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          FilledButton(
              key: const ValueKey('editor-leave-save'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(MaterialLocalizations.of(context).saveButtonLabel)),
        ],
      ),
    );
    if (save == null || !mounted) return;
    if (!save) {
      _discarded = true;
      EasyDebounce.cancel("save-entry");
      await _draftSession.discard();
      if (!mounted) return;
    }
    // Pops past the PopScope; leaving then saves unless discarded.
    Navigator.of(context).pop();
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
            // Going back over changes asks first; the done button does not.
            canPop: !_edited,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) return _confirmLeave();
              if (_discarded) return;
              if (!_deletingEntry) await _saveEntry();
              await _draftSession.commit();
            },
            child: Scaffold(
              appBar: AppBar(
                  titleSpacing: 0,
                  title: _buildDateTitle(context, theme),
                  leading: _closeButton(),
                  actions: [
                    _tagsButton(),
                    if (!_creatingNewEntry) _deleteButton(),
                  ]),
              body: EditorActionBarOverlay(
                keyboardInset: keyboardInset,
                // Like a page: title, writing, then what goes with it.
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final sidePadding =
                        ((constraints.maxWidth - _pageWidth) / 2)
                            .clamp(0.0, double.infinity);
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                          sidePadding + 8,
                          8,
                          sidePadding + 8,
                          24 + EditorActionBar.reservedHeight(context)),
                      children: [
                        _buildTitleField(theme),
                        _buildBodyEditor(context),
                        const SizedBox(height: 16),
                        _buildMedia(context),
                        const SizedBox(height: 16),
                        _buildMetaRows(context),
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

  /// The optional title: a large centred line that is simply left out of
  /// the entry when empty.
  Widget _buildTitleField(ThemeData theme) {
    return TextField(
      key: const ValueKey('editor-title'),
      controller: _titleController,
      textAlign: TextAlign.center,
      maxLines: null,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      onSubmitted: (_) => _focusNode.requestFocus(),
      style:
          theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: AppLocalizations.of(context)!.editorTitleHint,
      ),
    );
  }

  /// The writing itself; it grows with the text, and the space below the
  /// last line still takes a tap.
  Widget _buildBodyEditor(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        EditorKeyboardSessionScope.maybeOf(context)?.resume();
        _focusNode.requestFocus();
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 200),
        child: Align(
          alignment: Alignment.topCenter,
          child: EntryTextEditor(
            text: _body,
            expands: false,
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
    );
  }

  /// The entry's photos, videos and voice notes, then a tile to add more.
  Widget _buildMedia(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final add = Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox.square(
        dimension: 104,
        child: Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: cs.surfaceContainerHigh,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const ValueKey('editor-add-media'),
            onTap: _addMedia,
            child:
                Icon(Icons.add_rounded, size: 36, color: cs.onSurfaceVariant),
          ),
        ),
      ),
    );
    if (_currentImages.isEmpty) return add;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      EntryImageEditableList(
          images: _currentImages,
          onImagesChanged: (images) async {
            _currentImages = images;
            await _saveEntry();
          }),
      const SizedBox(height: 8),
      add,
    ]);
  }

  /// Weather and place, filled in on their own for a new entry, then tags.
  Widget _buildMetaRows(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    Widget row(Key key, IconData icon, String? value, String placeholder,
            VoidCallback? onTap,
            {VoidCallback? onClear}) =>
        ListTile(
          key: key,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Icon(icon, size: 20, color: cs.onSurfaceVariant),
          title: Text(value ?? placeholder,
              style:
                  value == null ? TextStyle(color: cs.onSurfaceVariant) : null),
          trailing: value == null || onClear == null
              ? null
              : IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip:
                      MaterialLocalizations.of(context).deleteButtonTooltip,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: onClear),
          onTap: onTap,
        );

    return ListenableBuilder(
      listenable: _tagSource,
      builder: (context, _) {
        final attachedIds = _tagSource.attachedTagIds.toSet();
        final tags = Provider.of<TagsProvider>(context)
            .tags
            .where((t) => attachedIds.contains(t.id))
            .toList();
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(
                  const ValueKey('editor-weather'),
                  weather == null
                      ? Icons.wb_sunny_outlined
                      : weatherIcon(weather!.code),
                  weather == null ? null : weatherSummary(weather!, l10n),
                  l10n.weatherTitle,
                  _chooseWeather,
                  onClear: () => _setWeather(null)),
              row(
                  const ValueKey('editor-location'),
                  Icons.place_outlined,
                  location?.label,
                  _locating ? l10n.editorLocating : l10n.locationTitle,
                  _chooseLocation,
                  onClear: () => _setLocation(null)),
              // Only imported entries still carry one.
              if (activity != null)
                row(const ValueKey('editor-activity'), activityIcon(activity!),
                    activityLabel(activity!, l10n), '', null,
                    onClear: () => _setActivity(null)),
              if (tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Wrap(spacing: 8, runSpacing: 8, children: [
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
                ),
            ]);
      },
    );
  }

  /// Groups the entry, as the one action used on nearly every entry.
  Widget _tagsButton() => IconButton(
        key: const ValueKey('editor-tags'),
        tooltip: AppLocalizations.of(context)!.toolbarTags,
        icon: const Icon(Icons.local_offer_outlined),
        onPressed: () => showDialog(
          context: context,
          builder: (_) =>
              TagPickerDialog(mode: TagPickerMode.attach, source: _tagSource),
        ),
      );

  /// The entry's date and time as the page title, with its mood beside it;
  /// tapping the date changes date and time.
  Widget _buildDateTitle(BuildContext context, ThemeData theme) {
    final cs = theme.colorScheme;
    final hasMood = MoodIcon.getMoodIcon(mood).isNotEmpty;
    final date = entryDate!;
    final day = date.year == DateTime.now().year
        ? TimeManager.formatMonthDay(date, context)
        : TimeManager.formatDate(date, context);
    final time =
        TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(date));
    final weekday =
        DateFormat.E(TimeManager.currentLocale(context)).format(date);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: InkWell(
          key: const ValueKey('editor-date'),
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            if (await _chooseDate()) await _chooseTime();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: day,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                TextSpan(
                    text: '  /  $time $weekday',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      IconButton(
        key: const ValueKey('editor-mood'),
        tooltip: AppLocalizations.of(context)!.tagMoodTitle,
        onPressed: _chooseMood,
        icon: hasMood
            ? MoodIcon(moodValue: mood, size: 24)
            : Icon(Icons.add_reaction_outlined, color: cs.onSurfaceVariant),
      ),
    ]);
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

  /// Offers ways to add an attachment, then runs the chosen one.
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

  Future<void> _pickFromGallery() {
    final messenger = ScaffoldMessenger.of(context);
    final tooLarge = AppLocalizations.of(context)!.mediaTooLarge;
    return EntryImageActions.pickFromGallery(_addImage,
        onMetadata: _offerPhotoMetadata,
        onVideo: (file) => MediaActions.addPickedVideo(file, _addImage,
            onTooLarge: () =>
                messenger.showSnackBar(SnackBar(content: Text(tooLarge)))));
  }

  /// Gallery, photo or video; only phones have a camera to offer.
  Future<void> _addMedia() {
    final l10n = AppLocalizations.of(context)!;
    if (!Platform.isAndroid) return _pickFromGallery();
    return _chooseAttachment([
      (Icons.photo_library_outlined, l10n.mediaFromGallery, _pickFromGallery),
      (
        Icons.photo_camera_rounded,
        l10n.actionTakePhoto,
        () => EntryImageActions.takePhoto(_addImage)
      ),
      (
        Icons.videocam_rounded,
        l10n.videoRecord,
        () => MediaActions.pickVideo(context, _addImage, camera: true)
      ),
    ]);
  }

  List<ToolbarAction> _buildMainActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Only what is reached for while writing; place and weather sit below
    // the text, mood by the date and tags at the top.
    return [
      ToolbarAction(
        icon: const Icon(Icons.photo_camera_outlined),
        tooltip: l10n.toolbarMedia,
        mayLeaveApp: true,
        onPressed: _addMedia,
      ),
      ToolbarAction(
        icon: const Icon(Icons.mic_none_rounded),
        tooltip: l10n.toolbarAudio,
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
    ];
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
