import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Route;

import '../main_game.dart';
import '../main_state.dart';

class Battle extends Component with HasGameRef<MainGame> {
  late final SpriteSheet _enemySpritesheet;
  late final SpriteSheet _playerSpritesheet;

  late final SpriteAnimationComponent _player;
  late final SpriteAnimationComponent _enemy;

  late final RectangleComponent _redBar;
  late final RectangleComponent _greenBar;

  var _greenBarWidth = 0.0;
  var _greenBarDirection = 1;
  var _isAttacked = false;

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
    final container = RectangleComponent(
      size: containerSize,
      position: Vector2(
        (game.size.x - containerSize.x) * 0.5,
        (game.size.y - containerSize.y) * 0.5,
      ),
      paint: Paint()..color = Colors.black,
    );
    await add(container);

    final grassSprite1 = await Sprite.load('Grass1.png');
    await container.add(
      SpriteComponent(
        size: containerSize,
        sprite: grassSprite1,
      ),
    );

    final spriteSize = Vector2.all(containerSize.y * 0.2);
    _enemySpritesheet = SpriteSheet(
      image: await game.images.load('Slime.png'),
      srcSize: Vector2.all(32),
    );
    await container.add(
      _enemy = SpriteAnimationComponent(
        size: spriteSize,
        position: Vector2(
          (containerSize.x - spriteSize.x) * 0.5,
          (containerSize.y - spriteSize.y) * 0.3,
        ),
      ),
    );
    _updateEnemyAnimation(0, 6);

    _playerSpritesheet = SpriteSheet(
      image: await game.images.load('Human-Soldier-Cyan.png'),
      srcSize: Vector2.all(32),
    );
    await container.add(
      _player = SpriteAnimationComponent(
        size: spriteSize,
        position: Vector2(
          (containerSize.x - spriteSize.x) * 0.5,
          (containerSize.y - spriteSize.y) * 0.3 + spriteSize.y * 0.5,
        ),
      ),
    );
    _updatePlayerAnimation(1, 5, true);

    await container.add(
      ButtonComponent(
        onPressed: _attack,
        position: Vector2(
          containerSize.x * 0.5,
          containerSize.y * 0.9,
        ),
        anchor: Anchor.center,
        button: TextComponent(
          text: 'Attack',
          textRenderer: TextPaint(
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: containerSize.y * 0.06,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final barSize = Vector2(
      containerSize.x * 0.8,
      containerSize.y * 0.06,
    );
    final barPosition = Vector2(
      containerSize.x * 0.1,
      containerSize.y * 0.7,
    );
    await container.add(
      _redBar = RectangleComponent(
        size: barSize,
        position: barPosition,
        paint: Paint()..color = Colors.red,
      ),
    );
    await container.add(
      _greenBar = RectangleComponent(
        size: barSize,
        position: barPosition,
        paint: Paint()..color = Colors.green,
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
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isAttacked) {
      return;
    }

    _greenBarWidth += _redBar.size.x * 0.4 * dt * _greenBarDirection;
    if (_greenBarWidth <= 0 && _greenBarDirection < 0 ||
        _greenBarWidth >= 100 && _greenBarDirection > 0) {
      _greenBarDirection *= -1;
    }

    _greenBar.size.x =
        (_redBar.size.x * _greenBarWidth / 100).clamp(0, _redBar.size.x);
  }

  _updateEnemyAnimation(int from, int to) {
    _enemy.animation = _enemySpritesheet.createAnimation(
      row: 0,
      stepTime: 0.2,
      from: from,
      to: to,
    );
  }

  _updatePlayerAnimation(int from, int to, bool loop) {
    _player.animation = _playerSpritesheet.createAnimation(
      row: 4,
      stepTime: 0.2,
      from: from,
      to: to,
      loop: loop,
    );
  }

  _attack() {
    _isAttacked = true;
    game.score += _greenBarWidth.toInt();

    _updateEnemyAnimation(6, 15);
    _updatePlayerAnimation(5, 9, false);

    Future.delayed(
      const Duration(milliseconds: 1400),
      () {
        game.router.pop();
        MainState().onChange();
      },
    );
  }
}
