import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import '../components/boundaries.dart';
import '../components/buttons.dart';
import '../game_assets.dart';
import '../components/quadrat.dart';
import '../components/svg_button.dart';
import '../tetris_game.dart';
import '../tetris_matrix.dart';
import '../components/tetris_play_block.dart';

class TetrisPlayPage extends Component
    with HasGameRef<TetrisGame>
    implements TetrisPageInterface {
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  TetrisPlayBlock? _currentFallingBlock;
  late final RouterComponent router;

  final defaultStartPosition = Vector2(250, 70);
  final xOffset = 50;
  TextComponent? _textComponent;
  int _freezedCounter = 0;
  double? _droppedAtY;
  int _removedRows = 0;
  static const lowestY = 1125;

  @override
  Future<void> onLoad() async {
    addAll([
      BackButton(),
      PauseButton(),
    ]);
    //debugMode = true;
    world = World();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;

    await addAll([world, cameraComponent]);
    children.register<World>();
    viewfinder.anchor = Anchor.topCenter;
    viewfinder.position = Vector2(300, 0);
    viewfinder.visibleGameSize = Vector2(600, 1224);

    world.add(Floor(size: Vector2(600, 10), position: Vector2(0, 1190)));
    world.add(Side(size: Vector2(10, 1100), position: Vector2(40, 50)));
    world.add(Side(size: Vector2(10, 1100), position: Vector2(550, 50)));
  }

  @override
  void onGameResize(Vector2 size) {
//    print('TetrisPlayPage.size: ${size}');
    final rightButtonX = size.x - 35;
    const leftButtonX = 0.0;
    final buttonSize = Vector2.all(35);
    final allsvgButtons = children.query<SvgButton>();
    allsvgButtons.forEach((button) => button.removeFromParent());
    _textComponent?.removeFromParent();
    _textComponent = TextBoxComponent(
      text: 'Tap down arrow to start',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0x66ffffff),
          fontSize: 16,
        ),
      ),
      align: Anchor.bottomCenter,
      size: gameRef.canvasSize,
    );

    addAll([
      SvgButton(
        name: 'svg/restart-grey.svg',
        position: Vector2(rightButtonX, 20),
        size: buttonSize,
        onTap: () => handleKey(LogicalKeyboardKey.escape),
      ),
      SvgButton(
        name: 'svg/rotate-left-variant-grey.svg',
        position: Vector2(leftButtonX, 300),
        size: buttonSize,
        onTap: () => handleKey(LogicalKeyboardKey.arrowUp),
      ),
      SvgButton(
        name: 'svg/arrow-left-bold-outline-grey.svg',
        position: Vector2(leftButtonX, 380),
        size: buttonSize,
        onTap: () => handleKey(LogicalKeyboardKey.arrowLeft),
      ),
      SvgButton(
        name: 'svg/rotate-right-variant-grey.svg',
        position: Vector2(rightButtonX, 300),
        size: buttonSize,
        onTap: () => handleKey(LogicalKeyboardKey.keyR),
      ),
      SvgButton(
        name: 'svg/arrow-right-bold-outline-grey.svg',
        position: Vector2(rightButtonX, 380),
        size: buttonSize,
        onTap: () => handleKey(LogicalKeyboardKey.arrowRight),
      ),
      SvgButton(
        name: 'svg/arrow-down-bold-outline-grey.svg',
        position: Vector2(rightButtonX, 460),
        size: buttonSize,
        paint: BasicPalette.white.paint(),
        onTap: () => handleKey(LogicalKeyboardKey.arrowDown),
      ),
      _textComponent!,
    ]);
    super.onGameResize(size);
  }

  void updatePoints(double? freezedAtY) {
    if (_droppedAtY != null && freezedAtY != null) {
      final deltaY = (freezedAtY - _droppedAtY!) / 25;
      _freezedCounter += deltaY.toInt();
      _droppedAtY = null;
    }
    _freezedCounter++;
    final pointString = sprintf(
      '[YaTetris] %05i rows:%02i',
      [_freezedCounter + _removedRows * 100, _removedRows],
    );
    _textComponent?.text = pointString;
//    print(pointString);
  }

  void reset() {
    game.isGameRunning = false;
    final allBlocks = world.children.query<TetrisPlayBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
    final allQuads = world.children.query<Quadrat>();
    allQuads.forEach((element) => element.removeFromParent());
    _removedRows = 0;
    _droppedAtY = null;
    _textComponent?.text = 'Tap down arrow to start';
    _freezedCounter = 0;
    _currentFallingBlock = null;
  }

  bool _checkResetOrGameStart(LogicalKeyboardKey logicalKey) {
    if (logicalKey == LogicalKeyboardKey.escape) {
      reset();
      return true;
    }
    if (!game.isGameRunning) {
      game.isGameRunning = true;
      addRandomBlock();
      updatePoints(null);
      return true;
    }
    return false;
  }

  void handleKey(LogicalKeyboardKey logicalKey) {
    if (_checkResetOrGameStart(logicalKey)) {
      return;
    }
    if (_currentFallingBlock == null) {
      return;
    }
    if (logicalKey == LogicalKeyboardKey.arrowLeft) {
      _currentFallingBlock!.moveXBy(-50);
    } else if (logicalKey == LogicalKeyboardKey.arrowRight) {
      _currentFallingBlock!.moveXBy(50);
    } else if (logicalKey == LogicalKeyboardKey.arrowUp) {
      _currentFallingBlock?.rotateBy(-pi / 2);
    } else if (logicalKey == LogicalKeyboardKey.arrowDown) {
      _currentFallingBlock?.setHighSpeed();
      _droppedAtY = _currentFallingBlock?.y;
    } else if (logicalKey == LogicalKeyboardKey.keyR) {
      _currentFallingBlock?.rotateBy(pi / 2);
    }
  }

  @override
  void onKeyboardKey(
    RawKeyEvent event,
  ) {
    if (_checkResetOrGameStart(event.logicalKey)) {
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyO) {
      _currentFallingBlock =
          TetrisPlayBlock.create('O', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      _currentFallingBlock =
          TetrisPlayBlock.create('J', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      _currentFallingBlock =
          TetrisPlayBlock.create('I', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyT) {
      _currentFallingBlock =
          TetrisPlayBlock.create('T', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      _currentFallingBlock =
          TetrisPlayBlock.create('S', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      _currentFallingBlock =
          TetrisPlayBlock.create('L', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _currentFallingBlock =
          TetrisPlayBlock.create('Z', defaultStartPosition, world);
      world.add(_currentFallingBlock!);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyR) {
      game.isGameRunning = true;
      updatePoints(null);
      addRandomBlock();
    }
    if (event.logicalKey == LogicalKeyboardKey.question) {
      final matrix = creatBlockMatrix();
      print(matrix);
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
      _droppedAtY = _currentFallingBlock?.y;
    }
  }

  void handleBlockFreezed() {
    updatePoints(_currentFallingBlock?.y);
    // final matrix = creatBlockMatrix();
    // print(matrix);
    removeFullRows();
    if (!game.isGameRunning) {
      print('>>> GAME OVER <<<');
      gameRef.router.pushNamed('gameOver');
      return;
    }
    // if (_currentFallingBlock != null && _currentFallingBlock!.y < 75) {
    //   return;
    // }
    addRandomBlock();
  }

  Future<void> removeFullRows() async {
    int removedRows = 0;
    final rowFillingMap = createRowFillCounts();
    rowFillingMap.removeWhere((key, value) => value < 10);
    final yOfRows = rowFillingMap.keys;
    print('yOfRows: ${yOfRows}');
    for (final y in yOfRows) {
      final yAfterDropping = y + removedRows * 50;
      removeRow(yAfterDropping.toDouble());
      var yAboveRemovedRow = yAfterDropping.toDouble() - 50;
      await Future<void>.delayed(const Duration(milliseconds: 300));
      moveRowsAbove(yAboveRemovedRow);
      do {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        moveRowsAbove(yAboveRemovedRow);
        yAboveRemovedRow -= 50;
      } while (yAboveRemovedRow > 125.0);
      removedRows++;
    }
  }

  void moveRowsAbove(double y) {
//    print('moveRowsAbove $y');
    for (var x = 25.0; x < 500.0; x += 50.0) {
      final point = Vector2(xOffset + x, y);
      final quad = world.children
          .query<Quadrat>()
          .where((quad) => quad.containsPoint(point))
          .firstOrNull;
      if (quad != null) {
        quad.dropOneRow();
      }
    }
  }

  void removeRow(double y) {
    print('removeRow $y');
    _removedRows++;
    updatePoints(null);
    for (var x = 25.0; x < 500.0; x += 50.0) {
      final point = Vector2(xOffset + x, y);
      final quad = world.children
          .query<Quadrat>()
          .where((block) => block.containsPoint(point))
          .firstOrNull;
      if (quad != null) {
        quad.removeFromParent();
      }
    }
  }

  void addRandomBlock({Vector2? startPosition}) {
//    print('addRandomBlock');
    _currentFallingBlock =
        TetrisPlayBlock.random(startPosition ?? defaultStartPosition, world);
    world.add(_currentFallingBlock!);
  }

  Map<int, int> createRowFillCounts() {
    final rowFillingMap = <int, int>{};
    for (var y = lowestY; y > 75; y -= 50) {
      var fillCount = 0;
      for (var x = 25.0; x < 500.0; x += 50.0) {
        final point = Vector2(xOffset + x, y.toDouble());
        final quad = world.children
            .query<Quadrat>()
            .where((quad) => quad.containsPoint(point))
            .firstOrNull;
        if ((quad != null) && quad.state != QuadState.hidden) {
          fillCount++;
        }
      }
      rowFillingMap[y] = fillCount;
    }
    return rowFillingMap;
  }

  TetrisMatrix creatBlockMatrix() {
    final matrix = TetrisMatrix();
    for (var i = matrix.rows - 1; i >= 0; i--) {
      final y = 125.0 + i * 50;
      for (var j = 0; j < matrix.cols; j++) {
        final x = 25.0 + j * 50;
        final point = Vector2(xOffset + x, y);
        final quad = world.children
            .query<Quadrat>()
            .where((quad) => quad.containsPoint(point))
            .firstOrNull;

        if ((quad != null)) {
          matrix.add(i, j, quad.state.value);
        }
      }
    }
    return matrix;
  }
}
