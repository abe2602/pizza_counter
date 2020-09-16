import 'package:meta/meta.dart';

class Player {
  const Player({
    @required this.id,
    @required this.slices,
    @required this.name,
  })  : assert(id != null),
        assert(slices != null),
        assert(name != null);

  final String id;
  final int slices;
  final String name;
}
