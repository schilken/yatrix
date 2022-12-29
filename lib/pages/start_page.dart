import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

import '../components/rounded_button.dart';

class StartPage extends Component with HasGameRef<TetrisGame> {
  late final TextComponent _logo;
  late final RoundedButton _button1;
  late final RoundedButton _button2;
  late final RoundedButton _button3;
  late final RoundedButton _button4;

  StartPage() {
    addAll([
      _logo = TextComponent(
        text: 'YaTetris',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
        anchor: Anchor.center,
      ),
      _button1 = RoundedButton(
        text: 'Construct',
        action: () => gameRef.router.pushNamed('level1'),
        color: const Color(0xffadde6c),
        borderColor: const Color(0xffedffab),
      ),
      _button2 = RoundedButton(
        text: 'Play',
        action: () => gameRef.router.pushNamed('level2'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
      _button3 = RoundedButton(
        text: 'High Score',
        action: () => gameRef.router.pushNamed('highScore'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
      _button4 = RoundedButton(
        text: 'Help',
        action: () => gameRef.router.pushNamed('help'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _button2.position = Vector2(size.x / 2, _logo.y + 140);
    _button3.position = Vector2(size.x / 2, _logo.y + 200);
    _button4.position = Vector2(size.x / 2, _logo.y + 260);
  }
}
