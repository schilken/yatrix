import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:yatrix/components/boundaries.dart';
void main() {
  group('adjust  - ', () {
    test('Floor', () {
      final floor = Floor(size: Vector2(500, 10), position: Vector2(0, 990));
      floor.onLoad();
      expect(floor.y, 950);
    });
  });
}
