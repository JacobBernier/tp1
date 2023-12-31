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
      playedGames: (fields[6] as List?)?.cast<Game>(),
      username: fields[7] as String?,
    )
      ..highscore = fields[2] as int
      ..highscoreEasy = fields[3] as int
      ..highscoreMedium = fields[4] as int
      ..highscoreHard = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Utilisateurs obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idUtilisateur)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.highscore)
      ..writeByte(3)
      ..write(obj.highscoreEasy)
      ..writeByte(4)
      ..write(obj.highscoreMedium)
      ..writeByte(5)
      ..write(obj.highscoreHard)
      ..writeByte(6)
      ..write(obj.playedGames)
      ..writeByte(7)
      ..write(obj.username);
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
