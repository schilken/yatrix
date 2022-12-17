import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flame/extensions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

import 'game_assets.dart';
import 'tetris_game.dart';

const tiny = 0.05;
const quadSize = 50.0;

typedef TetrisBlockTearOff = TetrisBlock Function({
  required Vector2 blockPosition,
  Vector2 velocity,
});

typedef CollisionCallback = void Function(PositionComponent);

class Quad extends PositionComponent with CollisionCallbacks {
  Quad({
    super.position,
    required this.collisionCallback,
  }) {
    size = Vector2(40, 40);
  }
  CollisionCallback collisionCallback;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    add(RectangleHitbox());
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
    return rect.containsPoint(parentPoint);
  }

  @override
  String toString() {
    return '$position, $size';
  }
}

abstract class TetrisBlock extends SpriteComponent
    with CollisionCallbacks, HasGameRef<TetrisGame> {
  TetrisBlock({
    required this.blockPosition,
    Vector2? velocity,
  }) : _velocity = velocity ?? Vector2(0, 100);

  Vector2 _velocity;
  Vector2 blockPosition;

  static final Random _random = Random();
  Vector2 get blockSize;
  Anchor get blockAnchor;
  List<Vector2> get quadPositions;
  double get xOffset;
  double get yOffset;
  String get name;
  double? _lastDeltaX;
  double? _lastRotate;
  PolygonHitbox? hitBox;

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    position = blockPosition;
    size = blockSize;
    sprite = gameAssets.sprites[name];
    anchor = blockAnchor;
    x += xOffset;

    quadPositions.forEach((position) async {
      final quad = Quad(position: position, collisionCallback: onQuadCollision);
      await add(quad);
//      print('Quad $quad');
    });
  }

  void moveXBy(double deltaX) {
//    print('moveXBy: $deltaX');
    x += deltaX;
    _lastDeltaX = deltaX;
    Future.delayed(const Duration(milliseconds: 100), () => _lastDeltaX = null);
  }

  void rotateBy(double deltaAngle) {
    angle += deltaAngle;
    _lastRotate = deltaAngle;
    Future.delayed(const Duration(milliseconds: 100), () => _lastRotate = null);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
  }

  void freezeBlock() {
    _velocity = Vector2.all(0);
    _lastDeltaX = null;
    adjustY();
    print('freezedBlock y: $y');
    if (y <= 75) {
      game.isGameRunning = false;
    }
    Future.delayed(
        Duration(milliseconds: 500), () => game.handleBlockFreezed());
  }

  void onQuadCollision(PositionComponent other) {
    print('onQuadCollision $other');

    Set<Vector2> intersectionPoints = {};
    onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
//    print('onCollisionStart $other');
    if (_velocity.y == 0 && _lastDeltaX == null && _lastRotate == null) {
      return;
    }
    if (other is Floor && _lastRotate == null) {
      freezeBlock();
      return;
    }
    if (other is Floor && _lastRotate != null) {
      angle -= _lastRotate!;
      _lastRotate = null;
      return;
    }

    if (_lastDeltaX != null) {
      x -= _lastDeltaX!;
      _lastDeltaX = null;
    } else if (_lastRotate != null) {
      angle -= _lastRotate!;
      _lastRotate = null;
    } else {
      freezeBlock();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void adjustY() {
    print('adjustY before: $y');
    final tempy = y - yOffset;
    y = (tempy / 50).floor() * 50.0 + yOffset;
    print('adjustY after: $y');
  }

  void setHighSpeed() {
    if (_velocity.y != 0) {
      _velocity.y = 1000.0;
    } else {
      _velocity.y = 100;
    }
  }

  factory TetrisBlock.create(String blockType, Vector2 blockPosition) {
    TetrisBlockTearOff constructorTearOff = TetrisI.new;
    switch (blockType) {
      case 'I':
        constructorTearOff = TetrisI.new;
        break;
      case 'O':
        constructorTearOff = TetrisO.new;
        break;
      case 'J':
        constructorTearOff = TetrisJ.new;
        break;
      case 'L':
        constructorTearOff = TetrisL.new;
        break;
      case 'S':
        constructorTearOff = TetrisS.new;
        break;
      case 'Z':
        constructorTearOff = TetrisZ.new;
        break;
      case 'T':
        constructorTearOff = TetrisT.new;
        break;
    }
    return constructorTearOff(blockPosition: blockPosition);
  }

  factory TetrisBlock.random(Vector2 blockPosition) {
    final blockTypes = [
      'I',
      'O',
      'J',
      'L',
      'S',
      'Z',
      'T',
    ];
    final newBlockType = blockTypes[_random.nextInt(blockTypes.length)];
    return TetrisBlock.create(newBlockType, blockPosition);
  }

  @override
  bool containsLocalPoint(Vector2 globalPoint) {
    final localPoint = parentToLocal(globalPoint);

    final isContaining = children.any((quad) {
      return (quad as Quad).containsParentPoint(localPoint);
    });
    return isContaining;
//    return super.containsLocalPoint(localPoint);
  }

  void removeQuad(Vector2 globalPoint) {
    print('TetrisBlock.removeQuad at $globalPoint');
    final localPoint = parentToLocal(globalPoint);
    final quads = children.query<Quad>();
    for (final quad in quads) {
      if (quad.containsParentPoint(localPoint)) {
        print('removeFromParent $globalPoint');
        quad.removeFromParent();
      }
    }
  }
}

class TetrisI extends TetrisBlock {
  TetrisI({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(4 * quadSize, quadSize);
  @override
  String get name => 'tet-I';
  @override
  Anchor get blockAnchor => const Anchor(0.125, 0.5);
  @override
  double get xOffset => 25.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 5),
        Vector2(55, 5),
        Vector2(105, 5),
        Vector2(155, 5),
      ];
}

class TetrisO extends TetrisBlock {
  TetrisO({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(2 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-O';
  @override
  Anchor get blockAnchor => Anchor.center;
  @override
  double get xOffset => 50.0;
  @override
  double get yOffset => 0.0;

  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 5),
        Vector2(55, 5),
        Vector2(5, 55),
        Vector2(55, 55),
      ];
}

class TetrisJ extends TetrisBlock {
  TetrisJ({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(3 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-J';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 55),
        Vector2(55, 55),
        Vector2(105, 55),
        Vector2(5, 5),
      ];
}

class TetrisL extends TetrisBlock {
  TetrisL({
    required super.blockPosition,
    super.velocity,
  });

  @override
  Vector2 get blockSize => Vector2(3 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-L';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 55),
        Vector2(55, 55),
        Vector2(105, 55),
        Vector2(105, 5),
      ];
}

class TetrisT extends TetrisBlock {
  TetrisT({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(3 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-T';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 55),
        Vector2(55, 55),
        Vector2(105, 55),
        Vector2(55, 5),
      ];
}

class TetrisS extends TetrisBlock {
  TetrisS({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(3 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-S';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 55),
        Vector2(55, 55),
        Vector2(105, 5),
        Vector2(55, 5),
      ];
}

class TetrisZ extends TetrisBlock {
  TetrisZ({
    required super.blockPosition,
    super.velocity,
  });
  @override
  Vector2 get blockSize => Vector2(3 * quadSize, 2 * quadSize);
  @override
  String get name => 'tet-Z';
  @override
  Anchor get blockAnchor => const Anchor(0.5, 0.75);
  @override
  double get xOffset => 75.0;
  @override
  double get yOffset => 25.0;
  @override
  List<Vector2> get quadPositions => [
        Vector2(5, 5),
        Vector2(55, 55),
        Vector2(105, 55),
        Vector2(55, 5),
      ];
}
