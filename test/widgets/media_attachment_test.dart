import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/widgets/media_attachment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  test('attachments are told apart by extension', () {
    expect(MediaKind.of('aid_diary_2026.jpg'), MediaKind.image);
    expect(MediaKind.of('clip.MP4'), MediaKind.video);
    expect(MediaKind.of('voice-1.m4a'), MediaKind.audio);
    expect(MediaKind.of('no_extension'), MediaKind.image);
  });

  test('media durations read like a player clock', () {
    expect(formatMediaDuration(const Duration(seconds: 7)), '0:07');
    expect(
        formatMediaDuration(const Duration(minutes: 12, seconds: 5)), '12:05');
    expect(
        formatMediaDuration(const Duration(hours: 1, minutes: 2)), '1:02:00');
  });
}
