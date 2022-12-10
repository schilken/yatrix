import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;

class Floor extends PositionComponent with CollisionCallbacks {
  final Vector2 gameSize;

  Floor(this.gameSize);

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;

void adjustY() {
    print('adjustY y: $y');
    y = (y ~/ 50) * 50.0;
  }

  @override
  Future<void> onLoad() async {
    debugMode = true;
    size = Vector2(1000, 10);
    position = Vector2(-250, 500);
    adjustY();
    final shape = PolygonHitbox.relative(
      [
        Vector2(-1.0, -1.0),
        Vector2(-1.0, 1.0),
        Vector2(1.0, 1.0),
        Vector2(1.0, -1.0),
      ],
      parentSize: size,
    )
      ..paint = hitboxPaint
      ..renderShape = true;
    add(shape);
  }

}
