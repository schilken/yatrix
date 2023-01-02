import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:tetris/tetris_game.dart';

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

  GameOverPage() {
    print('GameOverPage.constructor');
  }

  @override
  Future<void> onLoad() async {
    print('GameOverPage.onLoad');
    addAll([
      TextComponent(
        text: 'GAME OVER!',
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
        text: game.score,
        position: game.canvasSize / 2 + Vector2(0, 70),
        anchor: Anchor.center,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pop();
}
