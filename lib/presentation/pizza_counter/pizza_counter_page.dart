import 'package:domain/use_case/get_players_list_uc.dart';
import 'package:domain/use_case/validate_empty_text_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/async_snapshot_response_view.dart';
import 'package:pizza_counter/presentation/common/form_text_field.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';
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

  static Widget create(BuildContext context) =>
      ProxyProvider2<GetPlayersListUC, ValidateEmptyTextUC, PizzaCounterBloc>(
        update: (context, getPlayersListUC, validateEmptyTextUC, bloc) =>
            bloc ??
            PizzaCounterBloc(
              getPlayersListUC: getPlayersListUC,
              validateEmptyTextUC: validateEmptyTextUC,
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
        body: SafeArea(
          child: Container(
            //color: Color(0xFFFFF9C4),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
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
            ),
          ),
        ),
      );
}

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
            margin: EdgeInsets.all(10),
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
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(S.of(context).noPlayersEmptyStatePrimaryText),
                Text(S.of(context).noPlayersEmptyStateSecondaryText),
              ],
            ),
            Image.asset('images/pizza.png'),
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  child: PizzaCounterDialog(
                    onChangedSink: bloc.onNameValueChangedSink,
                    statusStream: bloc.nameInputStatusStream,
                    textFieldLostFocusSink: bloc.onNameFocusLostSink,
                    onAddFunction: () {
                      bloc.onAddPlayerSink.add(null);
                    },
                    inputStatus: bloc.playerNameInputStatusValue,
                    bloc: bloc,
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
      );
}

class PizzaCounterDialog extends StatefulWidget {
  const PizzaCounterDialog({
    @required this.onChangedSink,
    @required this.textFieldLostFocusSink,
    @required this.statusStream,
    @required this.onAddFunction,
    @required this.inputStatus,
    @required this.bloc,
  })  : assert(onChangedSink != null),
        assert(textFieldLostFocusSink != null),
        assert(statusStream != null);

  final Sink<String> onChangedSink;
  final Sink<void> textFieldLostFocusSink;
  final Stream<InputStatusVM> statusStream;
  final Function onAddFunction;
  final InputStatusVM inputStatus;
  final PizzaCounterBloc bloc;

  @override
  State<StatefulWidget> createState() => PizzaCounterDialogState();
}

class PizzaCounterDialogState extends State<PizzaCounterDialog> {
  final _nameFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    _nameFocusNode
        .addFocusLostListener(() => widget.textFieldLostFocusSink.add(null));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
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
              statusStream: widget.statusStream,
              focusNode: _nameFocusNode,
              labelText: S.of(context).nameLabel,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onEditingComplete: (){
                widget.onAddFunction();
                Navigator.of(context).pop();
              },
              onChanged: widget.onChangedSink.add,
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
                    style: TextStyle(color: PizzaCounterColors.lightRed),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    color: PizzaCounterColors.lightRed,
                    onPressed: () {
                      widget.onAddFunction();
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
      );
}
