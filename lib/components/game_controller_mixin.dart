import 'dart:math';
import 'package:tetris/components/tetris_play_block.dart';

import '../tetris_game.dart';
import 'keyboard_game_controller.dart';

mixin GameControllerMixin {
  TetrisBaseBlock? get currentFallingBlock;
  TetrisGame get game;
  void reset();
  void addRandomBlock();
  void updatePoints(double? freezedAtY);
  void addBlock(String name);
  set droppedAtY(double y);

  void initGameControllers(List<GameController> gameControllers) {
    gameControllers.forEach((controller) {
      controller.commandStream.listen(handleGameCommand);
    });
  }

  void handleGameCommand(GameCommand command) {
    print('gameCommand: $command');
    if (command == GameCommand.reset) {
      reset();
      return;
    }
    if (!game.isGameRunning) {
      game.isGameRunning = true;
      addRandomBlock();
      updatePoints(null);
      return;
    }
    if (currentFallingBlock == null) {
      return;
    }
    if (command == GameCommand.left) {
      currentFallingBlock!.moveXBy(-50);
    } else if (command == GameCommand.right) {
      currentFallingBlock!.moveXBy(50);
    } else if (command == GameCommand.up) {
      currentFallingBlock?.rotateBy(-pi / 2);
    } else if (command == GameCommand.rotateClockwise) {
      currentFallingBlock?.rotateBy(pi / 2);
    } else if (command == GameCommand.down) {
      currentFallingBlock?.setHighSpeed();
      droppedAtY = currentFallingBlock!.y;
    } else if (command == GameCommand.O) {
      addBlock('O');
    } else if (command == GameCommand.J) {
      addBlock('J');
    } else if (command == GameCommand.I) {
      addBlock('I');
    } else if (command == GameCommand.T) {
      addBlock('T');
    } else if (command == GameCommand.S) {
      addBlock('S');
    } else if (command == GameCommand.L) {
      addBlock('L');
    } else if (command == GameCommand.Z) {
      addBlock('Z');
    }
  }
}
