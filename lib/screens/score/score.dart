import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/dialog_latest_results.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/services/localizations.dart';

class ScorePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: QuizPage.quizDecoration(),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 70.0),),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                      'assets/logo.png'
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 40.0),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonQuiz(
                      MyLocalizations.of(context).localization['latest_results'],
                      () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => DialogLatestResults(),
                        );
                      },
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ButtonQuiz(
                      MyLocalizations.of(context).localization['top_leadboard'],
                      () {

                      },
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }

}