import '../model/player.dart';

abstract class PizzaCounterDataRepository {
  Future<List<Player>> getPlayersList();
  Future<void> addPlayer(Player player);
  Future<void> deletePlayer(String playerId);
  Future<void> addSlice(String playerId);
  Future<void> removeSlice(String playerId);
}