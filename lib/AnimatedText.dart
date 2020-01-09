import 'package:flutter/material.dart';
import 'dart:math' as math;
class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation transition;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    transition = Tween<double>(begin: 0.0, end: 2.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.linear));

    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationZ(transition.value * math.pi),
              child: Container(
                  color: Colors.red,
                  width: 150,
                  height: 150,
                  child: Text('Vidhi')),
            );
          },
        ),
      ),
    );
  }
}
