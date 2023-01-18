import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flutter/painting.dart';
import 'package:sprintf/sprintf.dart';
import 'package:yatrix/game_assets.dart';

import '../components/boundaries.dart';
import '../components/buttons.dart';
import '../components/five_buttons_game_controller.dart';
import '../components/game_controller_mixin.dart';
import '../components/keyboard_game_controller.dart';
import '../components/quadrat.dart';
import '../components/svg_button.dart';
import '../components/tetris_play_block.dart';
import '../components/three_buttons_game_controller.dart';
import '../custom_theme.dart';
import '../tetris_game.dart';
import '../tetris_matrix.dart';

enum Direction {
  up,
  down,
}

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
  static const bottomRowY = 1025;
  final _random = Random();

  FiveButtonsGameController? fiveButtons;
  ThreeButtonsGameController? threeButtons;
  SvgButton? _twoPlayerActive;

  TetrisBaseBlock? _currentFallingBlock;
  @override
  TetrisBaseBlock? get currentFallingBlock => _currentFallingBlock;

  double? _droppedAtY;
  @override
  set droppedAtY(double y) {
    game.playSoundEffect(SoundEffects.droppingBlock);
    _droppedAtY = y;
  }

  @override
  Future<void> onLoad() async {
    print('TetrisPlayPage.onLoad');
    addAll([
      BackButton(onTapped: onBackButton),
      PauseButton(onTapped: () => gameRef.router.pushNamed('pause')),
      if (game.showFps)
        FpsTextComponent(
          position: Vector2(10, 70),
          anchor: Anchor.topLeft,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Color(0x66ffffff),
              fontSize: 14,
            ),
          ),
        ),
    ]);
    //debugMode = true;
    world = World();
    children.register<Quadrat>();
    cameraComponent = CameraComponent(world: world);
    viewport = cameraComponent.viewport;
    viewfinder = cameraComponent.viewfinder;

    await addAll([world, cameraComponent]);
    children.register<World>();
    viewfinder.anchor = Anchor.topCenter;
    viewfinder.position = Vector2(300, 0);
    viewfinder.visibleGameSize = Vector2(600, 1224);

    world.add(Floor(size: Vector2(520, 10), position: Vector2(40, 1050)));
    world.add(Side(size: Vector2(10, 950), position: Vector2(40, 100)));
    world.add(Side(size: Vector2(10, 950), position: Vector2(550, 100)));
    initGameControllers([
      game.keyboardGameController!,
      fiveButtons!,
      threeButtons!,
    ]);
  }

  @override
  Future<void> onRemove() async {
    closeGameControllers();
    super.onRemove();
  }

  void onBackButton() async {
    await reset();
    gameRef.router.pop();
  }

  @override
  void onGameResize(Vector2 size) {
    print('TetrisPlayPage size: $size');
    const buttonGapX = 10.0;
    final allsvgButtons = children.query<SvgButton>();
    allsvgButtons.forEach((button) => button.removeFromParent());
    _textComponent?.removeFromParent();
    _textComponent = TextBoxComponent(
      text: 'Tap button to start ->',
      textRenderer: TextPaint(
        style: CustomTheme.darkTheme.textTheme.headline6,
      ),
      position: Vector2(20, size.y - 2 * 35 - buttonGapX),
      size: gameRef.canvasSize,
    );
    add(_textComponent!);
    final fiveButtonSize = (size.x < 600) ? Vector2.all(35) : Vector2.all(70);
    if (fiveButtons == null) {
      fiveButtons = FiveButtonsGameController(
        buttonSize: fiveButtonSize,
      );
      add(fiveButtons!);
    }
    fiveButtons?.position = Vector2(
      size.x - 2 * fiveButtonSize.x - 2 * buttonGapX,
      size.y - 2 * fiveButtonSize.y + buttonGapX,
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

    if (_twoPlayerActive == null) {
      _twoPlayerActive = SvgButton(
        name: 'svg/cloud-arrow-right-outline-green.svg',
        position: Vector2(size.x / 2, -100),
        onTap: () {},
      );
//      _twoPlayerActive?.opacity = 0.0;
      add(_twoPlayerActive!);
    }
    _twoPlayerActive?.position = Vector2(size.x / 2, buttonGapX);
    _twoPlayerActive?.size = fiveButtonSize;
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
    game.setScoreValues(
        points: _freezedCounter + _removedRows * 100, rows: _removedRows);
  }

  @override
  Future<void> reset() async {
//    print('TetrisPlayPage.reset');
    game.isGameRunning = false;
    final allBlocks = world.children.query<TetrisBaseBlock>();
    allBlocks.forEach((element) => element.removeFromParent());
    final allQuads = world.children.query<Quadrat>();
    await removeQuads(allQuads, delay: 10);
    _removedRows = 0;
    _droppedAtY = null;
    _textComponent?.text = 'Tap button to start ->';
    _freezedCounter = 0;
    _currentFallingBlock = null;
    game.backgroundMusicStop();
  }

  @override
  bool startGameIfNotRunning() {
    if (!game.isGameRunning) {
      _twoPlayerActive?.opacity = game.isTwoPlayerGame ? 1.0 : 0.0;
      game.startNewGame();
      addRandomBlock();
      updatePoints(null);
      return true;
    }
    return false;
  }

  // @override
  // void showHelp() {}

  // @override
  // void showSettings() {}

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
    if (_currentFallingBlock != null && _currentFallingBlock!.y < 75) {
      game.topIsReached();
      return;
    }
    game.playSoundEffect(SoundEffects.freezedBlock);
    // final matrix = creatBlockMatrix();
    // print(matrix);
    removeFullRows();
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
      await removeRow(yAfterDropping.toDouble());
      var yAboveRemovedRow = yAfterDropping.toDouble() - 50;
      await Future<void>.delayed(const Duration(milliseconds: 200));
      moveRow(yAboveRemovedRow, Direction.down);
      do {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        moveRow(yAboveRemovedRow, Direction.down);
        yAboveRemovedRow -= 50;
      } while (yAboveRemovedRow > 125.0);
      removedRows++;
    }
  }

  @override
  Future<void> handlePeerCommand(String command) async {
    final slotIndex = int.parse(command[2]);
    await insertEmptyRow();
    insertRow(emptySlot: slotIndex);
  }

  @override
  Future<void> debugAction() async {
    await insertEmptyRow();
    insertRow(emptySlot: _random.nextInt(11));
  }

  Future<void> insertRow({required int emptySlot}) async {
    for (var ix = 0; ix < 10; ix++) {
      if (ix == emptySlot) {
        continue;
      }
      final position =
          Vector2(xOffset + ix * 50, bottomRowY.toDouble() - 25 + quadPadding);
      final randomBlockName = gameAssets.allBlockNames[_random.nextInt(7)];
      final quad = Quadrat(
        position: position,
        collisionCallback: (_) {},
        blockType: randomBlockName,
      );
      await world.add(quad);
      quad.freeze();
    }
  }

  Future<void> insertEmptyRow() async {
    var yAboveInsertedRow = 175.0;
    do {
      await Future<void>.delayed(const Duration(milliseconds: 50));
//      print('insertEmptyRow $yAboveInsertedRow');
      moveRow(yAboveInsertedRow, Direction.up);
      yAboveInsertedRow += 50;
    } while (yAboveInsertedRow < 1075.0);
  }

  void moveRow(
    double y,
    Direction upDown,
  ) {
//    print('moveRowsAbove $y');
    for (var x = 25.0; x < 500.0; x += 50.0) {
      final point = Vector2(xOffset + x, y);
      final quad = world.children
          .query<Quadrat>()
          .where((quad) => quad.containsPoint(point))
          .firstOrNull;
      if (quad != null) {
        if (upDown == Direction.down) {
          quad.moveOneStepDown();
        } else {
          quad.moveOneStepUp();
        }
      }
    }
  }

  List<Quadrat> findQuadsInRow(double y) {
    final quads = <Quadrat>[];
    for (var x = 25.0; x < 500.0; x += 50.0) {
      final point = Vector2(xOffset + x, y);
      final quad = world.children
          .query<Quadrat>()
          .where((block) => block.containsPoint(point))
          .firstOrNull;
      if (quad != null) {
        quads.add(quad);
      }
    }
    return quads;
  }

  Future<void> removeRow(double y) async {
//    print('removeRow $y');
    game.playSoundEffect(SoundEffects.removingFilledRow);
    _removedRows++;
    updatePoints(null);
    game.rowWasRemoved();
    await removeQuadsAnimated(findQuadsInRow(y));
  }

  Future<void> removeQuadsAnimated(List<Quadrat> quads,
      {int delay = 20}) async {
    for (final quad in quads) {
      quad.removeAnimated();
      await Future<void>.delayed(Duration(milliseconds: delay));
    }
  }

  Future<void> removeQuads(List<Quadrat> quads, {int delay = 20}) async {
    print('removeQuads: $quads');
    final clonedList = [...quads];
    for (final quad in clonedList) {
      world.remove(quad);
      await Future<void>.delayed(Duration(milliseconds: delay));
    }
  }

  @override
  void addRandomBlock({Vector2? startPosition}) {
    _currentFallingBlock =
        TetrisBaseBlock.random(startPosition ?? defaultStartPosition, world);
    world.add(_currentFallingBlock!);
  }

  Map<int, int> createRowFillCounts() {
    final rowFillingMap = <int, int>{};
    for (var y = bottomRowY; y > 75; y -= 50) {
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
