// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/pages/settings/feedback_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  testWidgets('typed feedback is preserved in GitHub and mail drafts',
      (tester) async {
    final targets = <Uri>[];
    await tester.pumpWidget(harness.app(FeedbackPage(launch: (uri) async {
      targets.add(uri);
      return true;
    })));
    await tester.pumpAndSettle();
    const message = '搜索建议 & bug + 中文\n第二行';
    await tester.enterText(
        find.byKey(const ValueKey('feedback-text')), message);
    await tester.tap(find.byKey(const ValueKey('feedback-github')));
    await tester.pumpAndSettle();
    expect(targets.single.host, AppConfig.instance.feedbackIssuesUrl.host);
    expect(targets.single.queryParameters['body'], message);
    await tester.tap(find.byKey(const ValueKey('feedback-email')));
    await tester.pumpAndSettle();
    expect(targets.last.scheme, 'mailto');
    expect(targets.last.path, AppConfig.instance.feedbackEmail);
    expect(targets.last.queryParameters['body'], message);
    expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('feedback-text')))
            .controller!
            .text,
        message);
  });

  testWidgets('failed external launch retains the draft and offers a fallback',
      (tester) async {
    await tester
        .pumpWidget(harness.app(FeedbackPage(launch: (_) async => false)));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('feedback-text')), 'A suggestion');
    await tester.tap(find.byKey(const ValueKey('feedback-email')));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(AppConfig.instance.feedbackEmail), findsOneWidget);
    expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('feedback-text')))
            .controller!
            .text,
        'A suggestion');
    expect(
        tester
            .widget<TextButton>(find.byKey(const ValueKey('feedback-copy')))
            .onPressed,
        isNotNull);
  });
}
