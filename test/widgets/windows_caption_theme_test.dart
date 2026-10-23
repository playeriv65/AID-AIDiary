// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/widgets/windows_caption_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('aid/window_chrome');
  final calls = <MethodCall>[];
  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => calls.add(call));
  });
  tearDown(() => TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null));

  testWidgets('caption follows palette changes without reserving app space',
      (tester) async {
    Widget app(Brightness brightness) => MaterialApp(
          theme: ThemeData(
              platform: TargetPlatform.windows,
              brightness: brightness,
              scaffoldBackgroundColor: brightness == Brightness.dark
                  ? const Color(0xff101114)
                  : const Color(0xfffafafa)),
          home: const WindowsCaptionTheme(
              child: SizedBox.expand(key: ValueKey('content'))),
        );
    await tester.pumpWidget(app(Brightness.light));
    await tester.pumpAndSettle();
    expect(calls.single.arguments['background'], 0xfffafafa);
    expect(calls.single.arguments['dark'], false);
    expect(
        tester.getTopLeft(find.byKey(const ValueKey('content'))), Offset.zero);
    await tester.pumpWidget(app(Brightness.dark));
    await tester.pumpAndSettle();
    expect(calls.last.arguments['background'], 0xff101114);
    expect(calls.last.arguments['dark'], true);
  });

  testWidgets('mobile themes do not call Windows', (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: const WindowsCaptionTheme(child: SizedBox.expand())));
    expect(calls, isEmpty);
  });
}
