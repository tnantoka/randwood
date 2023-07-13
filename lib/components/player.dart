import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

import 'dungeon.dart';

enum PlayerDirection {
  down,
  right,
  up,
  left,
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({super.size, super.position, required this.dungeon});

  final Dungeon dungeon;

  late final SpriteSheet _spritesheet;

  var _direction = PlayerDirection.down;

  var positionInDungeon = Vector2.zero();

  PlayerDirection get direction {
    return _direction;
  }

  set direction(PlayerDirection value) {
    if (_direction != value) {
      _direction = value;
      _updateAnimation();
    }
  }

  @override
  Future onLoad() async {
    await super.onLoad();

    _spritesheet = SpriteSheet(
      image: await game.images.load('Human-Soldier-Cyan.png'),
      srcSize: Vector2.all(32),
    );
    _updateAnimation();

    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            _moveDown();
            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            _moveUp();
            return true;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            _moveRight();
            return true;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            _moveLeft();
            return true;
          },
        },
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
  }

  _updateAnimation() {
    animation = _spritesheet.createAnimation(
      row: direction.index * 2,
      stepTime: 0.2,
      from: 1,
      to: 5,
    );
  }

  _moveDown() {
    if (dungeon.map[positionInDungeon.y.toInt() + 1]
            [positionInDungeon.x.toInt()] ==
        0) {
      positionInDungeon.y++;
      direction = PlayerDirection.down;
    }
  }

  _moveUp() {
    if (dungeon.map[positionInDungeon.y.toInt() - 1]
            [positionInDungeon.x.toInt()] ==
        0) {
      positionInDungeon.y--;
      direction = PlayerDirection.up;
    }
  }

  _moveRight() {
    if (dungeon.map[positionInDungeon.y.toInt()]
            [positionInDungeon.x.toInt() + 1] ==
        0) {
      positionInDungeon.x++;
      direction = PlayerDirection.right;
    }
  }

  _moveLeft() {
    if (dungeon.map[positionInDungeon.y.toInt()]
            [positionInDungeon.x.toInt() - 1] ==
        0) {
      positionInDungeon.x--;
      direction = PlayerDirection.left;
    }
  }
}
