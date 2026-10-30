import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/services/app_updates.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../support/config_provider_harness.dart';

const _server = 'https://aid.example/updates/latest.json';
const _github = 'https://github.example/nightly/latest.json';
final _apk = utf8.encode('a newer app');

Map<String, Object?> _manifest({int build = 261029183}) => {
      'version': '0.1.0',
      'build': build,
      'notes': ['Map with momentum', 'Fix a crash'],
      'files': {
        'android': {
          'name': 'aid-diary.apk',
          'size': _apk.length,
          'sha256': '${sha256.convert(_apk)}',
        },
        'android-dev': {
          'name': 'aid-diary-dev.apk',
          'size': 1,
          'sha256': '00',
        },
      },
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('aid_updates');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (_) async => temp.path);
    AppConfig.setForTesting({
      'updates': {
        'manifestUrls': [_server, _github],
        'checkHours': 6,
        'timeoutSeconds': 5,
        'downloadTimeoutMinutes': 1,
      },
    });
    DeviceInfoService().appInfo = PackageInfo(
        appName: 'AID Diary',
        packageName: 'dev.aid.diary',
        version: '0.1.0',
        buildNumber: '261028090');
  });
  tearDown(() => temp.delete(recursive: true));

  test('an entry newer than the running build, beside its manifest', () {
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 261028090)!;
    expect(update.label, '0.1.0 (261029183)');
    expect(update.url, Uri.parse('https://aid.example/updates/aid-diary.apk'));
    // A manifest without languages: its lines are English.
    expect(update.notesFor(const Locale('zh')), hasLength(2));
    expect(
        AppUpdate.from(_manifest(),
            source: Uri.parse(_server),
            package: 'android',
            installed: 261029183),
        isNull);
    expect(
        AppUpdate.from(_manifest(),
            source: Uri.parse(_server), package: 'windows', installed: 0),
        isNull);
  });

  test('notes come in the app language, else English', () {
    final manifest = _manifest()
      ..['notesByLanguage'] = {
        'en': ['Updates by themselves'],
        'zh': ['会自己更新'],
        'zh_Hant': ['會自己更新'],
      };
    final update = AppUpdate.from(manifest,
        source: Uri.parse(_server), package: 'android', installed: 0)!;
    expect(update.notesFor(const Locale('zh')), ['会自己更新']);
    expect(
        update.notesFor(
            const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')),
        ['會自己更新']);
    expect(update.notesFor(const Locale('ja')), ['Updates by themselves']);
    // Kept through an install, as the "updated" note reads it back.
    expect(AppUpdate.fromJson(update.toJson()).notesFor(const Locale('zh')),
        ['会自己更新']);
  });

  test('a file name that leaves the manifest folder is refused', () {
    final manifest = _manifest();
    ((manifest['files'] as Map)['android'] as Map)['name'] = '../evil.apk';
    expect(
        () => AppUpdate.from(manifest,
            source: Uri.parse(_server), package: 'android', installed: 0),
        throwsA(isA<UpdateException>()));
  });

  test('the development app takes its own package', () {
    expect(AppUpdates.packageKey('dev.aid.diary.beta'), 'android-dev');
    expect(AppUpdates.packageKey('dev.aid.diary'), 'android');
  });

  test('check falls back to GitHub when the server does not answer', () async {
    final asked = <String>[];
    final updates = AppUpdates(client: MockClient((request) async {
      asked.add('${request.url}');
      return '${request.url}' == _server
          ? http.Response('down', 502)
          : http.Response(jsonEncode(_manifest()), 200);
    }));
    final update = await updates.check();
    expect(asked, [_server, _github]);
    expect(update!.url.host, 'github.example');
    expect(ConfigProvider.instance.get(Settings.lastUpdateCheck), isNotEmpty);
  });

  test('check fails when no manifest answers', () async {
    final updates =
        AppUpdates(client: MockClient((_) async => http.Response('down', 503)));
    await expectLater(updates.check(), throwsA(isA<UpdateException>()));
  });

  test('download keeps a package that matches the manifest', () async {
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 0)!;
    final progress = <double>[];
    final file = await AppUpdates(
            client: MockClient((_) async => http.Response.bytes(_apk, 200)))
        .download(update, progress: progress.add);
    expect(await file.readAsBytes(), _apk);
    expect(progress.last, 1);
  });

  test('download refuses a package that differs from the manifest', () async {
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 0)!;
    final updates = AppUpdates(
        client: MockClient(
            (_) async => http.Response.bytes(utf8.encode('tampered!!!'), 200)));
    await expectLater(
        updates.download(update),
        throwsA(
            isA<UpdateException>().having((e) => e.code, 'code', 'corrupt')));
  });

  test('after an install the update is reported once', () async {
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 0)!;
    await ConfigProvider.instance
        .set(Settings.installingUpdate, jsonEncode(update.toJson()));
    // Still the old build: the install did not happen yet.
    expect(await AppUpdates().justInstalled(), isNull);
    DeviceInfoService().appInfo = PackageInfo(
        appName: 'AID Diary',
        packageName: 'dev.aid.diary',
        version: '0.1.0',
        buildNumber: '261029183');
    expect((await AppUpdates().justInstalled())!.build, 261029183);
    expect(await AppUpdates().justInstalled(), isNull);
  });
}
