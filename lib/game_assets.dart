import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

final gameAssets = GameAssets();

class GameAssets {
  Map<String, Sprite> sprites = {};

  Future<void> preCache() async {
    sprites['tet-O'] = Sprite(await Flame.images.load('tetris-O.png'));
    sprites['tet-J'] = Sprite(await Flame.images.load('tetris-J.png'));
    sprites['tet-I'] = Sprite(await Flame.images.load('tetris-I.png'));
    sprites['tet-S'] = Sprite(await Flame.images.load('tetris-S.png'));
    sprites['tet-T'] = Sprite(await Flame.images.load('tetris-T.png'));
  }
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
