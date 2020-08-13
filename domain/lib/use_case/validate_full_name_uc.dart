import 'dart:async';
import '../exceptions.dart';
import 'use_case.dart';

class ValidateFullNameUC extends UseCase<ValidateUserFullNameUCParams, void> {
  @override
  Future<void> getRawFuture({ValidateUserFullNameUCParams params}) {
    final completer = Completer();
    final fullName = params.fullName ?? '';

    if (fullName.isEmpty) {
      completer.completeError(EmptyFormFieldException());
      return completer.future;
    }

    final words = (fullName ?? '').trim().split(' ');

    for (final word in words) {
      if (word.isEmpty) {
        completer.completeError(InvalidFormFieldException());
        return completer.future;
      }
    }

    final matches = RegExp("^[a-z]([-']?[a-z]+)*( [a-z]([-']?[a-z]+)*)+\$")
        .allMatches(fullName.toLowerCase());

    final isValid = matches
        .any((match) => match.start == 0 && match.end == fullName.length);

    if (words.length <= 1 || !isValid) {
      completer.completeError(InvalidFormFieldException());
    } else {
      completer.complete();
    }

    return completer.future;
  }
}

class ValidateUserFullNameUCParams {
  const ValidateUserFullNameUCParams(this.fullName);

  final String fullName;
}
