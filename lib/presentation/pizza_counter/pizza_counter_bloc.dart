import 'dart:async';

import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:flutter/foundation.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';
import 'package:pizza_counter/presentation/common/view_utils.dart';
import 'package:pizza_counter/presentation/common/subscription_utils.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_models.dart';
import 'package:rxdart/rxdart.dart';

class PizzaCounterBloc with SubscriptionBag {
  PizzaCounterBloc({
    @required this.getPlayersListUC,
    @required this.validateEmptyTextUC,
  })  : assert(getPlayersListUC != null),
        assert(validateEmptyTextUC != null) {
    MergeStream(
      [
        _getPlayers(),
      ],
    ).listen(_onNewStateSubject.add).addTo(subscriptionsBag);

    _onNameFocusLostSubject
        .listen(
          (_) => _buildPlayerNameValidationStream(_nameInputStatusSubject),
        )
        .addTo(subscriptionsBag);

    _onAddPlayerSubject.stream
        .flatMap(
          (_) => Future.wait(
            [
              _buildPlayerNameValidationStream(_nameInputStatusSubject),
            ],
            eagerError: false,
          ).asStream(),
        )
        .flatMap(
          (_) => _addPlayer(),
        )
        .listen((_) {})
        .addTo(subscriptionsBag);
  }

  final GetPlayersListUC getPlayersListUC;
  final ValidateEmptyTextUC validateEmptyTextUC;
  final _onNameValueChangedSubject = BehaviorSubject<String>();
  final _onNewStateSubject = BehaviorSubject<PizzaCounterResponseState>();
  final _nameInputStatusSubject = PublishSubject<InputStatusVM>();
  final _onNameFocusLostSubject = PublishSubject<void>();
  final _onAddPlayerSubject = PublishSubject<PizzaCounterResponseState>();
  final _onNewActionSubject = PublishSubject<InputStatusVM>();
  final _onTryAgainSubject = StreamController<void>();

  Stream<PizzaCounterResponseState> get onNewState => _onNewStateSubject;

  Stream<InputStatusVM> get nameInputStatusStream =>
      _nameInputStatusSubject.stream;

  Stream<InputStatusVM> get onActionEvent => _onNewActionSubject.stream.take(1);

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Sink<void> get onAddPlayerSink => _onAddPlayerSubject.sink;

  Sink<String> get onNameValueChangedSink => _onNameValueChangedSubject.sink;

  Sink<void> get onNameFocusLostSink => _onNameFocusLostSubject.sink;

  Sink<void> get onNewActionSink => _onNewActionSubject.sink;

  String get nameValue => _onNameValueChangedSubject.stream.value;

  Stream<PizzaCounterResponseState> _getPlayers() async* {
    yield Loading();

    try {
      yield Success(
        playersList: await getPlayersListUC.getFuture(),
      );
    } catch (e) {
      print(e.toString());
      yield Error();
    }
  }

  Stream<PizzaCounterResponseState> _addPlayer() async* {
    yield Loading();
  }

  Future<void> _buildPlayerNameValidationStream(Sink<InputStatusVM> sink) =>
      validateEmptyTextUC
          .getFuture(
            params: ValidateEmptyTextUCParams(nameValue),
          )
          .addStatusToSink(sink, onNewActionSink);

  void dispose() {
    _onNewActionSubject.close();
    _onAddPlayerSubject.close();
    _nameInputStatusSubject.close();
    _onNameFocusLostSubject.close();
    _onNameValueChangedSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }
}
