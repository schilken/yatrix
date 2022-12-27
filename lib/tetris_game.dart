import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show TextStyle, Colors, KeyEventResult;
import 'package:flutter/services.dart';

import 'package:tetris/splash_screen.dart';

import 'game_over_route.dart';
import 'tetris_page.dart';
import 'pause_route.dart';
import 'start_page.dart';
import 'tetris_play_page.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

abstract class TetrisPageInterface {
  void handleBlockFreezed();
  void onKeyboardKey(
    RawKeyEvent event,
  );
}

class TetrisGame extends FlameGame
    with
        HasCollisionDetection,
        HasDraggables,
        HasTappableComponents,
        KeyboardEvents {
  TetrisGame();
  bool isGameRunning = false;
  late final RouterComponent router;
  TetrisPageInterface? tetrisPage;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    add(
      router = RouterComponent(
        routes: {
          'splash': Route(SplashScreen.new),
          'home': Route(StartPage.new),
          'level1': Route(() {
            final tetrisConstructPage = TetrisConstructPage();
            tetrisPage = tetrisConstructPage;
            return tetrisConstructPage;
          }),
          'level2': Route(() {
            final tetrisPlayPage = TetrisPlayPage();
            tetrisPage = tetrisPlayPage;
            return tetrisPlayPage;
          }),
          'pause': PauseRoute(),
          'gameOver': GameOverRoute(),
        },
        initialRoute: 'splash',
      ),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return super.onKeyEvent(event, keysPressed);
    }
    tetrisPage?.onKeyboardKey(
      event,
    );
    return super.onKeyEvent(event, keysPressed);
  }

  void handleBlockFreezed() {
    tetrisPage?.handleBlockFreezed();
  }

}
