import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'background.dart';
import 'tetris_block.dart';

typedef TetrisBlockTearOff = TetrisBlock Function({
  required Vector2 blockPosition,
  Vector2 velocity,
});

typedef CollisionCallback = void Function(PositionComponent);

class Quadrat extends PositionComponent with CollisionCallbacks {
  Quadrat({
    super.position,
    required this.collisionCallback,
  }) {
    size = Vector2(40, 40);
  }
  CollisionCallback collisionCallback;
  RectangleHitbox? hitBox;

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    add(hitBox = RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    collisionCallback(other);
    super.onCollisionStart(intersectionPoints, other);
  }

  bool containsParentPoint(Vector2 parentPoint) {
    final rect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    return hitBox != null && rect.containsPoint(parentPoint);
  }

  void hide() {
    print('hide at position $position');
    hitBox?.removeFromParent();
    hitBox = null;
    add(Background(const Color(0xff282828)));
  }

  @override
  String toString() {
    return '$position, $size';
  }
}
