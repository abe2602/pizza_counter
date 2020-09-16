abstract class PizzaCounterException implements Exception {}

class NoInternetException implements PizzaCounterException {}

class GenericException implements PizzaCounterException {}

class EmptyCachedListException implements PizzaCounterException {}

class NameAlreadyAddedException implements PizzaCounterException {}

class CachedMovieDetailNotFoundException implements PizzaCounterException {}

class UnexpectedException implements PizzaCounterException {}

abstract class FormFieldException implements PizzaCounterException {}

class EmptyFormFieldException implements FormFieldException {}

class InvalidFormFieldException implements FormFieldException {}
