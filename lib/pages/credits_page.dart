import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../tetris_game.dart';

import '../components/background.dart';
import '../components/buttons.dart';

class CreditsPage extends Component with HasGameRef<TetrisGame> {
  late final TextComponent _title;
  late final TextBoxComponent _textBox;

  CreditsPage() {
    addAll([
      _title = TextBoxComponent(
        text: 'Credits',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0x66ffffff),
            fontSize: 32,
          ),
        ),
      ),
      _textBox = TextBoxComponent(
        text: 'This game is created with Flutter and Flame-Engine.\n\n'
            'The Background Music is from\nhttps://www.zapsplat.com\n\n'
            'The Icons are taken from\n'
            'https://materialdesignicons.com\n\n'
            'These packages are used: \n'
            '- flutter_riverpod\n'
            '- shared_preferences\n'
            '- flame\n'
            '- flame_svg\n'
            '- flame_audio\n'
            '- sprintf\n',
        textRenderer: _box,
        boxConfig: TextBoxConfig(
          maxWidth: 400,
          timePerChar: 0.05,
          growingBox: true,
        ),
        size: Vector2(400, 400),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    var yPosition = size.y / 4;
    _title.position = Vector2(size.x / 2 - _title.size.x / 2, yPosition);
    _textBox.position = Vector2(size.x / 2 - 200, yPosition += 100);
  }

  @override
  Future<void> onLoad() async {
    addAll([
      Background(paint: BasicPalette.black.paint()),
      BackButton(),
    ]);
  }
}

final _regularTextStyle =
    TextStyle(fontSize: 18, color: BasicPalette.white.color);
final _regular = TextPaint(style: _regularTextStyle);
final _box = _regular.copyWith(
  (style) => style.copyWith(
    color: Colors.lightGreenAccent,
    fontFamily: 'monospace',
    letterSpacing: 2.0,
  ),
);

