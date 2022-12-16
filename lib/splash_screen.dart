import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart' show runApp;
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

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

class Background extends Component {
  Background(this.color);
  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}
