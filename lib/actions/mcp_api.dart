// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:logging/logging.dart' as logging;
import 'package:mcp_dart/mcp_dart.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Runs the MCP server while the "MCP server" setting is on and a token is
/// set; see docs/ARCHITECTURE.md ("MCP").
class McpSwitch {
  McpSwitch._();

  static final McpSwitch instance = McpSwitch._();

  McpApi? _api;

  /// Where it listens, such as `127.0.0.1:18530`; null while off.
  String? get address => _api?.address;

  /// Why it is wanted but not running, such as a port another program has.
  String? problem;

  ConfigProvider get _config => ConfigProvider.instance;

  bool get wanted => _config.get(Settings.mcpServer);
  bool get hasToken => _config.get(Settings.mcpToken).isNotEmpty;

  /// The host names beyond the loopback address that requests may name.
  List<String> get allowedHosts =>
      _config.get(Settings.mcpAllowedHosts).cast<String>();

  /// Starts, restarts or stops the server to match the settings: on with a
  /// token, and listening with the allowed hosts set now.
  Future<void> apply() async {
    final running = _api;
    final hosts = allowedHosts;
    if (wanted && hasToken) {
      if (running != null && _sameHosts(running.allowedHosts, hosts)) return;
      await running?.stop();
      _api = null;
      final config = AppConfig.instance;
      final api = McpApi(AppActions.instance,
          host: config.mcpHost,
          port: config.mcpPort,
          path: config.mcpPath,
          tools: config.mcpTools,
          allowedHosts: hosts,
          version: (await PackageInfo.fromPlatform()).version,
          token: () => _config.get(Settings.mcpToken));
      try {
        await api.start();
        _api = api;
        problem = null;
      } on SocketException catch (error) {
        problem = 'Cannot listen on ${config.mcpHost}:${config.mcpPort}: '
            '${error.osError?.message ?? error.message}';
      }
    } else {
      problem = null;
      _api = null;
      await running?.stop();
    }
  }

  static bool _sameHosts(List<String> a, List<String> b) =>
      a.length == b.length && a.toSet().containsAll(b);
}

/// The app's read-only actions as MCP tools, for MCP clients such as
/// ChatGPT and Codex, served by `mcp_dart`'s [StreamableMcpServer]
/// (Streamable HTTP, JSON responses) on the loopback address.
///
/// Before any MCP message is read, a request must name an allowed host in
/// `Host` (and in `Origin`, when it sends one) so that a web page cannot
/// reach the server through DNS rebinding: the loopback names, and
/// [allowedHosts] for a reverse proxy in front, such as `tailscale serve`.
/// Then it needs `Authorization: Bearer <token>`.
///
/// The tools are generated from [AppActions]: an action is offered when its
/// id is in [tools] and it only reads. A listed action that does not exist
/// in this build (yet) is simply not offered.
class McpApi {
  McpApi(this.actions,
      {required this.host,
      required this.port,
      required this.path,
      required this.tools,
      this.allowedHosts = const [],
      required this.version,
      required this.token});

  final AppActions actions;
  final String host;
  final int port;
  final String path;

  /// The action ids that may be offered.
  final List<String> tools;

  /// Host names beyond the loopback ones that `Host` and `Origin` may name.
  final List<String> allowedHosts;
  final String version;

  /// The token clients must send, read at each request.
  final String Function() token;

  StreamableMcpServer? _server;

  /// The port it listens on; null while stopped.
  int? get boundPort => _server?.boundPort;

  String get address {
    final shown = host.contains(':') ? '[$host]' : host;
    return '$shown:${boundPort ?? port}';
  }

  Future<void> start() async {
    if (_server != null) return;
    // Other devices reach it only through a proxy on this one.
    if (!(InternetAddress.tryParse(host)?.isLoopback ?? false)) {
      throw ArgumentError.value(host, 'host', 'must be a loopback address');
    }
    _forwardLogs();
    final server = StreamableMcpServer(
      serverFactory: (_) => _mcpServer(),
      host: host,
      port: port,
      path: path,
      // The analyzer sees mcp_dart's web stubs, where the request is dynamic.
      authenticator: (request) => _authorized(request as HttpRequest),
      enableDnsRebindingProtection: true,
      // Replaces the library's default list, so the loopback names stay.
      allowedHosts: {host, ...loopbackHosts, ...allowedHosts},
      enableJsonResponse: true,
    );
    await server.start();
    _server = server;
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    await server?.stop();
  }

  /// The names of this device that `Host` may always give.
  static const loopbackHosts = {'localhost', '127.0.0.1', '::1'};

  /// The most host names [allowedHosts] takes.
  static const maxAllowedHosts = 16;

  /// Whether [text] is a bare host name, such as `pc.example.ts.net`: no
  /// scheme, port or path.
  static bool isHostName(String text) =>
      text.length <= 253 &&
      RegExp(r'^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?'
              r'(\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$')
          .hasMatch(text);

  /// The tools this build offers.
  List<AppAction> get offered => offeredTools(actions, tools);

  /// The actions of [actions] that are in [tools] and only read.
  static List<AppAction> offeredTools(AppActions actions, List<String> tools) =>
      [
        for (final action in actions.available)
          if (tools.contains(action.id) && action.risk == ActionRisk.read)
            action,
      ];

  static String toolName(AppAction action) => action.id.replaceAll('.', '_');

  bool _authorized(HttpRequest request) {
    final expected = token();
    final given = request.headers.value(HttpHeaders.authorizationHeader) ?? '';
    const scheme = 'bearer ';
    return expected.isNotEmpty &&
        given.length > scheme.length &&
        given.substring(0, scheme.length).toLowerCase() == scheme &&
        _same(given.substring(scheme.length), expected);
  }

  /// Compares in time that depends only on the length of [expected].
  static bool _same(String given, String expected) {
    final a = utf8.encode(given);
    final b = utf8.encode(expected);
    var differ = a.length ^ b.length;
    for (var i = 0; i < b.length; i++) {
      differ |= (i < a.length ? a[i] : 0) ^ b[i];
    }
    return differ == 0;
  }

  /// One MCP server, made per session (or per request of a stateless
  /// client) by [StreamableMcpServer].
  McpServer _mcpServer() {
    final server = McpServer(
      Implementation(name: 'aid-diary', title: 'AID Diary', version: version),
      options: const McpServerOptions(instructions: mcpInstructions),
    );
    for (final action in offered) {
      server.registerTool(
        toolName(action),
        title: action.id,
        description: action.describe,
        inputSchema: inputSchema(action),
        annotations: ToolAnnotations(
          title: action.id,
          readOnlyHint: true,
          destructiveHint: false,
          idempotentHint: true,
          openWorldHint: false,
        ),
        callback: (args, extra) => _call(action, args),
      );
    }
    return server;
  }

  /// [action]'s parameters as the JSON schema of its tool's arguments.
  static ToolInputSchema inputSchema(AppAction action) => JsonSchema.object(
        properties: {
          for (final param in action.params)
            param.name: switch (param.type) {
              ParamType.string =>
                JsonSchema.string(description: param.describe),
              ParamType.integer =>
                JsonSchema.integer(description: param.describe),
              ParamType.number =>
                JsonSchema.number(description: param.describe),
              ParamType.boolean =>
                JsonSchema.boolean(description: param.describe),
            },
        },
        required: [
          for (final param in action.params)
            if (param.required) param.name,
        ],
        additionalProperties: action.moreArgs,
      );

  Future<CallToolResult> _call(
      AppAction action, Map<String, dynamic> args) async {
    try {
      final result = await actions.run(action.id, args);
      return result is Map
          ? CallToolResult.fromStructuredContent(
              Map<String, dynamic>.from(result))
          : CallToolResult(content: [TextContent(text: jsonEncode(result))]);
    } on ActionException catch (error) {
      return CallToolResult(
        content: [
          TextContent(text: jsonEncode({'error': error.toJson()})),
        ],
        isError: true,
      );
    } catch (error, stackTrace) {
      // The client is told only that the tool failed; the log has why.
      _logger.warning('MCP tool ${action.id} failed', error, stackTrace);
      rethrow;
    }
  }

  static final _logger = logging.Logger('McpApi');

  static bool _logsForwarded = false;

  /// Sends `mcp_dart`'s own log lines to the app's log instead of stderr.
  static void _forwardLogs() {
    if (_logsForwarded) return;
    _logsForwarded = true;
    setMcpLogHandler((name, level, message) => _logger.log(
        switch (level) {
          LogLevel.debug || LogLevel.info => logging.Level.FINE,
          LogLevel.warn => logging.Level.WARNING,
          LogLevel.error => logging.Level.SEVERE,
        },
        '$name: $message'));
  }
}

/// What an MCP client is told about this server when it connects.
const String mcpInstructions = '''
AID Diary: the owner's private diary, read-only. Each entry has an id, a diary day (yyyy-MM-dd), the local time it was written, an optional title, Markdown text, and optionally a mood (-2 to 2), a place, tags and the weather of its day.
- To find entries by words, use the search tool (entry_search when offered, otherwise entry_list with search=...); to browse a period, use entry_list with from/to days; then entry_get with an id for the whole entry. Lists are paged with limit/offset and say how many match in total.
- For counts, statistics or anything across many entries, call sql_schema once, then sql_query with one read-only SQLite statement; results are capped and long queries are stopped.
- Time capsules that have not opened yet are sealed: you see that they exist and when they open, never their content.
- Quote the diary faithfully and cite entries by their diary day.
''';
