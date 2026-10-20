// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// One full-screen story slide: an icon and title above its content.
typedef StorySlide = ({IconData icon, String title, Widget body});

/// Full-screen slides with a progress bar. Slides advance on their own; a
/// tap on the left third steps back, elsewhere forward; a long press pauses.
class StoryShell extends StatefulWidget {
  const StoryShell({
    super.key,
    required this.slides,
    required this.subtitle,
    this.slideDuration = const Duration(seconds: 6),
  });

  final List<StorySlide> slides;

  /// Shown under every slide title, e.g. the period the story covers.
  final String subtitle;
  final Duration slideDuration;

  @override
  State<StoryShell> createState() => _StoryShellState();
}

class _StoryShellState extends State<StoryShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress =
      AnimationController(vsync: this, duration: widget.slideDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _next();
        })
        ..forward();
  int _slide = 0;

  int get _count => widget.slides.length;

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _go(int slide) {
    if (slide >= _count) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _slide = slide.clamp(0, _count - 1));
    _progress.forward(from: 0);
  }

  void _next() => _go(_slide + 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final slide = widget.slides[_slide];
    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      body: SafeArea(
        child: GestureDetector(
          key: const ValueKey('story-surface'),
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            final width = MediaQuery.sizeOf(context).width;
            details.localPosition.dx < width / 3 ? _go(_slide - 1) : _next();
          },
          onLongPressStart: (_) => _progress.stop(),
          onLongPressEnd: (_) => _progress.forward(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) => Row(children: [
                      for (var i = 0; i < _count; i++) ...[
                        if (i > 0) const SizedBox(width: 4),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: i < _slide
                                ? 1
                                : i == _slide
                                    ? _progress.value
                                    : 0,
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    CircleAvatar(
                        backgroundColor: cs.primary,
                        child: Icon(slide.icon, color: cs.onPrimary)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(slide.title.toUpperCase(),
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(letterSpacing: 1.6)),
                            Text(widget.subtitle,
                                style: theme.textTheme.labelMedium),
                          ]),
                    ),
                    IconButton(
                      key: const ValueKey('story-close'),
                      tooltip:
                          MaterialLocalizations.of(context).closeButtonTooltip,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ]),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: KeyedSubtree(
                          key: ValueKey('story-slide-$_slide'),
                          child: slide.body),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
