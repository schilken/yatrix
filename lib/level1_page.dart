import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart' show runApp;
import 'package:flutter/rendering.dart';
import 'package:tetris/tetris_game.dart';

import 'buttons.dart';
import 'rounded_button.dart';
import 'splash_screen.dart';

class Level1Page extends Component {
  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    addAll([
      Background(const Color(0xbb2a074f)),
      BackButton(),
      PauseButton(),
    ]);
  }
}
