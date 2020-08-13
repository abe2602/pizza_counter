import 'dart:async';
import '../exceptions.dart';
import 'use_case.dart';

class ValidatePasswordUC extends UseCase<ValidatePasswordUCParams, void> {
  @override
  Future<void> getRawFuture({ValidatePasswordUCParams params}) {
    final completer = Completer();
    final password = params.password ?? '';

    if (password.isEmpty) {
      completer.completeError(EmptyFormFieldException());
      return completer.future;
    }

    if (password.length < 8) {
      completer.completeError(InvalidFormFieldException());
    } else {
      completer.complete();
    }

    return completer.future;
  }
}

class ValidatePasswordUCParams {
  const ValidatePasswordUCParams(this.password);

  final String password;
}
