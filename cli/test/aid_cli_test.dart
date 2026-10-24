// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

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

  String info() => jsonEncode({'port': server.port, 'token': token});
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

  test('--info finds an app with its own data folder, before AID_API_INFO',
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
  });

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

  test(
    'reaches a phone over adb: reads the token, forwards, cleans up',
    () async {
      final calls = <List<String>>[];
      Future<ProcessResult> adb(
        String executable,
        List<String> arguments,
      ) async {
        calls.add(arguments);
        final stdout = switch (arguments) {
          [_, _, 'exec-out', 'cat', _] => app.info(),
          [_, _, 'forward', 'tcp:0', _] => '${app.server.port}\n',
          _ => '',
        };
        return ProcessResult(0, 0, stdout, '');
      }

      final (code, _) = await aid([
        '-d',
        'phone',
        'sync.now',
      ], client: () => AidClient(device: 'phone', run: adb, launch: false));

      expect(code, 0);
      expect(calls.first, [
        '-s', 'phone', 'exec-out', 'cat', //
        '/sdcard/Android/data/${AidClient.defaultPackage}/files/agent_api.json',
      ]);
      expect(
        calls,
        contains(
          equals(['-s', 'phone', 'forward', 'tcp:0', 'tcp:${app.server.port}']),
        ),
      );
      expect(calls.last, [
        '-s',
        'phone',
        'forward',
        '--remove',
        'tcp:${app.server.port}',
      ]);
      expect(app.runs.single['action'], 'sync.now');
    },
  );

  test('a release build without the command line on is explained', () async {
    Future<ProcessResult> adb(
      String executable,
      List<String> arguments,
    ) async => ProcessResult(
      0,
      1,
      '',
      'cat: /sdcard/Android/data/dev.aid.diary/files/agent_api.json: '
          'No such file or directory',
    );

    final (code, out) = await aid(
      ['-d', 'phone', 'app.status'],
      client: () => AidClient(
        device: 'phone',
        package: 'dev.aid.diary',
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
