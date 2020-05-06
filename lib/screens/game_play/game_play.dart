import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/countdown_timer.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/answer.dart';
import 'package:millionaire_quiz/models/question.dart';

class GamePlay extends StatefulWidget {

  @override
  _GamePlayState createState() {
    return _GamePlayState();
  }

}

class _GamePlayState extends State<GamePlay>  with TickerProviderStateMixin {

  List<Question> questions = [];
  BuildContext _context;
  int level = 0;
  int current_question_index = 0;
  Question current_question;

  AnimationController controller;

  List<Widget> answers_widgets = [];

  bool is_loading = true;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    initData();
  }

  initData() async {
    await Future.delayed(Duration.zero);
    _context = context;
    initQuestions();
  }

  initQuestions() {
    current_question_index = 0;
    setState(() {
      is_loading = true;
    });
    Question.getQuestions(_context, level).then((value) {
      questions = value;
      setState(() {
        is_loading = false;
      });
      if(questions.length > 0) {
        setState(() {
          current_question = questions[current_question_index++];
          answers_widgets = getAnswersWidgets(current_question.answers);
        });
        controller.reverse(
            from: 30.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: QuizPage.quizDecoration(),
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: (is_loading)?
        Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(bottom: 10.0),),
                Container(
                  child: Text(
                    'Please wait...',
                    textScaleFactor: 2.0,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
        ):
        ((questions.length > 0)?
        Column(
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
            Padding(padding: EdgeInsets.only(bottom: 40.0),),
            Container(
              height: MediaQuery.of(context).size.width / 5,
              width: MediaQuery.of(context).size.width / 5,
              child: CountDownTimer(this.controller),
            ),
            Padding(padding: EdgeInsets.only(bottom: 40.0),),
            Container(
              child: Text(
                current_question.description,
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
              children: answers_widgets,
            )
          ],
        ):
        Center(
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
                   () {
                    setState(() {
                      is_loading = true;
                    });
                     initQuestions();
                  },
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  List<Widget> getAnswersWidgets(List<Answer> answers) {
    List<Widget> widgets = [];

    int index = 1;
    for(Answer answer in answers) {
      String left_text = 'A:';
      if(index == 2) {
        left_text = 'B:';
      }
      if(index == 3) {
        left_text = 'C:';
      }
      if(index == 4) {
        left_text = 'D:';
      }
      index++;
      widgets.add(
        ButtonQuiz(
          answer.description,
          () {
            setState(() {
              //load another question
              if(current_question_index < questions.length) {
                current_question = questions[current_question_index++];
                answers_widgets = getAnswersWidgets(current_question.answers);
                controller.stop();
                controller.reverse(
                    from: 30);
              }
              else {
                if(level < 2) {
                  setState(() {
                    level += 1;
                    initQuestions();
                  });
                }
              }
            });
          },
          textLeft: left_text,
        ),
      );
      widgets.add(Padding(padding: EdgeInsets.only(bottom: 20.0),),);
    }

    return widgets;
  }

}