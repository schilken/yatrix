import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

import 'game_assets.dart';

class FallingComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef {
  Vector2 velocity;

  FallingComponent(
    this.type,
    this.velocity,
    Vector2 position, {
    double angle = 0,
  }) : super(
          position: position,
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
      anchor = Anchor.center;
      x += 50.0;
      add(
        PolygonHitbox.relative(
          [
            Vector2(-0.95, -0.95),
            Vector2(-0.95, 0.95),
            Vector2(0.95, 0.95),
            Vector2(0.95, -0.95),
          ],
          parentSize: size,
        )
          ..paint = hitboxPaint
          ..renderShape = true,
      );
    } else if (type == 'tet-J') {
      size = Vector2(149, 99);
      sprite = gameAssets.sprites[type];
      anchor = Anchor(0.5, 0.75);
      x += 25.0;
      add(
        PolygonHitbox.relative(
          [
            Vector2(-0.95, -0.95),
            Vector2(-0.95, 0.95),
            Vector2(0.95, 0.95),
            Vector2(0.95, 0.05),
            Vector2(-0.333, 0.05),
            Vector2(-0.333, -0.95),
          ],
          parentSize: size,
        )
          ..paint = hitboxPaint
          ..renderShape = true,
      );
    } else if (type == 'tet-I') {
      size = Vector2(199, 49);
      sprite = gameAssets.sprites[type];
      anchor = Anchor(0.125, 0.5);
      x += 25.0;
      add(
        PolygonHitbox.relative(
          [
            Vector2(-0.95, -0.95),
            Vector2(-0.95, 0.95),
            Vector2(0.95, 0.95),
            Vector2(0.95, -0.95),
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
    if (other is Wall) {
      velocity = Vector2.all(0);
      return;
    }
    if (other is FallingComponent) {
      velocity = Vector2.all(0);
      return;
    }
    if (intersectionPoints.first.x < 1) {
      return;
    }
    velocity = Vector2.all(0);
    super.onCollisionStart(intersectionPoints, other);
  }

  void rotate() {
    angle -= pi / 2;
  }
}
