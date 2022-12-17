import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

import 'background.dart';

class SplashScreen extends Component with TapCallbacks, HasGameRef<TetrisGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      Background(const Color(0xff282828)),
      TextBoxComponent(
        text: '[YaTetris]',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0x66ffffff),
            fontSize: 16,
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

