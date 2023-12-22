import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/game.dart';
import '../models/utilisateurs.dart';
import '../providers/theme_provider.dart';
import '../providers/utilisateur_provider.dart';

void main() {
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
  openBox();
}

void openBox() async {
  await Hive.openBox<Utilisateurs>('utilisateursBox');
}

Future<void> openBoxIfNeeded() async {
  if (!Hive.isBoxOpen('utilisateursBox')) {
    //print("opening box");
    await Hive.openBox<Utilisateurs>('utilisateursBox');
  }
}

int getHighScore(BuildContext context) {
  final utilisateurProvider = Provider.of<UtilisateurProvider>(context, listen: false);
  if (!utilisateurProvider.isLoggedIn) return 0;

  final currentUser = utilisateurProvider.user;
  return currentUser?.highscore ?? 0;
}

class MyGamingApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Circle Timing Game',
      theme: themeProvider.themeData,
      home: MyGamePage(),
    );
  }
}

class MyGamePage extends StatefulWidget {
  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  double tolerance = 20;
  int speed = 16;
  int score = 0;
  int lives = 3;
  bool clockwiseRotation = true; // Added a flag to control rotation direction
  double targetAngle = Random().nextDouble() * 360;
  double currentAngle = 0;
  double clickTargetX = 0;
  double clickTargetY = 0;
  double clickTargetWidth = 25;
  double clickTargetHeight = 25;
  bool clickTargetVisible = false;
  final GlobalKey blueCircleKey = GlobalKey();

  double angle = 0;
  Random random = Random();
  @override
  void initState() {
    super.initState();
    //print('Init State of MyGamePage');
  }

  void generateAndDisplayTargetPosition() {
    double targetAngle = random.nextDouble() * 360;
    //targetAngle = random.nextDouble() * 360;

    angle = (targetAngle + 90) % 360;
    double radius = 100; // Half of the container's width/height
    //double centerX = 100; // Half of the container's width/height

    double radians = targetAngle * (3.1415926535897932 / 180);

    //Size screenSize = MediaQuery.of(context).size;
    //double centerX = screenSize.width / 2;
    //double centerY = screenSize.height / 2;

    RenderBox renderBox = blueCircleKey.currentContext!.findRenderObject() as RenderBox;
    double centerX = renderBox.size.width / 2;
    double centerY = renderBox.size.height / 2;

    //double centerX = 100;
    //double centerY = 325;
    double x = centerX + radius * cos(radians) - (clickTargetWidth / 2);
    double y = centerY + radius * sin(radians) - (clickTargetHeight / 2);
    //print('--------------');
//
    //print('TARGET XXXX BEFORE ' + x.toString());
    //print('TARGET YYYY BEFORE ' + y.toString());
    //// Adjust x and y to be negative if needed
    ////if (x > centerX) {
    ////  x = centerX - (x - centerX);
    ////}
    ////if (y > centerY) {
    ////  y = centerY - (y - centerY);
    ////}
//
    //print('TARGET ANGLE BASE ' + angle.toString());
    //print('TARGET ANGLE ' + targetAngle.toString());
//
    //print('TARGET XXXX ' + x.toString());
    //print('TARGET YYYY ' + y.toString());
    //print('--------------');
    //print('--------------');
    //print('--------------');

    setState(() {
      clickTargetX = x;
      clickTargetY = y;
      clickTargetVisible = true;
    });
  }


  void startRotation() {
    generateAndDisplayTargetPosition();
    Timer.periodic(Duration(milliseconds: speed), (timer) {
      setState(() {
        if (clockwiseRotation) {
          currentAngle += 1; // Rotate clockwise by 1 degree (adjust as needed)
        } else {
          currentAngle -= 1; // Rotate counterclockwise by 1 degree (adjust as needed)
        }


      });
    });
  }

  void handleButtonClick() {

    double currentAngle2 = currentAngle % 360;
    print("Angle du shitos barre: " + currentAngle2.toString());
    print("Angle du bouton: " + angle.toString());

    //angle = (targetAngle + 90) % 360;
    //print((currentAngle2 - angle).abs());
    if ((currentAngle2 - angle).abs() <= tolerance && lives > 0) {
      setState(() {
        score++;
      });
    } else {
      if (lives > 0) {
        setState(() {
          lives--;
        });
      }

    }
    if (lives <= 0) {
      showGameOverDialog();
    }

    if (clockwiseRotation) {
      clockwiseRotation = !clockwiseRotation;
      currentAngle += 1; // Rotate clockwise by 1 degree (adjust as needed)
    } else {
      clockwiseRotation = !clockwiseRotation;

      currentAngle -= 1; // Rotate counterclockwise by 1 degree (adjust as needed)
    }
    generateAndDisplayTargetPosition();
  }

  Future<void> showGameOverDialog() async {

    final utilisateurProvider = Provider.of<UtilisateurProvider>(context, listen: false);
    if (utilisateurProvider.isLoggedIn) {

      await openBoxIfNeeded();

      final currentUser = utilisateurProvider.user;

      final box = Hive.box<Utilisateurs>('utilisateursBox');
      Utilisateurs? user = utilisateurProvider.user;
      print('GAMEOVER-------------');

      if (score > user!.highscore) {
        user?.highscore = score;
        box.put(utilisateurProvider.user?.idUtilisateur, user!);
      }
      print(SpeedButton);
      if (SpeedButton == 0 && user!.highscoreEasy < score) {

        user?.highscoreEasy = score;
        box.put(utilisateurProvider.user?.idUtilisateur, user!);
      }
      else if (SpeedButton == 1 && user!.highscoreMedium < score) {
        user?.highscoreMedium = score;
        box.put(utilisateurProvider.user?.idUtilisateur, user!);
      }
      else if (SpeedButton == 2 && user!.highscoreHard < score) {
        user?.highscoreHard = score;
        box.put(utilisateurProvider.user?.idUtilisateur, user!);
      }

      //if (utilisateurProvider.user != user) {
      //  box.put(utilisateurProvider.user?.idUtilisateur, user!);
      //}

      Game newGame = Game(
        idGame: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID for the game
        difficulty: SpeedButton, // Set the difficulty level here
        score: score,
        speed: DifficultyButton, // Set the game precision here
      );

      user.playedGames.add(newGame);
      box.put(utilisateurProvider.user?.idUtilisateur, user);

    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You ran out of lives. Your final score is $score.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
                resetGame();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: '',),
                  ),
                );
                //Navigator.pushReplacement(context, '/page1');
                //Navigator.popUntil(context, ModalRoute.withName('/page2'));

              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      lives = 3;
      targetAngle = 0;//Random().nextDouble() * 360;
      clockwiseRotation = true; // Reset rotation direction
    });
  }
  bool isRedButton = true; // To track the color and text of the button
  int DifficultyButton = 0;
  int SpeedButton = 0;
  Color difficultyTextColor = Colors.green; // Initial color for difficulty button text
  Color speedTextColor = Colors.green;
  List<String> difficultyOptions = ['0.75 X', '1.0 X', '1.25 X']; // Text options for difficulty button
  List<String> speedOptions = ['Easy', 'Medium', 'Hard']; // Text options for speed button

  void toggleRedButton() {
    setState(() {
      isRedButton = !isRedButton;
    });
  }
  void toggleDifficultyButton() {
    setState(() {
      DifficultyButton++;
      if(DifficultyButton > 2){
        DifficultyButton = 0;
      }
      // Update difficulty button text color based on DifficultyButton value
      switch (DifficultyButton) {
        case 0:
          difficultyTextColor = Colors.green;
          tolerance = 20;
          break;
        case 1:
          difficultyTextColor = Colors.yellow; // Change to your desired color
          tolerance = 15;
          break;
        case 2:
          difficultyTextColor = Colors.red; // Change to your desired color
          tolerance = 10;
          break;

      }}
    );
  }
  void toggleSpeedButton() {
    setState(() {
      SpeedButton++;
      if(SpeedButton > 2){
        SpeedButton = 0;
      }
      // Update difficulty button text color based on DifficultyButton value
      switch (SpeedButton) {
        case 0:
          speedTextColor = Colors.green;
          speed = 16;
          break;
        case 1:
          speedTextColor = Colors.yellow; // Change to your desired color
          speed = 3;
          break;
        case 2:
          speedTextColor = Colors.red; // Change to your desired color
          speed = 1;
          break;
      }}
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circle Timing Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Lives: $lives',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'High Score: ${getHighScore(context)}',
              style: TextStyle(fontSize: 24),
            ),
            // Blue circle centered on the screen
        Padding(
          padding: EdgeInsets.all(16.0),
            child:
            Container(
              key: blueCircleKey, // Assign the GlobalKey here
              width: 200,
              height: 200,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Target circle (green) centered on the blue circle
                  Positioned(
                    left: clickTargetX,
                    top: clickTargetY,
                    child: Container(
                      width: clickTargetWidth,
                      height: clickTargetHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  // Rotating red line
                  Transform.rotate(
                    angle: (currentAngle / 180) * pi,
                    child: Transform.translate(
                      offset: Offset(0, -50), // Move the bar up by half its height
                      child: Container(
                        width: 10,
                        height: 100, // Half the height of the circle
                        decoration: BoxDecoration(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
            // Buttons can be placed outside the blue circle container
            ElevatedButton(
              onPressed: () {
                toggleDifficultyButton();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blue,
                ),
              ),
              child: Text(
                difficultyOptions[DifficultyButton],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: difficultyTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                toggleSpeedButton();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blue,
                ),
              ),
              child: Text(
                speedOptions[SpeedButton],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: speedTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isRedButton) {
                  isRedButton = !isRedButton;
                  print(speed);
                  startRotation();
                } else {
                  handleButtonClick();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  isRedButton ? Colors.red : Colors.blue,
                ),
              ),
              child: Text(
                isRedButton ? 'prêt' : 'Click Me!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}