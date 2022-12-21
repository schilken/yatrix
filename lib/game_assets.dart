import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

final gameAssets = GameAssets();

class GameAssets {
  Map<String, Sprite> sprites = {};

  Future<void> preCache() async {
    sprites['tet-O'] = Sprite(await Flame.images.load('tetris-O-plain.png'));
    sprites['tet-J'] = Sprite(await Flame.images.load('tetris-J-plain.png'));
    sprites['tet-L'] = Sprite(await Flame.images.load('tetris-L-plain.png'));
    sprites['tet-I'] = Sprite(await Flame.images.load('tetris-I-plain.png'));
    sprites['tet-S'] = Sprite(await Flame.images.load('tetris-S-plain.png'));
    sprites['tet-Z'] = Sprite(await Flame.images.load('tetris-Z-plain.png'));
    sprites['tet-T'] = Sprite(await Flame.images.load('tetris-T-plain.png'));
    sprites['quad-tet-Z'] = Sprite(await Flame.images.load('quad_z.png'));
  }
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
