import 'dart:convert';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/agent/aid_command.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final calls = <(String, ActionArgs)>[];
  final actions = AppActions(devBuild: true, actions: [
    AppAction(
      id: 'entry.list',
      describe: 'Lists entries.',
      risk: ActionRisk.read,
      params: const [
        ActionParam('limit', ParamType.integer, 'How many', required: false),
      ],
      run: (context, args) async {
        calls.add(('entry.list', args));
        return [
          {'id': 1, 'text': 'hello'},
        ];
      },
    ),
    AppAction(
      id: 'entry.delete',
      describe: 'Deletes an entry.',
      risk: ActionRisk.destructive,
      params: const [ActionParam('id', ParamType.integer, 'The entry')],
      run: (context, args) async {
        calls.add(('entry.delete', args));
        return null;
      },
    ),
    AppAction(
      id: 'agent.ask',
      describe: 'Asks the agent.',
      risk: ActionRisk.write,
      run: (context, args) async => fail('reached a closed area'),
    ),
  ]);
  final aid = AidCommand(() => actions);

  setUp(calls.clear);

  Map<String, Object?> json(String text) =>
      jsonDecode(text) as Map<String, Object?>;

  test('runs an action with key=value arguments, as the command line does',
      () async {
    final out = await aid.run(['entry.list', 'limit=5']);
    expect(out.exitCode, 0);
    expect(json(out.stdout), {
      'ok': true,
      'result': [
        {'id': 1, 'text': 'hello'},
      ],
    });
    expect(calls.single.$1, 'entry.list');
    expect(calls.single.$2, {'limit': 5});
  });

  test('destructive actions need --yes', () async {
    final refused = await aid.run(['entry.delete', 'id=3']);
    expect(refused.exitCode, 1);
    expect(
        (json(refused.stdout)['error'] as Map)['code'], 'needs_confirmation');
    expect(calls, isEmpty);

    final done = await aid.run(['--yes', 'entry.delete', 'id=3']);
    expect(done.exitCode, 0);
    expect(calls.single.$1, 'entry.delete');
    expect(calls.single.$2, {'id': 3});
  });

  test('a wrong command exits 2 with a reason', () async {
    expect((await aid.run([])).exitCode, 2);
    final pair = await aid.run(['entry.list', 'limit']);
    expect(pair.exitCode, 2);
    expect(pair.stderr, contains('key=value'));
    final device = await aid.run(['-d', 'serial', 'entry.list']);
    expect(device.exitCode, 2);
    expect(device.stderr, contains('in the app itself'));
  });

  test('a failing action reports its error code', () async {
    final out = await aid.run(['entry.list', 'limit=many']);
    expect(out.exitCode, 1);
    expect((json(out.stdout)['error'] as Map)['code'], 'bad_args');
  });

  test('agents inside the app cannot reach agent and acp actions', () async {
    final ask = await aid.run(['agent.ask']);
    expect((json(ask.stdout)['error'] as Map)['code'], 'unknown_action');
    final listed = json((await aid.run(['actions'])).stdout)['result'] as List;
    expect([for (final action in listed) (action as Map)['id']],
        ['entry.list', 'entry.delete']);
    expect((await aid.run(['guide'])).stdout, isNot(contains('agent.ask')));
  });
}
