// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

/// Keeps the native caption in the app palette without changing window layout.
class WindowsCaptionTheme extends StatefulWidget {
  const WindowsCaptionTheme({super.key, required this.child});

  final Widget child;

  @override
  State<WindowsCaptionTheme> createState() => _WindowsCaptionThemeState();
}

class _WindowsCaptionThemeState extends State<WindowsCaptionTheme> {
  static const _channel = MethodChannel('aid/window_chrome');
  static final _logger = Logger('WindowsCaptionTheme');
  (int, int, bool)? _palette;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (theme.platform != TargetPlatform.windows) return;
    final palette = (
      theme.scaffoldBackgroundColor.toARGB32(),
      theme.colorScheme.onSurface.toARGB32(),
      theme.brightness == Brightness.dark,
    );
    if (_palette == palette) return;
    _palette = palette;
    unawaited(_apply(palette));
  }

  Future<void> _apply((int, int, bool) palette) async {
    try {
      await _channel.invokeMethod<void>('setTheme', {
        'background': palette.$1,
        'foreground': palette.$2,
        'dark': palette.$3,
      });
    } on PlatformException catch (error, stack) {
      _logger.warning('Native caption theme failed', error, stack);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
