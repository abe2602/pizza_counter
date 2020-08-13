abstract class TeleviException implements Exception {}

class NoInternetException implements TeleviException {}

class GenericException implements TeleviException {}

class EmptyCachedListException implements TeleviException {}

class CachedMovieDetailNotFoundException implements TeleviException {}

class UnexpectedException implements TeleviException {}

abstract class FormFieldException implements TeleviException {}

class EmptyFormFieldException implements FormFieldException {}

class InvalidFormFieldException implements FormFieldException {}
