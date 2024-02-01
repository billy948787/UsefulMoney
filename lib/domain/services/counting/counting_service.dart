import 'dart:async';

class CountingServce {
  String _counter = '0';
  late final StreamController<String> _counterController;
  //make singleton
  CountingServce._internal() {
    _counterController = StreamController.broadcast(
      onListen: () {
        _counterController.sink.add(_counter);
      },
    );
  }
  static final CountingServce _shared = CountingServce._internal();
  factory CountingServce() => _shared;

  Stream<String> get counter => _counterController.stream;

  void add(String value) {
    _counter += value;
    _counterController.add(_counter);
  }

  void deleteLast() {
    _counter = _counter.substring(0, _counter.length - 1);
    _counterController.add(_counter);
  }

  int getNum() {
    final num = int.parse(_counter);
    return num;
  }
}
