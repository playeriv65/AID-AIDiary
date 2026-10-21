// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/widgets/editor_action_bar.dart';
import 'package:aid_diary/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:material_ui/material_ui.dart';

/// Hands the on-screen keyboard's height to the editor's action bar.
///
/// Wrap the Scaffold in it: the Scaffold body sees no bottom inset. Only
/// the bar depends on it, so while the keyboard slides, the page does not
/// rebuild on every frame.
class EditorKeyboardInset extends StatelessWidget {
  const EditorKeyboardInset({super.key, required this.child});

  final Widget child;

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_KeyboardInsetScope>()
          ?.inset ??
      0;

  @override
  Widget build(BuildContext context) => _KeyboardInsetScope(
      inset: MediaQuery.viewInsetsOf(context).bottom, child: child);
}

class _KeyboardInsetScope extends InheritedWidget {
  const _KeyboardInsetScope({required this.inset, required super.child});

  final double inset;

  @override
  bool updateShouldNotify(_KeyboardInsetScope oldWidget) =>
      inset != oldWidget.inset;
}

class EditorActionBarOverlay extends StatefulWidget {
  final Widget body;
  final EditorActionBar actionBar;

  const EditorActionBarOverlay({
    super.key,
    required this.body,
    required this.actionBar,
  });

  @override
  State<EditorActionBarOverlay> createState() => _EditorActionBarOverlayState();
}

class _EditorActionBarOverlayState extends State<EditorActionBarOverlay> {
  EditorKeyboardSession? _session;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inset = EditorKeyboardInset.of(context);
    _session ??= EditorKeyboardSession(
        focusNode: widget.actionBar.focusNode, initialInset: inset);
    _session!.noteKeyboardInset(inset);
  }

  @override
  void didUpdateWidget(covariant EditorActionBarOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actionBar.focusNode != widget.actionBar.focusNode) {
      _session!.dispose();
      _session = EditorKeyboardSession(
          focusNode: widget.actionBar.focusNode,
          initialInset: EditorKeyboardInset.of(context));
    }
  }

  @override
  void dispose() {
    _session?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorKeyboardSessionScope(
      session: _session!,
      child: Stack(
        children: [
          Positioned.fill(child: widget.body),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TextFieldTapRegion(child: widget.actionBar),
          ),
        ],
      ),
    );
  }
}
