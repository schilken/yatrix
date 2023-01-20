import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

import '../../components/rounded_button.dart';
import '../../tetris_game.dart';

class GameOverRoute extends Route {
  GameOverRoute()
      : super(
          GameOverPage.new,
          transparent: true,
          maintainState: false,
        );

  @override
  void onPush(Route? previousRoute) {
    previousRoute!
      ..stopTime()
      ..addRenderEffect(
        PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
      );
  }

  @override
  void onPop(Route previousRoute) {
    previousRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}

class GameOverPage extends Component with TapCallbacks, HasGameRef<TetrisGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      TextComponent(
        text: game.gameEndString,
        position: game.canvasSize / 2,
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            Vector2.all(1.2),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          )
        ],
      ),
      TextComponent(
        text: 'Points: ${game.points}\nRows: ${game.rows}',
        position: game.canvasSize / 2 + Vector2(0, 70),
        anchor: Anchor.center,
      ),
      RoundedButton(
        text: 'Add to High Score',
        action: () => gameRef.router.pushNamed('highScore'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
        size: Vector2(220, 40),
      )..position = game.canvasSize / 2 + Vector2(0, 70 + 70 + 30),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    game.router.pop();
    game.router.pop();
  }
}
