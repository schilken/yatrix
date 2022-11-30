import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

import 'tetromino.dart';

const TextStyle _textStyle = TextStyle(color: Colors.black, fontSize: 2);

class TheGame extends Forge2DGame with TapDetector, HasDraggables {
  static const info = '''
This example shows how to compose a `BodyComponent` together with a normal Flame
component. Click the ball to see the number increment.
''';

  TheGame() : super(zoom: 10, gravity: Vector2(0, 20.0));

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await FlameAudio.audioCache.loadAll(['pha.mp3']);
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    final viewportCenter = camera.viewport.effectiveSize / 2;
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final position = details.eventPosition.game;
    add(Tetromino(position, size: Vector2(15, 10)));
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
