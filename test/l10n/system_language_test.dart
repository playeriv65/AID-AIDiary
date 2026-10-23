@Tags(['widget'])
library;

import 'package:aid_diary/custom_locale_delegates.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/l10n/locale_resolution.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('follows system changes unless a language is selected',
      (tester) async {
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
    Locale? override;
    late StateSetter update;

    await tester.pumpWidget(StatefulBuilder(builder: (context, setState) {
      update = setState;
      return MaterialApp(
        locale: override,
        supportedLocales: appSupportedLocales,
        localeListResolutionCallback: resolveAppLocale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...appLocalizationsDelegates,
        ],
        home: Builder(builder: (context) {
          return Text(AppLocalizations.of(context)!.onboardConnect);
        }),
      );
    }));

    tester.binding.platformDispatcher.localesTestValue = [const Locale('en')];
    await tester.pumpAndSettle();
    expect(find.text('Connect to an existing device'), findsOneWidget);

    tester.binding.platformDispatcher.localesTestValue = [const Locale('zh')];
    await tester.pumpAndSettle();
    expect(find.text('连接已有设备'), findsOneWidget);

    tester.binding.platformDispatcher.localesTestValue = [
      const Locale('zh', 'TW')
    ];
    await tester.pumpAndSettle();
    expect(find.text('連接現有裝置'), findsOneWidget);

    update(() => override = const Locale('en'));
    await tester.pumpAndSettle();
    tester.binding.platformDispatcher.localesTestValue = [const Locale('zh')];
    await tester.pumpAndSettle();
    expect(find.text('Connect to an existing device'), findsOneWidget);

    update(() => override = null);
    await tester.pumpAndSettle();
    expect(find.text('连接已有设备'), findsOneWidget);
  });
}
