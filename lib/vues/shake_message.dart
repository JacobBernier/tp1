import 'package:flutter/material.dart';

class ShakeMessage extends StatefulWidget {
  @override
  _ShakeMessageState createState() => _ShakeMessageState();
}

class _ShakeMessageState extends State<ShakeMessage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _rotationAngle = 0.1; // Increase the rotation angle for more shake

  @override
  void initState() {
    super.initState();
    _setupRotationAnimation();
  }

  void _setupRotationAnimation() {
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(
      begin: -_rotationAngle,
      end: _rotationAngle,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );

    _rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16, // Adjust the top position as needed
      right: 16, // Adjust the right position as needed
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Shake your phone!',
                style: TextStyle(
                  fontSize: 14.0, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
