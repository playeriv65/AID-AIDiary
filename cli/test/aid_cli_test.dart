// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aid_cli/aid_cli.dart';
import 'package:test/test.dart';

/// The app's agent API as far as the CLI sees it.
class FakeApp {
  late HttpServer server;
  final List<Map<String, Object?>> runs = [];
  static const token = 'secret-token';

  Future<void> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final response = request.response..headers.contentType = ContentType.json;
      if (request.headers.value('authorization') != 'Bearer $token') {
        response.statusCode = 401;
        response.write(jsonEncode({'ok': false}));
      } else if (request.uri.path == '/v1/actions') {
        response.write(
          jsonEncode({
            'ok': true,
            'result': [
              {'id': 'entry.list'},
            ],
          }),
        );
      } else if (request.uri.path == '/v1/guide') {
        response.headers.contentType = ContentType.text;
        response.write('# AID Diary for agents');
      } else {
        final body =
            jsonDecode(await utf8.decodeStream(request))
                as Map<String, Object?>;
        runs.add(body);
        response.write(
          jsonEncode(
            body['action'] == 'entry.delete' && body['confirmed'] != true
                ? {
                    'ok': false,
                    'error': {'code': 'needs_confirmation'},
                  }
                : {'ok': true, 'result': body['args']},
          ),
        );
      }
      await response.close();
    });
  }

  String info({int? port}) =>
      jsonEncode({'port': port ?? server.port, 'token': token});
}

/// adb as far as the CLI uses it: one app per device serial, and a forward
/// table like the adb server's that every client in a test shares. A
/// forward is a real local port that carries connections to the device's
/// app while it [FakeDevice.answering].
class FakeAdb {
  FakeAdb(this.devices);

  /// The port the app listens on inside each device, as on real devices.
  static const devicePort = 47819;

  final Map<String, FakeDevice> devices;
  final forwards = <({String serial, int local, int remote})>[];
  final _listeners = <int, ServerSocket>{};
  final calls = <List<String>>[];

  int created(String serial) => calls
      .where(
        (call) => call.length > 3 && call[1] == serial && call[3] == 'tcp:0',
      )
      .length;

  Future<ProcessResult> call(String executable, List<String> arguments) async {
    calls.add(arguments);
    // Slow enough that parallel callers interleave.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final [_, serial, ...command] = arguments;
    final device = devices[serial]!;
    switch (command) {
      case ['exec-out', 'cat', _]:
        return ProcessResult(0, 0, device.app.info(port: devicePort), '');
      case ['forward', '--list']:
        return ProcessResult(
          0,
          0,
          [
            for (final f in forwards)
              '${f.serial} tcp:${f.local} tcp:${f.remote}\n',
          ].join(),
          '',
        );
      case ['forward', 'tcp:0', final remote]:
        final listener = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        listener.listen((client) => _carry(client, device));
        _listeners[listener.port] = listener;
        forwards.add((
          serial: serial,
          local: listener.port,
          remote: int.parse(remote.substring(4)),
        ));
        return ProcessResult(0, 0, '${listener.port}\n', '');
      case ['forward', '--remove', final local]:
        final port = int.parse(local.substring(4));
        final listener = _listeners.remove(port);
        if (listener == null) {
          return ProcessResult(0, 1, '', "listener '$local' not found");
        }
        await listener.close();
        forwards.removeWhere((f) => f.local == port);
        return ProcessResult(0, 0, '', '');
      case ['shell', 'monkey', ...]:
        device.launched++;
        return ProcessResult(0, 0, '', '');
    }
    return ProcessResult(0, 1, '', 'unexpected adb $arguments');
  }

  Future<void> _carry(Socket client, FakeDevice device) async {
    if (!device.answering) {
      client.destroy();
      return;
    }
    final app = await Socket.connect(
      InternetAddress.loopbackIPv4,
      device.app.server.port,
    );
    unawaited(client.cast<List<int>>().pipe(app));
    unawaited(app.cast<List<int>>().pipe(client));
  }

  Future<void> close() async {
    for (final listener in _listeners.values) {
      await listener.close();
    }
  }
}

class FakeDevice {
  FakeDevice(this.app);
  final FakeApp app;
  bool answering = true;
  int launched = 0;
}

void main() {
  late FakeApp app;
  late Directory home;

  setUp(() async {
    app = FakeApp();
    await app.start();
    home = await Directory.systemTemp.createTemp('aid_cli');
  });

  tearDown(() async {
    await app.server.close(force: true);
    await home.delete(recursive: true);
  });

  Future<(int, String)> aid(
    List<String> arguments, {
    AidClient Function()? client,
  }) async {
    final out = StringBuffer();
    final code = await runAid(
      arguments,
      out: out,
      client: client == null ? null : (_) => client(),
    );
    return (code, out.toString());
  }

  AidClient local({bool withInfo = true}) {
    final info = File('${home.path}/agent_api.json');
    if (withInfo) info.writeAsStringSync(app.info());
    return AidClient(environment: {'AID_API_INFO': info.path}, launch: false);
  }

  test('runs an action on this computer with key=value arguments', () async {
    final (code, out) = await aid([
      'entry.list',
      'limit=2',
      'day=2026-10-20',
    ], client: local);

    expect(code, 0);
    expect(app.runs.single, {
      'action': 'entry.list',
      'args': {'limit': '2', 'day': '2026-10-20'},
      'confirmed': false,
    });
    expect(jsonDecode(out), {
      'ok': true,
      'result': {'limit': '2', 'day': '2026-10-20'},
    });
  });

  test('a destructive action goes ahead only with --yes', () async {
    expect((await aid(['entry.delete', 'id=3'], client: local)).$1, 1);
    expect((await aid(['--yes', 'entry.delete', 'id=3'], client: local)).$1, 0);
    expect(app.runs.last['confirmed'], isTrue);
  });

  test('lists the actions and prints the guide', () async {
    expect(jsonDecode((await aid(['actions'], client: local)).$2)['result'], [
      {'id': 'entry.list'},
    ]);
    expect(
      (await aid(['guide'], client: local)).$2,
      startsWith('# AID Diary for agents'),
    );
  });

  test(
    '--info finds an app with its own data folder, before AID_API_INFO',
    () async {
      final info = File('${home.path}/scratch_api.json')
        ..writeAsStringSync(app.info());
      final (code, _) = await aid(
        ['--info', info.path, 'entry.list'],
        client: () => AidClient(
          info: info.path,
          environment: {'AID_API_INFO': '${home.path}/missing.json'},
          launch: false,
        ),
      );
      expect(code, 0);
      expect(app.runs.single['action'], 'entry.list');
    },
  );

  test('says so when the app is not running', () async {
    final (code, out) = await aid([
      'app.status',
    ], client: () => local(withInfo: false));
    expect(code, 2);
    expect(jsonDecode(out)['error']['code'], 'unreachable');

    // A file left behind by an app that stopped is not running either.
    final port = app.server.port;
    await app.server.close(force: true);
    File(
      '${home.path}/agent_api.json',
    ).writeAsStringSync(jsonEncode({'port': port, 'token': FakeApp.token}));
    expect(
      (await aid(['app.status'], client: () => local(withInfo: false))).$1,
      2,
    );
  });

  group('over adb', () {
    late FakeApp tabletApp;
    late FakeAdb adb;

    setUp(() async {
      tabletApp = FakeApp();
      await tabletApp.start();
      adb = FakeAdb({
        'phone': FakeDevice(app),
        'tablet': FakeDevice(tabletApp),
      });
    });

    tearDown(() async {
      await adb.close();
      await tabletApp.server.close(force: true);
    });

    Future<int> call(
      String serial, {
      bool launch = false,
      Duration waitForApp = const Duration(seconds: 30),
    }) async => (await aid(
      ['-d', serial, 'sync.now'],
      client: () => AidClient(
        device: serial,
        run: adb.call,
        launch: launch,
        waitForApp: waitForApp,
      ),
    )).$1;

    test(
      'reads the token and keeps one forward that later calls reuse',
      () async {
        for (var i = 0; i < 5; i++) {
          expect(await call('phone'), 0);
        }

        expect(adb.calls.first, [
          '-s', 'phone', 'exec-out', 'cat', //
          '/sdcard/Android/data/${AidClient.defaultPackage}/files/agent_api.json',
        ]);
        expect(adb.created('phone'), 1);
        expect(adb.forwards, [
          (serial: 'phone', local: adb.forwards.single.local, remote: 47819),
        ]);
        expect(app.runs, hasLength(5));
      },
    );

    test('two devices get one forward each, to their own app', () async {
      for (var i = 0; i < 3; i++) {
        expect(await call('phone'), 0);
        expect(await call('tablet'), 0);
      }

      expect(
        adb.forwards.map((f) => f.serial),
        unorderedEquals(['phone', 'tablet']),
      );
      expect(app.runs, hasLength(3));
      expect(tabletApp.runs, hasLength(3));
    });

    test('parallel calls share one forward per device', () async {
      final codes = await Future.wait([
        for (var i = 0; i < 8; i++) call(i.isEven ? 'phone' : 'tablet'),
      ]);

      expect(codes, everyElement(0));
      expect(
        adb.forwards.map((f) => f.serial),
        unorderedEquals(['phone', 'tablet']),
      );
      expect(app.runs, hasLength(4));
      expect(tabletApp.runs, hasLength(4));
    });

    test('a call that cannot reach the app leaves no forward', () async {
      final phone = adb.devices['phone']!;
      expect(await call('tablet'), 0);
      expect(await call('phone'), 0);
      // The phone's app stops; its forward from the earlier call is stale.
      phone.answering = false;

      expect(await call('phone'), 2);
      expect(
        await call(
          'phone',
          launch: true,
          waitForApp: const Duration(milliseconds: 1200),
        ),
        2,
      );

      expect(phone.launched, 1);
      expect(adb.forwards.map((f) => f.serial), ['tablet']);
      expect(app.runs, hasLength(1));
    });

    test(
      'an app that starts while the call waits leaves one forward',
      () async {
        final phone = adb.devices['phone']!..answering = false;
        Timer(const Duration(milliseconds: 1200), () => phone.answering = true);

        expect(await call('phone', launch: true), 0);

        expect(phone.launched, 1);
        expect(adb.forwards.map((f) => f.serial), ['phone']);
        expect(app.runs, hasLength(1));
      },
    );
  });

  test('a release build without the command line on is explained', () async {
    Future<ProcessResult> adb(
      String executable,
      List<String> arguments,
    ) async => ProcessResult(
      0,
      1,
      '',
      'cat: /sdcard/Android/data/com.playeriv65.diary/files/agent_api.json: '
          'No such file or directory',
    );

    final (code, out) = await aid(
      ['-d', 'phone', 'app.status'],
      client: () => AidClient(
        device: 'phone',
        package: 'com.playeriv65.diary',
        run: adb,
        launch: false,
      ),
    );

    expect(code, 2);
    expect(jsonDecode(out)['error']['message'], contains('Command line'));
  });

  test('a malformed argument is a usage error', () async {
    expect((await aid(['entry.get', '12'], client: local)).$1, 2);
  });
}
