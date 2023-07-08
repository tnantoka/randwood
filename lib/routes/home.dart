import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../main_game.dart';

class Home extends Component with HasGameRef<MainGame> {
  @override
  Future onLoad() async {
    super.onLoad();

    await add(
      TextComponent(
        text: 'Randwood',
        textRenderer: TextPaint(
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: game.size.y * 0.04,
            color: Colors.white,
          ),
        ),
        position: Vector2(
          game.size.x * 0.5,
          game.size.y * 0.4,
        ),
        anchor: Anchor.center,
      ),
    );

    await add(
      ButtonComponent(
        onPressed: () => game.router.pushReplacementNamed('play'),
        button: TextComponent(
          text: 'Tap to Play',
          textRenderer: TextPaint(
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: game.size.y * 0.02,
              color: Colors.white,
            ),
          ),
        ),
        position: Vector2(
          game.size.x * 0.5,
          game.size.y * 0.6,
        ),
        anchor: Anchor.center,
      ),
    );
  }
}
