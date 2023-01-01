import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show TextStyle, Colors, KeyEventResult;
import 'package:flutter/services.dart';

import 'package:tetris/pages/splash_screen.dart';

import 'game_assets.dart';
import 'pages/game_over_route.dart';
import 'pages/help_page.dart';
import 'pages/high_score_page.dart';
import 'pages/settings_page.dart';
import 'pages/tetris_page.dart';
import 'pages/pause_route.dart';
import 'pages/start_page.dart';
import 'pages/tetris_play_page.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

abstract class TetrisPageInterface {
  void handleBlockFreezed();
  void onKeyboardKey(
    RawKeyEvent event,
  );
}

enum GameCommand {
  left,
  right,
  up,
  down,
  reset,
  pause,
  O,
  L,
  J,
  S,
  Z,
  T,
  I,
}
abstract class GameController {
  Stream<GameCommand> get commandStream;
}

class KeyboardGameController implements GameController {
  final _controller = StreamController<GameCommand>();

  void onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyUp = event is RawKeyUpEvent;
    if (event.repeat || !isKeyUp) {
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _controller.sink.add(GameCommand.reset);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _controller.sink.add(GameCommand.left);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _controller.sink.add(GameCommand.right);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _controller.sink.add(GameCommand.up);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _controller.sink.add(GameCommand.down);
    }
  }

  @override
  Stream<GameCommand> get commandStream => _controller.stream;

  // TODO: close streamController
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
  KeyboardGameController? keyboardGameController;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await gameAssets.preCache();
    add(
      router = RouterComponent(
        routes: {
          'splash': Route(SplashScreen.new),
          'home': Route(StartPage.new),
          'play': Route(() {
            final tetrisPlayPage = TetrisPlayPage();
            tetrisPage = tetrisPlayPage;
            return tetrisPlayPage;
          }),
          'construct': Route(() {
            final tetrisConstructPage = TetrisConstructPage();
            tetrisPage = tetrisConstructPage;
            return tetrisConstructPage;
          }),
          'settings': Route(SettingsPage.new),
          'highScore': Route(HighScorePage.new),
          'help': Route(HelpPage.new),
          'pause': PauseRoute(),
          'gameOver': GameOverRoute(),
        },
        initialRoute: 'splash',
      ),
    );
    keyboardGameController = KeyboardGameController();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    keyboardGameController?.onKeyEvent(event, keysPressed);
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
