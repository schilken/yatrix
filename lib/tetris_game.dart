import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show TextStyle, Colors, KeyEventResult;
import 'package:flutter/services.dart';

import 'package:tetris/pages/splash_screen.dart';

import 'components/keyboard_game_controller.dart';
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
    return super.onKeyEvent(event, keysPressed);
  }

  void handleBlockFreezed() {
    tetrisPage?.handleBlockFreezed();
  }

}
