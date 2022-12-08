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

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

class TheGame extends FlameGame
    with HasCollisionDetection, TapDetector, HasDraggables, KeyboardEvents {
  static const info = '''
This example shows how to compose a `BodyComponent` together with a normal Flame
component. Click the ball to see the number increment.
''';

  TheGame();

  FallingComponent? _currentFalling;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await gameAssets.preCache();
    add(ScreenHitbox());
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final tapPosition = details.eventPosition.game;
    final position = Vector2((tapPosition.x ~/ 50) * 51.0, 100);
    final componentSize = Vector2(10, 10);
    final type = (tapPosition.y < 200) ? 'tet-O' : 'tet-J';
    _currentFalling =
        FallingComponent(type, Vector2(0, 100), position, componentSize);
    add(_currentFalling!);
 
//    add(Tetromino(position, size: Vector2(15, 10)));
  }

@override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    if (!event.repeat) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        _currentFalling?.x += isKeyDown ? -51 : 0;
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        _currentFalling?.x += isKeyDown ? 0 : 51;
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        _currentFalling?.y += isKeyDown ? -1 : 1;
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        _currentFalling?.y += isKeyDown ? 1 : -1;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}

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
      size = Vector2(100, 100);
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
      size = Vector2(150, 100);
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
    print('onCollisionStart');
    super.onCollisionStart(intersectionPoints, other);
    velocity = Vector2.all(0);
  }
}
