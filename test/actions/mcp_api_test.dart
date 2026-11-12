// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/mcp_api.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/storage/in_memory_file_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

import '../support/diary_app_harness.dart';

const _token = 'test-token-0123456789-0123456789-abcdef';
const _version = '2025-11-25';

/// Tools listed in the test configuration: a write action and one this
/// build does not have are on the list too, and still not offered.
const _tools = [
  'entry.search',
  'entry.list',
  'entry.get',
  'sql.query',
  'sql.schema',
  'app.status',
  'entry.create',
];

typedef _Reply = ({int status, HttpHeaders headers, String text});

void main() {
  final actions = AppActions(devBuild: true);
  late Directory folder;
  late McpApi server;
  late HttpClient client;

  setUp(() async {
    // flutter_test answers every HttpClient request with 400 otherwise.
    HttpOverrides.global = null;
    ImageStorage.instance
        .overrideStores(InMemoryFileStore(), InMemoryFileStore());
    PackageInfo.setMockInitialValues(
        appName: 'AID Diary',
        packageName: 'com.playeriv65.diary.beta',
        version: '0.3.0',
        buildNumber: '1',
        buildSignature: '');
    folder = await Directory.systemTemp.createTemp('aid_mcp');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (_) async => folder.path);
    server = McpApi(actions,
        host: '127.0.0.1',
        // Never the configured port: another server may be using it.
        port: 0,
        path: '/mcp',
        tools: _tools,
        allowedHosts: const ['pc.example.ts.net', 'chatgpt.com'],
        version: '0.3.0',
        token: () => _token);
    await server.start();
    client = HttpClient();
  });
  tearDown(() async {
    client.close(force: true);
    await server.stop();
    ImageStorage.instance.clearStoreOverrides();
    await folder.delete(recursive: true);
  });
  DiaryAppHarness().register(
      databasePath: () => p.join(folder.path, AppDatabase.databaseFileName));

  Future<_Reply> send(Object? message,
      {String method = 'POST',
      String? session,
      String path = '/mcp',
      String? host,
      String? origin,
      String? authorization = 'Bearer $_token'}) async {
    final request =
        await client.open(method, '127.0.0.1', server.boundPort!, path);
    request.headers
      ..set(HttpHeaders.hostHeader, host ?? server.address)
      ..set(HttpHeaders.acceptHeader, 'application/json, text/event-stream')
      ..set('MCP-Protocol-Version', _version);
    if (authorization != null) {
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
    }
    if (session != null) request.headers.set('Mcp-Session-Id', session);
    if (origin != null) request.headers.set('Origin', origin);
    if (message != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(message));
    }
    final response = await request.close();
    return (
      status: response.statusCode,
      headers: response.headers,
      text: await utf8.decodeStream(response),
    );
  }

  Map<String, Object?> json(_Reply reply) =>
      jsonDecode(reply.text) as Map<String, Object?>;

  Map<String, Object?> initializeMessage() => {
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'initialize',
        'params': {
          'protocolVersion': _version,
          'capabilities': {},
          'clientInfo': {'name': 'test', 'version': '1'},
        },
      };

  /// Starts a session the way an MCP client does.
  Future<String> initialize() async {
    final reply = await send(initializeMessage());
    expect(reply.status, 200, reason: reply.text);
    final session = reply.headers.value('mcp-session-id')!;
    final ready = await send(
        {'jsonrpc': '2.0', 'method': 'notifications/initialized'},
        session: session);
    expect(ready.status, 202, reason: ready.text);
    return session;
  }

  Future<Map<String, Object?>> request(
      String session, String method, Map<String, Object?> params) async {
    final reply = await send(
        {'jsonrpc': '2.0', 'id': 7, 'method': method, 'params': params},
        session: session);
    expect(reply.status, 200, reason: reply.text);
    return json(reply);
  }

  Future<Map<String, Object?>> call(String session, String tool,
          [Map<String, Object?> arguments = const {}]) async =>
      (await request(session, 'tools/call', {
        'name': tool,
        'arguments': arguments
      }))['result'] as Map<String, Object?>;

  Map<String, Object?> structured(Map<String, Object?> result) {
    expect(result['isError'], isNot(true), reason: '$result');
    final content = result['structuredContent'] as Map<String, Object?>;
    // Clients without structured content read the same JSON as text.
    expect(jsonDecode((result['content'] as List).single['text'] as String),
        content);
    return content;
  }

  test('initialize starts a session with the server and its instructions',
      () async {
    final reply = await send(initializeMessage());
    expect(reply.status, 200);
    expect(reply.headers.value('mcp-session-id'), isNotEmpty);
    final result = json(reply)['result'] as Map<String, Object?>;
    expect(result['protocolVersion'], _version);
    expect(result['capabilities'], containsPair('tools', isA<Map>()));
    expect(result['serverInfo'], containsPair('version', '0.3.0'));
    expect(result['instructions'], mcpInstructions);
  });

  test('the tools are the listed read-only actions of AppActions', () async {
    final session = await initialize();
    final tools = ((await request(session, 'tools/list', {}))['result']
        as Map)['tools'] as List;
    final expected = [
      for (final action in actions.available)
        if (_tools.contains(action.id) && action.risk == ActionRisk.read)
          action,
    ];
    expect(expected.map((action) => action.id),
        containsAll(['entry.list', 'entry.get', 'sql.query', 'sql.schema']));
    expect({for (final tool in tools) tool['name']},
        {for (final action in expected) McpApi.toolName(action)});
    for (final tool in tools.cast<Map<String, Object?>>()) {
      final action =
          expected.singleWhere((a) => McpApi.toolName(a) == tool['name']);
      expect(tool['description'], action.describe);
      expect(tool['annotations'], containsPair('readOnlyHint', true));
      final schema = tool['inputSchema'] as Map<String, Object?>;
      expect(schema['additionalProperties'], isFalse);
      expect((schema['properties'] as Map? ?? {}).keys,
          [for (final param in action.params) param.name]);
    }
    final get = tools.cast<Map>().singleWhere((t) => t['name'] == 'entry_get');
    expect(get['inputSchema'], containsPair('required', ['id']));
    expect(((get['inputSchema'] as Map)['properties'] as Map)['id'],
        containsPair('type', 'integer'));
  });

  test('tools answer with the actions\' results, and capsules stay sealed',
      () async {
    final open = (await actions.run('entry.create', {
      'text': 'walked to the lake',
      'time': '2026-03-01T09:00:00+08:00',
    }) as Map)['id'] as int;
    final sealed = (await actions.run('entry.create', {
      'text': 'the sealed secret',
      'time': '2026-03-02T09:00:00+08:00',
    }) as Map)['id'] as int;
    final opens = DateTime.now().add(const Duration(days: 30));
    await actions.run('entry.seal', {
      'id': '$sealed',
      'opens': '${opens.year}-${'${opens.month}'.padLeft(2, '0')}-'
          '${'${opens.day}'.padLeft(2, '0')}',
    });
    final session = await initialize();

    final list = structured(await call(
        session, 'entry_list', {'from': '2026-03-01', 'to': '2026-03-02'}));
    expect(list['total'], 2);
    expect(jsonEncode(list), isNot(contains('secret')));
    expect((list['entries'] as List).firstWhere((e) => e['id'] == sealed),
        containsPair('sealed', true));

    final entry = structured(await call(session, 'entry_get', {'id': open}));
    expect(entry['text'], 'walked to the lake');
    final capsule =
        structured(await call(session, 'entry_get', {'id': sealed}));
    expect(capsule, containsPair('sealed', true));
    expect(jsonEncode(capsule), isNot(contains('secret')));

    final rows = structured(await call(session, 'sql_query',
        {'query': 'SELECT id, text FROM entries ORDER BY id'}));
    expect(rows['rows'], [
      {'id': open, 'text': 'walked to the lake'},
      {'id': sealed, 'text': null},
    ]);
    final everything = structured(await call(session, 'sql_query',
        {'query': "SELECT * FROM entries WHERE text LIKE '%secret%'"}));
    expect(everything['total'], 0);

    final schema = structured(await call(session, 'sql_schema'));
    expect(schema['conventions'], contains('utc_offset'));
    expect(jsonEncode(schema['schema']), contains('day_weather'));

    final status = structured(await call(session, 'app_status'));
    expect(status['entries'], 2);
  });

  test('bad arguments and failed actions are tool errors; writes stay out',
      () async {
    final session = await initialize();
    final capped = structured(await call(session, 'sql_query', {
      'query': 'WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 '
          'FROM n WHERE i < 6000) SELECT i FROM n',
      'limit': 100000,
    }));
    expect(capped['total'], 6000);
    expect((capped['rows'] as List).length, AppConfig.instance.sqlMaxRows);
    expect(capped['truncated'], isTrue);

    expect((await call(session, 'entry_get', {'id': 1, 'extra': 1}))['isError'],
        isTrue);
    expect((await call(session, 'entry_get'))['isError'], isTrue);
    final missing = await call(session, 'entry_get', {'id': 999});
    expect(missing['isError'], isTrue);
    expect(jsonEncode(missing['content']), contains('not_found'));

    final sqlWrite = await call(
        session, 'sql_query', {'query': "UPDATE entries SET text = 'x'"});
    expect(sqlWrite['isError'], isTrue);

    final write = await request(session, 'tools/call', {
      'name': 'entry_create',
      'arguments': {'text': 'x'}
    });
    expect(write, contains('error'));
    expect(await actions.run('entry.list', {}), containsPair('total', 0));
  });

  test('a request needs the token, an allowed host and an allowed origin',
      () async {
    final message = initializeMessage();
    for (final authorization in [null, 'Bearer wrong', 'Basic $_token']) {
      final refused = await send(message, authorization: authorization);
      expect(refused.status, 403, reason: '$authorization');
      expect(refused.headers.value('mcp-session-id'), isNull);
    }
    expect((await send(message, authorization: 'bearer $_token')).status, 200);

    for (final host in ['evil.example', 'evil.example:80', 'example.ts.net']) {
      final refused = await send(message, host: host);
      expect(refused.status, 403, reason: host);
      expect(refused.text, contains('DNS rebinding'));
    }
    for (final host in [
      'localhost:1234',
      'pc.example.ts.net',
      'PC.example.ts.net:443'
    ]) {
      expect((await send(message, host: host)).status, 200, reason: host);
    }
    // A reverse proxy forwards the browser's origin with its own host.
    expect(
        (await send(message,
                host: 'pc.example.ts.net', origin: 'https://chatgpt.com'))
            .status,
        200);
    expect((await send(message, origin: 'https://evil.example')).status, 403);
    expect((await send(message, path: '/other')).status, 404);
  });

  test('only a loopback address is listened on', () {
    expect(
        McpApi(actions,
            host: '0.0.0.0',
            port: 0,
            path: '/mcp',
            tools: _tools,
            version: '0.3.0',
            token: () => _token).start(),
        throwsArgumentError);
  });

  test('allowed hosts are bare host names, set through settings.set', () async {
    Future<Object?> set(String value) =>
        actions.run('settings.set', {'key': 'mcpAllowedHosts', 'value': value});
    await set('["pc.example.ts.net","chatgpt.com"]');
    expect(ConfigProvider.instance.get(Settings.mcpAllowedHosts),
        ['pc.example.ts.net', 'chatgpt.com']);
    expect(await actions.run('mcp.status', {}),
        containsPair('allowedHosts', ['pc.example.ts.net', 'chatgpt.com']));
    for (final wrong in [
      '["https://chatgpt.com"]',
      '["pc.example.ts.net:443"]',
      '["a/b"]',
      '[1]',
      '"pc.example.ts.net"',
    ]) {
      await expectLater(
          set(wrong),
          throwsA(
              isA<ActionException>().having((e) => e.code, 'code', 'bad_args')),
          reason: wrong);
    }
    await set('[]');
    expect(ConfigProvider.instance.get(Settings.mcpAllowedHosts), isEmpty);
  });
}
