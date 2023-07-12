import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

enum PlayerDirection {
  down,
  right,
  up,
  left,
}

class Player extends SpriteAnimationComponent with HasGameRef {
  Player({super.size, super.position});

  late final SpriteSheet _spritesheet;

  var _direction = PlayerDirection.down;

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
  }

  _updateAnimation() {
    animation = _spritesheet.createAnimation(
      row: direction.index * 2,
      stepTime: 0.2,
      from: 1,
      to: 5,
    );
  }
}
