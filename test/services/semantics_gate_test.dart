@Tags(['unit'])
library;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/services/semantics_gate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Set<String> noContent;

  setUpAll(() async {
    noContent = (await AppConfig.load()).noContentAccessibilityServices;
  });

  const adSkipper =
      'com.wpengapp.lightstart/com.wpengapp.lightstart.service.AccService';
  const clicker = 'com.clicker.automatic/'
      'com.clicker.automatic.service.AppAccessibilityService';
  const gkd = 'li.songe.gkd/'
      'com.google.android.accessibility.selecttospeak.SelectToSpeakService';
  const talkBack = 'com.google.android.marvin.talkback/'
      'com.google.android.marvin.talkback.TalkBackService';
  const selectToSpeak = 'com.google.android.marvin.talkback/'
      'com.google.android.accessibility.selecttospeak.SelectToSpeakService';

  bool holdsOff(List<String> services) =>
      SemanticsGate.holdsOff(services, noContent: noContent);

  test('semantics stay off with only ad skippers and auto-clickers', () {
    expect(holdsOff([adSkipper, clicker]), isTrue);
    expect(holdsOff([gkd]), isTrue);
  });

  test('a screen reader or an unknown service keeps semantics on', () {
    expect(holdsOff([adSkipper, clicker, talkBack]), isFalse);
    expect(holdsOff([adSkipper, 'com.example/com.example.Unknown']), isFalse);
    // GKD borrows Select to Speak's class name; the real one reads.
    expect(holdsOff([selectToSpeak]), isFalse);
  });

  test('with no service named, semantics stay on', () {
    expect(holdsOff([]), isFalse);
  });

  test('the list names whole components', () {
    for (final name in noContent) {
      final [package, service] = name.split('/');
      expect(package, isNotEmpty, reason: name);
      expect(service, contains('.'), reason: name);
      expect(service, isNot(startsWith('.')), reason: name);
    }
  });
}
