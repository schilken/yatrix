import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';

import '../components/boundaries.dart';
import '../components/buttons.dart';
import '../components/five_buttons_game_controller.dart';
import '../components/game_controller_mixin.dart';
import '../components/keyboard_game_controller.dart';
import '../components/png_button.dart';
import '../components/tetris_play_block.dart';
import '../components/three_buttons_game_controller.dart';
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

class MosaicPage extends Component
    with HasGameRef<TetrisGame>, GameControllerMixin
    implements TetrisPageInterface {
  World? world;
  CameraComponent? cameraComponent;
  Viewfinder? viewfinder;
  Viewport? viewport;
  Floor floor = Floor(size: Vector2(10, 10), position: Vector2(10, 10));
  Vector2 get visibleGameSize => viewfinder!.visibleGameSize!;
  JoystickComponent? _joystick;
  Vector2 defaultStartPosition = Vector2(250, 70);

  late final RouterComponent router;
  late Timer _joystickPoller;
  late Debouncer _rotater;

  TetrisBaseBlock? _currentFallingBlock;
  TetrisBaseBlock? get currentFallingBlock => _currentFallingBlock;

  double? _droppedAtY;
  set droppedAtY(double y) => _droppedAtY = y;

  ThreeButtonsGameController? threeButtons;
  FiveButtonsGameController? fiveButtons;

  @override
  Future<void> onLoad() async {
    print('MosaicPage.onLoad');
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
    initGameControllers([
      game.keyboardGameController!,
      threeButtons!,
      fiveButtons!,
    ]);
  }

  @override
  void onRemove() {
    reset();
    closeGameControllers();
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _joystickPoller.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
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
    const buttonGapX = 10.0;
//    print('onGameResize  size: $size  $gameSizeX,gameSizeY');
    viewfinder!.position = Vector2(gameSizeX / 2, 0);
    viewfinder!.visibleGameSize = Vector2(gameSizeX, gameSizeY);
    floor.removeFromParent();
    floor = Floor(
      size: Vector2(gameSizeX - 20, 10),
      position: Vector2(10, gameSizeY - 200),
    );
    world?.add(floor);
    defaultStartPosition = Vector2(gameSizeX / 2, 70);
    // world.add(Side(size: Vector2(10, 1100), position: Vector2(40, 50)));
    // world.add(Side(size: Vector2(10, 1100), position: Vector2(1150, 50)));
    addButtons(size);
    final fiveButtonSize = (size.x < 600) ? Vector2.all(35) : Vector2.all(50);
    if (fiveButtons == null) {
      fiveButtons = FiveButtonsGameController(
        buttonSize: fiveButtonSize,
      );
      add(fiveButtons!);
    }
    fiveButtons?.position = Vector2(
      size.x - 2 * fiveButtonSize.x - 2 * buttonGapX,
      size.y - 2 * fiveButtonSize.y,
    );
    fiveButtons?.size = fiveButtonSize;    
    if (threeButtons == null) {
      threeButtons = ThreeButtonsGameController(
        buttonSize: Vector2.all(35),
      );
      add(threeButtons!);
    }
    threeButtons?.position =
        Vector2(size.x - 2 * 35 - 2 * buttonGapX, buttonGapX);
  }

  void addButtons(Vector2 size) {
    final allsvgButtons = children.query<PngButton>();
    allsvgButtons.forEach((button) => button.removeFromParent());
    _joystick?.removeFromParent();
    final quadsize = min(25.0, (size.x - 20 - 6 * 10 - 20 - 50) / 14);
    print('quadsize: ${size.x}  $quadsize');
    final size3x2quads = Vector2(3 * quadsize, 2 * quadsize);
    final size2x2quads = Vector2(2 * quadsize, 2 * quadsize);
    final size1x4quads = Vector2(4 * quadsize, quadsize);
    final yOffsetRow1 = size.y - 30 - 3 * quadsize - 10;
    final yOffsetRow2 = size.y - 30 - quadsize;

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
        position: Vector2(20, yOffsetRow1),
        size: size3x2quads,
        onTap: () => addBlock('Z'),
      ),
      PngButton(
        name: 'tet-S',
        position: Vector2(20 + size3x2quads.x + 10, yOffsetRow1),
        size: size3x2quads,
        onTap: () => addBlock('S'),
      ),
      PngButton(
        name: 'tet-L',
        position: Vector2(20 + 2 * size3x2quads.x + 2 * 10, yOffsetRow1),
        size: size3x2quads,
        onTap: () => addBlock('L'),
      ),
      PngButton(
        name: 'tet-J',
        position: Vector2(20 + 3 * size3x2quads.x + 3 * 10, yOffsetRow1),
        size: size3x2quads,
        onTap: () => addBlock('J'),
      ),
      // second row of buttons
      PngButton(
        name: 'tet-T',
        position: Vector2(20, yOffsetRow2),
        size: size3x2quads,
        onTap: () => addBlock('T'),
      ),
      PngButton(
        name: 'tet-O',
        position: Vector2(20 + size3x2quads.x + 10, yOffsetRow2),
        size: size2x2quads,
        onTap: () => addBlock('O'),
      ),
      PngButton(
        name: 'tet-I',
        position:
            Vector2(20 + size3x2quads.x + size2x2quads.x + 2 * 10, yOffsetRow2),
        size: size1x4quads,
        onTap: () => addBlock('I'),
      ),
      PngButton(
        name: 'dice',
        position: Vector2(
            20 + size3x2quads.x + size2x2quads.x + size1x4quads.x + 3 * 10,
            yOffsetRow2),
        size: size2x2quads,
        onTap: addRandomBlock,
      ),
//      _joystick!,
    ]);
  }

  @override
  void reset() {
    game.isGameRunning = false;
    final allBlocks = world?.children.query<TetrisBaseBlock>();
    allBlocks?.forEach((element) => element.removeFromParent());
  }

  @override
  bool startGameIfNotRunning() {
    return false;
  }

  @override
  void addBlock(String name) {
    _currentFallingBlock =
        TetrisBaseBlock.create(name, defaultStartPosition, null);
    world?.add(_currentFallingBlock!);
  }

  // @override
  // void showHelp() {}

  // @override
  // void showSettings() {}

  @override
  void handleBlockFreezed() {
//    addRandomBlock();
  }

  @override
  void addRandomBlock({Vector2? startPosition}) {
    print('addRandomBlock');
    _currentFallingBlock = TetrisBaseBlock.random(
      startPosition ?? defaultStartPosition,
      null,
    );
    world?.add(_currentFallingBlock!);
  }

  @override
  void updatePoints(double? freezedAtY) {}
}
