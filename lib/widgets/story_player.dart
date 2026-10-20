// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';
import 'dart:ui' show ImageFilter;

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:material_ui/material_ui.dart';

/// One slide: an icon and title in the header above its content.
typedef StorySlide = ({IconData icon, String title, Widget body});

/// A story from the stories row: its slides under one header.
class StoryGroup {
  const StoryGroup({
    required this.id,
    required this.subtitle,
    required this.slides,
    this.leading,
    this.backdrop,
  });

  /// Names the story, so a row card can start the chain at it.
  final String id;

  /// Shown under every slide title, e.g. the period the story covers.
  final String subtitle;
  final List<StorySlide> slides;

  /// Replaces the slide icon in the header, e.g. the coach's face.
  final Widget? leading;

  /// Painted behind the slides under a dark scrim; text turns light.
  final Widget? backdrop;
}

/// Plays story groups one after another, like Journey's stories: slides
/// advance on their own, a tap on the left third steps back and elsewhere
/// forward, a long press pauses. With [wrapUp] a closing card follows the
/// last story.
class StoryPlayer extends StatefulWidget {
  const StoryPlayer({
    super.key,
    required this.groups,
    this.startAt,
    this.wrapUp = false,
    this.slideDuration = const Duration(seconds: 6),
  });

  final List<StoryGroup> groups;

  /// Id of the group to start at; the first when absent or unknown.
  final String? startAt;
  final bool wrapUp;
  final Duration slideDuration;

  /// Wide windows show the story as a card over the app, phones full screen.
  /// [groups] runs while the story builds, so it may read providers.
  static Future<void> show(
    BuildContext context, {
    required List<StoryGroup> Function(BuildContext context) groups,
    String? startAt,
    bool wrapUp = false,
  }) {
    Widget player(BuildContext context) =>
        StoryPlayer(groups: groups(context), startAt: startAt, wrapUp: wrapUp);
    // A tip still showing would move onto the story's own scaffold.
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    final size = MediaQuery.sizeOf(context);
    if (!diarySupportsSplit(size)) {
      return Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true, allowSnapshotting: false, builder: player));
    }
    return showDialog(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          width: min(580, size.width - 32),
          height: min(720, size.height - 48),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16), child: player(context)),
        ),
      ),
    );
  }

  /// Pauses the story around [action], e.g. while the user types.
  static Future<T> pauseDuring<T>(
      BuildContext context, Future<T> Function() action) async {
    final state = context.findAncestorStateOfType<_StoryPlayerState>();
    state?._progress.stop();
    try {
      return await action();
    } finally {
      if (state != null && state.mounted && !state._finished) {
        state._progress.forward();
      }
    }
  }

  @override
  State<StoryPlayer> createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress =
      AnimationController(vsync: this, duration: widget.slideDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _next();
        })
        ..forward();
  late int _group =
      max(0, widget.groups.indexWhere((g) => g.id == widget.startAt));
  int _slide = 0;

  /// Showing the closing card.
  bool _finished = false;

  // The groups are rebuilt as the diary changes, so stay within them.
  StoryGroup get _current =>
      widget.groups[_group.clamp(0, widget.groups.length - 1)];

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  void _next() {
    if (_finished) return _close();
    if (_slide < _current.slides.length - 1) {
      setState(() => _slide++);
    } else if (_group < widget.groups.length - 1) {
      setState(() {
        _group++;
        _slide = 0;
      });
    } else if (widget.wrapUp) {
      _progress.stop();
      setState(() => _finished = true);
      return;
    } else {
      return _close();
    }
    _progress.forward(from: 0);
  }

  void _previous() {
    if (_finished) return;
    if (_slide > 0) {
      setState(() => _slide--);
    } else if (_group > 0) {
      setState(() {
        _group--;
        _slide = _current.slides.length - 1;
      });
    }
    _progress.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final group = _current;
    final onBackdrop = group.backdrop != null && !_finished;
    final foreground = onBackdrop ? Colors.white : cs.onSurface;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      body: Stack(fit: StackFit.expand, children: [
        if (onBackdrop) ...[
          // Blurred, so the art sets the mood without fighting the text.
          ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: group.backdrop!),
          const ColoredBox(color: Colors.black38),
        ],
        SafeArea(
          child: GestureDetector(
            key: const ValueKey('story-surface'),
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final width = context.size?.width ?? 0;
              details.localPosition.dx < width / 3 ? _previous() : _next();
            },
            onLongPressStart: (_) => _progress.stop(),
            onLongPressEnd: (_) {
              if (!_finished) _progress.forward();
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _finished
                  ? const _WrapUp(key: ValueKey('story-wrap-up'))
                  : IconTheme.merge(
                      key: ValueKey('story-group-${group.id}'),
                      data: IconThemeData(color: foreground),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: foreground),
                        child: _GroupView(
                          group: group,
                          slide: _slide,
                          progress: _progress,
                          foreground: foreground,
                          onClose: _close,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _GroupView extends StatelessWidget {
  const _GroupView({
    required this.group,
    required this.slide,
    required this.progress,
    required this.foreground,
    required this.onClose,
  });

  final StoryGroup group;
  final int slide;
  final Animation<double> progress;
  final Color foreground;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final current = group.slides[slide];
    final count = group.slides.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AnimatedBuilder(
          animation: progress,
          builder: (context, _) => Row(children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: LinearProgressIndicator(
                  value: i < slide
                      ? 1
                      : i == slide
                          ? progress.value
                          : 0,
                  minHeight: 3,
                  color: group.backdrop != null ? Colors.white : null,
                  backgroundColor:
                      group.backdrop != null ? Colors.white30 : null,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          group.leading ??
              CircleAvatar(
                  backgroundColor: cs.primary,
                  child: Icon(current.icon, color: cs.onPrimary)),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(current.title.toUpperCase(),
                  style: theme.textTheme.labelLarge
                      ?.copyWith(letterSpacing: 1.6, color: foreground)),
              Text(group.subtitle,
                  style:
                      theme.textTheme.labelMedium?.copyWith(color: foreground)),
            ]),
          ),
          IconButton(
            key: const ValueKey('story-close'),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            color: foreground,
            icon: const Icon(Icons.close_rounded),
            onPressed: onClose,
          ),
        ]),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
                key: ValueKey('story-slide-${group.id}-$slide'),
                child: current.body),
          ),
        ),
      ]),
    );
  }
}

/// The card after the last story.
class _WrapUp extends StatelessWidget {
  const _WrapUp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Icon(Icons.celebration_rounded, size: 88, color: cs.tertiary),
        const SizedBox(height: 16),
        Text(l10n.storyWrapUp,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(l10n.storyTapToClose,
            style: theme.textTheme.labelLarge
                ?.copyWith(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}
