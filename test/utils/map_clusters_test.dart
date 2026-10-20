import 'package:daily_you/utils/map_clusters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('clusterByDistance groups items near the first of each cluster', () {
    final clusters = clusterByDistance(
        const [Offset(0, 0), Offset(30, 0), Offset(70, 0), Offset(200, 0)],
        (offset) => offset,
        50);
    expect(clusters, [
      [const Offset(0, 0), const Offset(30, 0)],
      [const Offset(70, 0)],
      [const Offset(200, 0)],
    ]);
  });
}
