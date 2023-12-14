import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/utilisateurs.dart';

class HighScoresPage extends StatelessWidget {
  final String userId;

  HighScoresPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your High Scores'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<Utilisateurs>('utilisateursBox'),
        builder: (BuildContext context, AsyncSnapshot<Box<Utilisateurs>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var user = snapshot.data!.get(userId);
              if (user != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('High Score (Easy): ${user.highscoreEasy}', style: TextStyle(fontSize: 20)),
                      Text('High Score (Medium): ${user.highscoreMedium}', style: TextStyle(fontSize: 20)),
                      Text('High Score (Hard): ${user.highscoreHard}', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                );
              } else {
                return Text('User not found');
              }
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
