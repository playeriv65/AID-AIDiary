import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/widgets/location_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

Entry _placed(DateTime time, EntryLocation location) =>
    Entry(text: '', timeCreate: time, timeModified: time, location: location);

void main() {
  test('recent places are named, newest first and listed once', () {
    final places = recentPlaces([
      _placed(DateTime(2026, 10, 3),
          const EntryLocation(name: '公园', latitude: 1, longitude: 2)),
      _placed(DateTime(2026, 10, 2),
          const EntryLocation(latitude: 5, longitude: 6)),
      _placed(DateTime(2026, 10, 1), const EntryLocation(name: '公园')),
      _placed(DateTime(2026, 9, 1), const EntryLocation(name: '学校')),
    ], 5);
    expect(places.map((p) => p.name), ['公园', '学校']);
    expect(places.first.latitude, 1);
  });
}
