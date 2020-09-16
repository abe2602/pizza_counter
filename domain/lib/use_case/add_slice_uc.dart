import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class AddSliceUC extends UseCase<AddSliceUCParams, void> {
  AddSliceUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<void> getRawFuture({AddSliceUCParams params}) =>
      pizzaCounterRepository.addSlice(params.playerId);
}

class AddSliceUCParams {
  const AddSliceUCParams({
    @required this.playerId,
  }) : assert(playerId != null);

  final String playerId;
}
