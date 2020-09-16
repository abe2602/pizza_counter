import 'dart:io';

import 'package:flutter/widgets.dart';

import 'bottom_navigation_tab.dart';
import 'cuppertino_bottom_navigation_scaffold.dart';
import 'material_bottom_navigation_scaffold.dart';

///Bottom Navigation adaptativa, se é iOS, adiciona Cupertino, CC, Material
class AdaptiveBottomNavigationScaffold extends StatefulWidget {
  const AdaptiveBottomNavigationScaffold({
    @required this.navigationBarItems,
    Key key,
  })  : assert(navigationBarItems != null),
        super(key: key);

  /// Lista das tabs do app (List<AppFlow) da HomeScreen
  final List<BottomNavigationTab> navigationBarItems;

  @override
  _AdaptiveBottomNavigationScaffoldState createState() =>
      _AdaptiveBottomNavigationScaffoldState();
}

class _AdaptiveBottomNavigationScaffoldState
    extends State<AdaptiveBottomNavigationScaffold> {
  int _currentlySelectedIndex = 0;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !await widget
            .navigationBarItems[_currentlySelectedIndex]
            .navigatorKey
            .currentState
            .maybePop(),
        child: Platform.isAndroid
            ? MaterialBottomNavigationScaffold(
                navigationBarItems: widget.navigationBarItems,
                onItemSelected: onTabSelected,
                selectedIndex: _currentlySelectedIndex,
              )
            : CupertinoBottomNavigationScaffold(
                navigationBarItems: widget.navigationBarItems,
                onItemSelected: onTabSelected,
                selectedIndex: _currentlySelectedIndex,
              ),
      );

  /// Seleção de tabs
  void onTabSelected(int newIndex) {
    if (_currentlySelectedIndex == newIndex) {
      ///Zera a pilha de telas caso a tab seja selecionada novamente
      widget.navigationBarItems[newIndex].navigatorKey.currentState
          .popUntil((route) => route.isFirst);
    }

    ///Pelo que entendi, o Android precisa do setState para poder mudar de tab
    if (Platform.isAndroid) {
      setState(() {
        _currentlySelectedIndex = newIndex;
      });
    } else {
      _currentlySelectedIndex = newIndex;
    }
  }
}
