@Tags(['integration'])
library;

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
import 'package:path/path.dart' as p;

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
          'sha256': '${sha256.convert([0])}',
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
        packageName: 'com.playeriv65.diary',
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

  test('a build the user skipped is marked skipped', () async {
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 261028090)!;
    expect(update.skipped, isFalse);
    await ConfigProvider.instance.set(Settings.skippedUpdate, update.build);
    expect(update.skipped, isTrue);
    await ConfigProvider.instance.set(Settings.skippedUpdate, 0);
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

  test('an immutable package resolves beside either manifest source', () {
    const name = 'aid-build-123456-2-aid-diary.apk';
    final manifest = _manifest();
    ((manifest['files'] as Map)['android'] as Map)['name'] = name;
    for (final source in [_server, _github]) {
      final uri = Uri.parse(source);
      final update = AppUpdate.from(manifest,
          source: uri, package: 'android', installed: 0)!;
      expect(
          update.url,
          uri.replace(pathSegments: [
            ...uri.pathSegments.take(uri.pathSegments.length - 1),
            name,
          ]));
      expect(update.sha256, '${sha256.convert(_apk)}');
    }
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
    final android = AppUpdates(os: 'android');
    expect(android.packageKey('com.playeriv65.diary.beta'), 'android-dev');
    expect(android.packageKey('com.playeriv65.diary'), 'android');
    expect(AppUpdates(os: 'windows').packageKey('aid_diary'), 'windows');
  });

  test('Windows downloads its installer under the installer\'s name', () async {
    final setup = utf8.encode('a newer installer');
    final manifest = _manifest()
      ..['files'] = {
        'windows': {
          'name': 'aid-build-1-1-aid-diary-windows-setup.exe',
          'size': setup.length,
          'sha256': '${sha256.convert(setup)}',
        },
      };
    final updates = AppUpdates(
        os: 'windows',
        client: MockClient((request) async => '${request.url}' == _server
            ? http.Response(jsonEncode(manifest), 200)
            : http.Response.bytes(setup, 200)));
    final update = (await updates.check())!;
    expect(update.url.path, endsWith('aid-diary-windows-setup.exe'));
    final file = await updates.download(update);
    expect(p.basename(file.path), 'update-261029183.exe');
    expect(await file.readAsBytes(), setup);
  });

  test('check falls back to GitHub when the server does not answer', () async {
    final asked = <String>[];
    final updates = AppUpdates(
        os: 'android',
        client: MockClient((request) async {
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
    final updates = AppUpdates(
        os: 'android',
        client: MockClient((_) async => http.Response('down', 503)));
    await expectLater(updates.check(), throwsA(isA<UpdateException>()));
  });

  test('malformed mirrors fall back before marking the check successful',
      () async {
    final config = ConfigProvider.instance;
    final malformed = {
      'invalid JSON': '{',
      'non-object JSON': '[]',
      'missing release data': '{}',
      'invalid package': jsonEncode(_manifest()..['files'] = {'android': []}),
      'invalid localized notes':
          jsonEncode(_manifest()..['notesByLanguage'] = {'en': 'one line'}),
      'invalid download metadata': jsonEncode(_manifest()
        ..['files'] = {
          'android': {'name': 'aid-diary.apk', 'sha256': '00', 'size': 0}
        }),
    };
    for (final MapEntry(:key, :value) in malformed.entries) {
      await config.set(Settings.lastUpdateCheck, '');
      final asked = <String>[];
      final updates = AppUpdates(
          os: 'android',
          client: MockClient((request) async {
            asked.add('${request.url}');
            if ('${request.url}' == _server) return http.Response(value, 200);
            expect(config.get(Settings.lastUpdateCheck), isEmpty, reason: key);
            return http.Response(jsonEncode(_manifest()), 200);
          }));
      final update = await updates.check();
      expect(asked, [_server, _github], reason: key);
      expect(update?.url.host, 'github.example', reason: key);
      expect(config.get(Settings.lastUpdateCheck), isNotEmpty, reason: key);
    }
  });

  test('a malformed check leaves the previous successful check time intact',
      () async {
    final config = ConfigProvider.instance;
    const previous = '2026-10-28T09:00:00Z';
    await config.set(Settings.lastUpdateCheck, previous);
    final updates = AppUpdates(
        os: 'android',
        client: MockClient((_) async => http.Response('{}', 200)));
    await expectLater(
        updates.check(),
        throwsA(isA<UpdateException>()
            .having((e) => e.code, 'code', 'unavailable')));
    expect(config.get(Settings.lastUpdateCheck), previous);
  });

  test('a valid mirror with no newer build still completes the check',
      () async {
    final asked = <String>[];
    final updates = AppUpdates(
        os: 'android',
        client: MockClient((request) async {
          asked.add('${request.url}');
          final build = '${request.url}' == _server ? 261028090 : 261029183;
          return http.Response(jsonEncode(_manifest(build: build)), 200);
        }));
    expect(await updates.check(), isNull);
    expect(asked, [_server]);
    expect(ConfigProvider.instance.get(Settings.lastUpdateCheck), isNotEmpty);
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

  group('Android installs', () {
    const channel = MethodChannel('test/updates');
    final update = AppUpdate.from(_manifest(),
        source: Uri.parse(_server), package: 'android', installed: 0)!;
    late List<MethodCall> calls;

    /// A platform side that answers [answers] by method name.
    AppUpdates platform(Map<String, Object? Function(MethodCall)> answers) {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return answers[call.method]!(call);
      });
      return AppUpdates(os: 'android', channel: channel);
    }

    tearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));

    test('the system decides whether installs can be silent', () async {
      for (final allowed in [true, false]) {
        final updates = platform({
          'silentSupported': (_) => allowed,
          'canInstallSilently': (_) => allowed,
        });
        expect(await updates.silentSupported(), allowed);
        expect(await updates.canInstallSilently(), allowed);
      }
    });

    test('the system installer gets the package and the update is noted',
        () async {
      await ConfigProvider.instance.set(Settings.installingUpdate, '');
      final file = File(p.join(temp.path, 'update-261029183.apk'));
      final updates = platform({'install': (_) => 'confirming'});
      expect(await updates.install(update, file), UpdateInstall.confirming);
      expect(calls.single.arguments, {'path': file.path});
      expect(ConfigProvider.instance.get(Settings.installingUpdate),
          contains('261029183'));
    });

    test('a package the app refuses is reported and not noted', () async {
      await ConfigProvider.instance.set(Settings.installingUpdate, '');
      final updates = platform({
        'install': (_) => throw PlatformException(
            code: 'wrong_key', message: 'Not signed with this app\'s key'),
      });
      await expectLater(
          updates.install(update, File(p.join(temp.path, 'update.apk'))),
          throwsA(isA<UpdateException>()
              .having((e) => e.code, 'code', 'wrong_key')));
      expect(ConfigProvider.instance.get(Settings.installingUpdate), isEmpty);
    });
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
        packageName: 'com.playeriv65.diary',
        version: '0.1.0',
        buildNumber: '261029183');
    expect((await AppUpdates().justInstalled())!.build, 261029183);
    expect(await AppUpdates().justInstalled(), isNull);
  });
}
