import 'dart:async';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/use_case.dart';

class ValidateEmptyTextUC extends UseCase<ValidateEmptyTextUCParams, void> {
  @override
  Future<void> getRawFuture({ValidateEmptyTextUCParams params}) {
    final completer = Completer();
    final fullName = params.text ?? '';

    if (fullName.isEmpty) {
      completer.completeError(EmptyFormFieldException());
      return completer.future;
    }
    completer.complete();

    return completer.future;
  }
}

class ValidateEmptyTextUCParams {
  const ValidateEmptyTextUCParams(this.text);

  final String text;
}
