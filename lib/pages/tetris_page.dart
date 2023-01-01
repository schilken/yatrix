import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';

import '../components/boundaries.dart';
import '../components/buttons.dart';
import '../components/game_controller_mixin.dart';
import '../components/png_button.dart';
import '../components/tetris_play_block.dart';
import '../tetris_game.dart';

class Debouncer {
  Debouncer(this.callback);
  VoidCallback callback;

  int delayTicks = 0;

  void tick() {
    print('delayTicks: ${delayTicks}');
    if (--delayTicks < 0) {
      callback();
      delayTicks = 2;
    }
  }
}

class TetrisConstructPage extends Component
    with
        HasGameRef<TetrisGame> //, GameControllerMixin
    implements TetrisPageInterface {
  World? world;
  CameraComponent? cameraComponent;
  Viewfinder? viewfinder;
  Viewport? viewport;
  Floor floor = Floor(size: Vector2(10, 10), position: Vector2(10, 10));
  Vector2 get visibleGameSize => viewfinder!.visibleGameSize!;
  JoystickComponent? _joystick;
  TetrisBaseBlock? _currentFallingBlock;
  Vector2 defaultStartPosition = Vector2(250, 70);

  late final RouterComponent router;
  late Timer _joystickPoller;
  late Debouncer _rotater;

  @override
  Future<void> onLoad() async {
    print('TetrisConstructPage.onLoad');
    _rotater = Debouncer(() => _currentFallingBlock?.rotateBy(-pi / 2));
    addAll([
      BackButton(),
      PauseButton(),
    ]);
    _joystickPoller = Timer(
      0.2,
      repeat: true,
      onTick: () {
        final direction = _joystick?.direction;
        if (direction == JoystickDirection.left) {
          _currentFallingBlock?.moveXBy(-50);
        }
        if (direction == JoystickDirection.right) {
          _currentFallingBlock?.moveXBy(50);
        }
        if (direction == JoystickDirection.up) {
          _rotater.tick();
        }
        if (direction == JoystickDirection.down) {
          _currentFallingBlock?.setHighSpeed();
        }
      },
    );
    _joystickPoller.start();
    //debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _joystickPoller.update(dt);
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
    _joystick?.removeFromParent();
    final quadsize = min(25.0, (size.x - 20 - 6 * 10 - 20 - 50) / 21);
    print('quadsize: ${size.x}  $quadsize');
    final size3x2quads = Vector2(3 * quadsize, 2 * quadsize);
    final size2x2quads = Vector2(2 * quadsize, 2 * quadsize);
    final size1x4quads = Vector2(4 * quadsize, quadsize);
    final yOffset = size.y - 30 - quadsize;

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    _joystick = JoystickComponent(
      knob: CircleComponent(radius: 10, paint: knobPaint),
      background: CircleComponent(radius: 25, paint: backgroundPaint),
//      margin: const EdgeInsets.only(left: 40, bottom: 40),
      position: Vector2(size.x - 40, size.y - 50),
    );

    addAll([
      PngButton(
        name: 'tet-Z',
        position: Vector2(20, yOffset),
        size: size3x2quads,
        onTap: () => addBlock('Z'),
      ),
      PngButton(
        name: 'tet-S',
        position: Vector2(20 + size3x2quads.x + 10, yOffset),
        size: size3x2quads,
        onTap: () => addBlock('S'),
      ),
      PngButton(
        name: 'tet-L',
        position: Vector2(20 + 2 * size3x2quads.x + 2 * 10, yOffset),
        size: size3x2quads,
        onTap: () => addBlock('L'),
      ),
      PngButton(
        name: 'tet-J',
        position: Vector2(20 + 3 * size3x2quads.x + 3 * 10, yOffset),
        size: size3x2quads,
        onTap: () => addBlock('J'),
      ),
      PngButton(
        name: 'tet-T',
        position: Vector2(20 + 4 * size3x2quads.x + 4 * 10, yOffset),
        size: size3x2quads,
        onTap: () => addBlock('T'),
      ),
      PngButton(
        name: 'tet-O',
        position: Vector2(20 + 5 * size3x2quads.x + 5 * 10, yOffset),
        size: size2x2quads,
        onTap: () => addBlock('O'),
      ),
      PngButton(
        name: 'tet-I',
        position: Vector2(20 + 5 * size3x2quads.x + size2x2quads.x + 6 * 10,
            yOffset + quadsize),
        size: size1x4quads,
        onTap: () => addBlock('I'),
      ),
      _joystick!,
    ]);
  }

  void restart() {
    game.isGameRunning = false;
    final allBlocks = world?.children.query<TetrisBaseBlock>();
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
      addBlock('O');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      addBlock('J');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      addBlock('I');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyT) {
      addBlock('T');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      addBlock('S');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      addBlock('L');
    }
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      addBlock('Z');
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

  void addBlock(String name) {
    _currentFallingBlock =
        TetrisPlayBlock.create(name, defaultStartPosition, world!);
    world?.add(_currentFallingBlock!);
  }

  void handleBlockFreezed() {
//    addRandomBlock();
  }

  void addRandomBlock({Vector2? startPosition}) {
    print('addRandomBlock');
    _currentFallingBlock =
        TetrisPlayBlock.random(startPosition ?? defaultStartPosition, world!);
    world?.add(_currentFallingBlock!);
  }
}
