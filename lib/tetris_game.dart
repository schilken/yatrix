// ignore_for_file: avoid_print
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' show KeyEventResult;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/keyboard_game_controller.dart';
import 'helpers/game_assets.dart';
import 'pages/flame/credits_page.dart';
import 'pages/dialog_overlay.dart';
import 'pages/flame/game_over_route.dart';
import 'pages/high_scores_page.dart';
import 'pages/info_page.dart';
import 'pages/flame/mosaic_page.dart';
import 'pages/flame/pause_route.dart';
import 'pages/peer_page.dart';
import 'pages/settings_page.dart';
import 'pages/flame/splash_screen.dart';
import 'pages/flame/start_page.dart';
import 'pages/flame/tetris_play_page.dart';
import 'providers/providers.dart';

enum SoundEffects {
  freezedBlock('pha.mp3'),
  removingFilledRow(
    'zapsplat_fantasy_magic_chime_ping_wand_fairy_godmother_013_38299.mp3',
  ),
  droppingBlock(
    'zapsplat_sound_design_transition_whoosh_fast_airy_002_74584.mp3',
  );

  final String name;

  const SoundEffects(this.name);

  static List<String> get allNames =>
      values.map((entry) => entry.name).toList();
}

class TetrisGame extends FlameGame
    with
        HasCollisionDetection,
        HasDraggables,
        HasTappableComponents,
        KeyboardEvents {
  TetrisGame({required this.widgetRef});

  bool isGameRunning = false;
  bool isGameOver = false;
  bool isTwoPlayerGame = false;

  late final RouterComponent router;
  TetrisPageInterface? gamePage;
  KeyboardGameController? keyboardGameController;
  WidgetRef widgetRef;
  String backgroundMusicName =
      'music_zapsplat_game_music_childrens_soft_warm_cuddly_calm_015.mp3';
  double backgroundMusicVolume = 0.25;
  double sfxVolume = 0.5;
  bool showFps = true;

  int _rows = 0;
  int _points = 0;

  void setScoreValues({required int points, required int rows}) {
    _points = points;
    _rows = rows;
    if (_rows >= 30 && isTwoPlayerGame) {
      notifyWin();
    }
    widgetRef.read(highScoreNotifier.notifier).setScoreValues(points, rows);
  }

  int get points => _points;
  int get rows => _rows;

  String _gameEndString = 'Game Over!';
  String get gameEndString => _gameEndString;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await gameAssets.preCache();
    add(
      router = RouterComponent(
        routes: {
          'splash': Route(SplashScreen.new),
          'home': Route(StartPage.new),
          'play': Route(
            () {
              final tetrisPlayPage = TetrisPlayPage();
              gamePage = tetrisPlayPage;
              return tetrisPlayPage;
            },
            maintainState: false,
          ),
          'mosaic': Route(
            () {
              final mosaicPage = MosaicPage();
              gamePage = mosaicPage;
              return mosaicPage;
            },
            maintainState: false,
          ),
          'settings': OverlayRoute((context, game) => SettingsPage(game: this)),
          'peer': OverlayRoute((context, game) => PeerPage(game: this)),
          'info': OverlayRoute(
            (context, game) {
              return InfoPage(game: this);
            },
          ),
          'pause': PauseRoute(),
          'credits': Route(CreditsPage.new),
          'gameOver': GameOverRoute(),
          'highScore': OverlayRoute(
            (context, game) {
              return HighScoresPage(game: this);
            },
          ),
          'commitDialog': OverlayRoute(
            (context, game) {
              return DialogOverlay(game: this);
            },
          ),
        },
        initialRoute: 'splash',
      ),
    );
    keyboardGameController = KeyboardGameController();
    await initAudio();
    showFps = widgetRef.read(settingsNotifier).showFps;
  }

  Future<void> initAudio() async {
    FlameAudio.bgm.initialize();
    final sfxNames = SoundEffects.allNames;
    await FlameAudio.audioCache.loadAll([backgroundMusicName, ...sfxNames]);
    final settings = widgetRef.read(settingsNotifier);
    setBackgroundMusicVolume(settings.musicVolume);
    setSoundEffectsVolume(settings.soundEffectsVolume);
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
    gamePage?.handleBlockFreezed();
  }

  void startNewGame() {
    _gameEndString = 'Game Over!';
    backgroundMusicStart();
    isGameRunning = true;
    isGameOver = false;
  }

  void stopGame() {
    isGameRunning = false;
    isGameOver = true;
    router.pushNamed('gameOver');
  }

  void topIsReached() {
    print('>>> GAME OVER <<<');
    notifyGameOver();
    stopGame();
  }

  void notifyGameOver() {
    if (isTwoPlayerGame) {
      _gameEndString = 'YOU LOSE!';
      // the other side has won
      widgetRef.read(peerServiceProvider).sendMessage('@+');
    }
  }

// Used by Two-Player-Mode
  void notifyWin() {
    // the other side has lost
    widgetRef.read(peerServiceProvider).sendMessage('@-');
    _gameEndString = 'YOU WIN!';
    stopGame();
  }

  void receivedLost() {
    _gameEndString = 'YOU LOSE!';
    stopGame();
  }

  void receivedWin() {
    _gameEndString = 'YOU WIN!';
    stopGame();
  }

  void handlePeerCommand(String command, bool isConnected) {
    print('handlePeerCommand >>>> command: $command $isConnected');
    isTwoPlayerGame = isConnected;
    String? message;
    if (command.length == 3 && command.startsWith('@i')) {
      gamePage?.handlePeerCommand(command);
    } else if (command == '@-') {
      message = 'Your peer has removed 30 rows!';
      receivedLost();
    } else if (command == '@+') {
      message = 'Your peer had "Game Over"!';
      receivedWin();
    } else if (command == '@done!') {
      message = 'Two-Player Mode finished';
    } else if (command.startsWith('@L')) {
      gamePage?.handlePeerCommand(command);
    }

    if (message != null) {
      BotToast.showText(
        text: message,
        duration: const Duration(seconds: 3),
        align: const Alignment(0, 0.3),
      );
    }
  }

  void notifyRowWasRemoved() {
    if (isTwoPlayerGame) {
      widgetRef.read(peerServiceProvider).sendMessage('@i3');
    }
  }

  void notifyLevel(int level) {
    print('notifyLevell: $level');
    if (isTwoPlayerGame) {
      widgetRef.read(peerServiceProvider).sendMessage('@L$level');
    }
  }

  void backgroundMusicStart() {
    FlameAudio.bgm.play(backgroundMusicName, volume: backgroundMusicVolume);
  }

  void backgroundMusicStop() {
    FlameAudio.bgm.stop();
  }

  void setBackgroundMusicVolume(double newVolume) {
    backgroundMusicVolume = newVolume;
    FlameAudio.bgm.audioPlayer.setVolume(newVolume);
  }

  void setSoundEffectsVolume(double newVolume) {
    sfxVolume = newVolume;
  }

  void playSoundEffect(SoundEffects soundEffect) {
    FlameAudio.play(soundEffect.name, volume: sfxVolume);
  }
}
