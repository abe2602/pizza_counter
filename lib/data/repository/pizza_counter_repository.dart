import 'dart:core';

import 'package:domain/data_repository/pizza_counter_data_repository.dart';
import 'package:domain/exceptions.dart';
import 'package:domain/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:pizza_counter/data/cache/pizza_counter_cds.dart';
import 'package:pizza_counter/data/cache/mappers/domain_to_cache.dart';
import 'package:pizza_counter/data/cache/mappers/cache_to_domain.dart';

class PizzaCounterRepository implements PizzaCounterDataRepository {
  const PizzaCounterRepository({
    @required this.pizzaCounterCDS,
  }) : assert(pizzaCounterCDS != null);

  final PizzaCounterCDS pizzaCounterCDS;

  @override
  Future<List<Player>> getPlayersList() =>
      pizzaCounterCDS
          .getPlayersList()
          .then(
            (playerList) => playerList.toDM(),
      )
          .catchError(
            (error) {
          if (error is EmptyCachedListException) {
            return <Player>[];
          } else {
            throw error;
          }
        },
      );

  @override
  Future<void> addSlice(String playerId) => pizzaCounterCDS.addSlice(playerId);

  @override
  Future<void> removeSlice(String playerId) =>
      pizzaCounterCDS.removeSlice(playerId);

  @override
  Future<void> addPlayer(Player player) =>
      pizzaCounterCDS.addPlayer(
        player.toCM(),
      );

  @override
  Future<void> deletePlayer(String playerId) =>
      pizzaCounterCDS.deletePlayer(playerId);

  @override
  Future<void> finishGame() =>
      pizzaCounterCDS.finishGame();
}
