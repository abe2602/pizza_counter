import 'package:domain/model/player.dart';
import 'package:flutter/foundation.dart';
import 'package:pizza_counter/presentation/common/subscription_utils.dart';
import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:pizza_counter/presentation/users_charts/users_charts_models.dart';
import 'package:rxdart/rxdart.dart';

class UsersChartsBloc with SubscriptionBag {
  UsersChartsBloc({
    @required this.getPlayersListUC,
    @required this.playersDataObservableStream,
  })  : assert(getPlayersListUC != null),
        assert(playersDataObservableStream != null) {
    MergeStream([
      playersDataObservableStream.flatMap(
        (value) => _upsertPlayersInformation(),
      ),
      _getPlayersInformation(),
    ]).listen(_onNewStateSubject.add);
  }

  final GetPlayersListUC getPlayersListUC;
  final _onNewStateSubject = BehaviorSubject<UsersChartResponseState>();
  final Stream<void> playersDataObservableStream;

  Stream<UsersChartResponseState> get onNewState => _onNewStateSubject;

  Stream<UsersChartResponseState> _getPlayersInformation() async* {
    yield Loading();

    try {
      final playersList = await getPlayersListUC.getFuture();
      playersList.sort(
        (a, b) => b.slices.compareTo(a.slices),
      );

      final playersPodium = playersList.length >= 3
          ? playersList.sublist(0, 3).toList()
          : playersList;

      yield Success(
        playersList: playersList,
        playersPodium: playersPodium,
        slicesNumber: playersList.isNotEmpty ?
            playersList.map((e) => e.slices).reduce((v1, v2) => v1 + v2) : 0,
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<UsersChartResponseState> _upsertPlayersInformation() async* {
    try {
      final playersList = await getPlayersListUC.getFuture();
      playersList.sort(
        (a, b) => b.slices.compareTo(a.slices),
      );

      final playersPodium = playersList.length >= 3
          ? playersList.sublist(0, 3).toList()
          : playersList;

      yield Success(
        playersList: playersList,
        playersPodium: playersPodium,
        slicesNumber: playersList.isNotEmpty ?
        playersList.map((e) => e.slices).reduce((v1, v2) => v1 + v2) : 0,
      );
    } catch (e) {
      yield Error();
    }
  }

  void dispose() {
    _onNewStateSubject.close();
  }
}
