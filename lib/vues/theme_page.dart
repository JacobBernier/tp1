import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/utilisateurs.dart';
import '../providers/theme_provider.dart';
import '../providers/utilisateur_provider.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final utilisateurProvider = Provider.of<UtilisateurProvider>(context, listen: false);
    //if (!utilisateurProvider.isLoggedIn) return 0;
    //print("miammers");

    final currentUser = utilisateurProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Parameters'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Change the Theme:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              child: Text('Toggle Theme'),
            ),
            utilisateurProvider.isLoggedIn
                ? TextFormField(
              initialValue: currentUser?.username,
              onFieldSubmitted: (newValue) {
                currentUser?.updateUsername(newValue);
                // Save the updated user to Hive box
                Hive.box<Utilisateurs>('utilisateurs').put(currentUser?.idUtilisateur, currentUser!);
              },
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
