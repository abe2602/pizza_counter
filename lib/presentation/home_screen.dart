import 'package:domain/data_observables/banner_size.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/admob.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/adaptive_bottom_navigation_scaffold.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_colors.dart';
import 'package:pizza_counter/presentation/common/route_name_builder.dart';
import 'package:provider/provider.dart';

/// Não devemos instanciar os itens da BottomNavigation dentro do build, uma vez
/// que - ao chamar um modal - a tela é recriada e as GlobalKeys mudam, fazendo
/// com o estado de todas as telas sejam perdidos
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd bannerAd;
  List<BottomNavigationTab> _navigationBarItems;

  BannerAd buildBannerAd() => BannerAd(
        adUnitId: AddMobConfig.bannerId,
        targetingInfo: AddMobConfig.targetingInfo,
        size: AdSize.banner,
        listener: (event) {
          if (event == MobileAdEvent.failedToLoad ||
              event == MobileAdEvent.closed) {
            Provider.of<BannerSizeSink>(context, listen: false).add(0);
          } else if (event == MobileAdEvent.loaded) {
            Provider.of<BannerSizeSink>(context, listen: false)
                .add(AddMobConfig.bannerPadding);
          }
        },
      );

  @override
  void initState() {
    super.initState();
    // AddMobConfig é uma classe custom, escondida do git
    FirebaseAdMob.instance.initialize(appId: AddMobConfig.appId);
  }

  @override
  void didChangeDependencies() {
    // para instanciar o banner apenas uma vez
    if (_navigationBarItems == null) {
      bannerAd = buildBannerAd()
        ..load()
        ..show(
          anchorType: AnchorType.top,
          anchorOffset:
              MediaQuery.of(context).padding.top + AddMobConfig.bannerPadding,
        );
    }
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
  Widget build(BuildContext context) => AdaptiveBottomNavigationScaffold(
        navigationBarItems: _navigationBarItems,
      );

  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();
  }
}
