import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../main_game.dart';

class Result extends Component with HasGameRef<MainGame> {
  late final TextComponent _scoreText;

  @override
  Future onLoad() async {
    super.onLoad();

    await add(
      _scoreText = TextComponent(
        text: 'Score: ${game.score}',
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
        onPressed: () {
          game.score = 0;
          game.router.pushReplacementNamed('home');
        },
        button: TextComponent(
          text: 'Tap to Back',
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

  @override
  void onMount() {
    super.onMount();

    _scoreText.text = 'Score: ${game.score}';
  }
}
