import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'dungeon.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef {
  Enemy({super.size, required this.dungeon});

  final Dungeon dungeon;
  final random = Random();

  var positionInDungeon = Vector2.zero();

  @override
  Future onLoad() async {
    await super.onLoad();

    final spritesheet = SpriteSheet(
      image: await game.images.load('Slime.png'),
      srcSize: Vector2.all(32),
    );
    animation = spritesheet.createAnimation(
      row: 0,
      stepTime: 0.2,
      from: 1,
      to: 5,
    );

    await add(
      RectangleHitbox(
        size: Vector2(
          size.x * 0.4,
          size.y * 0.4,
        ),
        position: Vector2(
          size.x * 0.25,
          size.y * 0.25,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position = Vector2(
          -dungeon.length * 0.5,
          -dungeon.length * 0.5,
        ) +
        positionInDungeon * dungeon.length;

    if (random.nextInt(50) < 1) {
      switch (random.nextInt(4)) {
        case 0:
          _moveDown();
          break;
        case 1:
          _moveUp();
          break;
        case 2:
          _moveRight();
          break;
        case 3:
          _moveLeft();
          break;
      }
    }
  }

  _moveDown() {
    if (dungeon.map[positionInDungeon.y.toInt() + 1]
            [positionInDungeon.x.toInt()] ==
        0) {
      positionInDungeon.y++;
    }
  }

  _moveUp() {
    if (dungeon.map[positionInDungeon.y.toInt() - 1]
            [positionInDungeon.x.toInt()] ==
        0) {
      positionInDungeon.y--;
    }
  }

  _moveRight() {
    if (dungeon.map[positionInDungeon.y.toInt()]
            [positionInDungeon.x.toInt() + 1] ==
        0) {
      positionInDungeon.x++;
    }
  }

  _moveLeft() {
    if (dungeon.map[positionInDungeon.y.toInt()]
            [positionInDungeon.x.toInt() - 1] ==
        0) {
      positionInDungeon.x--;
    }
  }
}
