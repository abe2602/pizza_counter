import 'dart:async';
import '../exceptions.dart';
import 'use_case.dart';

///Apenas um lembrete:
///Utlizamos o Completer ao invés de Future.value/error pela mesma razão que
///preferimos usar Single.creat ao invés de Single.just.
class ValidatePasswordConfirmationUC
    extends UseCase<ValidatePasswordConfirmationUCParams, void> {
  @override
  Future<void> getRawFuture({ValidatePasswordConfirmationUCParams params}) {
    final completer = Completer();
    final password = params.password ?? '';
    final passwordConfirmation = params.passwordConfirmation ?? '';

    if (password != passwordConfirmation) {
      completer.completeError(InvalidFormFieldException());
    } else {
      completer.complete();
    }

    return completer.future;
  }
}

class ValidatePasswordConfirmationUCParams {
  const ValidatePasswordConfirmationUCParams(
      this.password, this.passwordConfirmation);

  final String password;
  final String passwordConfirmation;
}
