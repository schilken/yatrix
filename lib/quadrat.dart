

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import 'background.dart';
import 'game_assets.dart';
import 'tetris_block.dart';

typedef TetrisBlockTearOff = TetrisBlock Function({
  required Vector2 blockPosition,
  Vector2 velocity,
});

typedef CollisionCallback = void Function(PositionComponent);

enum QuadState {
  initial('i'),
  falling('f'),
  freezed('z'),
  hidden('h'),
  dropped('d');

  final String value;
  const QuadState(this.value);
}

class Quadrat extends SpriteComponent with CollisionCallbacks {
  Quadrat({
    super.position,
    required this.collisionCallback,
    required this.blockType,
  }) {
    size = Vector2(40, 40);
  }
  CollisionCallback collisionCallback;
  RectangleHitbox? hitBox;
  double? dropDestination;
  var state = QuadState.initial; 
  String blockType;

final _textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 40,
      color: Color(0xFFC8FFF5),
      fontWeight: FontWeight.w800,
    ),
  );

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    add(hitBox = RectangleHitbox());
    sprite = gameAssets.sprites['quad-$blockType'];
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
    return hitBox != null && rect.containsPoint(parentPoint);
  }

  void hide() {
    print('hide at position $position');
    hitBox?.removeFromParent();
    hitBox = null;
    state = QuadState.hidden;
    add(Background(
        paint: PaletteEntry(Color(0x80000000)).paint(),
        rect: Rect.fromLTWH(0, 0, 50, 50)));
  }

  void freeze() {
    print('freeze at position $position $blockType');
    state = QuadState.freezed;
  }

  void dropOneRow() {
    dropDestination = y + 50;
    print('dropDestination: $dropDestination');
    y = dropDestination!;
    state = QuadState.dropped;
//    add(Background(paint: BasicPalette.green.paint()));
  }

  @override
  void render(Canvas canvas) {
//    _textPaint.render(canvas, state.value, Vector2(10, -5));
    if (state != QuadState.initial) {
      super.render(canvas);
    }
  }

  @override
  String toString() {
    return '$position, $size';
  }
}
