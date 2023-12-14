import 'package:flutter/material.dart';
import '../models/utilisateurs.dart';
import '../models/game.dart'; // Import your Game model

class UserDetailPage extends StatelessWidget {
  final Utilisateurs user;

  UserDetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details: ${user.idUtilisateur}'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Role: ${user.role}'),
            subtitle: Text('Highscore Easy: ${user.highscoreEasy}, Medium: ${user.highscoreMedium}, Hard: ${user.highscoreHard}'),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: user.playedGames.length,
              itemBuilder: (context, index) {
                final game = user.playedGames[index];
                return ListTile(
                  title: Text('Game ID: ${game.idGame}'),
                  subtitle: Text('Score: ${game.score}, Difficulty: ${game.difficulty}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
