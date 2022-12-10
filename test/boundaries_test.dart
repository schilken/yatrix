import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:tetris/boundaries.dart';

void main() {
  group('adjust  - ', () {
    test('Floor', () {
      final floor = Floor(Vector2(500, 690));
      floor.onLoad();
      expect(floor.y, 650);
    });
  });
}
