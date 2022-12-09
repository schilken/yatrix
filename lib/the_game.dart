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

import 'falling_component.dart';
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
//    add(ScreenHitbox());
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final tapPosition = details.eventPosition.game;
    final position = Vector2((tapPosition.x ~/ 50) * 50.0, 100);
    final componentSize = Vector2(10, 10);
    final type = (tapPosition.y < 150) ? 'tet-O' : 'tet-J';
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
    if (_currentFalling == null) {
      return super.onKeyEvent(event, keysPressed);
    }
    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    if (!event.repeat) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        var newX = _currentFalling!.x + (isKeyDown ? -50 : 0);
        if (isMoveAllowed(Vector2(newX, _currentFalling?.y ?? 0))) {
          print('isMoveAllowed true, newX: $newX');
          _currentFalling!.updateX(max(newX, 0));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _currentFalling?.x += isKeyDown ? 0 : 50;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (isKeyDown) {
          _currentFalling?.rotate();
        }
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
  
  bool isMoveAllowed(Vector2 checkPosition) {
    if (checkPosition.x < 0) {
      return false;
    }
    final otherComponents = componentsAtPoint(checkPosition +
            Vector2(
              -3,
              3,
            ))
        .whereType<FallingComponent>();
    print('checkPosition: $checkPosition, otherComponents: ${otherComponents}');
    final isAllowed = otherComponents.isEmpty;
    print('isAllowed: ${isAllowed}');
    return isAllowed;
  }
}

