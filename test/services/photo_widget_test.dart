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

  test('candidates are photos outside sealed capsules', () {
    final entries = [entry(1), entry(2), entry(3, openAt: DateTime(2099))];
    final media = {
      1: [image(1, 'a.jpg'), image(1, 'clip.mp4')],
      2: [image(2, 'b.jpg'), image(2, 'note.m4a')],
      3: [image(3, 'sealed.jpg')],
    };
    final names = photoCandidates(entries, (e) => media[e.id]!, 10)
        .map((c) => c.image.imgPath);
    expect(names, ['a.jpg', 'b.jpg']);
  });

  test('a capped sample is stable while the photos stay the same', () {
    final entries = [for (var id = 1; id <= 50; id++) entry(id)];
    List<EntryImage> imagesOf(Entry e) => [image(e.id!, '${e.id}.jpg')];
    final first = photoCandidates(entries, imagesOf, 12);
    final again = photoCandidates(entries, imagesOf, 12);
    expect(first, hasLength(12));
    expect(
        again.map((c) => c.image.imgPath), first.map((c) => c.image.imgPath));
  });

  test('no photos, no candidates', () {
    expect(photoCandidates([entry(1)], (_) => const [], 10), isEmpty);
  });

  test('photo widget taps name their entry', () {
    expect(HomeWidgetService.entryOf(Uri.parse('aiddiary://entry?id=12')), 12);
    expect(HomeWidgetService.entryOf(Uri.parse('aiddiary://write')), isNull);
    expect(HomeWidgetService.entryOf(null), isNull);
  });
}
