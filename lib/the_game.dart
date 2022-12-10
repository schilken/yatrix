import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Draggable, Viewport;
import 'package:flutter/services.dart';

import 'package:tetris/boundaries.dart';

import 'tetris_block.dart';
import 'game_assets.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

class TheGame extends FlameGame
    with HasCollisionDetection, TapDetector, HasDraggables, KeyboardEvents {

  TheGame();
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;


  TetrisBlock? _currentFallingBlock;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await gameAssets.preCache();
    world = World();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;

    await addAll([world, cameraComponent]);
    children.register<World>();
    viewfinder.anchor = Anchor.topCenter;
    viewfinder.position = Vector2(250, 0);
    viewfinder.visibleGameSize = Vector2(500, 1000);

    world.add(Floor(Vector2(0, 480)));
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
  }

  void restart() {
    print('restart');
    final allBlocks = world.children.query<TetrisBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
  }

@override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
//    print('size.x ${size.x}');
    final startPosition = Vector2(250, 70);
    final velocity = Vector2(0, 100);
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return super.onKeyEvent(event, keysPressed);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyO) {
      world.add(_currentFallingBlock = TetrisO(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      world.add(_currentFallingBlock = TetrisJ(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      world.add(_currentFallingBlock = TetrisI(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyT) {
      world.add(_currentFallingBlock = TetrisT(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      world.add(_currentFallingBlock = TetrisS(velocity, startPosition));
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      world.add(_currentFallingBlock = TetrisJ(velocity, startPosition)
          ..flipHorizontally(),
      );
    }
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      world.add(_currentFallingBlock = TetrisS(velocity, startPosition)
          ..flipHorizontally(),
      );
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
        final newX =
            _currentFallingBlock!.x - 50 - _currentFallingBlock!.xOffset;
        if (isMoveAllowed(Vector2(newX, _currentFallingBlock!.y))) {
//          print('isMoveAllowed true, newX: $newX');
          _currentFallingBlock!.moveXBy(-50);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        final newX =
            _currentFallingBlock!.x + 50 - _currentFallingBlock!.xOffset;
        if (isMoveAllowed(Vector2(newX, _currentFallingBlock!.y))) {
//          print('isMoveAllowed true, newX: $newX');
          _currentFallingBlock!.moveXBy(50);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _currentFallingBlock?.rotate();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _currentFallingBlock?.setHighSpeed();
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
    if (checkPosition.x > 400) {
      return false;
    }

    return true; 
  }
}

