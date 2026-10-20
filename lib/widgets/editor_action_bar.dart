// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/utils/text_editing.dart';
import 'package:aid_diary/widgets/editor_action_bar/action_bar_pill.dart';
import 'package:aid_diary/widgets/editor_action_bar/dock_metrics.dart';
import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_actions.dart';
import 'package:aid_diary/widgets/editor_action_bar/action_bar_toggle_button.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_entry.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_focus_restorer.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_morph.dart';
import 'package:aid_diary/widgets/editor_action_bar/toolbar_overflow_popup.dart';
import 'package:aid_diary/widgets/template_select_popup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:word_count/word_count.dart';

export 'package:aid_diary/widgets/editor_action_bar/editor_action_bar_overlay.dart';
export 'package:aid_diary/widgets/editor_action_bar/toolbar_actions.dart'
    show ToolbarAction;

class EditorActionBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final UndoHistoryController? undoController;
  final bool showTemplateButton;
  final void Function(Template template)? onTemplateInserted;
  final List<ToolbarAction>? mainActions;

  const EditorActionBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.undoController,
    this.showTemplateButton = true,
    this.onTemplateInserted,
    this.mainActions,
  });

  /// Space host pages reserve so content doesn't sit behind the bar
  static double reservedHeight(BuildContext context) =>
      DockMetrics.reservedHeight(context);

  /// Threshold for wide screen layout
  static const double wideBreakpoint = 600.0;

  static const double _dividerWidth = 8.0;

  /// Room reserved for the word and character count on wide windows.
  static const double _countWidth = 168.0;

  /// Space between the tools and the count.
  static const double _countGap = 12.0;

  @override
  State<EditorActionBar> createState() => _EditorActionBarState();
}

class _EditorActionBarState extends State<EditorActionBar> {
  final ToolbarOverflowPopup _overflowPopup = ToolbarOverflowPopup();
  late final ToolbarFocusRestorer _focusRestorer;
  late final BulletListContinuation _bulletContinuation;

  EditorKeyboardSession? _session;
  bool _isEditing = false;
  bool _showMainActionsWhileFocused = false;

  @override
  void initState() {
    super.initState();
    _focusRestorer = ToolbarFocusRestorer(widget.focusNode,
        isDismissed: () => _session?.state == EditorFocusState.dismissed,
        onIdle: _syncEditing,
        onReconnect: () => _session?.resume());
    _bulletContinuation = BulletListContinuation(widget.controller);
    widget.focusNode.addListener(_syncEditing);
    _isEditing = _editingTarget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Notify whenever the session changes
    _session = EditorKeyboardSessionScope.maybeOf(context);
    _syncEditing();
  }

  @override
  void dispose() {
    _focusRestorer.dispose();
    _bulletContinuation.dispose();
    widget.focusNode.removeListener(_syncEditing);
    _overflowPopup.dismiss();
    super.dispose();
  }

  bool get _editingTarget =>
      widget.mainActions != null &&
      (_session?.isEditing ?? widget.focusNode.hasFocus);

  void _syncEditing() {
    // A dialog an action opened holds focus while it is up
    if (_focusRestorer.isRunningAction) return;
    final isEditing = _editingTarget;
    if (isEditing == _isEditing) return;
    setState(() {
      _isEditing = isEditing;
      if (!isEditing) _showMainActionsWhileFocused = false;
    });
  }

  List<ToolbarEntry> _mainActionEntries(DockMetrics metrics) {
    return _spaced([
      if (widget.showTemplateButton) _templateEntry(metrics),
      for (final action in widget.mainActions ?? const <ToolbarAction>[])
        _iconEntry(metrics, action, claimsFocus: false),
    ]);
  }

  List<ToolbarEntry> _markdownEntries(
      BuildContext context, DockMetrics metrics) {
    final undoController = widget.undoController;
    return _spaced([
      // Keep template button in edit actions for full screen editor
      if (widget.showTemplateButton && widget.mainActions == null) ...[
        _templateEntry(metrics),
        _dividerEntry(),
      ],
      for (final action in markdownActions(context, widget.controller))
        _iconEntry(metrics, action),
      if (undoController != null) ...[
        _dividerEntry(),
        _undoEntry(metrics, undoController, isUndo: true),
        _undoEntry(metrics, undoController, isUndo: false),
      ],
    ]);
  }

  ToolbarEntry _templateEntry(DockMetrics metrics) {
    return ToolbarEntry(
      width: metrics.buttonSize,
      build: (context, dismissOverflow) => ToolbarIconButton(
        size: metrics.buttonSize,
        icon: const Icon(Icons.note_add_rounded),
        tooltip: AppLocalizations.of(context)!.templatePickerTitle,
        onPressed: () {
          dismissOverflow?.call();
          // Capture before the popup or focus restorer can shift focus away
          final hasFocus = widget.focusNode.hasFocus;
          _focusRestorer.run(
            () => showTemplateSelectPopup(context, widget.controller,
                hasFocus: hasFocus, onTemplateSelected: (template) {
              widget.onTemplateInserted?.call(template);
              widget.focusNode.requestFocus();
            }),
            claimsFocus: false,
          );
        },
      ),
    );
  }

  ToolbarEntry _iconEntry(
    DockMetrics metrics,
    ToolbarAction action, {
    bool claimsFocus = true,
  }) {
    return ToolbarEntry(
      width: metrics.buttonSize,
      build: (context, dismissOverflow) => ToolbarIconButton(
        size: metrics.buttonSize,
        icon: action.icon,
        tooltip: action.tooltip,
        onPressed: () {
          dismissOverflow?.call();
          _focusRestorer.run(action.onPressed,
              claimsFocus: claimsFocus, reconnectsKeyboard: action.mayLeaveApp);
        },
      ),
    );
  }

  ToolbarEntry _undoEntry(
      DockMetrics metrics, UndoHistoryController undoController,
      {required bool isUndo}) {
    return ToolbarEntry(
      width: metrics.buttonSize,
      group: 'undo',
      build: (context, dismissOverflow) =>
          ValueListenableBuilder<UndoHistoryValue>(
        valueListenable: undoController,
        builder: (context, value, _) {
          final enabled = isUndo ? value.canUndo : value.canRedo;
          return ToolbarIconButton(
            size: metrics.buttonSize,
            icon: Icon(isUndo ? Icons.undo_rounded : Icons.redo_rounded),
            tooltip: isUndo
                ? AppLocalizations.of(context)!.toolbarUndo
                : AppLocalizations.of(context)!.toolbarRedo,
            onPressed: enabled
                ? () {
                    dismissOverflow?.call();
                    _focusRestorer.run(() =>
                        isUndo ? undoController.undo() : undoController.redo());
                  }
                : null,
          );
        },
      ),
    );
  }

  ToolbarEntry _dividerEntry() => ToolbarEntry(
        width: EditorActionBar._dividerWidth,
        kind: ToolbarEntryKind.divider,
        build: (context, __) => VerticalDivider(
            width: EditorActionBar._dividerWidth,
            thickness: 1,
            color: IconTheme.of(context).color?.withValues(alpha: 0.4)),
      );

  List<ToolbarEntry> _spaced(List<ToolbarEntry> entries) {
    final spacer = ToolbarEntry(
      width: DockMetrics.itemSpacing,
      kind: ToolbarEntryKind.spacer,
      build: (_, __) => const SizedBox(width: DockMetrics.itemSpacing),
    );
    return [
      for (var index = 0; index < entries.length; index++) ...[
        if (index > 0) spacer,
        entries[index],
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final metrics = DockMetrics.of(context);
    final isWide =
        MediaQuery.sizeOf(context).width >= EditorActionBar.wideBreakpoint;
    // Wide windows fit both groups in one bar, so nothing to toggle.
    final combined = isWide && widget.mainActions != null;
    final showToggle = !combined && widget.mainActions != null && _isEditing;
    final showingMainActions = widget.mainActions != null &&
        (combined || !_isEditing || _showMainActionsWhileFocused);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.sideMargin,
        metrics.topMargin,
        metrics.sideMargin,
        MediaQuery.paddingOf(context).bottom + metrics.sideMargin,
      ),
      // Claims taps on the bar's dead space to prevent focus loss
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: LayoutBuilder(
          builder: (context, constraints) {
            final toggleReserved =
                showToggle ? metrics.toggleSize + DockMetrics.toggleGap : 0.0;
            final mirroredReserved = isWide ? toggleReserved : 0.0;
            final maxPillWidth = (constraints.maxWidth -
                    toggleReserved -
                    mirroredReserved -
                    metrics.contentInset * 2)
                .clamp(0.0, constraints.maxWidth);
            // Wide windows line the tools up from the start, the count
            // right after them.
            final pillAlignment = (showToggle && !isWide) || combined
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.center;

            final split = ToolbarEntrySplit.fit(
              combined
                  ? [
                      ..._mainActionEntries(metrics),
                      _dividerEntry(),
                      ..._markdownEntries(context, metrics),
                    ]
                  : showingMainActions
                      ? _mainActionEntries(metrics)
                      : _markdownEntries(context, metrics),
              maxWidth: maxPillWidth,
              overflowButtonWidth: metrics.buttonSize,
              padding: metrics.pillPadding,
            );
            // The count follows the pill only where it fits.
            final showCount = combined &&
                !split.hasOverflow &&
                maxPillWidth - split.pillWidth >=
                    EditorActionBar._countWidth + EditorActionBar._countGap;

            return Stack(
              children: [
                DockSurface(metrics: metrics, barWidth: constraints.maxWidth),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: metrics.contentInset),
                  child: Row(
                    children: [
                      if (isWide) SizedBox(width: toggleReserved),
                      Expanded(
                        child: AnimatedAlign(
                          duration: toolbarMorphDuration,
                          curve: toolbarMorphCurve,
                          heightFactor: 1.0,
                          alignment: pillAlignment,
                          child: ActionBarPill(
                            metrics: metrics,
                            split: split,
                            showingMainActions: showingMainActions,
                            onShowOverflow: (buttonContext) => _overflowPopup
                                .show(buttonContext, split.overflow),
                          ),
                        ),
                      ),
                      _buildToggle(metrics, visible: showToggle),
                    ],
                  ),
                ),
                if (showCount)
                  PositionedDirectional(
                    start: metrics.contentInset +
                        split.pillWidth +
                        EditorActionBar._countGap,
                    top: 0,
                    bottom: 0,
                    width: EditorActionBar._countWidth,
                    child: _WordCount(controller: widget.controller),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggle(DockMetrics metrics, {required bool visible}) {
    const gap = DockMetrics.toggleGap;
    return SizedBox(
      width: visible ? metrics.toggleSize + gap : 0,
      height: metrics.toggleSize,
      child: OverflowBox(
        minWidth: 0,
        maxWidth: metrics.toggleSize + gap,
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: gap),
          child: AnimatedScale(
            duration: toolbarMorphDuration,
            curve: visible ? Curves.easeOutBack : Curves.easeIn,
            scale: visible ? 1.0 : 0.0,
            child: AnimatedOpacity(
              duration: toolbarMorphDuration,
              curve: toolbarMorphCurve,
              opacity: visible ? 1.0 : 0.0,
              child: ActionBarToggle(
                size: metrics.toggleSize,
                visible: visible,
                isShowingMainActions: _showMainActionsWhileFocused,
                onPressed: () {
                  setState(() => _showMainActionsWhileFocused =
                      !_showMainActionsWhileFocused);
                  widget.focusNode.requestFocus();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Words and characters in the entry, counted as statistics count them.
class _WordCount extends StatelessWidget {
  const _WordCount({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          l10n.editorWordCount(
              wordsCount(value.text), value.text.characters.length),
          key: const ValueKey('editor-word-count'),
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant, letterSpacing: 0.6),
        ),
      ),
    );
  }
}
