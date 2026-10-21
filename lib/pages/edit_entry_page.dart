// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/pages/edit_entry_view_model.dart';
import 'package:aid_diary/pages/full_screen_text_editor_page.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/utils/photo_metadata.dart';
import 'package:aid_diary/widgets/context_dialogs.dart';
import 'package:aid_diary/widgets/editor_action_bar.dart';
import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:aid_diary/widgets/entry_image_actions.dart';
import 'package:aid_diary/widgets/entry_image_editable_list.dart';
import 'package:aid_diary/widgets/entry_mood_picker.dart';
import 'package:aid_diary/widgets/entry_text_edit.dart';
import 'package:aid_diary/widgets/location_dialog.dart';
import 'package:aid_diary/widgets/markdown_preview_controller.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:aid_diary/widgets/mood_icon.dart';
import 'package:aid_diary/widgets/tag_chip.dart';
import 'package:aid_diary/widgets/tag_picker_dialog.dart';
import 'package:aid_diary/widgets/template_select_popup.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// The entry editor's widgets: text fields, dialogs and navigation. What is
/// edited, saved and kept lives in [EditEntryViewModel].
class AddEditEntryPage extends StatefulWidget {
  final Entry? entry;

  /// Diary day for a new entry written about another day, such as one
  /// picked in the calendar; it is still written now.
  final DateTime? diaryDay;
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
    this.diaryDay,
    this.openCamera = false,
    this.images = const <EntryImage>[],
    this.sharedText,
    this.initialMood,
    this.template,
  });

  @override
  State<AddEditEntryPage> createState() => _AddEditEntryPageState();
}

class _AddEditEntryPageState extends State<AddEditEntryPage>
    with WidgetsBindingObserver {
  static const double _pageWidth = 800;

  late final EditEntryViewModel _model = EditEntryViewModel(
    entry: widget.entry,
    diaryDay: widget.diaryDay,
    images: widget.images,
    sharedText: widget.sharedText,
    initialMood: widget.initialMood,
    template: widget.template,
    onSavedForToday: Platform.isAndroid
        ? NotificationManager.instance.dismissReminderNotification
        : null,
  );
  final FocusNode _focusNode = FocusNode();
  final MarkdownPreviewController _textEditingController =
      MarkdownPreviewController();

  /// The optional title, kept as the text's first line; the body
  /// controller holds the rest.
  final TextEditingController _titleController = TextEditingController();
  final UndoHistoryController _undoController = UndoHistoryController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model.addListener(_redraw);
    _titleController.text = _model.initialTitle;
    _titleController.addListener(_reportText);
    _textEditingController.addListener(_reportText);

    if (widget.sharedText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _textEditingController.selection =
            TextSelection.collapsed(offset: _textEditingController.text.length);
      });
    }
    if (widget.openCamera) {
      EntryImageActions.takePhoto(_model.addAttachments);
    }
    if (_model.wantsCurrentContext) {
      // Needs the locale, which initState may not read yet.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final wanted = autoFillSettings(ConfigProvider.instance);
        _model.fillCurrentContext(
            place: wanted.place,
            weather: wanted.weather,
            languageCode: _language);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.removeListener(_reportText);
    _textEditingController.removeListener(_reportText);
    _model.removeListener(_redraw);
    _model.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
    _titleController.dispose();
    _undoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) _model.saveForBackground();
  }

  void _reportText() =>
      _model.setText(_titleController.text, _textEditingController.text);

  /// Redraws on model changes; ones reported while the editor builds (text
  /// set into a field) wait for the frame to end.
  void _redraw() {
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    } else {
      setState(() {});
    }
  }

  String get _language => TimeManager.currentLocale(context).split('_').first;

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
      await _model.discard();
      if (!mounted) return;
    }
    // Pops past the PopScope; leaving then saves unless discarded.
    Navigator.of(context).pop();
  }

  void _showDeleteEntryPopup() {
    if (_model.isNew && !_model.hasContent) {
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
                final navigator = Navigator.of(context);
                final entryToDelete = await _model.prepareDelete();
                // Pop dialog
                navigator.pop();
                // Pop edit page
                navigator.pop();
                if (!_model.isNew && navigator.canPop()) {
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

    // Like a page: title, writing, then what goes with it. Built here, not
    // in the LayoutBuilder, so the keyboard resizing the page re-lays it out
    // without rebuilding the text on every frame.
    final content = [
      if (_model.askDay) _buildDayQuestion(context),
      _buildTitleField(theme),
      _buildBodyEditor(context),
      _buildMedia(context),
      const SizedBox(height: 16),
      _buildMetaRows(context),
    ];
    return PopScope(
      // Going back over changes asks first; the done button does not.
      canPop: _model.canLeaveSilently,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) return _confirmLeave();
        await _model.leave();
      },
      child: EditorKeyboardInset(
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              title: _buildDateTitle(context, theme),
              leading: _closeButton(),
              actions: [
                _tagsButton(),
                if (!_model.isNew) _deleteButton(),
              ]),
          body: EditorActionBarOverlay(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final sidePadding = ((constraints.maxWidth - _pageWidth) / 2)
                    .clamp(0.0, double.infinity);
                return ListView(
                  padding: EdgeInsets.fromLTRB(
                      sidePadding + 8,
                      8,
                      sidePadding + 8,
                      24 + EditorActionBar.reservedHeight(context)),
                  children: content,
                );
              },
            ),
            actionBar: EditorActionBar(
              controller: _textEditingController,
              undoController: _undoController,
              focusNode: _focusNode,
              onTemplateInserted: _model.applyTemplateTags,
              mainActions: _buildMainActions(context),
            ),
          ),
        ),
      ),
    );
  }

  /// Written in the hours that could close the night or open the day: asks
  /// which day, counting it for today until answered, without stopping the
  /// writing.
  Widget _buildDayQuestion(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final today = DiaryDay.dateOf(_model.writtenAt);
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    Widget choice(String key, String label, DateTime day) => ChoiceChip(
          key: ValueKey(key),
          label: Text(label),
          selected: _model.diaryDay == day,
          onSelected: (_) => _model.setDiaryDay(day),
        );
    return Card.filled(
      key: const ValueKey('editor-day-question'),
      color: cs.secondaryContainer,
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.bedtime_outlined,
                size: 18, color: cs.onSecondaryContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                  l10n.editorDayAsk(TimeManager.timeOfDayString(
                      context, TimeOfDay.fromDateTime(_model.writtenAt))),
                  style: TextStyle(color: cs.onSecondaryContainer)),
            ),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            choice(
                'editor-day-yesterday',
                l10n.editorDayYesterday(
                    TimeManager.formatMonthDay(yesterday, context)),
                yesterday),
            choice(
                'editor-day-today',
                l10n.editorDayToday(TimeManager.formatMonthDay(today, context)),
                today),
          ]),
        ]),
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

  /// The writing itself; it grows with the text, and everything from the
  /// title down to the media tile, blank space included, takes a tap.
  Widget _buildBodyEditor(BuildContext context) {
    // Built under the action bar overlay, which holds the keyboard session.
    return Builder(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Taps on the text itself go to the field; this gets the rest.
        onTap: () {
          EditorKeyboardSessionScope.read(context)?.resume();
          _textEditingController.selection = TextSelection.collapsed(
              offset: _textEditingController.text.length);
          if (_focusNode.hasFocus) {
            // Still focused after the keyboard was swiped away: bring the
            // keyboard back, which focusing again would not.
            SystemChannels.textInput.invokeMethod<void>('TextInput.show');
          } else {
            _focusNode.requestFocus();
          }
        },
        child: ConstrainedBox(
          // The gap above the media tile is part of the writing area.
          constraints: const BoxConstraints(minHeight: 240),
          child: Align(
            alignment: Alignment.topCenter,
            child: EntryTextEditor(
              text: _model.initialBody,
              expands: false,
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              undoHistoryController: _undoController,
              onExpand: _openFullScreenEditor,
              onChooseTemplate: () => showTemplateSelectPopup(
                  context, _textEditingController,
                  hasFocus: _focusNode.hasFocus,
                  onTemplateSelected: _model.applyTemplateTags),
            ),
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
    if (_model.images.isEmpty) return add;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      EntryImageEditableList(
          images: _model.images, onImagesChanged: _model.setImages),
      const SizedBox(height: 8),
      add,
    ]);
  }

  /// Weather and place, filled in on their own for a new entry, then tags.
  Widget _buildMetaRows(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final model = _model;
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
      listenable: model.tagSource,
      builder: (context, _) {
        final attachedIds = model.tagSource.attachedTagIds.toSet();
        final tags = Provider.of<TagsProvider>(context)
            .tags
            .where((t) => attachedIds.contains(t.id))
            .toList();
        final weather = model.weather;
        final activity = model.activity;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(
                  const ValueKey('editor-weather'),
                  weather == null
                      ? Icons.wb_sunny_outlined
                      : weatherIcon(weather.code),
                  weather == null ? null : weatherSummary(weather, l10n),
                  l10n.weatherTitle,
                  _chooseWeather,
                  onClear: () => model.setWeather(null)),
              row(
                  const ValueKey('editor-location'),
                  Icons.place_outlined,
                  model.location?.label,
                  model.locating ? l10n.editorLocating : l10n.locationTitle,
                  _chooseLocation,
                  onClear: () => model.setLocation(null)),
              // When it was actually written, apart from the day it is for.
              row(
                  const ValueKey('editor-written-at'),
                  Icons.schedule_rounded,
                  l10n.editorWrittenAt(
                      '${TimeManager.formatDate(model.writtenAt, context)} '
                      '${TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(model.writtenAt))}'),
                  '',
                  _chooseWrittenTime),
              if (activity != null)
                row(const ValueKey('editor-activity'), activityIcon(activity),
                    activityLabel(activity, l10n), '', null,
                    onClear: () => model.setActivity(null)),
              if (tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final tag in tags)
                      TagChip(
                        tag: tag,
                        value: model.tagSource.valueFor(tag.id!),
                        onTap: tag.tagType == TagType.tracker
                            ? () => model.tagSource.editValue(context, tag)
                            : null,
                        onRemove: () => model.tagSource.detach(tag.id!),
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
          builder: (_) => TagPickerDialog(
              mode: TagPickerMode.attach, source: _model.tagSource),
        ),
      );

  /// The diary day as the page title with the time it was written, and the
  /// mood beside it; tapping the day changes the day only.
  Widget _buildDateTitle(BuildContext context, ThemeData theme) {
    final cs = theme.colorScheme;
    final mood = _model.mood;
    final hasMood = MoodIcon.getMoodIcon(mood).isNotEmpty;
    final date = _model.writtenAt;
    final diaryDay = _model.diaryDay;
    final day = diaryDay.year == DateTime.now().year
        ? TimeManager.formatMonthDay(diaryDay, context)
        : TimeManager.formatDate(diaryDay, context);
    final time =
        TimeManager.timeOfDayString(context, TimeOfDay.fromDateTime(date));
    final weekday =
        DateFormat.E(TimeManager.currentLocale(context)).format(diaryDay);
    final written = DiaryDay.dateOf(date);
    final lateNight =
        diaryDay == DateTime(written.year, written.month, written.day - 1);
    // Written on another day than it is about: the time alone would
    // mislead, so the written-at row says when.
    final sameNight = lateNight || diaryDay == written;
    final zone = _model.entry.otherZoneLabel;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: InkWell(
          key: const ValueKey('editor-date'),
          borderRadius: BorderRadius.circular(8),
          onTap: _chooseDiaryDay,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: day,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                TextSpan(
                    text: ' $weekday'
                        '${sameNight ? '  /  $time' : ''}'
                        '${zone == null ? '' : ' $zone'}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
                if (lateNight)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 4),
                      child: Tooltip(
                        message: AppLocalizations.of(context)!.lateNightBadge,
                        child: Icon(Icons.bedtime_outlined,
                            key: const ValueKey('editor-late-night'),
                            size: 16,
                            color: cs.onSurfaceVariant),
                      ),
                    ),
                  ),
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

  Future<void> _chooseMood() async {
    var picked = _model.mood;
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
    if (confirmed == true) _model.setMood(picked);
  }

  Future<void> _chooseLocation() async {
    final choice = await showLocationDialog(context, _model.location);
    if (choice != null) _model.setLocation(choice.location);
  }

  /// Like Journey, offers what a picked photo tells: its day and place.
  Future<void> _offerPhotoMetadata(PhotoMetadata photo) async {
    final l10n = AppLocalizations.of(context)!;
    final suggestion =
        await _model.suggestFromPhoto(photo, languageCode: _language);
    if (suggestion == null || !mounted) return;
    final dateLabel = switch (suggestion.day) {
      final day? => TimeManager.formatDate(day, context),
      null => null,
    };
    final message = switch ((dateLabel, suggestion.place?.label)) {
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
    if (apply == true && mounted) _model.applyPhotoSuggestion(suggestion);
  }

  Future<void> _chooseWeather() async {
    final choice = await showWeatherDialog(
        context, _model.weather, _model.location, _model.writtenAt);
    if (choice != null) _model.setWeather(choice.weather);
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
    return EntryImageActions.pickFromGallery(_model.addAttachments,
        onMetadata: _offerPhotoMetadata,
        onVideo: (file) => MediaActions.addPickedVideo(
            file, _model.addAttachments,
            onTooLarge: () =>
                messenger.showSnackBar(SnackBar(content: Text(tooLarge)))));
  }

  /// Everything an entry can hold: from the gallery, the camera (phones
  /// only), a voice note or files.
  Future<void> _addMedia() {
    final l10n = AppLocalizations.of(context)!;
    final add = _model.addAttachments;
    return _chooseAttachment([
      (Icons.photo_library_outlined, l10n.mediaFromGallery, _pickFromGallery),
      if (Platform.isAndroid) ...[
        (
          Icons.photo_camera_rounded,
          l10n.actionTakePhoto,
          () => EntryImageActions.takePhoto(add)
        ),
        (
          Icons.videocam_rounded,
          l10n.videoRecord,
          () => MediaActions.pickVideo(context, add, camera: true)
        ),
      ],
      (
        Icons.mic_rounded,
        l10n.audioRecordTitle,
        () => MediaActions.recordAudio(context, add)
      ),
      (
        Icons.folder_open_rounded,
        l10n.mediaFromFiles,
        () => MediaActions.pickFiles(context, add)
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
            () => MediaActions.recordAudio(context, _model.addAttachments)
          ),
          (
            Icons.audio_file_outlined,
            l10n.audioChoose,
            () => MediaActions.pickAudio(_model.addAttachments)
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
        tooltip: _model.edited
            ? MaterialLocalizations.of(context).saveButtonLabel
            : MaterialLocalizations.of(context).closeButtonTooltip,
        icon: Icon(_model.edited ? Icons.check_rounded : Icons.close_rounded),
        onPressed: () => Navigator.of(context).pop(),
      );

  /// Picks the day the entry belongs to; when it was written stays.
  Future<void> _chooseDiaryDay() async {
    final today = DiaryDay.dateOf(DateTime.now());
    final current = _model.diaryDay;
    final picked = await TimeManager.pickDate(
      context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: current.isAfter(today) ? current : today,
    );
    if (picked != null) _model.setDiaryDay(picked);
  }

  /// Corrects when the entry was written; the day it belongs to stays.
  Future<void> _chooseWrittenTime() async {
    final written = _model.writtenAt;
    final date = await TimeManager.pickDate(
      context,
      initialDate: DiaryDay.dateOf(written),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(written));
    if (time == null) return;
    _model.setWrittenAt(
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}
