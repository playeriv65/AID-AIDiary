import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/stats/period_review.dart';
import 'package:flutter_test/flutter_test.dart';

Entry _entry(int id, DateTime time,
        {int? mood, String text = '', String? place}) =>
    Entry(
        id: id,
        text: text,
        mood: mood,
        location: place == null ? null : EntryLocation(name: place),
        timeCreate: time,
        timeModified: time);

void main() {
  // Telling photos from voice notes reads the media extensions from config.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  test('a period review counts what happened inside it', () {
    final entries = [
      _entry(5, DateTime(2026, 10, 25), mood: -1, text: 'outside'),
      _entry(4, DateTime(2026, 10, 21, 20), mood: 2, text: 'great long day'),
      _entry(3, DateTime(2026, 10, 21, 8), mood: 1, place: '家'),
      _entry(2, DateTime(2026, 10, 20), mood: 1, place: '家'),
      _entry(1, DateTime(2026, 10, 18), text: 'before'),
    ];
    final review =
        PeriodReview.of(entries, DateTime(2026, 10, 19), DateTime(2026, 10, 26),
            tagsOf: (e) => e.id! >= 3 ? ['工作'] : const [],
            imagesOf: (e) => [
                  EntryImage(
                      entryId: e.id,
                      imgPath: e.id == 2 ? 'a.jpg' : 'b.m4a',
                      imgRank: 0,
                      timeCreate: e.timeCreate)
                ]);
    expect(review.entries.map((e) => e.id), [5, 4, 3, 2]);
    expect(review.daysInPeriod, 7);
    expect(review.daysWritten.length, 3);
    expect(review.longestStreak, 2);
    expect(review.averageMood, 0.75);
    expect(review.photos.single.imgPath, 'a.jpg');
    expect(review.topTags.single, (item: '工作', count: 3));
    expect(review.topPlaces.single, (item: '家', count: 2));
    expect(review.highlight!.id, 4);
    expect(review.perMonth[9], 4);
  });
}
