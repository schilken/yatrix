import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'keyboard_game_controller.dart';
import 'svg_button.dart';
import 'package:flame_svg/flame_svg.dart';

class FiveButtonsGameController extends PositionComponent
    with Draggable
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
      Dragger(
        position: Vector2(0, -buttonSize.y / 2 - 5),
        size: buttonSize,
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

@override
  bool onDragUpdate(DragUpdateInfo info) {
    position.add(info.delta.game);
    return false;
  }

  // TODO: close streamController
}


class Dragger extends SvgComponent {
  Dragger({required super.position, required super.size})
      : super(
          priority: 2,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void>? onLoad() async {
    svg = await Svg.load('svg/drag-grey.svg');
    await super.onLoad();
  }
}
