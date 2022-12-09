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

import 'tetris_block.dart';
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

  TetrisBlock? _currentFallingBlock;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await gameAssets.preCache();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
  }

  void restart() {
    print('restart');
    final allBlocks = children.query<TetrisBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
  }

@override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final startPosition = Vector2(size.x / 2, 150);
    final velocity = Vector2(0, 100);
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return super.onKeyEvent(event, keysPressed);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyO) {
      add(_currentFallingBlock = TetrisO(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      add(_currentFallingBlock = TetrisJ(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      add(_currentFallingBlock = TetrisI(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      restart();
    }

    if (_currentFallingBlock == null) {
      return super.onKeyEvent(event, keysPressed);
    }
    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    if (!event.repeat) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        var newX = _currentFallingBlock!.x + -50;
        if (isMoveAllowed(Vector2(newX, _currentFallingBlock?.y ?? 0))) {
          print('isMoveAllowed true, newX: $newX');
          _currentFallingBlock!.updateX(max(newX, 0));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _currentFallingBlock?.x += 50;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _currentFallingBlock?.rotate();
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
    return true; // TODO reactivate later
    final otherComponents = componentsAtPoint(checkPosition +
            Vector2(
              -3,
              3,
            ))
        .whereType<TetrisBlock>();
    print('checkPosition: $checkPosition, otherComponents: ${otherComponents}');
    final isAllowed = otherComponents.isEmpty;
    print('isAllowed: ${isAllowed}');
    return isAllowed;
  }
}

