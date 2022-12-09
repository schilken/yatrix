import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter/services.dart';

import 'package:tetris/boundaries.dart';

import 'game_assets.dart';
import 'tetromino.dart';

class FallingComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef {
  Vector2 velocity;

  FallingComponent(
    this.type,
    this.velocity,
    Vector2 position,
    Vector2 size, {
    double angle = 0,
  }) : super(
          position: position,
          size: size,
          angle: angle,
          anchor: Anchor.center,
        );

  String type;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topLeft;
    final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    if (type == 'tet-O') {
      size = Vector2(99, 99);
      sprite = gameAssets.sprites['tet-O'];
      add(
        PolygonHitbox.relative(
          [
            Vector2(-1.0, -1.0),
            Vector2(-1.0, 1.0),
            Vector2(1, 1.0),
            Vector2(1, -1),
          ],
          parentSize: size,
        )
          ..paint = hitboxPaint
          ..renderShape = true,
      );
    } else if (type == 'tet-J') {
      size = Vector2(149, 99);
      sprite = gameAssets.sprites[type];
      add(
        PolygonHitbox.relative(
          [
            Vector2(-1.0, -1.0),
            Vector2(-1.0, 1.0),
            Vector2(1, 1.0),
            Vector2(1, -1),
          ],
          parentSize: size,
        )
          ..paint = hitboxPaint
          ..renderShape = true,
      );
    }
  }

  void updateX(double newX) {
    print('updateX: $newX');
    x = newX;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    print('onCollisionStart $intersectionPoints $other');
    if (intersectionPoints.first.x < 1) {
      return;
    }
    if (intersectionPoints.first.y < 1) {
      velocity = Vector2.all(0);
    }
    velocity = Vector2.all(0);
    super.onCollisionStart(intersectionPoints, other);
  }

  void rotate() {
    angle -= pi / 2;
  }
}
