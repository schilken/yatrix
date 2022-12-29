import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

import '../components/background.dart';
import '../components/buttons.dart';

class HighScorePage extends Component with HasGameRef<TetrisGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      Background(paint: BasicPalette.black.paint()),
      BackButton(),
      TextBoxComponent(
        text: 'High Score',
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
}
