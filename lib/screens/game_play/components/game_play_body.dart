import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/countdown_timer.dart';
import 'package:millionaire_quiz/models/question.dart';

class GamePlayBody extends StatelessWidget {

  String moneyDescription;
  AnimationController controller;
  Question current_question;
  List<bool> answersVisible;

  Function onAnswerAclicked, onAnswerBClicked, onAnswerCClicked, onAnswerDClicked, getAnswerButtonColor;

  GamePlayBody(this.moneyDescription, this.current_question, this.controller, this.answersVisible, this.onAnswerAclicked,
      this.onAnswerBClicked, this.onAnswerCClicked, this.onAnswerDClicked, this.getAnswerButtonColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            '\$ ${moneyDescription}',
            textScaleFactor: 2.0,
            style: TextStyle(
                color: Colors.yellow
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: (30.0 / 853) * MediaQuery.of(context).size.height),),
        Container(
          height: MediaQuery.of(context).size.width / 5,
          width: MediaQuery.of(context).size.width / 5,
          child: CountDownTimer(this.controller),
        ),
        Padding(padding: EdgeInsets.only(bottom: (30.0 / 853) * MediaQuery.of(context).size.height),),
        Container(
          child: Text(
            current_question.description,
            textScaleFactor: 1.8,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: (50.0 / 853) * MediaQuery.of(context).size.height),),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (answersVisible[0])?
            ButtonQuiz(
              current_question.answers[0].description,
              this.onAnswerAclicked,
              textLeft: 'A:',
              buttonColor: getAnswerButtonColor(0),
            ): Container(height: 50.0,),
            Padding(padding: EdgeInsets.only(bottom: (20.0 / 853) * MediaQuery.of(context).size.height),),
            (answersVisible[1])?
            ButtonQuiz(
              current_question.answers[1].description,
              this.onAnswerBClicked,
              textLeft: 'B:',
              buttonColor: getAnswerButtonColor(1),
            ): Container(height: 50.0,),
            Padding(padding: EdgeInsets.only(bottom: 20.0),),
            (answersVisible[2])?
            ButtonQuiz(
              current_question.answers[2].description,
              this.onAnswerCClicked,
              textLeft: 'C:',
              buttonColor: getAnswerButtonColor(2),
            ): Container(height: 50.0,),
            Padding(padding: EdgeInsets.only(bottom: 20.0),),
            (answersVisible[3])?
            ButtonQuiz(
              current_question.answers[3].description,
              this.onAnswerDClicked,
              textLeft: 'D:',
              buttonColor: getAnswerButtonColor(3),
            ): Container(height: 50.0,)
          ],
        )
      ],
    );
  }

}