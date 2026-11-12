@Tags(['widget'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/services/app_updates.dart';
import 'package:aid_diary/widgets/app_update_prompt.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  final update = AppUpdate(
    version: '0.1.0',
    build: 261029205,
    notes: const {
      'en': ['Updates by themselves'],
      'zh': ['打开应用时会检查新版本'],
    },
    url: Uri.parse('https://aid.example/updates/aid-diary.apk'),
    sha256: '00',
    size: 1,
  );

  testWidgets('the update dialog speaks the app language, buttons in a row',
      (tester) async {
    // A phone held upright.
    DiaryAppHarness.size(tester, const Size(360, 800));
    await tester.pumpWidget(harness.app(Builder(
        builder: (context) => TextButton(
            onPressed: () => showUpdateDialog(context, update),
            child: const Text('open')))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('打开应用时会检查新版本'), findsOneWidget);
    expect(find.textContaining('Updates by themselves'), findsNothing);
    final rows = {
      for (final label in ['跳过此版本', '以后再说', '更新'])
        tester.getCenter(find.text(label)).dy,
    };
    expect(rows, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  group('downloaded in the background', () {
    const channel = MethodChannel('test/updates');
    final package = List<int>.generate(2000, (i) => i % 253);
    final manifest = {
      'version': '0.2.0',
      'build': 261111120,
      'notes': ['Ready before you tap Update'],
      'files': {
        'android-dev': {
          'name': 'aid-diary-dev.apk',
          'size': package.length,
          'sha256': '${sha256.convert(package)}',
        },
      },
    };
    late AppUpdates previous;
    late Directory temp;
    late StreamController<List<int>> body;
    late List<String> calls;
    late int downloads;
    late bool metered;
    late bool silent;

    setUp(() async {
      previous = AppUpdates.instance;
      temp = await Directory.systemTemp.createTemp('aid_update_prompt');
      body = StreamController<List<int>>();
      calls = [];
      downloads = 0;
      metered = false;
      silent = false;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => temp.path);
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call.method);
        return switch (call.method) {
          'enabled' => true,
          'metered' => metered,
          'canInstallSilently' => silent,
          'install' => 'confirming',
          _ => null,
        };
      });
      DeviceInfoService().appInfo = PackageInfo(
          appName: 'AID Diary',
          packageName: 'com.playeriv65.diary.beta',
          version: '0.1.2',
          buildNumber: '261110090');
      AppUpdates.instance = AppUpdates(
          os: 'android',
          channel: channel,
          client: MockClient.streaming((request, _) async {
            if (request.url.path.endsWith('latest.json')) {
              return http.StreamedResponse(
                  Stream.value(utf8.encode(jsonEncode(manifest))), 200);
            }
            downloads++;
            return http.StreamedResponse(body.stream, 200);
          }));
    });

    tearDown(() async {
      AppUpdates.instance = previous;
      await ConfigProvider.instance.set(Settings.silentUpdates, false);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      // Made on the test's fake clock, which no longer runs: not awaited.
      unawaited(body.close());
      await temp.delete(recursive: true);
    });

    /// The shell's context, once the app is on screen.
    Future<BuildContext> shell(WidgetTester tester) async {
      late BuildContext context;
      await tester.pumpWidget(harness.app(Builder(builder: (built) {
        context = built;
        return const SizedBox();
      })));
      return context;
    }

    /// Lets real file and channel work run. Work begun from a tap waits on
    /// the fake clock between its steps, so the two take turns.
    Future<void> settle(WidgetTester tester) async {
      for (var turn = 0; turn < 40; turn++) {
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      // Settings, such as the note of an install, stay in memory: the
      // debounced file write would wait on the fake clock.
      EasyDebounce.cancel('save-config');
    }

    final dialog = find.byKey(const ValueKey('update-dialog'));

    testWidgets(
        'the dialog comes once the package is verified; Update '
        'installs it at once', (tester) async {
      final context = await shell(tester);
      await tester.runAsync(() async {
        unawaited(AppUpdatePrompt.instance.start(context));
      });
      await settle(tester);
      // Found and downloading: nothing on screen yet.
      expect(downloads, 1);
      expect(dialog, findsNothing);

      body.add(package);
      unawaited(body.close());
      await settle(tester);
      expect(dialog, findsOneWidget);
      expect(
          find.textContaining('Ready before you tap Update'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('update-install')));
      await settle(tester);
      expect(calls, contains('install'));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(downloads, 1);
      expect(dialog, findsNothing);
    });

    testWidgets(
        'Update before the download finishes shows its progress and '
        'installs when it is done', (tester) async {
      final context = await shell(tester);
      final found = (await tester.runAsync(AppUpdates.instance.check))!;
      await tester.runAsync(() async {
        unawaited(AppUpdates.instance.prefetch(found));
        unawaited(showUpdateDialog(context, found));
      });
      body.add(package.sublist(0, 1000));
      await settle(tester);
      expect(dialog, findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('update-install')));
      await settle(tester);
      expect(
          tester
              .widget<LinearProgressIndicator>(
                  find.byType(LinearProgressIndicator))
              .value,
          0.5);
      expect(calls, isNot(contains('install')));

      body.add(package.sublist(1000));
      unawaited(body.close());
      await settle(tester);
      expect(calls, contains('install'));
      expect(downloads, 1);
      expect(dialog, findsNothing);
    });

    testWidgets(
        'on a metered network the dialog asks at once and Update '
        'downloads', (tester) async {
      metered = true;
      final context = await shell(tester);
      await tester.runAsync(() async {
        unawaited(AppUpdatePrompt.instance.start(context));
      });
      await settle(tester);
      expect(dialog, findsOneWidget);
      expect(downloads, 0);

      await tester.tap(find.byKey(const ValueKey('update-install')));
      body.add(package);
      unawaited(body.close());
      await settle(tester);
      expect(downloads, 1);
      expect(calls, contains('install'));
    });

    testWidgets('a failed download shows nothing; the next start tries again',
        (tester) async {
      final context = await shell(tester);
      await tester.runAsync(() async {
        unawaited(AppUpdatePrompt.instance.start(context));
      });
      await settle(tester);
      body.add(package.sublist(0, 500));
      body.addError(const SocketException('reset'));
      unawaited(body.close());
      await settle(tester);
      expect(dialog, findsNothing);
      expect(tester.takeException(), isNull);

      // The app opens again before the next check is due.
      body = StreamController<List<int>>();
      AppUpdates.instance = AppUpdates(
          os: 'android',
          channel: channel,
          client: MockClient.streaming((request, _) async {
            downloads++;
            expect(request.headers['Range'], 'bytes=500-');
            return http.StreamedResponse(body.stream, 206,
                headers: {'content-range': 'bytes 500-1999/2000'});
          }));
      await tester.runAsync(() async {
        unawaited(AppUpdatePrompt.instance.start(context));
      });
      body.add(package.sublist(500));
      unawaited(body.close());
      await settle(tester);
      expect(downloads, 2);
      expect(dialog, findsOneWidget);
    });

    testWidgets(
        'silent updates install the downloaded package when the user '
        'leaves', (tester) async {
      silent = true;
      await ConfigProvider.instance.set(Settings.silentUpdates, true);
      final context = await shell(tester);
      await tester.runAsync(() async {
        unawaited(AppUpdatePrompt.instance.start(context));
      });
      body.add(package);
      unawaited(body.close());
      await settle(tester);
      expect(dialog, findsNothing);
      expect(calls, isNot(contains('install')));

      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await settle(tester);
      expect(calls, contains('install'));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    });
  });
}
