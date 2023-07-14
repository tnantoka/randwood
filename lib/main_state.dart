class MainState {
  static final MainState _instance = MainState._internal();

  factory MainState() {
    return _instance;
  }

  MainState._internal();

  var onChange = () {};
}
