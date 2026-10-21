// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

/// The `aid` command line: runs AID Diary's actions in the running app, on
/// this computer or on a phone or tablet over adb, and prints JSON. The app
/// does the work, so its screen shows what a command changes.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart' as http;

const usage = '''
aid [options] <command> [key=value ...]

Commands:
  actions                every action the app offers, with its arguments
  guide                  how an agent uses the app, as Markdown
  <action-id> [k=v ...]  runs an action, e.g. `aid entry.list limit=5`

Options:
''';

/// Runs a program and returns what it printed; a seam for tests.
typedef RunProcess =
    Future<ProcessResult> Function(String executable, List<String> arguments);

Future<ProcessResult> _runProcess(String executable, List<String> arguments) =>
    Process.run(executable, arguments, stdoutEncoding: utf8);

class AidException implements Exception {
  const AidException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Where the app's agent API answers, and the token for it.
typedef Endpoint = ({Uri base, String token});

/// Finds the app and talks to it.
class AidClient {
  AidClient({
    this.device,
    this.package = defaultPackage,
    this.launch = true,
    RunProcess? run,
    http.Client? client,
    Map<String, String>? environment,
    this.waitForApp = const Duration(seconds: 30),
  }) : _run = run ?? _runProcess,
       _client = client ?? http.Client(),
       _environment = environment ?? Platform.environment;

  static const defaultPackage = 'dev.aid.diary.dev';
  static const _infoName = 'agent_api.json';

  /// An adb serial; null for the app on this computer.
  final String? device;
  final String package;

  /// Start the app when it is not running.
  final bool launch;
  final Duration waitForApp;
  final RunProcess _run;
  final http.Client _client;
  final Map<String, String> _environment;
  Endpoint? _endpoint;
  String? _forwarded;

  String get _adb => _environment['ADB'] ?? 'adb';

  Future<String> _adbOut(List<String> arguments) async {
    final result = await _run(_adb, ['-s', device!, ...arguments]);
    if (result.exitCode != 0) {
      throw AidException('adb ${arguments.join(' ')}: ${result.stderr}'.trim());
    }
    return '${result.stdout}';
  }

  /// The port and token the app wrote, or null when it is not running.
  Future<({int port, String token})?> _readInfo() async {
    final String text;
    if (device == null) {
      final file = File(
        _environment['AID_API_INFO'] ??
            '${_environment['USERPROFILE'] ?? _environment['HOME']}'
                '${Platform.pathSeparator}.aid${Platform.pathSeparator}$_infoName',
      );
      if (!await file.exists()) return null;
      text = await file.readAsString();
    } else {
      final result = await _run(_adb, [
        '-s', device!, 'exec-out', 'run-as', package, 'cat', //
        'files/$_infoName',
      ]);
      final out = '${result.stdout}';
      final said = '$out${result.stderr}';
      if (said.contains('not debuggable') || said.contains('unknown package')) {
        throw AidException(
          'run-as $package: ${said.trim()}. Over adb aid '
          'reaches development builds only.',
        );
      }
      if (result.exitCode != 0 || !out.trimLeft().startsWith('{')) {
        return null;
      }
      text = out;
    }
    final json = jsonDecode(text) as Map<String, Object?>;
    return (port: json['port'] as int, token: json['token'] as String);
  }

  Future<Endpoint?> _connect() async {
    final info = await _readInfo();
    if (info == null) return null;
    var port = info.port;
    if (device != null) {
      final local = await _adbOut(['forward', 'tcp:0', 'tcp:$port']);
      _forwarded = 'tcp:${local.trim()}';
      port = int.parse(local.trim());
    }
    final endpoint = (
      base: Uri.parse('http://127.0.0.1:$port/v1/'),
      token: info.token,
    );
    // A file left by an app that has since stopped points at nothing.
    try {
      await _get(endpoint, 'actions');
      return endpoint;
    } on SocketException {
      return null;
    } on http.ClientException {
      return null;
    }
  }

  Future<Endpoint> _ensureEndpoint() async {
    final known = _endpoint;
    if (known != null) return known;
    var endpoint = await _connect();
    if (endpoint == null && launch) {
      await _start();
      final deadline = DateTime.now().add(waitForApp);
      while (endpoint == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        endpoint = await _connect();
      }
    }
    if (endpoint == null) {
      throw AidException(
        device == null
            ? 'AID Diary is not running on this computer. Start it, then try '
                  'again.'
            : 'AID Diary ($package) is not answering on $device.',
      );
    }
    return _endpoint = endpoint;
  }

  Future<void> _start() async {
    if (device == null) return;
    await _adbOut([
      'shell', 'monkey', '-p', package, //
      '-c', 'android.intent.category.LAUNCHER', '1',
    ]);
  }

  Future<http.Response> _get(Endpoint endpoint, String path) => _client.get(
    endpoint.base.resolve(path),
    headers: {'Authorization': 'Bearer ${endpoint.token}'},
  );

  Future<String> guide() async =>
      utf8.decode((await _get(await _ensureEndpoint(), 'guide')).bodyBytes);

  Future<Map<String, Object?>> actions() async =>
      _decode(await _get(await _ensureEndpoint(), 'actions'));

  Future<Map<String, Object?>> run(
    String action,
    Map<String, String> args, {
    bool confirmed = false,
  }) async {
    final endpoint = await _ensureEndpoint();
    return _decode(
      await _client.post(
        endpoint.base.resolve('run'),
        headers: {
          'Authorization': 'Bearer ${endpoint.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'action': action,
          'args': args,
          'confirmed': confirmed,
        }),
      ),
    );
  }

  Map<String, Object?> _decode(http.Response response) =>
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;

  Future<void> close() async {
    if (_forwarded case final forwarded?) {
      await _run(_adb, ['-s', device!, 'forward', '--remove', forwarded]);
    }
    _client.close();
  }
}

ArgParser buildParser() => ArgParser()
  ..addOption(
    'device',
    abbr: 'd',
    help: 'An adb serial: the app on that phone or tablet',
  )
  ..addOption(
    'package',
    abbr: 'p',
    defaultsTo: AidClient.defaultPackage,
    help: 'The Android package over adb',
  )
  ..addFlag(
    'yes',
    abbr: 'y',
    negatable: false,
    help: 'Confirm a destructive action',
  )
  ..addFlag(
    'launch',
    defaultsTo: true,
    help: 'Start the app when it is not running',
  )
  ..addFlag('help', abbr: 'h', negatable: false);

/// Runs the command line; returns the exit code: 0 done, 1 the action
/// failed, 2 the command was wrong or the app could not be reached.
Future<int> runAid(
  List<String> arguments, {
  StringSink? out,
  AidClient Function(ArgResults options)? client,
}) async {
  out ??= stdout;
  final parser = buildParser();
  final ArgResults options;
  try {
    options = parser.parse(arguments);
  } on FormatException catch (error) {
    out.writeln('${error.message}\n\n$usage${parser.usage}');
    return 2;
  }
  final rest = options.rest;
  if (options.flag('help') || rest.isEmpty) {
    out.writeln('$usage${parser.usage}');
    return rest.isEmpty && !options.flag('help') ? 2 : 0;
  }
  final aid =
      client?.call(options) ??
      AidClient(
        device: options.option('device'),
        package: options.option('package')!,
        launch: options.flag('launch'),
      );
  try {
    final command = rest.first;
    if (command == 'guide') {
      out.write(await aid.guide());
      return 0;
    }
    final Map<String, Object?> reply;
    if (command == 'actions') {
      reply = await aid.actions();
    } else {
      final args = <String, String>{};
      for (final pair in rest.skip(1)) {
        final cut = pair.indexOf('=');
        if (cut <= 0) {
          out.writeln('Arguments are key=value, not "$pair"');
          return 2;
        }
        args[pair.substring(0, cut)] = pair.substring(cut + 1);
      }
      reply = await aid.run(command, args, confirmed: options.flag('yes'));
    }
    out.writeln(const JsonEncoder.withIndent('  ').convert(reply));
    return reply['ok'] == true ? 0 : 1;
  } on AidException catch (error) {
    out.writeln(
      jsonEncode({
        'ok': false,
        'error': {'code': 'unreachable', 'message': error.message},
      }),
    );
    return 2;
  } finally {
    await aid.close();
  }
}
