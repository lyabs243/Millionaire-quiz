import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountDownTimer extends StatefulWidget {

  @override
  _CountDownTimerState createState() => _CountDownTimerState();

}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value).then((value) {
    });
    return AnimatedBuilder(
      animation: controller,
      builder:
          (BuildContext context, Widget child) {
        return Stack(
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
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
                        fontSize: 40.0,
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