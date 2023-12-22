import 'package:audioplayers/audioplayers.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tp1/controleurs/utilisateurs_controleur.dart';
import 'package:tp1/providers/utilisateur_provider.dart';
import 'package:tp1/vues/creation_combat.dart';
import 'package:tp1/vues/login.dart';
import 'package:tp1/vues/profile.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tp1/vues/user_highscore_list.dart';
import 'package:tp1/vues/user_profile.dart';
import 'package:tp1/vues/theme_page.dart';
import 'providers/theme_provider.dart';
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

  Utilisateurs user1 = Utilisateurs(
      role: 'user', idUtilisateur: '633633232as32ws',username: 'jeremy');
  _utilisateursBox?.put(2, user1);

  // Close the boxes after use
  await _utilisateursBox?.close();
}


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UtilisateursAdapter());
  _utilisateursBox = await Hive.openBox<Utilisateurs>('utilisateurs');
  await seedDatabase();
  await getBoxUtilisateurs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(), // Initialize your theme provider here
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UtilisateurProvider(
            Auth0('dev-xzdjv7klxcuqi3rz.us.auth0.com', 'dYJVlhgM3HfUBlTpJceq91XikSIMMkQz'),
            UtilisateursControleur(_utilisateursBox),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Combat box',
        theme: themeProvider.themeData,
        home: const MyHomePage(title: 'TP1 - Home Page'),
        routes: {
          '/page1': (context) {
            print('Navigating to /page1');
            return MyApp();
          },
          '/page2': (context) {
            print('Navigating to /page2');
            return MyGamingApp();
          },
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
  void _navigateToThemePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThemePage()), // ThemePage is the name of your theme change page
    );
  }
  void _listenToShake() {
    accelerometerEventStream().listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      // Calculate the speed (or the shake)
      double speed = x.abs() + y.abs() + z.abs();

      if (speed > 20) { // Define a suitable threshold
        _changeTheme();
        _playSound();
      }
    });
  }
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() {
    _audioPlayer.play(AssetSource('sounds/maracas.mp3'));
  }
  void _changeTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }


  @override
  void initState() {
    super.initState();
    print('Init State of MyHomePage');
    _listenToShake();
  }





@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.settings), // Icon of an engrenage
          onPressed: () {
            _navigateToThemePage(context);
          },
        ),
      ),
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

            // New button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(

                  builder: (context) => MyPageUserListApp(),
                ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 24.0),
                // Customize the button style as needed
              ),
              child: Text('Highscores', style: TextStyle(fontSize: 24.0)),
            ),
            const SizedBox(height: 20), // Add spacing between buttons
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
