import 'dart:async';
import 'package:flame/components.dart';
import 'keyboard_game_controller.dart';
import 'svg_button.dart';

class ThreeButtonsGameController extends PositionComponent
    implements GameController {
  ThreeButtonsGameController({
    super.position,
    required this.buttonSize,
  });

  final Vector2 buttonSize;
  final _controller = StreamController<GameCommand>.broadcast();

  @override
  Future<void> onLoad() async {
    addAll([
      // SvgButton(
      //   name: 'svg/help.svg',
      //   position: Vector2(-35 - 10, 0),
      //   size: buttonSize,
      //   onTap: () => _controller.sink.add(GameCommand.help),
      // ),
      // SvgButton(
      //   name: 'svg/cog-outline.svg',
      //   position: Vector2(0, 0),
      //   size: buttonSize,
      //   onTap: () => _controller.sink.add(GameCommand.settings),
      // ),
      SvgButton(
        name: 'svg/restart-grey.svg',
        position: Vector2(35 + 10, 0),
        size: buttonSize,
        onTap: () => _controller.sink.add(GameCommand.reset),
      ),
    ]);
  }

  @override
  Stream<GameCommand> get commandStream => _controller.stream;

  // TODO(as): close streamController
}
