import 'package:domain/exceptions.dart';
import 'package:hive/hive.dart';

import 'model/player_cm.dart';

class PizzaCounterCDS {
  static const _playersBoxKey = 'playersBoxKey';

  Future<Box> _openPlayersListBox() => Hive.openBox(_playersBoxKey);

  Future<List<PlayerCM>> getPlayersList() => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList = box.get(_playersBoxKey);

          if(playersList == null) {
            throw EmptyCachedListException();
          } else {
            return playersList;
          }
        }
      );

  Future<void> addSlice(int playerId) => null;

  Future<void> removeSlice(int playerId) => null;
}