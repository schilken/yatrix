import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris/tetris_game.dart';

import 'game_page.dart';

String link(String example) =>
    'https://github.com/flame-engine/flame_forge2d/tree/main/example/lib/$example';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: SafeArea(
          child: Builder(builder: (context) {
            return GamePage(
                game: TetrisGame(
            ));
          }),
        ),
      ),
  );
}
