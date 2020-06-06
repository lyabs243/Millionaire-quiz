import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import '../../services/constants.dart' as constants;

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: QuizPage.quizDecoration(),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 40.0),),
              Container(
                child: Text(
                  'About',
                  textScaleFactor: 3.0,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
              Container(
                child: Text(
                  '${constants.APP_NAME}',
                  textScaleFactor: 1.4,
                  style: TextStyle(
                    color: Colors.yellow
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0),),
              Container(
                child: Text(
                  'version ${constants.APP_VERSION}',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0, bottom: 4.0),),
              Container(
                child: Text(
                  "${constants.APP_NAME} is a fun game in the form of multiple choice questions. The game is based on the concept of \"Who wants to be a Millionaire\". Your goal is to answer the questions correctly to reach the maximum amount of \$1,000,000 and become the new millionaire! Enjoy the game!",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,height: 1.2,wordSpacing: 1.2
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0, bottom: 4.0),),
              Container(
                child: Text(
                  '© ${constants.APP_COMPANY_NAME} ${constants.APP_DATE}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}