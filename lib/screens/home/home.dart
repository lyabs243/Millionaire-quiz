import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/screens/game_play/game_play.dart';

class HomePage extends StatefulWidget {

  String title = 'Millionaire quiz';

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

   Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: QuizPage.quizDecoration(),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 40.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonCircle(
                        Icon(
                          Icons.share,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        () {

                        }
                    ),
                    ButtonCircle(
                        Icon(
                          Icons.star,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        () {

                        }
                    )
                  ],
                ),
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
                      'Play',
                      () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_context){
                              return GamePlay();
                            }
                        ));
                      },
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ButtonQuiz(
                      'Score',
                      () {

                        },
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ButtonQuiz(
                      'About',
                      () {

                        },
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            )
          ),
        );
  }
}