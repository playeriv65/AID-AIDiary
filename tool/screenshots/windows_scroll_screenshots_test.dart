// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  setUpAll(() async {
    final font =
        File('${Platform.environment['WINDIR']}/Fonts/NotoSansSC-VF.ttf');
    await (FontLoader('Segoe UI')
          ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync()))))
        .load();
  });
  testWidgets('Windows predictable preview rows', (tester) async {
    await session.start(tester, const Size(1280, 800));
    await session.capture(tester, 'windows-journal-scroll');
    await session.finish(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));
}
