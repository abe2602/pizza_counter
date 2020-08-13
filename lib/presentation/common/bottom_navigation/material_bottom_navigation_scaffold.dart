import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_tab.dart';

class MaterialBottomNavigationScaffold extends StatefulWidget {
  const MaterialBottomNavigationScaffold({
    @required this.navigationBarItems,
    @required this.onItemSelected,
    @required this.selectedIndex,
    Key key,
  })  : assert(navigationBarItems != null),
        assert(onItemSelected != null),
        assert(selectedIndex != null),
        super(key: key);

  /// List of the tabs to be displayed with their respective navigator's keys.
  final List<BottomNavigationTab> navigationBarItems;

  /// Called when a tab selection occurs.
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  @override
  _MaterialBottomNavigationScaffoldState createState() =>
      _MaterialBottomNavigationScaffoldState();
}

class _MaterialBottomNavigationScaffoldState
    extends State<MaterialBottomNavigationScaffold>
    with TickerProviderStateMixin<MaterialBottomNavigationScaffold> {
  final List<_MaterialBottomNavigationTab> materialNavigationBarItems = [];
  final List<AnimationController> _animationControllers = [];

  /// Controls which tabs should have its content built. This enables us to
  /// lazy instantiate it.
  final List<bool> _shouldBuildTab = <bool>[];

  @override
  void initState() {
    _initAnimationControllers();
    _initMaterialNavigationBarItems();

    _shouldBuildTab.addAll(List<bool>.filled(
      widget.navigationBarItems.length,
      false,
    ));

    super.initState();
  }

  void _initMaterialNavigationBarItems() {
    materialNavigationBarItems.addAll(
      widget.navigationBarItems
          .map(
            (barItem) => _MaterialBottomNavigationTab(
              bottomNavigationBarItem: barItem.bottomNavigationBarItem,
              navigatorKey: barItem.navigatorKey,
              subtreeKey: GlobalKey(),
              initialRouteName: barItem.initialRouteName,
            ),
          )
          .toList(),
    );
  }

  void _initAnimationControllers() {
    _animationControllers.addAll(
      widget.navigationBarItems.map<AnimationController>(
        (destination) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );

    if (_animationControllers.isNotEmpty) {
      _animationControllers[0].value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationControllers.forEach(
      (controller) => controller.dispose(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: materialNavigationBarItems
              .map(
                (barItem) => _PageFlow(
                  item: barItem,
                  tabIndex: materialNavigationBarItems.indexOf(barItem),
                  selectedIndex: widget.selectedIndex,
                  animationControllers: _animationControllers,
                  shouldBuildTab: _shouldBuildTab,
                  isCurrentlySelected:
                      materialNavigationBarItems.indexOf(barItem) ==
                          widget.selectedIndex,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          items: materialNavigationBarItems
              .map(
                (item) => item.bottomNavigationBarItem,
              )
              .toList(),
          onTap: widget.onItemSelected,
        ),
      );
}

class _PageFlow extends StatelessWidget {
  const _PageFlow(
      {@required this.tabIndex,
      @required this.selectedIndex,
      @required this.item,
      @required this.isCurrentlySelected,
      @required this.shouldBuildTab,
      @required this.animationControllers});

  final int tabIndex, selectedIndex;
  final _MaterialBottomNavigationTab item;
  final List<bool> shouldBuildTab;
  final bool isCurrentlySelected;
  final List<AnimationController> animationControllers;

  @override
  Widget build(BuildContext context) {
    // We should build the tab content only if it was already built or
    // if it is currently selected.
    shouldBuildTab[tabIndex] = isCurrentlySelected || shouldBuildTab[tabIndex];

    final Widget view = FadeTransition(
      opacity: animationControllers[tabIndex].drive(
        CurveTween(curve: Curves.fastOutSlowIn),
      ),
      child: KeyedSubtree(
        key: item.subtreeKey,
        child: shouldBuildTab[tabIndex]
            ? Navigator(
                // The key enables us to access the Navigator's state inside the
                // onWillPop callback and for emptying its stack when a tab is
                // re-selected. That is why a GlobalKey is needed instead of
                // a simpler ValueKey.
                key: item.navigatorKey,
                initialRoute: item.initialRouteName,
                onGenerateRoute:
                    Provider.of<RouteFactory>(context, listen: false),
              )
            : Container(),
      ),
    );

    if (tabIndex == selectedIndex) {
      animationControllers[tabIndex].forward(); //fade in
      return view;
    } else {
      animationControllers[tabIndex].reverse(); //fade out
      if (animationControllers[tabIndex].isAnimating) {
        //while animating, interactions are off
        return IgnorePointer(child: view);
      }
      return Offstage(child: view);
    }
  }
}

/// Extension class of BottomNavigationTab that adds another GlobalKey to it
/// in order to use it within the KeyedSubtree widget.
class _MaterialBottomNavigationTab extends BottomNavigationTab {
  const _MaterialBottomNavigationTab({
    @required BottomNavigationBarItem bottomNavigationBarItem,
    @required GlobalKey<NavigatorState> navigatorKey,
    @required String initialRouteName,
    @required this.subtreeKey,
  })  : assert(bottomNavigationBarItem != null),
        assert(subtreeKey != null),
        assert(initialRouteName != null),
        assert(navigatorKey != null),
        super(
          bottomNavigationBarItem: bottomNavigationBarItem,
          navigatorKey: navigatorKey,
          initialRouteName: initialRouteName,
        );

  final GlobalKey subtreeKey;
}
