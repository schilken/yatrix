import 'dart:async';
import 'package:flame/components.dart';
import 'keyboard_game_controller.dart';
import 'svg_button.dart';

class FiveButtonsGameController extends PositionComponent
    implements GameController {
  FiveButtonsGameController({
    super.position,
    required this.buttonSize,
  });

  final Vector2 buttonSize;
  late StreamController<GameCommand> _controller;

  @override
  Future<void> onLoad() async {
    priority = 200;
    _controller = StreamController<GameCommand>.broadcast();
    addAll([
      SvgButton(
        name: 'svg/rotate-left-variant-grey.svg',
        position: Vector2(-buttonSize.x - 10, -buttonSize.y / 2 - 5),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.up),
      ),
      SvgButton(
        name: 'svg/rotate-right-variant-grey.svg',
        position: Vector2(buttonSize.x + 10, -buttonSize.y / 2 - 5),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.rotateClockwise),
      ),
      SvgButton(
        name: 'svg/arrow-left-bold-outline-grey.svg',
        position: Vector2(-buttonSize.x - 10, buttonSize.y / 2 + 5),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.left),
      ),
      SvgButton(
        name: 'svg/arrow-right-bold-outline-grey.svg',
        position: Vector2(buttonSize.x + 10, buttonSize.y / 2 + 5),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.right),
      ),
      SvgButton(
        name: 'svg/arrow-down-bold-outline-grey.svg',
        position: Vector2(0, buttonSize.y / 2 + 5),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.down),
      ),
    ]);
  }

  @override
  Stream<GameCommand> get commandStream => _controller.stream;

  // TODO: close streamController
}
