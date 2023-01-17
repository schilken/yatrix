import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart'
    show TextStyle, Colors, KeyEventResult, TextField, Center, Material;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/keyboard_game_controller.dart';
import 'game_assets.dart';
import 'pages/credits_page.dart';
import 'pages/game_over_route.dart';
import 'pages/help_page.dart';
import 'pages/high_scores_page.dart';
import 'pages/info_page.dart';
import 'pages/pause_route.dart';
import 'pages/peer_page.dart';
import 'pages/settings_page.dart';
import 'pages/splash_screen.dart';
import 'pages/start_page.dart';
import 'pages/mosaic_page.dart';
import 'pages/tetris_play_page.dart';
import 'providers/providers.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

enum SoundEffects {
  freezedBlock('pha.mp3'),
  removingFilledRow(
    'zapsplat_fantasy_magic_chime_ping_wand_fairy_godmother_013_38299.mp3',
  ),
  droppingBlock(
      'zapsplat_sound_design_transition_whoosh_fast_airy_002_74584.mp3');

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
  late final RouterComponent router;
  TetrisPageInterface? gamePage;
  KeyboardGameController? keyboardGameController;
  WidgetRef widgetRef;
  String backgroundMusicName =
      'music_zapsplat_game_music_childrens_soft_warm_cuddly_calm_015.mp3';
  double backgroundMusicVolume = 0.25;
  double sfxVolume = 0.5;
  bool showFps = true;
  bool isGameOver = false;

  int _rows = 0;
  int _points = 0;
  void setScoreValues({required int points, required int rows}) {
    _points = points;
    _rows = rows;
    widgetRef.read(highScoreNotifier.notifier).setScoreValues(points, rows);
  }

  int get points => _points;
  int get rows => _rows;

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

  void handlePeerCommand(String command) {
    if (command.length == 3 && command.startsWith('@i')) {
      gamePage?.handlePeerCommand(command);
    }
  }

  void rowWasRemoved() {
    widgetRef.read(peerServiceProvider).sendMessage('@i3');
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
