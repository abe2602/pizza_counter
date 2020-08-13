import 'package:flutter/widgets.dart';
import 'package:pizza_counter/presentation/common/subscription_utils.dart';

class TeleviActionListener<T> extends StatefulWidget {
  const TeleviActionListener({
    @required this.child,
    @required this.actionStream,
    @required this.onReceived,
    Key key,
  })  : assert(child != null),
        assert(actionStream != null),
        assert(onReceived != null),
        super(key: key);

  final Widget child;
  final Stream<T> actionStream;
  final Function(T action) onReceived;

  @override
  _TeleviActionListenerState<T> createState() => _TeleviActionListenerState<T>();
}

class _TeleviActionListenerState<T> extends State<TeleviActionListener<T>>
    with SubscriptionBag {
  @override
  void initState() {
    widget.actionStream
        .listen(
          widget.onReceived,
        )
        .addTo(subscriptionsBag);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
