import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris/tetris_game.dart';

import 'game_page.dart';

class GamePage extends StatelessWidget {
  GamePage({Key? key, required this.game}) : super(key: key);

  final TetrisGame game;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: TetrisGame(
      ),
      loadingBuilder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
