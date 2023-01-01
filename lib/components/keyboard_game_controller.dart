import 'dart:async';

import 'package:flutter/services.dart';

abstract class TetrisPageInterface {
  void handleBlockFreezed();
}

enum GameCommand {
  left,
  right,
  up,
  down,
  reset,
  pause,
  O,
  L,
  J,
  S,
  Z,
  T,
  I,
}

abstract class GameController {
  Stream<GameCommand> get commandStream;
}

class KeyboardGameController implements GameController {
  final _controller = StreamController<GameCommand>();

  void onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _controller.sink.add(GameCommand.reset);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _controller.sink.add(GameCommand.left);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _controller.sink.add(GameCommand.right);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _controller.sink.add(GameCommand.up);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _controller.sink.add(GameCommand.down);
    } else if (event.logicalKey == LogicalKeyboardKey.keyO) {
      _controller.sink.add(GameCommand.O);
    } else if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      _controller.sink.add(GameCommand.J);
    } else if (event.logicalKey == LogicalKeyboardKey.keyI) {
      _controller.sink.add(GameCommand.I);
    } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
      _controller.sink.add(GameCommand.T);
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      _controller.sink.add(GameCommand.S);
    } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
      _controller.sink.add(GameCommand.L);
    } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _controller.sink.add(GameCommand.Z);
    }
  }

  @override
  Stream<GameCommand> get commandStream =>
      _controller.stream.asBroadcastStream();

  // TODO: close streamController
}