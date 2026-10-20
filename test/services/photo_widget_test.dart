import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  final time = DateTime(2026, 10, 1);
  Entry entry(int id, {DateTime? openAt}) => Entry(
      id: id, text: '', timeCreate: time, timeModified: time, openAt: openAt);
  EntryImage image(int entryId, String name) =>
      EntryImage(entryId: entryId, imgPath: name, imgRank: 0, timeCreate: time);

  test('the photo stays the same all day and skips other media', () {
    final entries = [entry(1), entry(2), entry(3, openAt: DateTime(2099))];
    final media = {
      1: [image(1, 'a.jpg'), image(1, 'clip.mp4')],
      2: [image(2, 'b.jpg'), image(2, 'note.m4a')],
      3: [image(3, 'sealed.jpg')],
    };
    List<EntryImage> imagesOf(Entry e) => media[e.id]!;
    final morning = photoForDay(entries, imagesOf, DateTime(2026, 10, 20, 8));
    final evening = photoForDay(entries, imagesOf, DateTime(2026, 10, 20, 22));
    expect(morning!.image.imgPath, evening!.image.imgPath);
    final seen = {
      for (var day = 1; day <= 30; day++)
        photoForDay(entries, imagesOf, DateTime(2026, 11, day))!.image.imgPath,
    };
    expect(seen, {'a.jpg', 'b.jpg'});
  });

  test('no photos, no choice', () {
    expect(photoForDay([entry(1)], (_) => const [], DateTime(2026)), isNull);
  });

  test('photo widget taps name their entry', () {
    expect(HomeWidgetService.entryOf(Uri.parse('aiddiary://entry?id=12')), 12);
    expect(HomeWidgetService.entryOf(Uri.parse('aiddiary://write')), isNull);
    expect(HomeWidgetService.entryOf(null), isNull);
  });
}
