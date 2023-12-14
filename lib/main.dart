import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1/controleurs/utilisateurs_controleur.dart';
import 'package:tp1/providers/utilisateur_provider.dart';
import 'package:tp1/vues/creation_combat.dart';
import 'package:tp1/vues/login.dart';
import 'package:tp1/vues/profile.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tp1/vues/user_profile.dart';


import 'models/utilisateurs.dart';

// Commandes à rouler:
// flutter pub add hive hive_flutter
// flutter pub add dev:hive_generator dev:build_runner

// Auteurs : Jacob Bernier

late Box<Utilisateurs> _utilisateursBox;
TextEditingController filterController = TextEditingController();
bool isloading = false;

Future<void> getBoxUtilisateurs() async {
  _utilisateursBox = await Hive.openBox<Utilisateurs>('utilisateurs');
}

Future<void> getCombatListData() async {
  isloading = true;
  isloading = false;
}

Future seedDatabase() async {
  _utilisateursBox = await Hive.openBox<Utilisateurs>('utilisateurs');

  Utilisateurs admin = Utilisateurs(
      role: 'analyste', idUtilisateur: 'auth0|654444f87c403dde6a25e8bb');
  _utilisateursBox?.put(1, admin);

  // Close the boxes after use
  await _utilisateursBox?.close();
}


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UtilisateursAdapter());

  //await seedDatabase();
  await getBoxUtilisateurs();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (context) => UtilisateurProvider(
        Auth0('dev-xzdjv7klxcuqi3rz.us.auth0.com',
            'dYJVlhgM3HfUBlTpJceq91XikSIMMkQz'),
        UtilisateursControleur(_utilisateursBox)),
    child:MaterialApp(
      title: 'Combat box',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      home: const MyHomePage(title: 'TP1 - Home Page'), // Page de démarrage
      routes: {
        '/page1': (context) => MyApp(),
        '/page2': (context) => MyGamingApp(),
      },
    ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  //ajout
  Future<void> _orderFilterCombatListData(
      int? btnNumber, String? filter) async {
    await getCombatListData();
    setState(() {});
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Play" button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(

                  builder: (context) => MyGamingApp(),
                ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Adjust padding
                textStyle: TextStyle(fontSize: 24.0), // Increase text size
              ),
              child: Text('Play', style: TextStyle(fontSize: 24.0)), // Increase text size
            ),
            const SizedBox(height: 20), // Add spacing between buttons

            // "View High Scores" button
            ElevatedButton(
              onPressed: () {
                final utilisateurProvider = Provider.of<UtilisateurProvider>(context, listen: false);
                final userId = utilisateurProvider.user?.idUtilisateur;
                print('UserID passed to HighScoresPage: $userId');
                if (userId != null) {
                  Navigator.push(context, MaterialPageRoute(

                    builder: (context) => HighScoresPage(userId: userId),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 24.0),
              ),
              child: Text('View High Scores', style: TextStyle(fontSize: 24.0)),
            ),
            const SizedBox(height: 20),
            Consumer<UtilisateurProvider>(
              builder: (context, utilisateurProvider, child) {
                return Center(
                    child: utilisateurProvider.isAuthenticating
                        ? const CircularProgressIndicator()
                        : utilisateurProvider.isLoggedIn
                        ? Profile()
                        : Login());
              },
            ),
          ],
        ),
      ),
    );
  }


}
