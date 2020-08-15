import 'package:domain/model/player.dart';
import 'package:pizza_counter/data/cache/model/player_cm.dart';

extension PlayerCMtoDM on PlayerCM {
  Player toDM() => Player(id: id, slices: slices, name: name);
}

extension PlayerCMListtoDM on List<PlayerCM> {
  List<Player> toDM() => map((player) => player.toDM()).toList();
}
