import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Route;

import '../main_game.dart';
import '../main_state.dart';

class Battle extends Component with HasGameRef<MainGame> {
  @override
  Future onLoad() async {
    super.onLoad();

    await add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = Colors.black.withAlpha(160),
      ),
    );

    final containerSize = Vector2(
      game.size.x * 0.8,
      game.size.y * 0.5,
    );
    await add(
      RectangleComponent(
        size: containerSize,
        position: Vector2(
          (game.size.x - containerSize.x) * 0.5,
          (game.size.y - containerSize.y) * 0.5,
        ),
        paint: Paint()..color = Colors.black,
      ),
    );
    await add(
      RectangleComponent(
        size: containerSize,
        position: Vector2(
          (game.size.x - containerSize.x) * 0.5,
          (game.size.y - containerSize.y) * 0.5,
        ),
        paint: Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = game.size.y * 0.002,
      ),
    );

    await add(
      ButtonComponent(
        onPressed: () {
          game.router.pop();
          MainState().onChange();
        },
        button: TextComponent(text: 'close'),
        position: Vector2(0, 40),
        size: Vector2(200, 30),
      ),
    );
  }
}
