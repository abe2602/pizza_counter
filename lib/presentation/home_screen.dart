import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/admob.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/adaptive_bottom_navigation_scaffold.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_colors.dart';
import 'package:pizza_counter/presentation/common/route_name_builder.dart';

/// Não devemos instanciar os itens da BottomNavigation dentro do build, uma vez
/// que - ao chamar um modal - a tela é recriada e as GlobalKeys mudam, fazendo
/// com o estado de todas as telas sejam perdidos
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const targetingInfo = MobileAdTargetingInfo(
    testDevices: AddMobIds.appId != null ? [AddMobIds.appId] : null,
    keywords: [
      'food',
      'drink',
      'pizza',
    ],
  );
  BannerAd bannerAd;
  List<BottomNavigationTab> _navigationBarItems;

  BannerAd buildBannerAd() => BannerAd(
        adUnitId: AddMobIds.bannerId,
        targetingInfo: targetingInfo,
        size: AdSize.banner,
        listener: print,
      );

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AddMobIds.appId);
    bannerAd = buildBannerAd()..load();
  }

  @override
  void didChangeDependencies() {
    _navigationBarItems ??= [
      BottomNavigationTab(
        bottomNavigationBarItem: BottomNavigationBarItem(
          title: Text(
            S.of(context).pizzaCounterTabLabel,
          ),
          activeIcon: IconTheme(
            data: IconThemeData(color: PizzaCounterColors.sauceRed),
            child: const Icon(Icons.local_pizza),
          ),
          icon: const Icon(Icons.local_pizza),
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        initialRouteName: RouteNameBuilder.pizzaCounterResource,
      ),
      BottomNavigationTab(
        bottomNavigationBarItem: BottomNavigationBarItem(
          title: Text(
            S.of(context).pizzaChartsTabLabel,
          ),
          activeIcon: IconTheme(
            data: IconThemeData(color: PizzaCounterColors.sauceRed),
            child: const Icon(Icons.graphic_eq),
          ),
          icon: const Icon(Icons.graphic_eq),
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        initialRouteName: RouteNameBuilder.pizzaGraphResource,
      ),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bannerAd
      ..load()
      ..show();
    return SafeArea(
      child: AdaptiveBottomNavigationScaffold(
        navigationBarItems: _navigationBarItems,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();
  }
}
