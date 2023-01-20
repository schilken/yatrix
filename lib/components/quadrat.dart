import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/animation.dart';

import '../helpers/game_assets.dart';
import 'tetris_play_block.dart';

typedef TetrisBlockTearOff = TetrisBaseBlock Function({
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
    size = Vector2(
      quadSize - 2 * quadPadding,
      quadSize - 2 * quadPadding,
    );
  }
  CollisionCallback collisionCallback;
  RectangleHitbox? hitBox;
  QuadState state = QuadState.initial;
  String blockType;

  // final _textPaint = TextPaint(
  //   style: const TextStyle(
  //     fontSize: 40,
  //     color: Color(0xFFC8FFF5),
  //     fontWeight: FontWeight.w800,
  //   ),
  // );

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

  // void hide() {
  //   print('hide at position $position');
  //   hitBox?.removeFromParent();
  //   hitBox = null;
  //   state = QuadState.hidden;
  //   add(Background(
  //       paint: PaletteEntry(Color(0x80000000)).paint(),
  //       rect: Rect.fromLTWH(0, 0, 50, 50)));
  // }

  void removeAnimated() {
    anchor = Anchor.bottomCenter;
    y += 50.0;
    add(
      ScaleEffect.to(
        Vector2(1, 0.1),
        EffectController(duration: 0.2, curve: Curves.easeOut),
        onComplete: removeFromParent,
      ),
    );
  }


  void freeze() {
//    print('freeze at position $position $blockType');
    state = QuadState.freezed;
  }

  void moveOneStepDown() {
    y += 50;
    state = QuadState.dropped;
  }

  void moveOneStepUp() {
    y -= 50;
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
