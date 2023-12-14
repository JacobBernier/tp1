import 'dart:math';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'game.dart';

// Rouler commande 'flutter packages pub run  build_runner build'


part 'utilisateurs.g.dart';

@HiveType(typeId: 4)
class Utilisateurs{
  Utilisateurs({required this.idUtilisateur, required this.role, List<Game>? playedGames, String? username
  }) : this.playedGames = playedGames ?? [], this.username = username ?? 'User_${Random().nextInt(9999)}';
  @HiveField(0)
  final String idUtilisateur;
  @HiveField(1)
  final String role;
  @HiveField(2)
  int highscore = 0;
  @HiveField(3)
  int highscoreEasy = 0;
  @HiveField(4)
  int highscoreMedium = 0;
  @HiveField(5)
  int highscoreHard = 0;
  @HiveField(6)
  List<Game> playedGames;
  @HiveField(7)
  String username;

  void updateUsername(String newUsername) {
    username = newUsername;
  }
}



