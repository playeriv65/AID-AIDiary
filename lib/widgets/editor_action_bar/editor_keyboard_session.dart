// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:flutter/widgets.dart';

enum EditorFocusState {
  /// Never focused, or the user clicked away
  unfocused,

  /// Focused, on-screen keyboard up
  docked,

  /// Focused, on-screen keyboard has never appeared
  floating,

  /// Focused, keyboard was up and has since been dismissed
  dismissed,
}

/// Derives [state] from focus and the current keyboard inset, without a delay.
class EditorKeyboardSession extends ChangeNotifier {
  final FocusNode focusNode;

  bool _dismissed = false;
  bool _everShown;
  double _lastInset;

  EditorKeyboardSession({required this.focusNode, double initialInset = 0})
      : _lastInset = initialInset,
        _everShown = initialInset > 0 {
    focusNode.addListener(_handleFocusChanged);
  }

  EditorFocusState get state {
    if (!focusNode.hasFocus) return EditorFocusState.unfocused;
    if (_dismissed) return EditorFocusState.dismissed;
    return _everShown ? EditorFocusState.docked : EditorFocusState.floating;
  }

  bool get isEditing =>
      state == EditorFocusState.docked || state == EditorFocusState.floating;

  bool get isUp => _lastInset > 0;

  /// React to a new inset
  void noteKeyboardInset(double inset) {
    if (inset == _lastInset) return;
    final rising = inset > _lastInset;
    _lastInset = inset;
    if (rising) {
      // A rise clears a dismissal on its own. If the user switches keyboard it a new keyboard will appear
      final alreadyDocked = _everShown && !_dismissed;
      _everShown = true;
      _dismissed = false;
      if (!alreadyDocked) notifyListeners();
      return;
    }
    // Keep following the keyboard during its slide, then hide in the same
    // frame it reaches zero. A timer here leaves the bar parked at the bottom.
    if (inset == 0) _setDismissed(true);
  }

  void resume() {
    _setDismissed(false);
  }

  void _setDismissed(bool dismissed) {
    if (dismissed == _dismissed) return;
    _dismissed = dismissed;
    notifyListeners();
  }

  void _handleFocusChanged() => notifyListeners();

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }
}

/// Scope to provide [EditorKeyboardSession] to the bar
class EditorKeyboardSessionScope
    extends InheritedNotifier<EditorKeyboardSession> {
  const EditorKeyboardSessionScope({
    super.key,
    required EditorKeyboardSession session,
    required super.child,
  }) : super(notifier: session);

  static EditorKeyboardSession? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<EditorKeyboardSessionScope>()
      ?.notifier;

  /// The session without listening to it, for event handlers.
  static EditorKeyboardSession? read(BuildContext context) => context
      .getInheritedWidgetOfExactType<EditorKeyboardSessionScope>()
      ?.notifier;
}
