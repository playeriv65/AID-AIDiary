import 'package:aid_diary/models/entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an entry is sealed only until its opening day', () {
    final now = DateTime.now();
    Entry entry(DateTime? openAt) =>
        Entry(text: '', timeCreate: now, timeModified: now, openAt: openAt);
    expect(entry(null).isSealed, isFalse);
    expect(entry(now.add(const Duration(days: 1))).isSealed, isTrue);
    expect(entry(now.subtract(const Duration(days: 1))).isSealed, isFalse);
    expect(entry(now).copy(openAt: null).openAt, isNull);
  });
}
