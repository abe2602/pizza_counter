import 'dart:async';
import '../exceptions.dart';
import 'use_case.dart';

class ValidateEmailUC extends UseCase<ValidateEmailUCParams, void> {
  @override
  Future<void> getRawFuture({ValidateEmailUCParams params}) {
    final completer = Completer();
    final email = params.email ?? '';

    if (email.isEmpty) {
      completer.completeError(EmptyFormFieldException());
      return completer.future;
    }

    final matches = RegExp(
            '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
            '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
            '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
            ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$')
        .allMatches(email);

    final isValid =
        matches.any((match) => match.start == 0 && match.end == email.length);

    if (!isValid) {
      completer.completeError(InvalidFormFieldException());
    } else {
      completer.complete();
    }

    return completer.future;
  }
}

class ValidateEmailUCParams {
  const ValidateEmailUCParams(this.email);

  final String email;
}
