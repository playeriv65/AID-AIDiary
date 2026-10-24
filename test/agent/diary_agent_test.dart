@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/agent/aid_command.dart';
import 'package:aid_diary/agent/aid_shell.dart';
import 'package:aid_diary/agent/diary_agent.dart';
import 'package:aid_diary/agent/diary_sql.dart';
import 'package:dart_agent_core/dart_agent_core.dart';
import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'aid_shell_test.dart' show builtLibrary;

/// Answers with [script]ed messages in turn, and keeps what it was sent.
class ScriptedModel implements LLMClient {
  ScriptedModel(this.script);

  final List<ModelMessage> script;
  final List<List<LLMMessage>> seen = [];

  ModelMessage _next(List<LLMMessage> messages) {
    seen.add(List.of(messages));
    return script.removeAt(0);
  }

  @override
  Future<ModelMessage> generate(List<LLMMessage> messages,
          {List<Tool>? tools,
          ToolChoice? toolChoice,
          required ModelConfig modelConfig,
          bool? jsonOutput,
          CancelToken? cancelToken}) async =>
      _next(messages);

  @override
  Future<Stream<StreamingMessage>> stream(List<LLMMessage> messages,
          {List<Tool>? tools,
          ToolChoice? toolChoice,
          required ModelConfig modelConfig,
          bool? jsonOutput,
          CancelToken? cancelToken}) async =>
      Stream.value(StreamingMessage(modelMessage: _next(messages)));
}

/// What the last tool call returned to the model.
String toolText(ScriptedModel model) => model.seen.last
    .whereType<FunctionExecutionResultMessage>()
    .expand((message) => message.results)
    .single
    .content
    .whereType<TextPart>()
    .map((part) => part.text)
    .join();

ModelMessage bash(String script) =>
    ModelMessage(model: 'test', stopReason: 'tool_calls', functionCalls: [
      FunctionCall(
          id: 'call-${script.hashCode}',
          name: 'bash',
          arguments: jsonEncode({'command': script})),
    ]);

ModelMessage answer(String text) =>
    ModelMessage(model: 'test', stopReason: 'stop', textOutput: text);

void main() {
  late Directory folder;
  late AidShell shell;

  setUpAll(() async {
    sqfliteFfiInit();
    await AidShell.load(library: builtLibrary());
  });

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('diary_agent_test');
    final path = p.join(folder.path, 'diary.db');
    final db = await databaseFactoryFfi.openDatabase(path);
    await db.execute('CREATE TABLE entries (id INTEGER PRIMARY KEY, text TEXT)');
    await db.insert('entries', {'id': 1, 'text': 'a long walk by the river'});
    await db.close();
    shell = await AidShell.open(
      aid: AidCommand(() => AppActions(devBuild: true, actions: const [])),
      sql: DiarySql(
          () => databaseFactoryFfi.openDatabase(path,
              options:
                  OpenDatabaseOptions(readOnly: true, singleInstance: false)),
          rowLimit: 100),
    );
  });

  tearDown(() async {
    await shell.close();
    await folder.delete(recursive: true);
  });

  DiaryAgent agent(ScriptedModel model, {int outputChars = 1000}) =>
      DiaryAgent(
        model: (baseUrl: 'http://unused', model: 'test', apiKey: 'unused'),
        shell: shell,
        systemPrompt: 'You are a test.',
        outputChars: outputChars,
        maxTurns: 5,
        client: model,
      );

  test('runs the bash the model asks for and returns its answer', () async {
    final model = ScriptedModel([
      bash('sql "SELECT text FROM entries" | jq -r ".[0].text"'),
      answer('You walked by the river.'),
    ]);
    final reply = await agent(model).ask('What did I do?');

    expect(reply.answer, 'You walked by the river.');
    expect(reply.steps.single.exitCode, 0);
    expect(toolText(model), contains('a long walk by the river'));
  });

  test('cuts long output before the model sees it', () async {
    final model = ScriptedModel([
      bash('seq 1 1000'),
      answer('done'),
    ]);
    await agent(model, outputChars: 50).ask('Count');

    expect(toolText(model), contains('[cut:'));
    expect(toolText(model).length, lessThan(400));
  });
}
