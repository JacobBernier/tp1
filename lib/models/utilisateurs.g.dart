// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateurs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilisateursAdapter extends TypeAdapter<Utilisateurs> {
  @override
  final int typeId = 4;

  @override
  Utilisateurs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Utilisateurs(
      idUtilisateur: fields[0] as String,
      role: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Utilisateurs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idUtilisateur)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.highscore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UtilisateursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
