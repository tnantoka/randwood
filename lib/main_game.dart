import 'package:flame/game.dart';

import 'routes/routes.dart';

class MainGame extends FlameGame {
  late final RouterComponent router;

  var score = 0;

  @override
  Future onLoad() async {
    super.onLoad();

    // debugMode = true;

    router = RouterComponent(
      routes: {
        'home': Route(Home.new),
        'play': Route(Play.new, maintainState: false),
        'result': Route(Result.new),
      },
      initialRoute: 'home',
    );
    await add(router);
  }
}
