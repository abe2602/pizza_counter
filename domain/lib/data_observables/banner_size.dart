import 'dart:async';

import 'package:domain/data_observables/data_observable.dart';

class BannerSizeStream extends StreamObservable<double> {
  BannerSizeStream(StreamController controller) : super(controller);
}

class BannerSizeSink extends SinkObservable<double> {
  BannerSizeSink(StreamController controller) : super(controller);
}
