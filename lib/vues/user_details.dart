import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/utilisateurs.dart';
import '../providers/utilisateur_provider.dart'; // Import your UtilisateurProvider

class UserDetailPage extends StatefulWidget {
  final Utilisateurs user;

  UserDetailPage({required this.user});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Access the UtilisateurProvider to check the user's role
    final utilisateurProvider = Provider.of<UtilisateurProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details: ${widget.user.username}'),
        actions: [
          // Reset highscores icon
          if (utilisateurProvider.user?.role == 'admin')
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // Reset highscores and update the state
                setState(() {
                  widget.user.highscoreEasy = 0;
                  widget.user.highscoreMedium = 0;
                  widget.user.highscoreHard = 0;
                  widget.user.playedGames.clear();
                });
                // Implement any additional logic to update these scores in the backend or database if necessary
              },
            ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Highscore'),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text('Highscore Easy: ${widget.user.highscoreEasy}, Medium: ${widget.user.highscoreMedium}, Hard: ${widget.user.highscoreHard}'),
                ),
                if (utilisateurProvider.user?.role == 'analyste')
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        widget.user.highscoreEasy = 0;
                        widget.user.highscoreMedium = 0;
                        widget.user.highscoreHard = 0;
                      });
                      // Implement any additional logic to update these scores in the backend or database if necessary
                    },
                  ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user.playedGames.length,
              itemBuilder: (context, index) {
                final game = widget.user.playedGames[index];
                return ListTile(
                  title: Text('Game ID: ${game.idGame}'),
                  subtitle: Text('Score: ${game.score}, Difficulty: ${game.difficulty}, Precision: ${game.speed}'),
                  trailing: utilisateurProvider.user?.role == 'analyste' ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (utilisateurProvider.user?.role == 'analyste') {
                        setState(() {
                          widget.user.playedGames.removeAt(index);
                        });
                      }
                    },
                  ) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
