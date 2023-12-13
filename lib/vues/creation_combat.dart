import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../main.dart';

void main() {
  runApp(MyGamingApp());
}

class MyGamingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Timing Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGamePage(),
    );
  }
}

class MyGamePage extends StatefulWidget {
  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
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

  double angle = 0;
  Random random = Random();
  @override
  void initState() {
    super.initState();
    startRotation();
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
    double centerX = 100;
    double centerY = 325;
    double x = centerX + radius * cos(radians) - (clickTargetWidth / 2);
    double y = centerY + radius * sin(radians) - (clickTargetHeight / 2);


    setState(() {
      clickTargetX = x;
      clickTargetY = y;
      clickTargetVisible = true;
    });
  }

  void startRotation() {
    generateAndDisplayTargetPosition();
    Timer.periodic(Duration(milliseconds: 16), (timer) {
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
    double tolerance = 20;
    double currentAngle2 = currentAngle % 360;
    print("Angle du shitos barre: " + currentAngle2.toString());
    print("Angle du bouton: " + angle.toString());

    //angle = (targetAngle + 90) % 360;
    print((currentAngle2 - angle).abs());
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

  void showGameOverDialog() {
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
                //Navigator.pop(context);
                //Navigator.of(context).pop();
                //resetGame();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                    MyApp(),
                ),
                );
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
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Light blue circle container
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue,
                    ),
                  ),
                  // Green target (click target)
                  Positioned(
                    left: clickTargetX,
                    top: clickTargetY,
                    child: Visibility(
                      visible: clickTargetVisible,
                      child: Container(
                        width: clickTargetWidth,
                        height: clickTargetHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
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

                  // Button at the bottom
                  Positioned(
                    top: 300,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: handleButtonClick,
                        child: Text(
                          'Click Me!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
