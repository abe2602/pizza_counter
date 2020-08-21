import 'package:domain/model/player.dart';
import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grafpix/icons.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:grafpix/pixbuttons/medal.dart';
import 'package:pizza_counter/presentation/common/async_snapshot_response_view.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_colors.dart';
import 'package:pizza_counter/presentation/users_charts/users_charts_bloc.dart';
import 'package:pizza_counter/presentation/users_charts/users_charts_models.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:rxdart/rxdart.dart';

class UsersChartsPage extends StatelessWidget {
  const UsersChartsPage({
    @required this.bloc,
    Key key,
  })  : assert(bloc != null),
        super(key: key);

  static Widget create(BuildContext context) =>
      ProxyProvider2<GetPlayersListUC, PublishSubject<void>, UsersChartsBloc>(
        update:
            (context, getPlayersListUC, playersDataObservableStream, bloc) =>
                bloc ??
                UsersChartsBloc(
                  getPlayersListUC: getPlayersListUC,
                  playersDataObservableStream: playersDataObservableStream,
                ),
        child: Consumer<UsersChartsBloc>(
          builder: (context, bloc, _) => UsersChartsPage(
            bloc: bloc,
          ),
        ),
      );

  final UsersChartsBloc bloc;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).pizzaChartsTabLabel,
            maxLines: 1,
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              successWidgetBuilder: (successState) {
                if (successState.playersList.isEmpty) {
                  return NoUsersEmptyState();
                } else {
                  final _chartData = <String, double>{};

                  successState.playersList.forEach((player) {
                    _chartData.putIfAbsent(
                      player.name,
                      () => player.slices.toDouble(),
                    );
                  });

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          ...successState.playersPodium
                              .asMap()
                              .map((index, player) {
                                MedalType type;
                                if (index == 0) {
                                  type = MedalType.Gold;
                                } else if (index == 1) {
                                  type = MedalType.Silver;
                                } else {
                                  type = MedalType.Bronze;
                                }

                                return MapEntry(
                                  index,
                                  Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                          ),
                                          child: PixMedal(
                                            icon: PixIcon.shopware,
                                            medalType: type,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4),
                                          child: Text(
                                            player.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ],
                      ),
                      PizzaChart(
                        playersList: successState.playersList,
                        chartData: _chartData,
                      ),
                    ],
                  );
                }
              },
              errorWidgetBuilder: (errorState) => Text('Eita nois'),
            ),
          ),
        ),
      );
}

class NoUsersEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 170,
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    S.of(context).noPodiumEmptyStatePrimaryText,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: PizzaCounterColors.mediumGray,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    S.of(context).noPodiumEmptyStateSecondaryText,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: PizzaCounterColors.mediumGray,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Image.asset('images/podium.png'),
            ],
          ),
        ),
      );
}

class PizzaChart extends StatefulWidget {
  const PizzaChart({
    @required this.playersList,
    @required this.chartData,
  })  : assert(playersList != null);

  final List<Player> playersList;
  final Map<String, double> chartData;

  @override
  _PizzaChartState createState() => _PizzaChartState();
}

class _PizzaChartState extends State<PizzaChart> {
  final _colorLuminosity = ColorBrightness.random;
  final _colorSaturation = ColorSaturation.random;
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];
  List<Color> colorList = [];

  @override
  void didChangeDependencies() {
    widget.playersList.forEach((player) {
      colorList.add(
        RandomColor().randomColor(
            colorHue: ColorHue.multiple(colorHues: _hueType),
            colorSaturation: _colorSaturation,
            colorBrightness: _colorLuminosity),
      );
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Center(
          child: PieChart(
            dataMap: widget.chartData,
            animationDuration: const Duration(milliseconds: 1000),
            chartLegendSpacing: 40,
            chartRadius: MediaQuery.of(context).size.width / 2,
            showChartValuesInPercentage: false,
            showChartValues: true,
            showChartValuesOutside: false,
            chartValueBackgroundColor: Colors.grey[200],
            colorList: colorList,
            showLegends: true,
            legendPosition: LegendPosition.right,
            decimalPlaces: 1,
            showChartValueLabel: true,
            initialAngle: 0,
            chartValueStyle: defaultChartValueStyle.copyWith(
              color: Colors.blueGrey[900].withOpacity(0.9),
            ),
            chartType: ChartType.disc,
          ),
        ),
      );
}