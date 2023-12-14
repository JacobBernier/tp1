import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

// Rouler commande 'flutter packages pub run  build_runner build'


part 'game.g.dart';

@HiveType(typeId: 4)
class Game{
  Game({required this.idGame, required this.difficulty, required this.score, required this.speed});
  @HiveField(0)
  final String idGame;
  @HiveField(1)
  final int difficulty;
  @HiveField(2)
  final int score;
  @HiveField(3)
  final int speed;
}



