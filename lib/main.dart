import 'package:flutter/material.dart';
import 'package:millionaire_quiz/screens/home/home.dart';
import 'package:millionaire_quiz/styles/style.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'services/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    Admob.initialize(constants.ADMOB_APP_ID);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: HomePage(),
    );
  }
}
