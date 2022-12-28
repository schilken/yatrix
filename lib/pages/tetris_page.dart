import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/services.dart';

import '../components/boundaries.dart';
import '../components/buttons.dart';
import '../components/png_button.dart';
import '../components/tetris_block.dart';
import '../game_assets.dart';
import '../tetris_game.dart';

class TetrisConstructPage extends Component
    with HasGameRef<TetrisGame>
    implements TetrisPageInterface {
  World? world;
  CameraComponent? cameraComponent;
  Viewfinder? viewfinder;
  Viewport? viewport;
  Floor floor = Floor(size: Vector2(10, 10), position: Vector2(10, 10));
  Vector2 get visibleGameSize => viewfinder!.visibleGameSize!;

  TetrisBlock? _currentFallingBlock;
  late final RouterComponent router;

  Vector2 defaultStartPosition = Vector2(250, 70);

  late bool isRemovingRows;

  @override
  Future<void> onLoad() async {
    print('onLoad');
    isRemovingRows = false;
    addAll([
      BackButton(),
      PauseButton(),
    ]);
    //debugMode = true;
  }

  @override
  void onGameResize(Vector2 size) {
    world?.removeFromParent();
    world = World();
    cameraComponent = CameraComponent(world: world!);
    viewport = cameraComponent!.viewport;
    viewfinder = cameraComponent!.viewfinder;

    addAll([world!, cameraComponent!]);
    children.register<World>();
    viewfinder?.anchor = Anchor.topCenter;
    floor = Floor(size: Vector2(10, 10), position: Vector2(10, 10));
    world?.add(floor);
    final ratio = size.x / size.y;
    const gameSizeY = 1225.0;
    final gameSizeX = gameSizeY * ratio;
    print('onGameResize  size: $size  $gameSizeX,gameSizeY');
    viewfinder!.position = Vector2(gameSizeX / 2, 0);
    viewfinder!.visibleGameSize = Vector2(gameSizeX, gameSizeY);
    floor.removeFromParent();
    floor = Floor(
      size: Vector2(gameSizeX - 20, 10),
      position: Vector2(10, gameSizeY - 150),
    );
    world?.add(floor);
    defaultStartPosition = Vector2(gameSizeX / 2, 70);
    // world.add(Side(size: Vector2(10, 1100), position: Vector2(40, 50)));
    // world.add(Side(size: Vector2(10, 1100), position: Vector2(1150, 50)));
    addButtons(size);
  }

  void addButtons(Vector2 size) {
    final allsvgButtons = children.query<PngButton>();
    allsvgButtons.forEach((button) => button.removeFromParent());
    final quadsize = min(25.0, (size.x - 20 - 6 * 10 - 20) / 21);
    print('quadsize: ${size.x}  $quadsize');
    final size3x2quads = Vector2(3 * quadsize, 2 * quadsize);
    final size2x2quads = Vector2(2 * quadsize, 2 * quadsize);
    final size1x4quads = Vector2(4 * quadsize, quadsize);

    final yOffset = size.y - 30 - quadSize;
    addAll([
      PngButton(
        name: 'tet-Z',
        position: Vector2(20, yOffset),
        size: size3x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-S',
        position: Vector2(20 + size3x2quads.x + 10, yOffset),
        size: size3x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-L',
        position: Vector2(20 + 2 * size3x2quads.x + 2 * 10, yOffset),
        size: size3x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-J',
        position: Vector2(20 + 3 * size3x2quads.x + 3 * 10, yOffset),
        size: size3x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-T',
        position: Vector2(20 + 4 * size3x2quads.x + 4 * 10, yOffset),
        size: size3x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-O',
        position: Vector2(20 + 5 * size3x2quads.x + 5 * 10, yOffset),
        size: size2x2quads,
        onTap: () => print('button pressed'),
      ),
      PngButton(
        name: 'tet-I',
        position: Vector2(20 + 5 * size3x2quads.x + size2x2quads.x + 6 * 10,
            yOffset + quadsize),
        size: size1x4quads,
        onTap: () => print('button pressed'),
      ),
    ]);
  }

  void restart() {
    game.isGameRunning = false;
    final allBlocks = world?.children.query<TetrisBlock>();
    allBlocks?.forEach((element) => element.removeFromParent());
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
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      _currentFallingBlock = TetrisBlock.create('J', defaultStartPosition);
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      _currentFallingBlock = TetrisBlock.create('I', defaultStartPosition);
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyT) {
      _currentFallingBlock = TetrisBlock.create('T', defaultStartPosition);
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      _currentFallingBlock = TetrisBlock.create('S', defaultStartPosition);
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      _currentFallingBlock = TetrisBlock.create('L', defaultStartPosition);
      world?.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _currentFallingBlock = TetrisBlock.create('Z', defaultStartPosition);
      world?.add(_currentFallingBlock!);
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
    world?.add(_currentFallingBlock!);
  }
}
