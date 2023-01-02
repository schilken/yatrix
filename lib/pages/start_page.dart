import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

import '../components/rounded_button.dart';

class StartPage extends Component with HasGameRef<TetrisGame> {
  late final TextComponent _logo;
  late final RoundedButton _playButton;
  late final RoundedButton _constructButton;
  late final RoundedButton _settingsButton;
  late final RoundedButton _highScoreButton;
//  late final RoundedButton _helpButton;

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
      _playButton = RoundedButton(
        text: 'Play',
        action: () => gameRef.router.pushNamed('play'),
        color: const Color(0xffadde6c),
        borderColor: const Color(0xfffff4c7),
        size: Vector2(150, 40),
      ),
      _constructButton = RoundedButton(
        text: 'Construct',
        action: () => gameRef.router.pushNamed('construct'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xffedffab),
        size: Vector2(150, 40),
      ),
      _settingsButton = RoundedButton(
        text: 'Settings',
        action: () => gameRef.router.pushNamed('settings'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
        size: Vector2(150, 40),
      ),
      _highScoreButton = RoundedButton(
        text: 'High Score',
        action: () => gameRef.router.pushNamed('highScore'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
        size: Vector2(150, 40),
      ),
      // _helpButton = RoundedButton(
      //   text: 'Help',
      //   action: () => gameRef.router.pushNamed('help'),
      //   color: const Color(0xffdebe6c),
      //   borderColor: const Color(0xfffff4c7),
      // ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _playButton.position = Vector2(size.x / 2, _logo.y + 80);
    _constructButton.position = Vector2(size.x / 2, _logo.y + 140);
    _highScoreButton.position = Vector2(size.x / 2, _logo.y + 200);
    _settingsButton.position = Vector2(size.x / 2, _logo.y + 260);
//    _helpButton.position = Vector2(size.x / 2, _logo.y + 320);
  }
}
