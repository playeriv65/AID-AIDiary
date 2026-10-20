import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/utils/entry_share.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  final time = DateTime(2026, 10, 20, 8, 40);
  final entry =
      Entry(text: '# 河边散步\n空气有点冷 <b>', timeCreate: time, timeModified: time);
  EntryImage media(String name) =>
      EntryImage(entryId: 1, imgPath: name, imgRank: 0, timeCreate: time);

  test('plain text puts the heading above the entry', () {
    expect(EntryShare.plainText(entry, '😊 10月20日'),
        '😊 10月20日\n# 河边散步\n空气有点冷 <b>');
  });

  test('html renders the markdown and escapes the heading', () {
    final html = EntryShare.html(entry, '<10月20日>');
    expect(html, matches(RegExp(r'<h1[^>]*>河边散步</h1>')));
    expect(html, contains('&lt;10月20日&gt;'));
  });

  test('zip holds the entry, its page and the media that exists', () async {
    final bytes = await EntryShare.zip(
        entry,
        '10月20日',
        [media('a.jpg'), media('gone.jpg'), media('note.m4a')],
        (name) async =>
            name == 'gone.jpg' ? null : Uint8List.fromList([1, 2, 3]));
    final archive = ZipDecoder().decodeBytes(bytes);
    expect(archive.files.map((f) => f.name).toSet(),
        {'entry.md', 'entry.html', 'media/a.jpg', 'media/note.m4a'});
    final html =
        utf8.decode(archive.findFile('entry.html')!.content as List<int>);
    expect(html, contains('<img src="media/a.jpg"'));
    expect(html, contains('<audio src="media/note.m4a"'));
    expect(html, isNot(contains('gone.jpg')));
  });
}
