import 'package:flame/game.dart';

class TransparentRoute extends Route {
  TransparentRoute(super.builder) : super(transparent: true);

  @override
  void onPush(Route? previousRoute) {
    previousRoute?.stopTime();
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute.resumeTime();
  }
}
