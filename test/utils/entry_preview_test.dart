import 'package:aid_diary/utils/entry_preview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('heading becomes the title and markdown is stripped', () {
    final preview = entryPreview('# 周末\n\n去了**公园**，看见 [湖](https://x.y)。');
    expect(preview.title, '周末');
    expect(preview.snippet, '去了公园，看见 湖。');
  });

  test('only a written title is a title', () {
    final preview = entryPreview('Rainy day\nStayed in and read.');
    expect(preview.title, isNull);
    expect(preview.snippet, 'Rainy day Stayed in and read.');
  });

  test('the editor title round-trips through the entry text', () {
    expect(splitEntryTitle('# 周末\n去了公园'), (title: '周末', body: '去了公园'));
    expect(splitEntryTitle('## 小标题\n正文'), (title: '', body: '## 小标题\n正文'));
    expect(joinEntryTitle(' 周末 ', '去了公园'), '# 周末\n去了公园');
    expect(joinEntryTitle('', '去了公园'), '去了公园');
    expect(joinEntryTitle('两行\n标题', ''), '# 两行 标题\n');
  });

  test('a single paragraph has no title', () {
    final preview = entryPreview('今天下雨，一直在家看书。');
    expect(preview.title, isNull);
    expect(preview.snippet, '今天下雨，一直在家看书。');
  });

  test('lists, quotes, images and rules are flattened', () {
    final preview = entryPreview(
        '# Done\n## Chores\n- [x] laundry\n> calm\n![cat](a.jpg)\n---\n1. call mom');
    expect(preview.title, 'Done');
    expect(preview.snippet, 'Chores laundry calm cat call mom');
  });

  test('a long entry gives a cut snippet ending in an ellipsis', () {
    final preview = entryPreview('${'很长的一天。' * 100}\n${'More. ' * 100}');
    expect(preview.snippet, '${('很长的一天。' * 100).substring(0, 300)}…');
    // An emoji is not split in half.
    final emoji = entryPreview('${'a' * 299}😀 and more');
    expect(emoji.snippet, '${'a' * 299}…');
  });

  test('shared text goes below the entry text after a blank line', () {
    expect(mergeSharedText('template', null), 'template');
    expect(mergeSharedText('', 'shared'), 'shared');
    expect(mergeSharedText('template', 'shared'), 'template\n\nshared');
  });

  test('empty text gives an empty preview', () {
    final preview = entryPreview('\n  \n');
    expect(preview.title, isNull);
    expect(preview.snippet, isEmpty);
  });
}
