import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tp1/vues/user_details.dart';
import '../models/utilisateurs.dart';
import '../providers/theme_provider.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersBox = Hive.box<Utilisateurs>('utilisateurs');
    final List<Utilisateurs> users = usersBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text('User ID: ${user.idUtilisateur}'),
            subtitle: Text('Role: ${user.role}'),
            trailing: Text('Highscore: ${user.highscore}'), // Adjust according to your scoring system
            onTap: () {
              // Navigate to UserDetailPage on tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UtilisateursAdapter());

  runApp(MyPageUserListApp());
}

class MyPageUserListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      home: UserListPage(),
      theme: themeProvider.themeData,
    );
  }
}
