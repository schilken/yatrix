import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter/services.dart';


List<Wall> createBoundaries(FlameGame game) {
  final bottomRight = game.size;
  final bottomLeft = Vector2(0, bottomRight.y);

  return [
    Wall(bottomRight, bottomLeft),
  ];
}

class Wall extends PositionComponent with CollisionCallbacks {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    size = Vector2(506, 10);
    position = Vector2(end.x, end.y - 10);
    final shape = PolygonHitbox.relative(
      [
        Vector2(0, 1),
        Vector2(1, 0),
        Vector2(0, -1),
        Vector2(-1, 0),
      ],
      parentSize: size,
    )
      ..paint = hitboxPaint
      ..renderShape = true;
    add(shape);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }
}
