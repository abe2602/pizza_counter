import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_tab.dart';

class CupertinoBottomNavigationScaffold extends StatelessWidget {
  const CupertinoBottomNavigationScaffold({
    @required this.navigationBarItems,
    @required this.onItemSelected,
    @required this.selectedIndex,
    Key key,
  })  : assert(navigationBarItems != null),
        assert(onItemSelected != null),
        assert(selectedIndex != null),
        super(key: key);

  final List<BottomNavigationTab> navigationBarItems;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  ///Diferente do Material, o Cupertino não precisa fazer o "truque" com o
  ///IndexedStack
  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        controller: CupertinoTabController(initialIndex: selectedIndex),
        tabBar: CupertinoTabBar(
          items: navigationBarItems
              .map(
                (item) => item.bottomNavigationBarItem,
              )
              .toList(),
          onTap: onItemSelected,
        ),
        tabBuilder: (context, index) {
          final barItem = navigationBarItems[index];
          return CupertinoTabView(
            navigatorKey: barItem.navigatorKey,
            onGenerateRoute: (settings) {
              final routeFactory = Provider.of<RouteFactory>(
                context,
                listen: false,
              );
              if (settings.name == '/') {
                return routeFactory(
                  settings.copyWith(name: barItem.initialRouteName),
                );
              } else {
                return routeFactory(settings);
              }
            },
          );
        },
      );
}
