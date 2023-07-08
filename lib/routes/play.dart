import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

import '../main_game.dart';

class Play extends Component with HasGameRef<MainGame> {
  @override
  Future onLoad() async {
    super.onLoad();

    add(ButtonComponent(
      button: TextComponent(text: 'test'),
      onPressed: () {
        game.router.pushReplacementNamed('result');
      },
    ));
  }
}
