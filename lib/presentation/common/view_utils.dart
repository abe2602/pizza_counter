import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pizza_counter/generated/l10n.dart';
import 'package:pizza_counter/presentation/common/input_status_vm.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}

class InternetImage extends StatelessWidget {
  const InternetImage({
    @required this.url,
    this.width,
    this.height,
  }) : assert(url != null);

  final String url;
  final double width, height;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Center(
          child: Image.asset(
            'images/no_image.png',
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
        fit: BoxFit.cover,
      );
}

class InternetErrorEmptyState extends StatelessWidget {
  const InternetErrorEmptyState({
    @required this.action,
  }) : assert(action != null);

  final Function action;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text(S.of(context).noInternetMessage),
                ),
              ),
            ),
            Image.asset(
              'images/internetEmptyState.png',
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: RaisedButton(
                    onPressed: action,
                    child: Text(S.of(context).tryAgainButtonLabel),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class GenericErrorEmptyState extends StatelessWidget {
  const GenericErrorEmptyState({
    @required this.action,
  }) : assert(action != null);

  final Function action;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: <Widget>[
            Text(S.of(context).genericErrorMessage),
            FlatButton(
              onPressed: () => action,
              child: Text(S.of(context).tryAgainButtonLabel),
            ),
          ],
        ),
      );
}

extension FutureViewUtils on Future<void> {
  Future<void> addStatusToSink(Sink<InputStatusVM> sink) => then(
        (_) {
          sink.add(InputStatusVM.valid);
          return null;
        },
      ).catchError(
        (error) {
          sink.add(error is EmptyFormFieldException
              ? InputStatusVM.empty
              : InputStatusVM.invalid);

          throw error;
        },
      );
}

//Sempre que o foco é perdido, da um trigger no listener
extension FocusNodeViewUtils on FocusNode {
  void addFocusLostListener(VoidCallback listener) {
    addListener(
      () {
        if (!hasFocus) {
          listener();
        }
      },
    );
  }
}

extension ObservableViewUtils<T> on Stream<T> {
  Stream<T> addToSink(Sink<T> sink) => doOnData(
        (data) => sink.add(data),
      );
}
