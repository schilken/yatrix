import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris/the_game.dart';

import 'game_page.dart';

class GamePage extends StatelessWidget {
  GamePage({Key? key, required this.game}) : super(key: key);

  final TheGame game;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: TheGame(
      ),
      loadingBuilder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
