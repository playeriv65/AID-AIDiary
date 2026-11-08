// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

class _Store extends PasswordStore {
  String? saved;

  @override
  int get minLength => 4;

  @override
  Future<bool> validate(String password) async => password == saved;

  @override
  Future<void> save(String password) async => saved = password;
}

void main() {
  final harness = DiaryAppHarness()..register();

  testWidgets('a new password is long enough and typed the same twice',
      (tester) async {
    final store = _Store();
    await tester.pumpWidget(harness.app(Scaffold(
        body: Builder(
            builder: (context) => TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AuthPopup(
                        mode: AuthPopupMode.setPassword,
                        title: 'Set',
                        showBiometrics: false,
                        dismissable: true,
                        store: store)),
                child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(AuthPopup)))!;
    Future<void> submit(String password, String repeat) async {
      await tester.enterText(
          find.byKey(const ValueKey('auth-new-password')), password);
      await tester.enterText(
          find.byKey(const ValueKey('auth-repeat-password')), repeat);
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pump();
    }

    await submit(' 123 ', ' 123 ');
    expect(find.text(l10n.passwordTooShort(4)), findsOneWidget);
    await submit('1234', '1243');
    expect(find.text(l10n.settingsSecurityPasswordsDoNotMatch), findsOneWidget);
    expect(store.saved, isNull);
    await submit('1234', '1234');
    await tester.pumpAndSettle();
    expect(store.saved, '1234');
    expect(find.byType(AuthPopup), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
