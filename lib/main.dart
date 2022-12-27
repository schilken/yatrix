import 'package:flutter/material.dart';
import 'package:tetris/tetris_game.dart';
import 'pages/game_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: SafeArea(
          child: Builder(builder: (context) {
            return GamePage(
                game: TetrisGame(
            ),
            );
          },
        ),
        ),
      ),
  );
}
