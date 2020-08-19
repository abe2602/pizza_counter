import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class DeletePlayerUC extends UseCase<DeletePlayerUCParams, void> {
  DeletePlayerUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<void> getRawFuture({DeletePlayerUCParams params}) =>
      pizzaCounterRepository.deletePlayer(params.playerId);
}

class DeletePlayerUCParams {
  const DeletePlayerUCParams({
    @required this.playerId,
  }) : assert(playerId != null);

  final String playerId;
}
