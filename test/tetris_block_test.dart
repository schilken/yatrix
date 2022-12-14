import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:tetris/tetris_block.dart';

void main() {
  group('TetrisI ', () {
    test('calculates Y 553 modulo(floor) to 550 ', () {
      final startPosition = Vector2(5 * 100.0, 553);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      expect(sut.y, 550);
    });

    test('calculates Y 925 modulo(floor) to 925 ', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      expect(sut.y, 925);
    });

    test('containsLocalPoint', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.containsLocalPoint(Vector2(25, 925));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 75/25', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(75, 25));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 25/75', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(75, 25));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 125/75', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(125, 25));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 175/75', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(175, 25));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint -5/25 is false', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(-5, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 205/25 is false', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(205, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 0/25 is false', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(-1, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 200/25 is false', () {
      final startPosition = Vector2(25.0, 925.0);
      final sut = TetrisI(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(195, 25));
      expect(isFound, false);
    });
  });

  group('TetrisJ ', () {
    test('hitbox containsLocalPoint 25/25', () async {
      final startPosition = Vector2(75.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      await sut.onLoad();
      sut.adjustY();
      await Future<void>.delayed(Duration(milliseconds: 10));
      print('children: ${sut.children}');
      final isFound =
          sut.containsLocalPoint(Vector2(25, 925));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 25/75', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound =
          sut.children.any((box) => box.containsLocalPoint(Vector2(25, 75)));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 75/25', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound =
          sut.children.any((box) => box.containsLocalPoint(Vector2(75, 25)));
      expect(isFound, true);
    });


    test('hitbox containsLocalPoint 125/75', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound =
          sut.children.any((box) => box.containsPoint(Vector2(125, 75)));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint -5/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound =
          sut.children.any((box) => box.containsPoint(Vector2(-5, 25)));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 205/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(205, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 0/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(-1, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 200/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisJ(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(195, 25));
      expect(isFound, false);
    });

  });

  group('TetrisO ', () {

    test('hitbox containsLocalPoint 25/75', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(25, 75));
      expect(isFound, true);
    });

    test('hitbox containsLocalPoint 125/75', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(125, 75));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint -5/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(-5, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 205/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(205, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 0/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(-1, 25));
      expect(isFound, false);
    });

    test('hitbox containsLocalPoint 200/25 is false', () {
      final startPosition = Vector2(125.0, 925.0);
      final sut = TetrisO(blockPosition: startPosition);
      sut.onLoad();
      sut.adjustY();
      final isFound = sut.hitBox!.containsLocalPoint(Vector2(195, 25));
      expect(isFound, false);
    });
  });

}
