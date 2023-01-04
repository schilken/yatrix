import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/components/boundaries.dart';

import '../game_assets.dart';
import '../helpers.dart';
import '../tetris_game.dart';
import 'quadrat.dart';

const quadSize = 50.0;
const quadPadding = 5.0;

typedef TetrisBaseBlockTearOff = TetrisBaseBlock Function({
  required Vector2 blockPosition,
  World? world,
});

abstract class TetrisBaseBlock extends SpriteComponent
    with CollisionCallbacks, HasGameRef<TetrisGame> {
  TetrisBaseBlock({
    required this.blockPosition,
    this.world,
  }) : _velocity = Vector2(0, 100);

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
  bool _isFreezed = false;
  World? world;
  // if world == null, then we are in Construction Mode
  bool get isConstructionMode => world == null;

  factory TetrisBaseBlock.create(
    String blockType,
    Vector2 blockPosition,
    World? world,
  ) {
    TetrisBaseBlockTearOff constructorTearOff = TetrisPlayI.new;
    switch (blockType) {
      case 'I':
        constructorTearOff = TetrisPlayI.new;
        break;
      case 'O':
        constructorTearOff = TetrisPlayO.new;
        break;
      case 'J':
        constructorTearOff = TetrisPlayJ.new;
        break;
      case 'L':
        constructorTearOff = TetrisPlayL.new;
        break;
      case 'S':
        constructorTearOff = TetrisPlayS.new;
        break;
      case 'Z':
        constructorTearOff = TetrisPlayZ.new;
        break;
      case 'T':
        constructorTearOff = TetrisPlayT.new;
        break;
    }
    return constructorTearOff(
      blockPosition: blockPosition,
      world: world,
    );
  }

  factory TetrisBaseBlock.random(Vector2 blockPosition, World? world) {
    final blockTypes = [
      'I',
      'O',
      'J',
      'L',
      'S',
      'Z',
      'T',
    ];
    final newBlockType =
        blockTypes[TetrisBaseBlock._random.nextInt(blockTypes.length)];
    return TetrisBaseBlock.create(newBlockType, blockPosition, world);
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

  void freezeBlock() {
    _velocity = Vector2.all(0);
    _lastDeltaX = null;
    adjustY();
//    print('freezedBlock y: $y');
    if (y <= 75) {
      game.isGameRunning = false;
    }
    if (!isConstructionMode) {
      Future.delayed(const Duration(milliseconds: 500), markAllQuadsAsFreezed);
    }
    Future.delayed(const Duration(milliseconds: 600), game.handleBlockFreezed);
  }

  void markAllQuadsAsFreezed() {
    final quads = children.query<Quadrat>();
    for (final quad in quads) {
      final absolutePosition = quad.absolutePosition;
      quad.changeParent(world!);
      // print(
      //     'Helpers.rotCorrection(quad.absoluteAngle): ${Helpers.rotCorrection(quad.absoluteAngle)}');
      quad.position =
          absolutePosition + Helpers.rotCorrection(quad.absoluteAngle) * 40;
      quad.freeze();
      _isFreezed = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isFreezed || isConstructionMode) {
      super.render(canvas);
    }
  }

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    position = blockPosition;
    size = blockSize;
    sprite = gameAssets.sprites[name];
    anchor = blockAnchor;
    x += xOffset;
    quadPositions.forEach((position) async {
      final quad = Quadrat(
        position: position,
        collisionCallback: onQuadCollision,
        blockType: name,
      );
      await add(quad);
    });
  }

  void moveXBy(double deltaX) {
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

  void onQuadCollision(PositionComponent other) {
//    print('onQuadCollision $other');
    final intersectionPoints = <Vector2>{};
    onCollisionStart(intersectionPoints, other);
  }

  void adjustY() {
//    print('adjustY before: $y');
    final tempy = y - yOffset - 5;
    y = (tempy / 50).floor() * 50.0 + yOffset;
//    print('adjustY after: $y');
  }

  void setHighSpeed() {
    if (_velocity.y != 0) {
      _velocity.y = 1000.0;
    } else {
      _velocity.y = 100;
    }
  }

  @override
  bool containsLocalPoint(Vector2 globalPoint) {
    final localPoint = parentToLocal(globalPoint);

    final isContaining = children.any((quad) {
      return (quad as Quadrat).containsParentPoint(localPoint);
    });
    return isContaining;
//    return super.containsLocalPoint(localPoint);
  }
}

class TetrisPlayI extends TetrisBaseBlock {
  TetrisPlayI({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
        Vector2(3 * quadSize + quadPadding, quadPadding),
      ];
}

class TetrisPlayO extends TetrisBaseBlock {
  TetrisPlayO({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
      ];
}

class TetrisPlayJ extends TetrisBaseBlock {
  TetrisPlayJ({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadPadding, quadPadding),
      ];
}

class TetrisPlayL extends TetrisBaseBlock {
  TetrisPlayL({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
      ];
}

class TetrisPlayT extends TetrisBaseBlock {
  TetrisPlayT({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
      ];
}

class TetrisPlayS extends TetrisBaseBlock {
  TetrisPlayS({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
      ];
}

class TetrisPlayZ extends TetrisBaseBlock {
  TetrisPlayZ({
    required super.blockPosition,
    super.world,
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
      ];
}
