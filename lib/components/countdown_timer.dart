import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountDownTimer extends StatefulWidget {

  AnimationController controller;

  CountDownTimer(this.controller);

  @override
  _CountDownTimerState createState() => _CountDownTimerState(this.controller);

}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {

  AnimationController controller;

  _CountDownTimerState(this.controller);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: controller,
      builder:
          (BuildContext context, Widget child) {
        return Stack(
          children: <Widget>[
            Container(
              width: (200.0 / 853) * MediaQuery.of(context).size.height,
              height: (200.0 / 853) * MediaQuery.of(context).size.height,
              child: CustomPaint(
                  painter: CustomTimerPainter(
                    animation: controller,
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                  )),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    timerString,
                    style: TextStyle(
                        fontSize: (40.0 / 853) * MediaQuery.of(context).size.height,
                        color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inSeconds}';
  }

}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}