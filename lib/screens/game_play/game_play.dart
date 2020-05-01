import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';

class GamePlay extends StatefulWidget {

  @override
  _GamePlayState createState() {
    return _GamePlayState();
  }

}

class _GamePlayState extends State<GamePlay> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: QuizPage.quizDecoration(),
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ButtonCircle(
                    Icon(
                      Icons.filter_center_focus,
                      size: 25.0,
                      color: Colors.white,
                    ),
                        () {

                    }
                ),
                ButtonCircle(
                    Icon(
                      Icons.call,
                      size: 25.0,
                      color: Colors.white,
                    ),
                        () {

                    }
                ),
                ButtonCircle(
                    Icon(
                      Icons.group,
                      size: 25.0,
                      color: Colors.white,
                    ),
                        () {

                    }
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 150.0),),
            Container(
              child: Text(
                'Quel est la ville la mieux organisee du centre de l Afrique de l ouest?',
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 50.0),),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ButtonQuiz(
                  'Kinshasa',
                  () {
                    },
                  textLeft: 'A:',
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                ButtonQuiz(
                  'Lagos',
                  () {
                    },
                  textLeft: 'B:',
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                ButtonQuiz(
                  'Accra',
                  () {

                    },
                  textLeft: 'C:',
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                ButtonQuiz(
                  'Lubumbashi NB: je sais que c est pa une capitale c juste pour les testes',
                  () {

                    },
                  textLeft: 'D:',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}