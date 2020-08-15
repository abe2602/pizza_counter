import '../model/player.dart';

abstract class PizzaCounterDataRepository {
  Future<List<Player>> getPlayersList();
  Future<void> addSlice(int playerId);
  Future<void> removeSlice(int playerId);
}