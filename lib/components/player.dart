import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteComponent with HasGameRef {
  Player({super.size, super.position});

  @override
  Future onLoad() async {
    await super.onLoad();

    final spritesheet = SpriteSheet(
      image: await game.images.load('Human-Soldier-Cyan.png'),
      srcSize: Vector2.all(32),
    );
    sprite = spritesheet.getSprite(0, 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.stroke,
    );
  }
}
