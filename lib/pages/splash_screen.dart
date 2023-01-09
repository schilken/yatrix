import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import '../tetris_game.dart';

import '../components/background.dart';

class SplashScreen extends Component with TapCallbacks, HasGameRef<TetrisGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      Background(paint: BasicPalette.black.paint()),
      TextBoxComponent(
        text: '[YaTrix]',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0x66ffffff),
            fontSize: 32,
          ),
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
