import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import '../main_game.dart';
import '../components/components.dart';

class Play extends Component with HasGameRef<MainGame> {
  final _random = Random();
  final _maxEnemies = 5;

  late final Player _player;
  late final Dungeon _dungeon;
  late final Guide _guide;

  final _enemies = <Enemy>[];
  final _world = World();

  @override
  Future onLoad() async {
    super.onLoad();

    final cameraComponent = CameraComponent(world: _world);
    await add(_world);
    await add(cameraComponent);

    _dungeon = Dungeon();
    await _world.add(_dungeon);

    _guide = Guide(dungeon: _dungeon);
    await add(_guide);

    _player = Player(size: Vector2.all(_dungeon.length * 2), dungeon: _dungeon);
    await _world.add(_player);

    cameraComponent.follow(_player);

    _initPlayerPosition();
    _spawnEnemies();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _enemies.removeWhere((e) => e.parent == null);

    if (_enemies.isEmpty) {
      game.router.pushReplacementNamed('result');
    }

    _guide.playerPosition = _player.positionInDungeon;
    _guide.enemyPositions = _enemies.map((e) => e.positionInDungeon).toList();
  }

  _initPlayerPosition() {
    _player.positionInDungeon = _randomPosition();
  }

  _spawnEnemies() {
    for (var i = 0; i < _maxEnemies; i++) {
      final enemy = Enemy(
        size: Vector2.all(_dungeon.length * 2),
        dungeon: _dungeon,
      );
      enemy.positionInDungeon = _randomPosition();
      _enemies.add(enemy);
      _world.add(enemy);
    }
  }

  Vector2 _randomPosition() {
    while (true) {
      final x = _random.nextInt(_dungeon.columns - 1);
      final y = _random.nextInt(_dungeon.rows - 1);

      if (_dungeon.map[y][x] == 0) {
        if (_player.positionInDungeon == Vector2(x.toDouble(), y.toDouble())) {
          continue;
        }

        if (_enemies.any((e) =>
            e.positionInDungeon == Vector2(x.toDouble(), y.toDouble()))) {
          continue;
        }

        return Vector2(x.toDouble(), y.toDouble());
      }
    }
  }
}
