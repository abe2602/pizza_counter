import 'package:flutter/widgets.dart';

/// Holds information about our app's flows.
class AppFlow {
  const AppFlow({
    @required this.title,
    @required this.iconData,
    @required this.navigatorKey,
    @required this.rootPage,
  })  : assert(title != null),
        assert(iconData != null),
        assert(navigatorKey != null),
        assert(rootPage != null);

  final String title;
  final IconData iconData;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget rootPage;
}
