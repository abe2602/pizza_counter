import 'package:domain/model/player.dart';
import 'package:domain/use_case/add_player_uc.dart';
import 'package:domain/use_case/add_slice_uc.dart';
import 'package:domain/use_case/delete_player_uc.dart';
import 'package:domain/use_case/finish_game_uc.dart';
import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/remove_slice_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/async_snapshot_response_view.dart';
import 'package:pizza_counter/presentation/common/form_text_field.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_action_listener.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_colors.dart';
import 'package:pizza_counter/presentation/common/view_utils.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_bloc.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_models.dart';
import 'package:provider/provider.dart';

class PizzaCounterPage extends StatelessWidget {
  const PizzaCounterPage({
    @required this.bloc,
    Key key,
  })  : assert(bloc != null),
        super(key: key);

  static Widget create(BuildContext context) => ProxyProvider6<
          GetPlayersListUC,
          ValidateEmptyTextUC,
          AddPlayerUC,
          DeletePlayerUC,
          AddSliceUC,
          RemoveSliceUC,
          PizzaCounterBloc>(
        update: (
          context,
          getPlayersListUC,
          validateEmptyTextUC,
          addPlayerUC,
          deletePlayerUC,
          addSliceUC,
          removeSliceUC,
          bloc,
        ) =>
            bloc ??
            PizzaCounterBloc(
              getPlayersListUC: getPlayersListUC,
              validateEmptyTextUC: validateEmptyTextUC,
              addPlayerUC: addPlayerUC,
              deletePlayerUC: deletePlayerUC,
              addSliceUC: addSliceUC,
              removeSliceUC: removeSliceUC,
              finishGameUC: Provider.of<FinishGameUC>(context),
            ),
        child: Consumer<PizzaCounterBloc>(
          builder: (context, bloc, _) => PizzaCounterPage(
            bloc: bloc,
          ),
        ),
      );

  final PizzaCounterBloc bloc;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).appTitle,
            maxLines: 1,
          ),
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  child: PizzaCounterDialog(
                    onInputTextChangedSink: bloc.onNameValueChangedSink,
                    onInputTextStatusStream: bloc.nameInputStatusStream,
                    onInputTextLostFocusSink: bloc.onNameFocusLostSink,
                    onActionButtonSink: bloc.onAddPlayerSink,
                    onActionEventStream: bloc.onInputTextActionEvent,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                child: const Icon(Icons.person_add),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: PizzaCounterActionListener(
            actionStream: bloc.onAddPlayerActionStream,
            onReceived: (event) {
              if (event is NameAlreadyAddedError) {
                showDialog(
                  context: context,
                  child: SingleActionDialog(
                    title: S.of(context).playerAlreadyAddedLabel,
                  ),
                );
              }
            },
            child: StreamBuilder(
              stream: bloc.onNewState,
              builder: (context, snapshot) =>
                  AsyncSnapshotResponseView<Loading, Error, Success>(
                snapshot: snapshot,
                successWidgetBuilder: (successState) {
                  if (successState.playersList.isEmpty) {
                    return NoPlayersEmptyState(
                      bloc: bloc,
                    );
                  } else {
                    return Container(
                      //color: PizzaCounterColors.orange,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: false,
                              //vai ocupar os espaços que precisa e nada mais
                              children: List.generate(
                                successState.playersList.length,
                                (index) => PlayerCard(
                                  player: successState.playersList[index],
                                  bloc: bloc,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                              ),
                              child: FlatButton(
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    child: SingleActionDialog(
                                      title: S
                                          .of(context)
                                          .finishGameConfirmationLabel,
                                      primaryButtonAction: () {
                                        bloc.onFinishGameSink.add(null);
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  S.of(context).finishRound,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                errorWidgetBuilder: (errorState) => Text(
                  errorState.toString(),
                ),
              ),
            ),
          ),
        ),
      );
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    @required this.bloc,
    @required this.player,
  })  : assert(bloc != null),
        assert(player != null);

  final PizzaCounterBloc bloc;
  final Player player;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        child: DeletePlayerConfirmationDialog(
                          primaryButtonAction: () {
                            bloc.onDeletePlayerSubject.add(player.id);
                          },
                        ),
                      );
                    },
                    child: Image.asset('images/red_delete.png'),
                  ),
                ),
                Text(player.name),
                Text(
                  player.slices.toString(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          if (player.slices > 0) {
                            bloc.onRemoveSliceSubject.add(player.id);
                          }
                        },
                        child: Text(
                          S.of(context).minus,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: (MediaQuery.of(context).size.width +
                                    MediaQuery.of(context).size.height) /
                                45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 2.5, left: 2.5),
                    ),
                    Expanded(
                      child: FlatButton(
                        color: Colors.red,
                        onPressed: () {
                          bloc.onAddSliceSubject.add(player.id);
                        },
                        child: Text(
                          S.of(context).plus,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.width +
                                    MediaQuery.of(context).size.height) /
                                45,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}

class NoPlayersEmptyState extends StatelessWidget {
  const NoPlayersEmptyState({
    @required this.bloc,
  }) : assert(bloc != null);

  final PizzaCounterBloc bloc;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 170,
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    S.of(context).noPlayersEmptyStatePrimaryText,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: PizzaCounterColors.mediumGray,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    S.of(context).noPlayersEmptyStateSecondaryText,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: PizzaCounterColors.mediumGray,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Image.asset('images/pizza.png'),
              FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    child: PizzaCounterDialog(
                      onInputTextChangedSink: bloc.onNameValueChangedSink,
                      onInputTextStatusStream: bloc.nameInputStatusStream,
                      onInputTextLostFocusSink: bloc.onNameFocusLostSink,
                      onActionButtonSink: bloc.onAddPlayerSink,
                      onActionEventStream: bloc.onInputTextActionEvent,
                    ),
                  );
                },
                color: Colors.red,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    S.of(context).addPlayerLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class SingleActionDialog extends StatelessWidget {
  const SingleActionDialog({
    @required this.title,
    this.primaryButtonAction,
  });

  final String title;
  final Function primaryButtonAction;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: PizzaCounterColors.mediumGray,
                  fontSize: (MediaQuery.of(context).size.width +
                          MediaQuery.of(context).size.height) /
                      50,
                ),
              ),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                if (primaryButtonAction != null) {
                  primaryButtonAction();
                }

                Navigator.pop(context);
              },
              child: Text(
                S.of(context).okLabel,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
}

class DeletePlayerConfirmationDialog extends StatelessWidget {
  const DeletePlayerConfirmationDialog({
    @required this.primaryButtonAction,
  }) : assert(primaryButtonAction != null);

  final Function primaryButtonAction;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              alignment: Alignment.center,
              child: Text(
                S.of(context).deletePlayerConfirmationLabel,
                style: TextStyle(
                  color: PizzaCounterColors.mediumGray,
                  fontSize: (MediaQuery.of(context).size.width +
                          MediaQuery.of(context).size.height) /
                      50,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).cancelLabel,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: () {
                      primaryButtonAction();
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).deleteLabel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class PizzaCounterDialog extends StatefulWidget {
  const PizzaCounterDialog({
    @required this.onInputTextChangedSink,
    @required this.onInputTextLostFocusSink,
    @required this.onInputTextStatusStream,
    @required this.onActionEventStream,
    @required this.onActionButtonSink,
  })  : assert(onInputTextChangedSink != null),
        assert(onInputTextLostFocusSink != null),
        assert(onInputTextStatusStream != null);

  final Sink<String> onInputTextChangedSink;
  final Sink<void> onInputTextLostFocusSink;
  final Sink<void> onActionButtonSink;
  final Stream<void> onActionEventStream;
  final Stream<InputStatusVM> onInputTextStatusStream;

  @override
  State<StatefulWidget> createState() => PizzaCounterDialogState();
}

class PizzaCounterDialogState extends State<PizzaCounterDialog> {
  final _nameFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    _nameFocusNode
        .addFocusLostListener(() => widget.onInputTextLostFocusSink.add(null));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => PizzaCounterActionListener(
        actionStream: widget.onActionEventStream,
        onReceived: (event) {
          Navigator.of(context).pop();
        },
        child: AlertDialog(
          title: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).addPlayerLabel,
                  style: TextStyle(
                    color: PizzaCounterColors.mediumGray,
                    fontSize: (MediaQuery.of(context).size.width +
                            MediaQuery.of(context).size.height) /
                        50,
                  ),
                ),
              ),
              FormTextField(
                statusStream: widget.onInputTextStatusStream,
                focusNode: _nameFocusNode,
                labelText: S.of(context).nameLabel,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  widget.onActionButtonSink.add(null);
                },
                onChanged: widget.onInputTextChangedSink.add,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onInputTextChangedSink.add('');
                    },
                    child: Text(
                      S.of(context).cancelLabel,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        widget.onActionButtonSink.add(null);
                      },
                      child: Text(
                        S.of(context).addLabel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
