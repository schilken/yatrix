import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tetris/components/boundaries.dart';

import '../game_assets.dart';
import 'quadrat.dart';
import '../tetris_game.dart';

const quadSize = 50.0;
const quadPadding = 3.0;

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
      final quad = Quadrat(
          position: position,
          collisionCallback: onQuadCollision,
          blockType: name);
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
//    print('freezedBlock y: $y');
    if (y <= 75) {
      game.isGameRunning = false;
    }
  }

  void onQuadCollision(PositionComponent other) {
//    print('onQuadCollision $other');
    final intersectionPoints = <Vector2>{};
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
//    print('adjustY before: $y');
    final tempy = y - yOffset;
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
      return (quad as Quadrat).containsParentPoint(localPoint);
    });
    return isContaining;
//    return super.containsLocalPoint(localPoint);
  }

  void hideQuad(Vector2 globalPoint) {
//    print('TetrisBlock.hideQuad at $globalPoint');
    final localPoint = parentToLocal(globalPoint);
    final quads = children.query<Quadrat>();
    for (final quad in quads) {
      if (quad.containsParentPoint(localPoint)) {
        quad.hide();
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
        Vector2(3 * quadSize + quadPadding, quadPadding),
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadPadding, quadPadding),
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
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
        Vector2(quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
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
        Vector2(quadPadding, quadPadding),
        Vector2(quadSize + quadPadding, quadSize + quadPadding),
        Vector2(2 * quadSize + quadPadding, quadSize + quadPadding),
        Vector2(quadSize + quadPadding, quadPadding),
      ];
}
