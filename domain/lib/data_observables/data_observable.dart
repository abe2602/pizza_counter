import 'dart:async';

class StreamObservable<T> extends Stream<T> {
  StreamObservable(this._controller);

  final StreamController<T> _controller;

  @override
  StreamSubscription<T> listen(
    void Function(T event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

class SinkObservable<T> extends Sink<T> {
  SinkObservable(this._controller);

  final StreamController<T> _controller;

  @override
  void add(T data) => _controller.sink.add(data);

  @override
  void close() => _controller.sink.close();
}
