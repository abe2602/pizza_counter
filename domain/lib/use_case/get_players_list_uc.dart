import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:domain/model/player.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class GetPlayersListUC extends UseCase<void, List<Player>> {
  GetPlayersListUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<List<Player>> getRawFuture({void params}) =>
      pizzaCounterRepository.getPlayersList();
}