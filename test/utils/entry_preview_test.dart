import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final when = DateTime(2026, 10, 25, 9);
  Entry entry(String text, {String title = ''}) =>
      Entry(title: title, text: text, timeCreate: when, timeModified: when);

  test('the title is its own and markdown is stripped from the snippet', () {
    final preview =
        entryPreview(entry('去了**公园**，看见 [湖](https://x.y)。', title: '周末'));
    expect(preview.title, '周末');
    expect(preview.snippet, '去了公园，看见 湖。');
  });

  test('a heading in the text is not a title', () {
    final preview = entryPreview(entry('# 周末\nStayed in and read.'));
    expect(preview.title, isNull);
    expect(preview.snippet, '周末 Stayed in and read.');
  });

  test('a first-line heading of older text becomes the title', () {
    expect(splitEntryTitle('# 周末\n去了公园'), (title: '周末', body: '去了公园'));
    expect(splitEntryTitle('## 小标题\n正文'), (title: '', body: '## 小标题\n正文'));
    final titled = titledByHeading(entry('# 周末\n去了公园'));
    expect((titled.title, titled.text), ('周末', '去了公园'));
    final kept = titledByHeading(entry('# 不是\n正文', title: '标题'));
    expect((kept.title, kept.text), ('标题', '# 不是\n正文'));
  });

  test('markdown puts the title above the text as a heading', () {
    expect(entry('去了公园', title: '周末').markdown, '# 周末\n去了公园');
    expect(entry('去了公园').markdown, '去了公园');
  });

  test('lists, quotes, images and rules are flattened', () {
    final preview = entryPreview(entry(
        '## Chores\n- [x] laundry\n> calm\n![cat](a.jpg)\n---\n1. call mom'));
    expect(preview.snippet, 'Chores laundry calm cat call mom');
  });

  test('a long entry gives a cut snippet ending in an ellipsis', () {
    final preview = entryPreview(entry('${'很长的一天。' * 100}\n${'More. ' * 100}'));
    expect(preview.snippet,
        '${('很长的一天。' * 100).substring(0, snippetCharacters)}…');
    // An emoji is not split in half.
    final emoji =
        entryPreview(entry('${'a' * (snippetCharacters - 1)}😀 and more'));
    expect(emoji.snippet, '${'a' * (snippetCharacters - 1)}…');
  });

  test('a search snippet starts just before the first match', () {
    final text = '${'前面的事情。' * 20}\n下午在**日常**里读书，日常很好。';
    final preview = entryPreview(entry(text), around: '日常');
    expect(preview.snippet, startsWith('…'));
    expect(preview.snippet, contains('下午在日常里读书'));
    expect(preview.snippet.indexOf('日常'), lessThan(20));
    // Near the start, or not there at all: from the start.
    expect(entryPreview(entry('日常的一天'), around: '日常').snippet, '日常的一天');
    expect(entryPreview(entry('没有'), around: '日常').snippet, '没有');
  });

  test('shared text goes below the entry text after a blank line', () {
    expect(mergeSharedText('template', null), 'template');
    expect(mergeSharedText('', 'shared'), 'shared');
    expect(mergeSharedText('template', 'shared'), 'template\n\nshared');
  });

  test('empty text gives an empty preview', () {
    final preview = entryPreview(entry('\n  \n'));
    expect(preview.title, isNull);
    expect(preview.snippet, isEmpty);
  });
}
