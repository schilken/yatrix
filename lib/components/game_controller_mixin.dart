// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:math';

import 'keyboard_game_controller.dart';
import 'tetris_play_block.dart';

mixin GameControllerMixin {
  TetrisBaseBlock? get currentFallingBlock;
  void reset();
  bool startGameIfNotRunning();
  void addRandomBlock();
  void updatePoints(double? freezedAtY);
  void addBlock(String name);
  set droppedAtY(double y);
  void debugAction();
  List<StreamSubscription> subscriptions = [];

  void initGameControllers(List<GameController> gameControllers) {
    gameControllers.forEach((controller) {
      subscriptions.add(
        controller.commandStream.listen(handleGameCommand),
      );
    });
  }

  void closeGameControllers() {
    subscriptions.forEach((subscription) => subscription.cancel());
  }

  void handleGameCommand(GameCommand command) {
    print('gameCommand: $command');
    if (command == GameCommand.reset) {
      reset();
      return;
    }
    // if (command == GameCommand.help) {
    //   showHelp();
    //   return;
    // }
    // if (command == GameCommand.settings) {
    //   showSettings();
    //   return;
    // }
    if (startGameIfNotRunning()) {
      return;
    }
    if (command == GameCommand.random) {
      addRandomBlock();
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
    } else if (command == GameCommand.debug) {
      debugAction();
    } 
  }
}
