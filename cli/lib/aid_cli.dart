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
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

const usage = '''
aid [options] <command> [key=value ...]

Commands:
  actions                every action the app offers, with its arguments
  guide                  how an agent uses the app, as Markdown
  <action-id> [k=v ...]  runs an action, e.g. `aid entry.list limit=5`
  trace start [widgets=true]
                         records the app's timeline (debug and profile
                         builds); widgets=true adds every build, layout
                         and paint, which slows frames
  trace stop [path=...]  stops and writes it in the Chrome trace format,
                         for ui.perfetto.dev or DevTools; with vm=<uri>
                         either one uses that VM service, such as the one
                         `flutter run` prints for a debug run

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

  static const defaultPackage = 'dev.aid.diary.beta';
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
      // The app's external files folder: adb can read it, other apps
      // cannot, and it works for release builds that refuse run-as.
      final result = await _run(_adb, [
        '-s', device!, 'exec-out', 'cat', //
        '/sdcard/Android/data/$package/files/$_infoName',
      ]);
      final out = '${result.stdout}';
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
            : 'AID Diary ($package) is not answering on $device. A release '
                  'build answers once Settings > Command line is on.',
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

  /// The app's Dart VM service, which debug and profile builds serve,
  /// reachable from here: over adb through a forwarded port. [given] is
  /// one on this computer instead, such as the one `flutter run` prints:
  /// it stands between the app and every other client.
  Future<VmService> _vmService(String? given) async {
    if (given != null) return _connectVm(Uri.parse(given));
    final status = await run('app.status', {});
    final address = (status['result'] as Map?)?['vmService'] as String?;
    if (address == null) {
      throw const AidException(
        'The app serves no VM service: it is a release build.',
      );
    }
    var uri = Uri.parse(address);
    if (device != null) {
      final local = (await _adbOut([
        'forward', 'tcp:0', 'tcp:${uri.port}', //
      ])).trim();
      _vmForwarded = 'tcp:$local';
      uri = uri.replace(port: int.parse(local));
    }
    return _connectVm(uri);
  }

  Future<VmService> _connectVm(Uri uri) {
    final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
    return vmServiceConnectUri(
      uri.replace(scheme: 'ws', path: '${path}ws').toString(),
    );
  }

  String? _vmForwarded;

  static const _traceStreams = ['Dart', 'Embedder', 'GC'];

  /// Flutter's switches that put every widget build, layout and paint on
  /// the timeline, to see what a slow frame did; they slow frames down.
  static const _widgetProfiling = [
    'ext.flutter.profileWidgetBuilds',
    'ext.flutter.profileRenderObjectLayouts',
    'ext.flutter.profileRenderObjectPaints',
  ];

  /// Starts recording the timeline afresh, with every widget build, layout
  /// and paint on it when [widgets].
  Future<Map<String, Object?>> traceStart({
    required bool widgets,
    String? vm,
  }) async {
    final service = await _vmService(vm);
    try {
      await service.setVMTimelineFlags(_traceStreams);
      await service.clearVMTimeline();
      await _profileWidgets(service, widgets);
      return {
        'ok': true,
        'result': {'recording': _traceStreams, 'widgets': widgets},
      };
    } finally {
      await service.dispose();
    }
  }

  /// Stops recording and writes the timeline to [path] in the Chrome trace
  /// format, which Perfetto (ui.perfetto.dev) and DevTools open.
  Future<Map<String, Object?>> traceStop(String path, {String? vm}) async {
    final service = await _vmService(vm);
    try {
      final timeline = await service.getVMTimeline();
      await _profileWidgets(service, false);
      await service.setVMTimelineFlags([]);
      final events = [
        for (final event in timeline.traceEvents ?? <TimelineEvent>[])
          event.json,
      ];
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({'traceEvents': events}));
      return {
        'ok': true,
        'result': {'path': file.absolute.path, 'events': events.length},
      };
    } finally {
      await service.dispose();
    }
  }

  Future<void> _profileWidgets(VmService service, bool enabled) async {
    final vm = await service.getVM();
    for (final ref in vm.isolates ?? <IsolateRef>[]) {
      final Isolate isolate;
      try {
        isolate = await service.getIsolate(ref.id!);
      } on SentinelException {
        // A short-lived isolate (Isolate.run) that ended in the meantime.
        continue;
      }
      for (final extension in _widgetProfiling) {
        if (isolate.extensionRPCs?.contains(extension) ?? false) {
          await service.callServiceExtension(
            extension,
            isolateId: ref.id,
            args: {'enabled': '$enabled'},
          );
        }
      }
    }
  }

  Future<void> close() async {
    for (final forwarded in [?_forwarded, ?_vmForwarded]) {
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
    final args = <String, String>{};
    for (final pair in rest.skip(command == 'trace' ? 2 : 1)) {
      final cut = pair.indexOf('=');
      if (cut <= 0) {
        out.writeln('Arguments are key=value, not "$pair"');
        return 2;
      }
      args[pair.substring(0, cut)] = pair.substring(cut + 1);
    }
    final Map<String, Object?> reply;
    if (command == 'actions') {
      reply = await aid.actions();
    } else if (command == 'trace') {
      switch (rest.elementAtOrNull(1)) {
        case 'start':
          reply = await aid.traceStart(
            widgets: args['widgets'] == 'true',
            vm: args['vm'],
          );
        case 'stop':
          reply = await aid.traceStop(
            args['path'] ?? 'aid_timeline.json',
            vm: args['vm'],
          );
        default:
          out.writeln(
            'trace start [widgets=true] [vm=...] | trace stop [path=...] [vm=...]',
          );
          return 2;
      }
    } else {
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
  } on Exception catch (error) {
    // Scripts read the JSON; say what broke there too.
    out.writeln(
      jsonEncode({
        'ok': false,
        'error': {'code': 'failed', 'message': '$error'},
      }),
    );
    return 1;
  } finally {
    await aid.close();
  }
}
