// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerCMAdapter extends TypeAdapter<PlayerCM> {
  @override
  final int typeId = 0;

  @override
  PlayerCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerCM(
      id: fields[0] as int,
      slices: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slices)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
