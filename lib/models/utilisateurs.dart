import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

// Rouler commande 'flutter packages pub run  build_runner build'


part 'utilisateurs.g.dart';

@HiveType(typeId: 4)
class Utilisateurs{
  Utilisateurs({required this.idUtilisateur, required this.role});
  @HiveField(0)
  final String idUtilisateur;
  @HiveField(1)
  final String role;
  @HiveField(2)
  int highscoreEasy = 0;
  @HiveField(3)
  int highscoreMedium = 0;
  @HiveField(4)
  int highscoreHard = 0;
}



