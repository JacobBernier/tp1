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
            if (utilisateurProvider.isLoggedIn) // Conditional rendering
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Change your username?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: currentUser?.username,
                      onFieldSubmitted: (newValue) {
                        currentUser?.updateUsername(newValue);
                        // Save the updated user to Hive box
                        Hive.box<Utilisateurs>('utilisateurs').put(currentUser?.idUtilisateur, currentUser!);
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
