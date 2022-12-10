import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

import 'game_assets.dart';

const tiny = 0.01;

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
  double get yOffset;
  String get name;
  double? _lastDeltaX;

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    final hitboxPaint = BasicPalette.white.withAlpha(128).paint()
      ..style = PaintingStyle.fill;
    position = blockPosition;
    size = blockSize;
    sprite = gameAssets.sprites[name];
    anchor = blockAnchor;
    x += xOffset;
    add(
      PolygonHitbox.relative(
        hitboxPoints,
        parentSize: size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
  }

  void moveXBy(double deltaX) {
//    print('moveXBy: $deltaX');
    x += deltaX;
    _lastDeltaX = deltaX;
    Future.delayed(Duration(milliseconds: 100), () => _lastDeltaX = null);
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
//    print('onCollisionStart $intersectionPoints $other');
    if (velocity.y == 0 && _lastDeltaX == null) {
      return;
    }
    if (other is Floor) {
      velocity = Vector2.all(0);
      _lastDeltaX = null;
      adjustY();
      print('y: $y');
      return;
    }
    if (other is TetrisBlock) {
      if (_lastDeltaX != null) {
        x -= _lastDeltaX!;
        _lastDeltaX = null;
      } else {
        velocity = Vector2.all(0);
        adjustY();
        print('y: $y');
      }
      return;
    }
    // if (intersectionPoints.first.x < 1) {
    //   return;
    // }
    //velocity = Vector2.all(0);
    super.onCollisionStart(intersectionPoints, other);
  }

  void adjustY() {
    y = (y / 50).round() * 50.0 - yOffset;
  }
}

class TetrisI extends TetrisBlock {
  TetrisI(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(200 - tiny, 50 - tiny);
  @override
  String get name => 'tet-I';
  @override
  Anchor get blockAnchor => const Anchor(0.125, 0.5);
  @override
  double get xOffset => 25.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-1 + tiny, -1 + tiny),
        Vector2(-1 + tiny, 1 - tiny),
        Vector2(1 - tiny, 1 - tiny),
        Vector2(1 - tiny, -1 + tiny),
      ];
}

class TetrisO extends TetrisBlock {
  TetrisO(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(99.99, 99.99);
  @override
  String get name => 'tet-O';
  @override
  Anchor get blockAnchor => Anchor.center;
  @override
  double get xOffset => 50.0;
  @override
  double get yOffset => 0.0;

  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.99, -0.99),
        Vector2(-0.99, 0.99),
        Vector2(0.99, 0.99),
        Vector2(0.99, -0.99),
      ];
}

class TetrisJ extends TetrisBlock {
  TetrisJ(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(149.99, 99.99);
  @override
  String get name => 'tet-J';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.99, -0.99),
        Vector2(-0.99, 0.99),
        Vector2(0.99, 0.99),
        Vector2(0.99, 0.01),
        Vector2(-0.33333, 0.01),
        Vector2(-0.33333, -0.99),
      ];
}

class TetrisT extends TetrisBlock {
  TetrisT(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(149.99, 99.99);
  @override
  String get name => 'tet-T';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.99, 0.0),
        Vector2(-0.99, 0.99),
        Vector2(0.99, 0.99),
        Vector2(0.99, 0.01),
        Vector2(0.33333, 0.01),
        Vector2(0.33333, -0.99),
        Vector2(-0.33333, -0.99),
        Vector2(-0.33333, 0.01),
      ];
}

class TetrisS extends TetrisBlock {
  TetrisS(super.velocity, super.blockPosition);
  @override
  Vector2 get blockSize => Vector2(149.99, 99.99);
  @override
  String get name => 'tet-S';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get hitboxPoints => [
        Vector2(-0.99, 0.0),
        Vector2(-0.99, 0.99),
        Vector2(0.33333, 0.99),
        Vector2(0.33333, -0.01),
        Vector2(0.99, -0.01),
        Vector2(0.99, -0.99),
        Vector2(-0.33333, -0.99),
        Vector2(-0.33333, 0.01),
      ];
}
