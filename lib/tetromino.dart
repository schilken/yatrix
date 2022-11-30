import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:tetris/boundaries.dart';

class Tetromino extends BodyComponent {
  final Vector2 position;
  final Vector2 size;

  Tetromino(
    this.position, {
    Vector2? size,
  }) : size = size ?? Vector2(2, 3);

  late BodyDef bodyDef2;
//TextConfig get debugTextConfig => TextConfig(color: debugColor, fontSize: 12);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite('tetris-L.png');
    renderBody = false;

    add(
      SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    bodyDef2.angle = 0;
    bodyDef2.position.x = 400;
  }

  @override
  Body createBody() {
    final shape = PolygonShape();

    final vertices = [
      Vector2(-size.x / 2, -size.y / 2),
      Vector2(-size.x / 2, size.y / 2),
      Vector2(size.x / 2, size.y / 2),
      Vector2(size.x / 2, -size.y / 2),
    ];
    shape.set(vertices);

    final fixtureDef = FixtureDef(
      shape,
      userData: this, // To be able to determine object in collision
      restitution: 0.4,
      density: 1.0,
      friction: 0.5,
    );

    final bodyDef = BodyDef(
      position: position,
//      angle: (position.x + position.y) / 2 * pi,
      type: BodyType.dynamic,
    );
    bodyDef2 = bodyDef;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
