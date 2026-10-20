import 'dart:typed_data';

import 'package:daily_you/utils/photo_metadata.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

/// A tiny JPEG carrying the EXIF that [fill] writes.
Uint8List _jpeg(void Function(img.ExifData exif) fill) {
  final image = img.Image(width: 4, height: 4);
  fill(image.exif);
  return img.encodeJpg(image);
}

/// Degrees, minutes, seconds as EXIF writes them. Rational itself is not
/// exported, so borrow it from single values.
img.IfdValueRational _dms(int degrees, int minutes, int seconds) =>
    img.IfdValueRational(degrees, 1)
      ..value.addAll([
        img.IfdValueRational(minutes, 1).value.single,
        img.IfdValueRational(seconds, 1).value.single,
      ]);

void main() {
  test('reads the time taken and the GPS position', () {
    final meta = PhotoMetadata.read(_jpeg((exif) {
      exif.exifIfd[0x9003] = img.IfdValueAscii('2026:10:19 15:53:07');
      exif.gpsIfd[0x0001] = img.IfdValueAscii('N');
      exif.gpsIfd[0x0002] = _dms(31, 14, 24);
      exif.gpsIfd[0x0003] = img.IfdValueAscii('W');
      exif.gpsIfd[0x0004] = _dms(121, 29, 24);
    }));
    expect(meta.taken, DateTime(2026, 10, 19, 15, 53, 7));
    expect(meta.latitude, closeTo(31.24, 1e-6));
    expect(meta.longitude, closeTo(-121.49, 1e-6));
  });

  test('a photo without EXIF, or with a 0,0 fix, has nothing to offer', () {
    expect(PhotoMetadata.read(_jpeg((_) {})).isEmpty, isTrue);
    final zero = PhotoMetadata.read(_jpeg((exif) {
      exif.gpsIfd[0x0002] = _dms(0, 0, 0);
      exif.gpsIfd[0x0004] = _dms(0, 0, 0);
    }));
    expect(zero.hasPlace, isFalse);
    expect(PhotoMetadata.read(Uint8List.fromList([1, 2, 3])).isEmpty, isTrue);
  });

  test('dates must look like EXIF dates', () {
    expect(PhotoMetadata.parseDate('0000:00:00 00:00:00'), isNull);
    expect(PhotoMetadata.parseDate('yesterday'), isNull);
    expect(PhotoMetadata.parseDate('2026:01:02 03:04:05'),
        DateTime(2026, 1, 2, 3, 4, 5));
  });
}
