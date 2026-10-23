@Tags(['widget'])
library;

import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/pages/onboarding_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('$locale first run and tutorial fit a small enlarged-text view',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 600);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...appLocalizationsDelegates,
        ],
        builder: (context, child) => MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const OnboardingPage(next: SizedBox.shrink()),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final connect = find.byKey(const ValueKey('onboard-nearby-receive'));
      final context = tester.element(connect);
      expect(
          Directionality.of(context),
          const {'ar', 'fa', 'he'}.contains(locale.languageCode)
              ? TextDirection.rtl
              : TextDirection.ltr);
      await tester.ensureVisible(connect);
      expect(connect.hitTestable(), findsOneWidget);

      final start = find.byKey(const ValueKey('onboard-new-diary'));
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final l10n = AppLocalizations.of(
          tester.element(find.byKey(const ValueKey('tutorial-content'))))!;
      await tester.scrollUntilVisible(
          find.text(l10n.tutorialPrivacyTitle), 250);
      await tester.pumpAndSettle();
      expect(
          find.text(l10n.tutorialPrivacyTitle).hitTestable(), findsOneWidget);
      expect(find.byKey(const ValueKey('tutorial-start')).hitTestable(),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
