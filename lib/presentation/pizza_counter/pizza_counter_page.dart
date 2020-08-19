import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:domain/use_case/add_player_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/async_snapshot_response_view.dart';
import 'package:pizza_counter/presentation/common/form_text_field.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_action_listener.dart';
import 'package:pizza_counter/presentation/common/pizza_counter_colors.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_bloc.dart';
import 'package:pizza_counter/presentation/pizza_counter/pizza_counter_models.dart';
import 'package:pizza_counter/presentation/common/view_utils.dart';
import 'package:provider/provider.dart';

class PizzaCounterPage extends StatelessWidget {
  const PizzaCounterPage({
    @required this.bloc,
    Key key,
  })  : assert(bloc != null),
        super(key: key);

  static Widget create(BuildContext context) => ProxyProvider3<GetPlayersListUC,
          ValidateEmptyTextUC, AddPlayerUC, PizzaCounterBloc>(
        update: (context, getPlayersListUC, validateEmptyTextUC, addPlayerUC,
                bloc) =>
            bloc ??
            PizzaCounterBloc(
              getPlayersListUC: getPlayersListUC,
              validateEmptyTextUC: validateEmptyTextUC,
              addPlayerUC: addPlayerUC,
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
          title: const Text(
            'Contador de Pizzas',
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
                    onActionEventStream: bloc.onActionEvent,
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
                  return Column(
                    children: [
                      Container(
                        child: Text('PREMIOS'),
                      ),
                      ...successState.playersList.map(
                        (player) => PlayerCard(
                          name: player.name,
                          slices: player.slices,
                          bloc: bloc,
                        ),
                      ),
                    ],
                  );
                }
              },
              errorWidgetBuilder: (errorState) => Text(
                errorState.toString(),
              ),
            ),
          ),
        ),
      );
}

//todo: será feito nas próximas tasks
class PlayerCard extends StatelessWidget {
  const PlayerCard(
      {@required this.bloc, @required this.name, @required this.slices})
      : assert(bloc != null),
        assert(name != null),
        assert(slices != null);

  final PizzaCounterBloc bloc;
  final int slices;
  final String name;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                Row(
                  children: [
                    Text('- '),
                    Text(
                      slices.toString(),
                    ),
                    Text(' +'),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    S.of(context).noPlayersEmptyStateSecondaryText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
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
                      onActionEventStream: bloc.onActionEvent,
                    ),
                  );
                },
                color: PizzaCounterColors.lightRed,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    S.of(context).addPlayerLabel,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
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
                  style: const TextStyle(color: Colors.black87),
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
                      style: TextStyle(color: PizzaCounterColors.lightRed),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      color: PizzaCounterColors.lightRed,
                      onPressed: () {
                        widget.onActionButtonSink.add(null);
                      },
                      child: Text(
                        S.of(context).addLabel,
                        style: const TextStyle(color: Colors.black87),
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
