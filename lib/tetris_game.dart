import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flutter/material.dart'
    show TextStyle, Colors, KeyEventResult, TextField, Center, Material;
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:tetris/pages/splash_screen.dart';

import 'components/keyboard_game_controller.dart';
import 'game_assets.dart';
import 'pages/game_over_route.dart';
import 'pages/help_page.dart';
import 'pages/high_scores_page.dart';
import 'pages/pause_route.dart';
import 'pages/settings_page.dart';
import 'pages/start_page.dart';
import 'pages/tetris_page.dart';
import 'pages/tetris_play_page.dart';
import 'providers/providers.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

class TetrisGame extends FlameGame
    with
        HasCollisionDetection,
        HasDraggables,
        HasTappableComponents,
        KeyboardEvents {
  TetrisGame({required this.widgetRef});

  bool isGameRunning = false;
  late final RouterComponent router;
  TetrisPageInterface? tetrisPage;
  KeyboardGameController? keyboardGameController;
  WidgetRef widgetRef;
  String _score = '';

  set score(String newValue) {
    _score = newValue;
    widgetRef.read(highScoreNotifier.notifier).setCurrentScore(newValue);
  }

  String get score => _score;

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
//          'highScore': Route(HighScorePage.new),
          'help': Route(HelpPage.new),
          'pause': PauseRoute(),
          'gameOver': GameOverRoute(),
          'highScore': OverlayRoute(
            (context, game) {
              return HighScoresPage(game: this);
            },
          ),  
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
