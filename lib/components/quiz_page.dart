import 'package:flutter/material.dart';

/**
 * This is a reusable componnent for quiz page
 */
class QuizPage {

  static BoxDecoration quizDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/background.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }

}