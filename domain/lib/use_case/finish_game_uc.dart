import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class FinishGameUC extends UseCase<void, void> {
  FinishGameUC({
    @required this.pizzaCounterRepository,
  }) : assert(pizzaCounterRepository != null);

  final PizzaCounterDataRepository pizzaCounterRepository;

  @override
  Future<void> getRawFuture({void params}) =>
      pizzaCounterRepository.finishGame();
}

