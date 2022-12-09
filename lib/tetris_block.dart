import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

import 'game_assets.dart';

abstract class TetrisBlock extends SpriteComponent
    with CollisionCallbacks, HasGameRef {
  TetrisBlock(
    this.velocity,
    this.blockPosition,
  );
  Vector2 velocity;
  Vector2 blockPosition;

  Vector2 get blockSize;
  Anchor get blockAnchor;
  List<Vector2> get hitboxPoints;
  double get xOffset;
  String get name;

  @override
  Future<void> onLoad() async {
    position = blockPosition;
    size = blockSize;
    sprite = gameAssets.sprites[name];
    anchor = blockAnchor;
    x += xOffset;
    add(
      PolygonHitbox.relative(
        hitboxPoints,
        parentSize: size,
      ),
//        ..paint = hitboxPaint
//        ..renderShape = true,
    );
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

  void rotate() {
    angle -= pi / 2;
  }

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
    if (other is TetrisBlock) {
      velocity = Vector2.all(0);
      return;
    }
    if (intersectionPoints.first.x < 1) {
      return;
    }
    velocity = Vector2.all(0);
    super.onCollisionStart(intersectionPoints, other);
  }
}

class TetrisI extends TetrisBlock {
  TetrisI(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(199, 49);
  @override
  String get name => 'tet-I';
  @override
  Anchor get blockAnchor => const Anchor(0.125, 0.5);
  @override
  double get xOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.95, -0.95),
        Vector2(-0.95, 0.95),
        Vector2(0.95, 0.95),
        Vector2(0.95, -0.95),
      ];
}

class TetrisO extends TetrisBlock {
  TetrisO(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(99, 99);
  @override
  String get name => 'tet-O';
  @override
  Anchor get blockAnchor => Anchor.center;
  @override
  double get xOffset => 50.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.95, -0.95),
        Vector2(-0.95, 0.95),
        Vector2(0.95, 0.95),
        Vector2(0.95, -0.95),
      ];
}

class TetrisJ extends TetrisBlock {
  TetrisJ(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(149, 99);
  @override
  String get name => 'tet-J';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.95, -0.95),
        Vector2(-0.95, 0.95),
        Vector2(0.95, 0.95),
        Vector2(0.95, 0.05),
        Vector2(-0.333, 0.05),
        Vector2(-0.333, -0.95),
      ];
}



