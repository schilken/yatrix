import 'dart:async';

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
import '../components/five_buttons_game_controller.dart';
import '../components/game_controller_mixin.dart';
import '../components/keyboard_game_controller.dart';
import '../components/quadrat.dart';
import '../components/svg_button.dart';
import '../components/tetris_play_block.dart';
import '../components/three_buttons_game_controller.dart';
import '../tetris_game.dart';
import '../tetris_matrix.dart';

class TetrisPlayPage extends Component
    with HasGameRef<TetrisGame>, GameControllerMixin
    implements TetrisPageInterface {
  late final World world;
  late final CameraComponent cameraComponent;
  late final Viewfinder viewfinder;
  late final Viewport viewport;
  Vector2 get visibleGameSize => viewfinder.visibleGameSize!;

  late final RouterComponent router;

  final defaultStartPosition = Vector2(250, 70);
  final xOffset = 50;
  TextComponent? _textComponent;
  int _freezedCounter = 0;
  int _removedRows = 0;
  static const lowestY = 1075;

  FiveButtonsGameController? fiveButtons;
  ThreeButtonsGameController? threeButtons;

  TetrisBaseBlock? _currentFallingBlock;
  @override
  TetrisBaseBlock? get currentFallingBlock => _currentFallingBlock;

  double? _droppedAtY;
  @override
  set droppedAtY(double y) => _droppedAtY = y;

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

    world.add(Floor(size: Vector2(600, 10), position: Vector2(0, 1070)));
    world.add(Side(size: Vector2(10, 1050), position: Vector2(40, 50)));
    world.add(Side(size: Vector2(10, 1050), position: Vector2(550, 50)));
    initGameControllers([
      game.keyboardGameController!,
      fiveButtons!,
      threeButtons!,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
//    print('TetrisPlayPage.size: ${size}');
    const buttonGapX = 10.0;
    final allsvgButtons = children.query<SvgButton>();
    allsvgButtons.forEach((button) => button.removeFromParent());
    _textComponent?.removeFromParent();
    _textComponent = TextBoxComponent(
      text: 'Tap down arrow to start',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0x66ffffff),
          fontSize: 20,
        ),
      ),
      position: Vector2(30, size.y - 2 * 35 - buttonGapX),
      size: gameRef.canvasSize,
    );
    add(_textComponent!);
    if (fiveButtons == null) {
      fiveButtons = FiveButtonsGameController(
        buttonSize: Vector2.all(35),
      );
      add(fiveButtons!);
    }
    fiveButtons?.position =
        Vector2(size.x - 2 * 35 - buttonGapX, size.y - 2 * 35 - buttonGapX);
    if (threeButtons == null) {
      threeButtons = ThreeButtonsGameController(
        buttonSize: Vector2.all(35),
      );
      add(threeButtons!);
    }
    threeButtons?.position =
        Vector2(size.x - 2 * 35 - 2 * buttonGapX, buttonGapX);
    super.onGameResize(size);
  }

  @override
  void updatePoints(double? freezedAtY) {
    if (_droppedAtY != null && freezedAtY != null) {
      final deltaY = (freezedAtY - _droppedAtY!) / 25;
      _freezedCounter += deltaY.toInt();
      _droppedAtY = null;
    }
    _freezedCounter++;
    final pointString = sprintf(
      'Points: %06i\nRows:%03i',
      [_freezedCounter + _removedRows * 100, _removedRows],
    );
    _textComponent?.text = pointString;
    game.score = sprintf('Points: %06i\nRows:%03i',
        [_freezedCounter + _removedRows * 100, _removedRows]);
//    print(pointString);
  }

  @override
  void reset() {
    game.isGameRunning = false;
    final allBlocks = world.children.query<TetrisBaseBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
    final allQuads = world.children.query<Quadrat>();
    allQuads.forEach((element) => element.removeFromParent());
    _removedRows = 0;
    _droppedAtY = null;
    _textComponent?.text = 'Tap down arrow to start';
    _freezedCounter = 0;
    _currentFallingBlock = null;
  }

  @override
  bool startGameIfNotRunning() {
    if (!game.isGameRunning) {
      game.isGameRunning = true;
      addRandomBlock();
      updatePoints(null);
      return true;
    }
    return false;
  }

  @override
  void showHelp() {}

  @override
  void showSettings() {}

  @override
  void addBlock(String name) {
    _currentFallingBlock = TetrisBaseBlock.create(
      name,
      defaultStartPosition,
      world,
    );
    world.add(_currentFallingBlock!);
  }

  @override
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
    var removedRows = 0;
    final rowFillingMap = createRowFillCounts();
    rowFillingMap.removeWhere((key, value) => value < 10);
    final yOfRows = rowFillingMap.keys;
//    print('yOfRows: ${yOfRows}');
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

  @override
  void addRandomBlock({Vector2? startPosition}) {
//    print('addRandomBlock');
    _currentFallingBlock =
        TetrisBaseBlock.random(startPosition ?? defaultStartPosition, world);
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

        if (quad != null) {
          matrix.add(i, j, quad.state.value);
        }
      }
    }
    return matrix;
  }
}
