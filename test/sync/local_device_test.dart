import 'package:aid_diary/sync/local_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unicode device labels fit the server enrollment byte limit', () {
    expect(LocalDevice.validName(List.filled(32, '😀').join()), isTrue);
    expect(LocalDevice.validName(List.filled(33, '😀').join()), isFalse);
    expect(LocalDevice.validName('My\nphone'), isFalse);
  });
}
