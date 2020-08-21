import 'dart:async';

import 'package:domain/exceptions.dart';
import 'package:domain/model/player.dart';
import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:domain/use_case/add_player_uc.dart';
import 'package:domain/use_case/delete_player_uc.dart';
import 'package:domain/use_case/add_slice_uc.dart';
import 'package:domain/use_case/remove_slice_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';
import 'package:pizza_counter/presentation/common/view_utils.dart';
import 'package:pizza_counter/presentation/common/subscription_utils.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class PizzaCounterBloc with SubscriptionBag {
  PizzaCounterBloc({
    @required this.getPlayersListUC,
    @required this.addPlayerUC,
    @required this.deletePlayerUC,
    @required this.removeSliceUC,
    @required this.addSliceUC,
    @required this.validateEmptyTextUC,
  })  : assert(getPlayersListUC != null),
        assert(validateEmptyTextUC != null),
        assert(addPlayerUC != null) {
    MergeStream(
      [
        _getPlayers(),
      ],
    ).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _onNameFocusLostSubject
        .take(1)
        .listen(
          (_) => _buildPlayerNameValidationStream(_nameInputStatusSubject),
        )
        .addTo(subscriptionsBag);

    _onAddPlayerSubject.stream
        .flatMap(
          (_) => Future.wait(
            [
              _buildPlayerNameValidationStream(_nameInputStatusSubject).then(
                (value) => onNewActionSink.add(null),
              ),
            ],
            eagerError: false,
          ).asStream(),
        )
        .flatMap(
          (_) => _addPlayer(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);

    _onDeletePlayerSubject.stream
        .flatMap(
          _deletePlayer,
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);

    _onAddSliceSubject.stream
        .flatMap(
          _addSlice,
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);

    _onRemoveSliceSubject.stream
        .flatMap(
          _removeSlice,
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptionsBag);
  }

  final RemoveSliceUC removeSliceUC;
  final AddSliceUC addSliceUC;
  final DeletePlayerUC deletePlayerUC;
  final AddPlayerUC addPlayerUC;
  final GetPlayersListUC getPlayersListUC;
  final ValidateEmptyTextUC validateEmptyTextUC;
  final _onNameValueChangedSubject = BehaviorSubject<String>();
  final _onNewStateSubject = BehaviorSubject<PizzaCounterResponseState>();
  final _nameInputStatusSubject = PublishSubject<InputStatusVM>();
  final _onNameFocusLostSubject = PublishSubject<void>();
  final _onAddPlayerSubject = PublishSubject<PizzaCounterResponseState>();
  final _onAddPlayerActionSubject = PublishSubject<PizzaCounterResponseState>();
  final _onNewInputTextActionSubject = PublishSubject<InputStatusVM>();
  final _onDeletePlayerSubject = PublishSubject<String>();
  final _onTryAgainSubject = StreamController<void>();
  final _onAddSliceSubject = PublishSubject<String>();
  final _onRemoveSliceSubject = PublishSubject<String>();

  int _listSize = 0;

  Stream<PizzaCounterResponseState> get onNewState => _onNewStateSubject;

  Stream<InputStatusVM> get nameInputStatusStream =>
      _nameInputStatusSubject.stream;

  Stream<InputStatusVM> get onInputTextActionEvent =>
      _onNewInputTextActionSubject.stream.take(1);

  Stream<PizzaCounterResponseState> get onAddPlayerActionStream =>
      _onAddPlayerActionSubject;

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Sink<void> get onAddPlayerSink => _onAddPlayerSubject.sink;

  Sink<String> get onNameValueChangedSink => _onNameValueChangedSubject.sink;

  Sink<String> get onDeletePlayerSubject => _onDeletePlayerSubject.sink;

  Sink<String> get onAddSliceSubject => _onAddSliceSubject.sink;

  Sink<String> get onRemoveSliceSubject => _onRemoveSliceSubject.sink;

  Sink<void> get onNameFocusLostSink => _onNameFocusLostSubject.sink;

  Sink<void> get onNewActionSink => _onNewInputTextActionSubject.sink;

  String get nameValue => _onNameValueChangedSubject.stream.value;

  Stream<PizzaCounterResponseState> _getPlayers() async* {
    yield Loading();

    try {
      final playersList = await getPlayersListUC.getFuture();
      _listSize = playersList.length;

      yield Success(
        playersList: playersList,
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<PizzaCounterResponseState> _addPlayer() async* {
    if (_listSize == 0) {
      yield Loading();
    }

    try {
      await addPlayerUC.getFuture(
        params: AddPlayerUCParams(
          player: Player(id: Uuid().v1(), name: nameValue, slices: 0),
        ),
      );

      final playersList = await getPlayersListUC.getFuture();
      _listSize = playersList.length;

      //Every time a player is added i MUST clean the stream sink
      onNameValueChangedSink.add('');

      yield Success(
        playersList: playersList,
      );
    } catch (error) {
      if (error is NameAlreadyAddedException) {
        _onAddPlayerActionSubject.sink.add(NameAlreadyAddedError());
      } else {
        yield Error();
      }
    }
  }

  Stream<PizzaCounterResponseState> _deletePlayer(String playerId) async* {
    if (_listSize == 1) {
      yield Loading();
    }

    try {
      await deletePlayerUC.getFuture(
        params: DeletePlayerUCParams(
          playerId: playerId,
        ),
      );

      final playersList = await getPlayersListUC.getFuture();
      _listSize = playersList.length;

      yield Success(
        playersList: playersList,
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<PizzaCounterResponseState> _addSlice(String playerId) async* {
    try {
      await addSliceUC.getFuture(
        params: AddSliceUCParams(
          playerId: playerId,
        ),
      );

      final playersList = await getPlayersListUC.getFuture();
      _listSize = playersList.length;

      yield Success(
        playersList: playersList,
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<PizzaCounterResponseState> _removeSlice(String playerId) async* {
    try {
      await removeSliceUC.getFuture(
        params: RemoveSliceUCParams(
          playerId: playerId,
        ),
      );

      final playersList = await getPlayersListUC.getFuture();
      _listSize = playersList.length;

      yield Success(
        playersList: playersList,
      );
    } catch (e) {
      yield Error();
    }
  }

  Future<void> _buildPlayerNameValidationStream(Sink<InputStatusVM> sink) =>
      validateEmptyTextUC
          .getFuture(
            params: ValidateEmptyTextUCParams(nameValue),
          )
          .addStatusToSink(sink);

  void dispose() {
    _onAddPlayerActionSubject.close();
    _onRemoveSliceSubject.close();
    _onAddSliceSubject.close();
    _onDeletePlayerSubject.close();
    _onNewInputTextActionSubject.close();
    _onAddPlayerSubject.close();
    _nameInputStatusSubject.close();
    _onNameFocusLostSubject.close();
    _onNameValueChangedSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }
}
