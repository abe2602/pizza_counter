import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'player_cm.g.dart';

@HiveType(typeId: 0)
class PlayerCM {
  const PlayerCM({
    @required this.id,
    @required this.slices,
    @required this.name,
  })  : assert(id != null),
        assert(slices != null),
        assert(name != null);

  @HiveField(0)
  final int id;
  @HiveField(1)
  final int slices;
  @HiveField(2)
  final String name;
}
