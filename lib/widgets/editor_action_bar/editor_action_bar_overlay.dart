// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/widgets/editor_action_bar.dart';
import 'package:daily_you/widgets/editor_action_bar/editor_keyboard_session.dart';
import 'package:material_ui/material_ui.dart';

class EditorActionBarOverlay extends StatefulWidget {
  final Widget body;
  final EditorActionBar actionBar;
  final double keyboardInset;

  const EditorActionBarOverlay({
    super.key,
    required this.body,
    required this.actionBar,
    required this.keyboardInset,
  });

  /// Must be used outside of the Scaffold hold this overlay. The Scaffold body zeros the bottom inset
  static double keyboardInsetOf(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom;

  @override
  State<EditorActionBarOverlay> createState() => _EditorActionBarOverlayState();
}

class _EditorActionBarOverlayState extends State<EditorActionBarOverlay> {
  late EditorKeyboardSession _session;

  @override
  void initState() {
    super.initState();
    _session = EditorKeyboardSession(
        focusNode: widget.actionBar.focusNode,
        initialInset: widget.keyboardInset);
  }

  @override
  void didUpdateWidget(covariant EditorActionBarOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actionBar.focusNode != widget.actionBar.focusNode) {
      _session.dispose();
      _session = EditorKeyboardSession(
          focusNode: widget.actionBar.focusNode,
          initialInset: widget.keyboardInset);
    }
    _session.noteKeyboardInset(widget.keyboardInset);
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(viewInsets: EdgeInsets.only(bottom: widget.keyboardInset)),
      child: EditorKeyboardSessionScope(
        session: _session,
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
      ),
    );
  }
}
