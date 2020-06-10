import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';

class LoadFailed extends StatelessWidget {

  Function tryAgain;

  LoadFailed(this.tryAgain);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 40.0),),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                  'assets/logo.png'
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 6),),
            Container(
              child: Text(
                'Failed to load questions, please check your internet connection ans try again',
                textScaleFactor: 1.8,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0),),
            ButtonQuiz(
              'Try again',
              this.tryAgain,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

}