import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide BackButton;

import '../../components/background.dart';
import '../../components/simple_button_component.dart';
import '../../helpers/custom_theme.dart';
import '../../tetris_game.dart';

class CreditsPage extends Component with HasGameRef<TetrisGame> {
  late final TextComponent _title;
  late final TextBoxComponent _textBox;

  CreditsPage() {
    addAll([
      _title = TextBoxComponent(
        text: 'Credits',
        textRenderer: TextPaint(
          style: CustomTheme.darkTheme.textTheme.headline4,
        ),
      ),
      _textBox = TextBoxComponent(
        text: 'This game is created with Flutter and Flame-Engine.\n\n'
            'The Background Music is from\nhttps://www.zapsplat.com.\n\n'
            'The Icons are taken from\n'
            'https://materialdesignicons.com\n\n'
            'These packages are used: \n'
            '- flame\n'
            '- flame_svg\n'
            '- flame_audio\n'
            '- hooks_riverpod\n'
            '- flutter_markdown\n'
            '- shared_preferences\n'
            '- peerdart\n'
            '- flutter_webrtc\n'
            '- bot_toast\n'
            '- pubspec_parse\n'
            '- bot_toast\n'
            '- share_plus\n'
            '- mocktail\n',
        textRenderer: _vintageGreen,
        boxConfig: TextBoxConfig(
          timePerChar: 0.05,
          growingBox: true,
        ),
        size: Vector2(350, 600),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    var yPosition = 60.0;
    _title.position = Vector2(12, yPosition);
    _textBox.position = Vector2(12, yPosition += 50);
  }

  @override
  Future<void> onLoad() async {
    addAll([
      Background(paint: BasicPalette.black.paint()),
      BackButtonComponent(onTapped: gameRef.router.pop),
    ]);
  }
}

final _regular = TextPaint(style: CustomTheme.darkTheme.textTheme.headline6);
final _vintageGreen = _regular.copyWith(
  (style) => style.copyWith(
    color: Colors.lightGreenAccent,
    fontFamily: 'monospace',
    letterSpacing: 1.2,
  ),
);
