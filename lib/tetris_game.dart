import 'dart:math';
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

class TetrisGame extends FlameGame
    with HasCollisionDetection, TapDetector, HasDraggables, KeyboardEvents {
  TetrisGame();
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  TetrisBlock? _currentFallingBlock;
  bool isGameRunning = false;

  final defaultStartPosition = Vector2(250, 70);

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

    world.add(Floor(size: Vector2(500, 10), position: Vector2(0, 990)));
    world.add(Side(size: Vector2(10, 900), position: Vector2(-10, 50)));
    world.add(Side(size: Vector2(10, 900), position: Vector2(500, 50)));
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
  }

  void restart() {
    print('restart');
    isGameRunning = false;
    final allBlocks = world.children.query<TetrisBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return super.onKeyEvent(event, keysPressed);
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      restart();
    }

    if (event.logicalKey == LogicalKeyboardKey.keyO) {
      _currentFallingBlock = TetrisBlock.create('O', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      _currentFallingBlock = TetrisBlock.create('J', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      _currentFallingBlock = TetrisBlock.create('I', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyT) {
      _currentFallingBlock = TetrisBlock.create('T', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      _currentFallingBlock = TetrisBlock.create('S', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      _currentFallingBlock = TetrisBlock.create('L', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _currentFallingBlock = TetrisBlock.create('Z', defaultStartPosition);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyR) {
      isGameRunning = true;
      addRandomBlock();
    }
    if (event.logicalKey == LogicalKeyboardKey.question) {
      createRowFillCounts();
    }


    if (_currentFallingBlock == null) {
      return super.onKeyEvent(event, keysPressed);
    }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _currentFallingBlock!.moveXBy(-50);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _currentFallingBlock!.moveXBy(50);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _currentFallingBlock?.rotateBy(-pi / 2);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _currentFallingBlock?.setHighSpeed();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void addRandomBlock({Vector2? startPosition}) {
    if (!isGameRunning) {
      print('>>> GAME OVER <<<');
      return;
    }
    _currentFallingBlock =
        TetrisBlock.random(startPosition ?? defaultStartPosition);
    world.add(_currentFallingBlock!);
  }
  
  void createRowFillCounts() {
    final rowFillCount = <int>[];
    for (var y = 925.0; y > 75.0; y -= 50.0) {
      var fillCount = 0;
      for (var x = 25.0; x < 500.0; x += 50.0) {
        final point = Vector2(x, y);
        final blocks =
            world.children.where((block) => block.containsLocalPoint(point));
        if (blocks.isNotEmpty) {
          fillCount++;
        }
      }
      rowFillCount.add(fillCount);
    }
    print('rowFillCount $rowFillCount');
  }

}
