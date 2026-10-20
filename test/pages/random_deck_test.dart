import 'dart:math';

import 'package:aid_diary/pages/random_review_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the random deck shows every entry before repeating', () {
    final deck = RandomDeck(Random(1));
    final seen = <int>{};
    int? last;
    for (var i = 0; i < 4; i++) {
      last = deck.next([1, 2, 3, 4], avoid: last);
      seen.add(last!);
    }
    expect(seen, {1, 2, 3, 4});
    final next = deck.next([1, 2, 3, 4], avoid: last);
    expect(next, isNot(last));
    expect(deck.next(const []), isNull);
  });
}
