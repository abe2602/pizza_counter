import 'package:domain/model/player.dart';
import 'package:flutter/foundation.dart';

abstract class UsersChartResponseState {}

class Success implements UsersChartResponseState {
  const Success({
    @required this.playersList,
    @required this.slicesNumber,
    @required this.playersPodium,
  })  : assert(playersList != null),
        assert(playersPodium != null),
        assert(slicesNumber != null);

  final List<Player> playersList;
  final List<Player> playersPodium;
  final int slicesNumber;
}

class Loading implements UsersChartResponseState {}

class Error implements UsersChartResponseState {}

class GenericError implements Error {}
