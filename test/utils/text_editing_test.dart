import 'package:daily_you/utils/text_editing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('blocks go on lines of their own', () {
    final controller = TextEditingController(text: 'ab')
      ..selection = const TextSelection.collapsed(offset: 1);
    insertBlock(controller, '---\n', cursorOffset: 4);
    expect(controller.text, 'a\n---\nb');
    expect(controller.selection.baseOffset, 6);

    final empty = TextEditingController();
    insertBlock(empty, '- [ ] ', cursorOffset: 6);
    expect(empty.text, '- [ ] ');
  });
}
