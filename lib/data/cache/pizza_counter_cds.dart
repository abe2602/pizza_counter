import 'package:domain/exceptions.dart';
import 'package:hive/hive.dart';

import 'model/player_cm.dart';

class PizzaCounterCDS {
  static const _playersBoxKey = 'playersBoxKey';

  Future<Box> _openPlayersListBox() => Hive.openBox(_playersBoxKey);

  Future<List<PlayerCM>> getPlayersList() => _openPlayersListBox().then((box) {
        final List<PlayerCM> playersList =
            box.get(_playersBoxKey)?.cast<PlayerCM>();

        if (playersList == null) {
          throw EmptyCachedListException();
        } else {
          playersList.sort(
            (p1, p2) => p1.name.compareTo(p2.name),
          );
          return playersList;
        }
      });

  Future<void> addPlayer(PlayerCM player) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            return box.put(_playersBoxKey, <PlayerCM>[player]);
          } else {
            playersList.add(player);
            return box.put(_playersBoxKey, playersList);
          }
        },
      );

  Future<void> deletePlayer(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            return EmptyCachedListException();
          } else {
            playersList.removeWhere((player) => player.id == playerId);
            return box.put(_playersBoxKey, playersList);
          }
        },
      );

  Future<void> addSlice(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
          box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            return EmptyCachedListException();
          } else {
            final p = playersList
                .where((player) => player.id == playerId)
                .map(
                  (player) => player,
            )
                .toList()[0];

            playersList
              ..remove(p)
              ..add(
                PlayerCM(id: p.id, slices: p.slices + 1, name: p.name),
              );

            return box.put(_playersBoxKey, playersList);
          }
        },
      );

  Future<void> removeSlice(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            return EmptyCachedListException();
          } else {
            final p = playersList
                .where((player) => player.id == playerId)
                .map(
                  (player) => player,
                )
                .toList()[0];

            playersList
              ..remove(p)
              ..add(
                PlayerCM(id: p.id, slices: p.slices - 1, name: p.name),
              );

            return box.put(_playersBoxKey, playersList);
          }
        },
      );
}
