import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import '../main_game.dart';
import '../components/components.dart';

class Play extends Component with HasGameRef<MainGame> {
  final random = Random();

  late final Player _player;
  late final Dungeon _dungeon;

  var _playerPosition = Vector2.zero();

  @override
  Future onLoad() async {
    super.onLoad();

    await add(
      ButtonComponent(
        button: TextComponent(text: 'test'),
        position: Vector2.all(100),
        onPressed: () {
          game.router.pushReplacementNamed('result');
        },
      ),
    );

    final world = World();
    final cameraComponent = CameraComponent(world: world);
    await add(world);
    await add(cameraComponent);

    _dungeon = Dungeon();
    world.add(_dungeon);

    _player = Player(size: Vector2.all(_dungeon.length * 2));
    world.add(_player);

    cameraComponent.follow(_player);

    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            if (_dungeon.map[_playerPosition.y.toInt() + 1]
                    [_playerPosition.x.toInt()] ==
                0) {
              _playerPosition.y++;
              _player.direction = PlayerDirection.down;
            }
            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            if (_dungeon.map[_playerPosition.y.toInt() - 1]
                    [_playerPosition.x.toInt()] ==
                0) {
              _playerPosition.y--;
              _player.direction = PlayerDirection.up;
            }
            return true;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (_dungeon.map[_playerPosition.y.toInt()]
                    [_playerPosition.x.toInt() + 1] ==
                0) {
              _playerPosition.x++;
              _player.direction = PlayerDirection.right;
            }
            return true;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (_dungeon.map[_playerPosition.y.toInt()]
                    [_playerPosition.x.toInt() - 1] ==
                0) {
              _playerPosition.x--;
              _player.direction = PlayerDirection.left;
            }
            return true;
          },
        },
      ),
    );

    _initPlayerPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerPosition = Vector2(
      _playerPosition.x.clamp(0, _dungeon.columns - 1).toDouble(),
      _playerPosition.y.clamp(0, _dungeon.rows - 1).toDouble(),
    );

    _player.position = Vector2(
          -_dungeon.length * 0.5,
          -_dungeon.length * 0.5,
        ) +
        _playerPosition * _dungeon.length;
    _dungeon.playerPosition = _playerPosition;
  }

  _initPlayerPosition() {
    while (_playerPosition.isZero()) {
      final x = random.nextInt(_dungeon.columns - 1);
      final y = random.nextInt(_dungeon.rows - 1);

      if (_dungeon.map[y][x] == 0) {
        _playerPosition = Vector2(x.toDouble(), y.toDouble());
        break;
      }
    }
  }
}
