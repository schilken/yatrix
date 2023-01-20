import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import '../../components/background.dart';
import '../../helpers/custom_theme.dart';
import '../../tetris_game.dart';

class SplashScreen extends Component with TapCallbacks, HasGameRef<TetrisGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      Background(paint: BasicPalette.black.paint()),
      TextBoxComponent(
        text: '[YaTriX]',
        textRenderer: TextPaint(
          style: CustomTheme.darkTheme.textTheme.headline4,
        ),
        align: Anchor.center,
        size: gameRef.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => gameRef.router.pushNamed('home');
}
