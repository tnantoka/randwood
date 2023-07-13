import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import './dungeon.dart';

class Guide extends RectangleComponent with HasGameRef {
  Guide({required this.dungeon});

  final Dungeon dungeon;

  var playerPosition = Vector2.zero();
  var enemyPositions = <Vector2>[];

  get length => game.size.y * 0.004;

  @override
  Future onLoad() async {
    await super.onLoad();

    size = Vector2(length * dungeon.columns, length * dungeon.rows);
    paint = Paint()..color = Colors.white.withAlpha(80);
    position = Vector2(
      game.size.x - size.x,
      game.size.y - size.y,
    );
    priority = 1;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (var i = 0; i < dungeon.rows; i++) {
      for (var j = 0; j < dungeon.columns; j++) {
        if (dungeon.map[i][j] == 1) {
          continue;
        }

        canvas.drawRect(
          Rect.fromLTWH(
            length * j,
            length * i,
            length,
            length,
          ),
          Paint()..color = Colors.white,
        );
      }
    }

    canvas.drawRect(
      Rect.fromLTWH(
        length * playerPosition.x,
        length * playerPosition.y,
        length,
        length,
      ),
      Paint()..color = Colors.red,
    );

    for (var enemyPosition in enemyPositions) {
      canvas.drawRect(
        Rect.fromLTWH(
          length * enemyPosition.x,
          length * enemyPosition.y,
          length,
          length,
        ),
        Paint()..color = Colors.blue,
      );
    }
  }
}
