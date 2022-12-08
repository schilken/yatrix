import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

final gameAssets = GameAssets();

class GameAssets {
  Map<String, Sprite> sprites = {};

  Future<void> preCache() async {
    sprites['tet-O'] = Sprite(await Flame.images.load('tetris-O.png'));
    sprites['tet-J'] = Sprite(await Flame.images.load('tetris-J.png'));
  }
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
