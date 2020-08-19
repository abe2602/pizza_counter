import 'package:domain/model/player.dart';
import 'package:pizza_counter/data/cache/model/player_cm.dart';

extension PlayerDMtoCM on Player {
  PlayerCM toCM() => PlayerCM(id: id, slices: slices, name: name);
}