import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:domain/model/player.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class AddPlayerUC extends UseCase<AddPlayerUCParams, void> {
  AddPlayerUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<void> getRawFuture({AddPlayerUCParams params}) =>
      pizzaCounterRepository.addPlayer(params.player);
}

class AddPlayerUCParams {
  const AddPlayerUCParams({
    @required this.player,
  }) : assert(player != null);

  final Player player;
}
