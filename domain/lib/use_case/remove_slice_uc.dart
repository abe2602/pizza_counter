import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class RemoveSliceUC extends UseCase<RemoveSliceUCParams, void> {
  RemoveSliceUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<void> getRawFuture({RemoveSliceUCParams params}) =>
      pizzaCounterRepository.removeSlice(params.playerId);
}

class RemoveSliceUCParams {
  const RemoveSliceUCParams({
    @required this.playerId,
  }) : assert(playerId != null);

  final String playerId;
}
