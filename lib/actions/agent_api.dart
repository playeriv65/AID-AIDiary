// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/utils/scratch_folders.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Runs the agent API while it is wanted: always in development builds, in
/// others once the user turns on the command line in settings.
class AgentApiSwitch {
  AgentApiSwitch._();

  static final AgentApiSwitch instance = AgentApiSwitch._();

  AgentApi? _api;

  /// The port it listens on; null while off.
  int? get port => _api?.port;

  bool get wanted =>
      AppActions.instance.devBuild ||
      ConfigProvider.instance.get(Settings.agentApi);

  /// Where the CLI finds the port and token: the app's own folder on
  /// Android, where `adb run-as` reads it, and `~/.aid` on computers, or
  /// the scratch folder of a tool run (`AID_API_INFO` points `aid` there).
  static Future<File> infoFile() async {
    if (scratchFolder case final folder?) {
      return File(p.join(folder, _infoName));
    }
    if (Platform.isAndroid) {
      return File(
          p.join((await getApplicationSupportDirectory()).path, _infoName));
    }
    final home = Platform.environment['USERPROFILE'] ??
        Platform.environment['HOME'] ??
        (await getApplicationSupportDirectory()).path;
    return File(p.join(home, '.aid', _infoName));
  }

  static const _infoName = 'agent_api.json';

  /// Starts or stops the API to match [wanted].
  Future<void> apply() async {
    if (wanted && _api == null) {
      final api = AgentApi(AppActions.instance, infoFile: await infoFile());
      _api = api;
      await api.start(port: AppConfig.instance.agentApiPort);
    } else if (!wanted && _api != null) {
      await _api!.stop();
      _api = null;
    }
  }
}

/// The app's actions over HTTP on this device only, for the `aid` CLI and
/// other local agents. Each start makes a new token; the port and the token
/// go into [infoFile], which only this user (and, on Android, only this
/// app) can read.
///
///     GET  /v1/actions   every action, with its arguments
///     GET  /v1/guide     how an agent uses the app, as Markdown
///     POST /v1/run       {"action": id, "args": {...}, "confirmed": bool}
class AgentApi {
  AgentApi(this.actions, {required this.infoFile});

  final AppActions actions;
  final File infoFile;
  static final Logger _logger = Logger('AgentApi');

  HttpServer? _server;
  String _token = '';

  bool get running => _server != null;
  int? get port => _server?.port;

  /// Listens on [port] of the loopback address, or any free port when that
  /// one is taken by another copy of the app.
  Future<void> start({required int port}) async {
    if (_server != null) return;
    final HttpServer server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    } on SocketException {
      return _bindAnyPort();
    }
    await _serve(server);
  }

  Future<void> _bindAnyPort() async =>
      _serve(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));

  Future<void> _serve(HttpServer server) async {
    final random = Random.secure();
    _token = [
      for (var i = 0; i < 24; i++)
        random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ].join();
    _server = server;
    await infoFile.parent.create(recursive: true);
    await infoFile.writeAsString(jsonEncode({
      'port': server.port,
      'token': _token,
      'pid': pid,
    }));
    server.listen((request) => unawaited(_handle(request)));
    _logger.info('Agent API on 127.0.0.1:${server.port}');
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    await server?.close(force: true);
    if (await infoFile.exists()) await infoFile.delete();
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    Future<void> reply(int status, Object? body) async {
      response
        ..statusCode = status
        ..headers.contentType = ContentType.json;
      response.write(jsonEncode(body));
      await response.close();
    }

    if (request.headers.value(HttpHeaders.authorizationHeader) !=
        'Bearer $_token') {
      return reply(HttpStatus.unauthorized, {
        'ok': false,
        'error': {'code': 'unauthorized', 'message': 'Wrong or missing token'},
      });
    }
    if ((request.method, request.uri.path) == ('GET', '/v1/guide')) {
      response.headers.contentType =
          ContentType('text', 'markdown', charset: 'utf-8');
      response.write(actions.guide());
      return response.close();
    }
    (int, Object?) answer;
    try {
      answer = await _answer(request);
    } on ActionException catch (error) {
      answer = (HttpStatus.badRequest, {'ok': false, 'error': error.toJson()});
    } catch (error, stackTrace) {
      _logger.warning('Action failed', error, stackTrace);
      answer = (
        HttpStatus.internalServerError,
        {
          'ok': false,
          'error': {'code': 'failed', 'message': '$error'},
        }
      );
    }
    await reply(answer.$1, answer.$2);
  }

  Future<(int, Object?)> _answer(HttpRequest request) async {
    switch ((request.method, request.uri.path)) {
      case ('GET', '/v1/actions'):
        return (200, {'ok': true, 'result': actions.describe()});
      case ('POST', '/v1/run'):
        final body = jsonDecode(await utf8.decodeStream(request))
            as Map<String, Object?>;
        final result = await actions.run(body['action'] as String,
            (body['args'] as Map? ?? const {}).cast<String, Object?>(),
            confirmed: body['confirmed'] == true);
        return (200, {'ok': true, 'result': result});
    }
    return (
      HttpStatus.notFound,
      {
        'ok': false,
        'error': {'code': 'not_found', 'message': 'No ${request.uri.path}'},
      }
    );
  }
}
