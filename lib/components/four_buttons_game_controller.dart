import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'keyboard_game_controller.dart';
import 'svg_button.dart';

class FourButtonsGameController extends PositionComponent
    implements GameController {
  FourButtonsGameController({
    super.position,
    required this.buttonSize,
  });

  final Vector2 buttonSize;
  final _controller = StreamController<GameCommand>.broadcast();

  @override
  Future<void> onLoad() async {
    print('FourButtonsGameController.onLoad');
    addAll([
      SvgButton(
        name: 'svg/rotate-left-variant-grey.svg',
        position: Vector2(0, -35),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.up),
      ),
      SvgButton(
        name: 'svg/arrow-left-bold-outline-grey.svg',
        position: Vector2(-35, 0),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.left),
      ),
      SvgButton(
        name: 'svg/arrow-right-bold-outline-grey.svg',
        position: Vector2(35, 0),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.right),
      ),
      SvgButton(
        name: 'svg/arrow-down-bold-outline-grey.svg',
        position: Vector2(0, 35),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.down),
      ),
    ]);
  }

  void onButtonEvent(
    RawKeyEvent event,
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
  Stream<GameCommand> get commandStream => _controller.stream;

  // TODO: close streamController
}
