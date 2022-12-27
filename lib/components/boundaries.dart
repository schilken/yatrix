import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;


class Boundary extends PositionComponent with CollisionCallbacks {
  Boundary({
    super.size,
    super.position,
  });

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;

  void adjustY() {
//    print('adjustY y: $y');
    y = (y ~/ 50) * 50.0;
  }

  @override
  Future<void> onLoad() async {
//    debugMode = true;
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

class Floor extends Boundary {
  Floor({super.size, super.position});
}

class Side extends Boundary {
  Side({super.size, super.position});
}
