import 'package:meta/meta.dart';

class ProductionCountry {
  const ProductionCountry({
    @required this.name,
  }) : assert(name != null);
  final String name;
}