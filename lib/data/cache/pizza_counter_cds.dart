import 'dart:collection';

import 'package:domain/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'model/player_cm.dart';

class PizzaCounterCDS {
  PizzaCounterCDS({
    @required this.playersDataObservableSink,
  }) : assert(playersDataObservableSink != null);
  static const _playersBoxKey = 'playersBoxKey';

  final Sink<void> playersDataObservableSink;

  Future<Box> _openPlayersListBox() => Hive.openBox(_playersBoxKey);

  Future<List<PlayerCM>> getPlayersList() => _openPlayersListBox().then((box) {
        final List<PlayerCM> playersList =
            box.get(_playersBoxKey)?.cast<PlayerCM>();

        if (playersList == null || playersList.isEmpty) {
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
            if(playersList.map((player) => player.name).contains(player.name)) {
              throw NameAlreadyAddedException();
            } else {
              playersList.add(player);
              playersDataObservableSink.add(null);
              return box.put(_playersBoxKey, playersList);
            }
          }
        },
      );

  Future<void> deletePlayer(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            throw EmptyCachedListException();
          } else {
            playersList.removeWhere((player) => player.id == playerId);
            playersDataObservableSink.add(null);
            return box.put(_playersBoxKey, playersList);
          }
        },
      );

  Future<void> finishGame() => _openPlayersListBox().then(
        (box) {
      final List<PlayerCM> playersList =
      box.get(_playersBoxKey)?.cast<PlayerCM>();

      playersDataObservableSink.add(null);
      
      if (playersList != null) {
        return box.delete(_playersBoxKey);
      } else {
        return Future.value(null);
      }
    },
  );

  Future<void> addSlice(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            throw EmptyCachedListException();
          } else {
            final newPlayersList = playersList
                .where((player) => player.id == playerId)
                .map(
                  (player) => player,
                )
                .toList()[0];

            playersList
              ..remove(newPlayersList)
              ..add(
                PlayerCM(
                    id: newPlayersList.id,
                    slices: newPlayersList.slices + 1,
                    name: newPlayersList.name),
              );
            playersDataObservableSink.add(null);
            return box.put(_playersBoxKey, playersList);
          }
        },
      );

  Future<void> removeSlice(String playerId) => _openPlayersListBox().then(
        (box) {
          final List<PlayerCM> playersList =
              box.get(_playersBoxKey)?.cast<PlayerCM>();

          if (playersList == null) {
            throw EmptyCachedListException();
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
            playersDataObservableSink.add(null);
            return box.put(_playersBoxKey, playersList);
          }
        },
      );
}
