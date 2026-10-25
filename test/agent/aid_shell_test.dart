@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/agent/aid_command.dart';
import 'package:aid_diary/agent/aid_shell.dart';
import 'package:aid_diary/agent/diary_sql.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The library `cargo build --release` makes in rust/; dev.ps1 builds it
/// before tests, CI before its test step.
ExternalLibrary builtLibrary() {
  final name = Platform.isWindows
      ? 'aid_shell.dll'
      : Platform.isMacOS
          ? 'libaid_shell.dylib'
          : 'libaid_shell.so';
  final path = p.join('rust', 'target', 'release', name);
  if (!File(path).existsSync()) {
    throw StateError('$path is missing: cargo build --release '
        '--manifest-path rust/Cargo.toml');
  }
  return ExternalLibrary.open(path);
}

void main() {
  late Directory folder;
  late AidShell shell;
  final created = <String>[];

  setUpAll(() async {
    sqfliteFfiInit();
    await AidShell.load(library: builtLibrary());
  });

  setUp(() async {
    created.clear();
    folder = await Directory.systemTemp.createTemp('aid_shell_test');
    final path = p.join(folder.path, 'diary.db');
    final db = await databaseFactoryFfi.openDatabase(path);
    await db
        .execute('CREATE TABLE entries (id INTEGER PRIMARY KEY, text TEXT)');
    await db.insert('entries', {'id': 1, 'text': 'met Wang at the park'});
    await db.insert('entries', {'id': 2, 'text': 'rainy, stayed in'});
    await db.close();
    final actions = AppActions(devBuild: true, actions: [
      AppAction(
        id: 'entry.create',
        describe: 'Writes an entry.',
        risk: ActionRisk.write,
        params: const [ActionParam('text', ParamType.string, 'The text')],
        run: (context, args) async {
          created.add(args['text'] as String);
          return {'id': 3};
        },
      ),
    ]);
    shell = await AidShell.open(
      aid: AidCommand(() => actions),
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

  test('runs bash with pipes and jq', () async {
    final out = await shell.run(
        r'''printf '{"a":[1,2,3]}' | jq '.a | add'; echo "x y z" | wc -w''');
    expect(out.exitCode, 0);
    expect(
        out.stdout.split('\n').take(2).map((line) => line.trim()), ['6', '3']);
  });

  test('sql answers from the diary, and pipes on', () async {
    final out = await shell.run(
        r'''sql "SELECT id, text FROM entries" | jq -r '.[] | select(.text | test("Wang")) | .id' ''');
    expect(out.exitCode, 0, reason: out.stderr);
    expect(out.stdout.trim(), '1');
  });

  test('aid runs actions in the app', () async {
    final out = await shell
        .run(r'''aid entry.create "text=from the shell" | jq -r .result.id''');
    expect(out.exitCode, 0, reason: out.stderr);
    expect(out.stdout.trim(), '3');
    expect(created, ['from the shell']);
  });

  test('files written stay for the next script', () async {
    await shell.run('mkdir -p /tmp/notes && echo draft > /tmp/notes/a.txt');
    final out = await shell.run('cat /tmp/notes/a.txt');
    expect(out.stdout.trim(), 'draft');
  });

  test('sees neither the host files nor the network', () async {
    final hostFile = File(p.join(folder.path, 'secret.txt'))
      ..writeAsStringSync('host secret');
    final read = await shell.run('cat "${hostFile.path}"');
    expect(read.exitCode, isNot(0));
    expect(read.stdout, isNot(contains('host secret')));
    final passwd = await shell.run('cat /etc/passwd');
    expect(passwd.stdout, isNot(contains('root:')));
    final net = await shell.run('curl -s https://example.com');
    expect(net.exitCode, isNot(0));
  });

  test('reports a script that does not parse', () async {
    final out = await shell.run('if then fi (');
    expect(out.exitCode, isNot(0));
    expect(out.stderr, isNotEmpty);
  });

  test('a failing aid command carries its JSON and exit code', () async {
    final out = await shell.run('aid entry.create; echo "code=\$?"');
    expect(out.stdout, contains('"ok": false'));
    expect(out.stdout, contains('code=1'));
    expect(jsonDecode(out.stdout.split('code=').first)['error']['code'],
        'bad_args');
  });
}
