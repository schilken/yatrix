import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/boundaries.dart';

import 'game_assets.dart';
import 'helpers.dart';
import 'quadrat.dart';
import 'tetris_game.dart';

const quadSize = 50.0;
const quadPadding = 3.0;

typedef TetrisPlayBlockTearOff = TetrisPlayBlock Function({
  required Vector2 blockPosition,
  required World world,
  Vector2 velocity,
});

abstract class TetrisPlayBlock extends TetrisBlock {
  TetrisPlayBlock(
      {required super.blockPosition, required this.world, Vector2? velocity});

  World world;

  factory TetrisPlayBlock.create(
    String blockType,
    Vector2 blockPosition,
    World world,
  ) {
    TetrisPlayBlockTearOff constructorTearOff = TetrisPlayI.new;
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

  factory TetrisPlayBlock.random(Vector2 blockPosition, World world) {
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
        blockTypes[TetrisBlock._random.nextInt(blockTypes.length)];
    return TetrisPlayBlock.create(newBlockType, blockPosition, world);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (dropDestination != null) {
      return;
    }
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
    print('freezedBlock y: $y');
    if (y <= 75) {
      game.isGameRunning = false;
    }
    if (y >= 950) {
      print('out of area');
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      markAllQuadsAsFreezed();
    });
    Future.delayed(Duration(milliseconds: 600), () {
      game.handleBlockFreezed();
    });
  }

  void markAllQuadsAsFreezed() {
    final quads = children.query<Quadrat>();
    for (final quad in quads) {
      final absolutePosition = quad.absolutePosition;
      quad.changeParent(world);
      // print(
      //     'Helpers.rotCorrection(quad.absoluteAngle): ${Helpers.rotCorrection(quad.absoluteAngle)}');
      quad.position =
          absolutePosition + Helpers.rotCorrection(quad.absoluteAngle) * 50;
      quad.freeze();
      _isFreezed = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isFreezed) {
      super.render(canvas);
    }
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
  double? dropDestination;
  bool _isFreezed = false;

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    position = blockPosition;
    size = blockSize;
    sprite = gameAssets.sprites[name];
    anchor = blockAnchor;
    x += xOffset;
    quadPositions.forEach((position) async {
      final quad =
          Quadrat(
          position: position,
          collisionCallback: onQuadCollision,
          blockType: name);
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
    if (dropDestination != null && dropDestination! > position.y) {
      _velocity = Vector2.all(0);
    }
  }

  void onQuadCollision(PositionComponent other) {
    print('onQuadCollision $other');
    final intersectionPoints = <Vector2>{};
    onCollisionStart(intersectionPoints, other);
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

  // void dropOneRow() {
  //   dropDestination = y + 50;
  //   print('dropDestination: $dropDestination');
  //   y = dropDestination!;
  // }

  @override
  bool containsLocalPoint(Vector2 globalPoint) {
    final localPoint = parentToLocal(globalPoint);

    final isContaining = children.any((quad) {
      return (quad as Quadrat).containsParentPoint(localPoint);
    });
    return isContaining;
//    return super.containsLocalPoint(localPoint);
  }

//   void hideQuad(Vector2 globalPoint) {
// //    print('TetrisBlock.hideQuad at $globalPoint');
//     final localPoint = parentToLocal(globalPoint);
//     final quads = children.query<Quadrat>();
//     for (final quad in quads) {
//       if (quad.containsParentPoint(localPoint)) {
//         quad.hide();
//       }
//     }
//   }
}

class TetrisPlayI extends TetrisPlayBlock {
  TetrisPlayI({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayO extends TetrisPlayBlock {
  TetrisPlayO({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayJ extends TetrisPlayBlock {
  TetrisPlayJ({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayL extends TetrisPlayBlock {
  TetrisPlayL({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayT extends TetrisPlayBlock {
  TetrisPlayT({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayS extends TetrisPlayBlock {
  TetrisPlayS({
    required super.blockPosition,
    required super.world,
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

class TetrisPlayZ extends TetrisPlayBlock {
  TetrisPlayZ({
    required super.blockPosition,
    required super.world,
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
