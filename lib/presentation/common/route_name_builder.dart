class RouteNameBuilder {
  static const pizzaCounterResource = 'pizza_counter';
  static const pizzaGraphResource = 'pizza_graph';

  static String extractScreenName(String path) {
    // ignore fluro arguments
    final resource = RegExp(r'^[^\?\/]*').stringMatch(path);

    if (resource.isEmpty) {
      return 'Main';
    }

    // Todo: Add future new screens
    switch (resource) {
      case pizzaCounterResource:
        return 'Counter Page';
      case pizzaGraphResource:
        return 'Charts Page';
      default:
        return resource;
    }
  }
}
