import 'package:domain/model/player.dart';
import 'package:flutter/cupertino.dart';

abstract class PizzaCounterResponseState {}

class Success implements PizzaCounterResponseState {
  const Success({
    @required this.playersList,
  }) : assert(playersList != null);

  final List<Player> playersList;
}

class Loading implements PizzaCounterResponseState {}

class Error implements PizzaCounterResponseState {}

class GenericError implements Error {}

class NameAlreadyAddedError implements Error {}