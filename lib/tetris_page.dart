import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flutter/services.dart';

import 'boundaries.dart';
import 'buttons.dart';
import 'game_assets.dart';
import 'tetris_block.dart';
import 'tetris_game.dart';

class TetrisConstructPage extends Component
    with HasGameRef<TetrisGame>
    implements TetrisPageInterface {
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  TetrisBlock? _currentFallingBlock;
  late final RouterComponent router;

  final defaultStartPosition = Vector2(250, 70);

  late bool isRemovingRows;
  @override
  Future<void> onLoad() async {
    isRemovingRows = false;
    addAll([
//      Background(const Color(0xbb2a074f)),
      BackButton(),
      PauseButton(),
    ]);
    //debugMode = true;
    await gameAssets.preCache();
    world = World();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;

    await addAll([world, cameraComponent]);
    children.register<World>();
    viewfinder.anchor = Anchor.topCenter;

    viewfinder.position = Vector2(600, 0);
    viewfinder.visibleGameSize = Vector2(1200, 1224);

    world.add(Floor(size: Vector2(1200, 10), position: Vector2(0, 1190)));
    world.add(Side(size: Vector2(10, 1100), position: Vector2(40, 50)));
    world.add(Side(size: Vector2(10, 1100), position: Vector2(1150, 50)));




  }

  void restart() {
    game.isGameRunning = false;
    final allBlocks = world.children.query<TetrisBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
  }

  void onKeyboardKey(
    RawKeyEvent event,
  ) {
    final isKeyUp = event is RawKeyUpEvent;
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
      game.isGameRunning = true;
      addRandomBlock();
    }

    if (_currentFallingBlock == null) {
      return;
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
  }

  void handleBlockFreezed() {
//    addRandomBlock();
  }

  void addRandomBlock({Vector2? startPosition}) {
    print('addRandomBlock');
    _currentFallingBlock =
        TetrisBlock.random(startPosition ?? defaultStartPosition);
    world.add(_currentFallingBlock!);
  }

}

