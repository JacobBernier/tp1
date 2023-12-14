import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Changer'),
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
            ///////////
            //TextFormField(
            //  initialValue: user?.username,
            //  onFieldSubmitted: (newValue) {
            //    user?.updateUsername(newValue);
            //    // Save the updated user to Hive box
            //    Hive.box<Utilisateurs>('utilisateurs').put(user?.idUtilisateur, user);
            //  },
            //),
            ////////////
          ],
        ),
      ),
    );
  }
}
