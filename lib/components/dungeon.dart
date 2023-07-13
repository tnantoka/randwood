import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Dungeon extends PositionComponent with HasGameRef {
  static const seedScale = 7;
  final columns = 11 * seedScale;
  final rows = 9 * seedScale;
  final random = Random();

  late final RectangleComponent _spritesContainer;
  late final RectangleComponent _guideContainer;
  late final List<List<int>> map;
  late final RectangleComponent _playerGuide;

  var playerPosition = Vector2.zero();

  get seedColumns => columns ~/ seedScale;
  get seedRows => rows ~/ seedScale;
  get length => (game.size.y * 0.04).round();
  get guideLength => game.size.y * 0.004;

  @override
  Future onLoad() async {
    await super.onLoad();

    size = Vector2(length * columns, length * rows);

    map = _generateMap();
    await _addGuide(map);
    await _addSprites(map);

    _playerGuide = RectangleComponent(
      size: Vector2.all(guideLength),
      paint: Paint()..color = Colors.red,
    );
    _guideContainer.add(_playerGuide);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerGuide.position = Vector2(
      playerPosition.x * guideLength,
      playerPosition.y * guideLength,
    );
  }

  List<List<int>> _generateSeed() {
    List<List<int>> seed =
        List.generate(seedRows, (_) => List<int>.filled(seedColumns, 0));

    for (int i = 0; i < seedRows; i++) {
      seed[i][0] = 1;
      seed[i][seedColumns - 1] = 1;
    }
    for (int i = 0; i < seedColumns; i++) {
      seed[0][i] = 1;
      seed[seedRows - 1][i] = 1;
    }

    for (int i = 2; i < seedRows - 1; i += 2) {
      for (int j = 2; j < seedColumns - 1; j += 2) {
        seed[i][j] = 1;

        var i2 = 0;
        var j2 = 0;

        switch (random.nextInt(i == 2 ? 4 : 3)) {
          case 0:
            i2 = -1;
            j2 = 0;
            break;
          case 1:
            i2 = -1;
            j2 = 0;
            break;
          case 2:
            i2 = 0;
            j2 = 1;
            break;
          case 3:
            i2 = 0;
            j2 = -1;
            break;
        }

        seed[i + i2][j + j2] = 1;
      }
    }

    return seed;
  }

  List<List<int>> _generateMap() {
    List<List<int>> seed = _generateSeed();
    List<List<int>> map =
        List.generate(rows, (_) => List<int>.filled(columns, 1));

    for (int i = 1; i < seedRows - 1; i++) {
      for (int j = 1; j < seedColumns - 1; j++) {
        final x = (j * seedScale).toInt() + 1;
        final y = (i * seedScale).toInt() + 1;
        if (seed[i][j] == 0) {
          if (random.nextInt(100) < 20) {
            for (int i2 = -(seedScale ~/ 2); i2 <= (seedScale ~/ 2); i2++) {
              for (int j2 = -(seedScale ~/ 2); j2 <= (seedScale ~/ 2); j2++) {
                map[y + i2][x + j2] = 0;
              }
            }
          } else {
            map[y][x] = 0;
            for (int k = 1; k <= (seedScale ~/ 2); k++) {
              if (seed[i - 1][j] == 0) {
                map[y - k][x] = 0;
              }
              if (seed[i + 1][j] == 0) {
                map[y + k][x] = 0;
              }
              if (seed[i][j - 1] == 0) {
                map[y][x - k] = 0;
              }
              if (seed[i][j + 1] == 0) {
                map[y][x + k] = 0;
              }
            }
          }
        }
      }
    }

    return map;
  }

  Future _addGuide(List<List<int>> map) async {
    final containerSize =
        Vector2(guideLength * (columns - 3), guideLength * (rows - 3));
    _guideContainer = RectangleComponent(
      size: containerSize,
      position: Vector2(
        game.size.x - containerSize.x,
        game.size.y - containerSize.y,
      ),
      paint: Paint()..color = const Color(0x55FFFFFF),
      priority: 1,
    );
    await game.add(_guideContainer);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        if (map[i][j] == 1) {
          continue;
        }

        await _guideContainer.add(
          RectangleComponent(
            size: Vector2.all(guideLength),
            position: Vector2(guideLength * j, guideLength * i),
            paint: Paint()..color = const Color(0xFFFFFFFF),
          ),
        );
      }
    }
  }

  Future _addSprites(List<List<int>> map) async {
    final grassSprite1 = await Sprite.load('Grass1.png');
    final grassSprite2 = await Sprite.load('Grass2.png');
    final treeSprite = await Sprite.load('Tree.png');

    final containerSize = Vector2(length * columns, length * rows);
    _spritesContainer = RectangleComponent(
      size: containerSize,
      paint: Paint()
        ..color = const Color(0x55FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = length,
    );
    await add(_spritesContainer);

    await _spritesContainer.add(
      SpriteComponent(
        sprite: grassSprite1,
        size: _spritesContainer.size,
      ),
    );

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        await _spritesContainer.add(
          SpriteComponent(
            sprite: i % 2 == j % 2 ? grassSprite1 : grassSprite2,
            size: Vector2.all(length),
            position: Vector2(length * j, length * i),
          ),
        );
        if (map[i][j] == 1) {
          await _spritesContainer.add(
            SpriteComponent(
              sprite: treeSprite,
              size: Vector2.all(length),
              position: Vector2(length * j, length * i),
            ),
          );
        }
      }
    }
  }
}
