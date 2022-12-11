import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:tetris/tetris_block.dart';

void main() {
  group('adjust  - ', () {
    test('only double match', () {
      final startPosition = Vector2(5 * 100.0, 553);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      expect(sut.y, 525);
    });
  });
}
