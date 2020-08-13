import 'package:dio/dio.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:domain/use_case/validate_full_name_uc.dart';
import 'package:domain/use_case/validate_password_confirmation_uc.dart';
import 'package:domain/use_case/validate_password_uc.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pizza_counter/data/remote/televi_dio.dart';
import 'package:pizza_counter/presentation/common/bottom_navigation/navigation_utils.dart';
import 'package:pizza_counter/presentation/common/route_name_builder.dart';
import 'package:pizza_counter/presentation/home_screen.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_page.dart';
import 'package:pizza_counter/presentation/pizza_graphs/pizza_graphs_page.dart';

class TeleviGeneralProvider extends StatelessWidget {
  const TeleviGeneralProvider({
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
            )..define(
              RouteNameBuilder.pizzaGraphResource,
              handler: Handler(
                handlerFunc: (context, params) =>
                    PizzaGraphsPage.create(context),
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
        Provider<PublishSubject<List<int>>>(
          create: (_) => PublishSubject<List<int>>(),
          dispose: (context, listDataObservable) => listDataObservable.close(),
        ),
      ];

  List<SingleChildWidget> _buildCDSProviders() => [
      ];

  List<SingleChildWidget> _buildRDSProviders() => [
        Provider<Dio>(
          create: (context) {
            final options = BaseOptions(
              baseUrl:
                  'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies',
            );

            return TeleviDio(options);
          },
        ),
      ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
      ];

  List<SingleChildWidget> _buildUseCaseProviders() => [
        Provider<ValidateFullNameUC>(
          create: (_) => ValidateFullNameUC(),
        ),
        Provider<ValidateEmailUC>(
          create: (_) => ValidateEmailUC(),
        ),
        Provider<ValidatePasswordUC>(
          create: (_) => ValidatePasswordUC(),
        ),
        Provider<ValidatePasswordConfirmationUC>(
          create: (_) => ValidatePasswordConfirmationUC(),
        ),
      ];
}
