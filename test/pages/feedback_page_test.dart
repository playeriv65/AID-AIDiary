// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'dart:convert';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/pages/settings/feedback_page.dart';
import 'package:aid_diary/services/feedback_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  const message = '搜索建议 & bug + 中文\n第二行';

  String draft(WidgetTester tester) => tester
      .widget<TextField>(find.byKey(const ValueKey('feedback-text')))
      .controller!
      .text;

  testWidgets('typed feedback is sent to the server, then cleared',
      (tester) async {
    final requests = <http.Request>[];
    final service = FeedbackService(client: MockClient((request) async {
      requests.add(request);
      return http.Response('', 204);
    }));
    await tester.pumpWidget(harness.app(FeedbackPage(service: service)));
    await tester.pumpAndSettle();
    final send = find.byKey(const ValueKey('feedback-send'));
    expect(tester.widget<FilledButton>(send).onPressed, isNull);
    await tester.enterText(
        find.byKey(const ValueKey('feedback-text')), message);
    await tester.pump();
    await DiaryAppHarness.runUntil(tester, () => tester.tap(send),
        () => find.byType(SnackBar).evaluate().isNotEmpty);

    final sent = requests.single;
    expect(sent.url, AppConfig.instance.feedbackSubmitUrl);
    final body = jsonDecode(sent.body) as Map;
    expect(body['text'], message);
    expect(body.keys, containsAll(['text', 'platform', 'locale']));
    expect(draft(tester), isEmpty);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('a failed send keeps the draft', (tester) async {
    final service = FeedbackService(
        client: MockClient((_) async => http.Response('', 503)));
    await tester.pumpWidget(harness.app(FeedbackPage(service: service)));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('feedback-text')), message);
    await tester.pump();
    await DiaryAppHarness.runUntil(
        tester,
        () => tester.tap(find.byKey(const ValueKey('feedback-send'))),
        () => find.byType(SnackBar).evaluate().isNotEmpty);
    expect(draft(tester), message);
  });

  testWidgets('GitHub and mail open with the same text, nothing else to copy',
      (tester) async {
    final targets = <Uri>[];
    await tester.pumpWidget(harness.app(FeedbackPage(launch: (uri) async {
      targets.add(uri);
      return true;
    })));
    await tester.pumpAndSettle();
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
    expect(draft(tester), message);
    expect(find.byKey(const ValueKey('feedback-copy')), findsNothing);
    expect(find.text(AppConfig.instance.feedbackEmail), findsNothing);
  });
}
