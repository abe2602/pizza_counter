import 'package:dio/dio.dart';
import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:domain/use_case/finish_game_uc.dart';
import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/add_player_uc.dart';
import 'package:domain/use_case/add_slice_uc.dart';
import 'package:domain/use_case/remove_slice_uc.dart';
import 'package:domain/use_case/delete_player_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart' hide Router;
import 'package:pizza_counter/data/cache/pizza_counter_cds.dart';
import 'package:pizza_counter/data/remote/pizza_counter_dio.dart';
import 'package:pizza_counter/data/repository/pizza_counter_repository.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/navigation_utils.dart';
import 'package:pizza_counter/presentation/common/route_name_builder.dart';
import 'package:pizza_counter/presentation/home_screen.dart';
import 'package:pizza_counter/presentation/users_charts/users_charts_page.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

class PizzaCounterGeneralProvider extends StatelessWidget {
  const PizzaCounterGeneralProvider({
    @required this.child,
  }) : assert(child != null);

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._buildStreamProviders(),
          ..._buildCDSProviders(),
          ..._buildRDSProviders(),
          ..._buildRepositoryProviders(),
          ..._buildUseCaseProviders(),
          ..._buildRouteFactory(),
        ],
        child: child,
      );

  List<SingleChildWidget> _buildRouteFactory() => [
        Provider<Router>(
          create: (context) => Router()
            ..define(
              '/',
              handler: Handler(
                handlerFunc: (context, params) => HomeScreen(),
              ),
            )
            ..define(
              RouteNameBuilder.pizzaCounterResource,
              handler: Handler(
                handlerFunc: (context, params) =>
                    PizzaCounterPage.create(context),
              ),
            )
            ..define(
              RouteNameBuilder.pizzaGraphResource,
              handler: Handler(
                handlerFunc: (context, params) =>
                    UsersChartsPage.create(context),
              ),
            ),
        ),
        //Com a atualização do Flutter, o método "generator" do Router ficou com
        //bugs. Para resolver isso, criei uma extension chamada
        // routeGeneratorFactory, com isso eu posso utilizar o meu generator
        // sempre que precisar.
        ProxyProvider<Router, RouteFactory>(
          update: (context, router, _) =>
              (settings) => router.routeGeneratorFactory(context, settings),
        ),
      ];

  List<SingleChildWidget> _buildStreamProviders() => [
        Provider<PublishSubject<void>>(
          create: (_) => PublishSubject<void>(),
          dispose: (context, playersSubject) => playersSubject.close(),
        ),
      ];

  List<SingleChildWidget> _buildCDSProviders() => [
        ProxyProvider<PublishSubject<void>, PizzaCounterCDS>(
          update: (context, playersSubject, _) => PizzaCounterCDS(
            playersDataObservableSink: playersSubject.sink,
          ),
        ),
      ];

  List<SingleChildWidget> _buildRDSProviders() => [
        Provider<Dio>(
          create: (context) {
            final options = BaseOptions(
              baseUrl: '',
            );
            return PizzaCounterDio(options);
          },
        ),
      ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
        ProxyProvider<PizzaCounterCDS, PizzaCounterDataRepository>(
          update: (context, pizzaCounterCDS, _) => PizzaCounterRepository(
            pizzaCounterCDS: pizzaCounterCDS,
          ),
        ),
      ];

  List<SingleChildWidget> _buildUseCaseProviders() => [
        ProxyProvider<PizzaCounterDataRepository, GetPlayersListUC>(
          update: (context, pizzaCounterDataRepository, _) => GetPlayersListUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        ProxyProvider<PizzaCounterDataRepository, AddSliceUC>(
          update: (context, pizzaCounterDataRepository, _) => AddSliceUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        ProxyProvider<PizzaCounterDataRepository, RemoveSliceUC>(
          update: (context, pizzaCounterDataRepository, _) => RemoveSliceUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        ProxyProvider<PizzaCounterDataRepository, AddPlayerUC>(
          update: (context, pizzaCounterDataRepository, _) => AddPlayerUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        ProxyProvider<PizzaCounterDataRepository, DeletePlayerUC>(
          update: (context, pizzaCounterDataRepository, _) => DeletePlayerUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        ProxyProvider<PizzaCounterDataRepository, FinishGameUC>(
          update: (context, pizzaCounterDataRepository, _) => FinishGameUC(
            pizzaCounterRepository: pizzaCounterDataRepository,
          ),
        ),
        Provider<ValidateEmptyTextUC>(
          create: (_) => ValidateEmptyTextUC(),
        ),
      ];
}
