import 'package:aid_diary/utils/entry_preview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('heading becomes the title and markdown is stripped', () {
    final preview = entryPreview('# 周末\n\n去了**公园**，看见 [湖](https://x.y)。');
    expect(preview.title, '周末');
    expect(preview.snippet, '去了公园，看见 湖。');
  });

  test('short first line followed by text is a title', () {
    final preview = entryPreview('Rainy day\nStayed in and read.');
    expect(preview.title, 'Rainy day');
    expect(preview.snippet, 'Stayed in and read.');
  });

  test('a single paragraph has no title', () {
    final preview = entryPreview('今天下雨，一直在家看书。');
    expect(preview.title, isNull);
    expect(preview.snippet, '今天下雨，一直在家看书。');
  });

  test('long first line is not a title', () {
    final line = 'a' * 60;
    final preview = entryPreview('$line\nmore');
    expect(preview.title, isNull);
    expect(preview.snippet, '$line more');
  });

  test('lists, quotes, images and rules are flattened', () {
    final preview = entryPreview(
        '## Done\n- [x] laundry\n> calm\n![cat](a.jpg)\n---\n1. call mom');
    expect(preview.title, 'Done');
    expect(preview.snippet, 'laundry calm cat call mom');
  });

  test('empty text gives an empty preview', () {
    final preview = entryPreview('\n  \n');
    expect(preview.title, isNull);
    expect(preview.snippet, isEmpty);
  });
}
