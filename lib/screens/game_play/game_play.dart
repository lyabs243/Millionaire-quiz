import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/countdown_timer.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/answer.dart';
import 'package:millionaire_quiz/models/question.dart';
import 'package:millionaire_quiz/screens/game_play/components/dialog_get_money.dart';
import 'components/dialog_game_finished.dart';
import '../../models/money_mangement.dart';
import 'components/dialog_step_transition.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../../services/constants.dart' as constants;

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
  AdmobInterstitial interstitialAd;
  int current_question_index = 0, currentMoney = 0;
  Question current_question;
  int timeToWaitAfterAnswer = 1, selectedAnswerIndex = -1;
  bool checkingAnswerFinished = false, doFlash = false;
  MoneyManagement moneyManagement;

  AnimationController controller;

  bool is_loading = true, isAnswerAClicked = false, isAnswerBClicked = false, isAnswerCClicked = false,
      isAnswerDClicked = false;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  String getMoneyDescription() {
    if (currentMoney == 0) {
      return '0';
    }
    return MoneyManagement.jackpotsText[MoneyManagement.jackpots.indexOf(currentMoney)].trim();
  }

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: constants.ADMOB_INTERSTITIAL_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) async {
        if(event == AdmobAdEvent.closed || event == AdmobAdEvent.failedToLoad) {
          setState(() {
            is_loading = false;
          });
          showTransition();
          interstitialAd.load();
        }
      },
    );
    interstitialAd.load();
    moneyManagement = new MoneyManagement();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    controller.addStatusListener((status) {
      if(status == AnimationStatus.dismissed) {
        finishGame();
      }
    });
    play();
  }

  play() {
    level = 0;
    moneyManagement.currentStep = 0;
    currentMoney = 0;
    initData();
  }

  initData() async {
    await Future.delayed(Duration.zero);
    _context = context;
    initQuestions();
  }

  Future initQuestions({transition: false}) async {
    current_question_index = 0;
    setState(() {
      is_loading = true;
      checkingAnswerFinished = false;
      selectedAnswerIndex = -1;
    });
    if(transition) {
      Question.getQuestions(_context, level).then((value) {
        questions = value;
        if (questions.length > 0) {
          setState(() {
            current_question = questions[current_question_index++];
          });
        }
        interstitialAd.show();
      });
    }
    else {
      Question.getQuestions(_context, level).then((value) {
        questions = value;
        setState(() {
          is_loading = false;
        });
        if (questions.length > 0) {
          setState(() {
            current_question = questions[current_question_index++];
          });
          if (transition) {
            showTransition();
          }
          else {
            controller.reverse(from: 30.0);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: QuizPage.quizDecoration(),
          height: MediaQuery.of(context).size.height,
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 40.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    (currentMoney > 0)?
                    Container(
                      height: (40.0 / 853) * MediaQuery.of(context).size.height,
                      child: new RaisedButton(
                        onPressed: () {
                          controller.stop();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => DialogGetMoney(currentMoney),
                          ).then((value) {
                            if(value) {
                              finishGame();
                            }
                            else {
                              controller.reverse(from: controller.value);
                            }
                          });
                        },
                        highlightColor: Colors.orange,
                        child: SizedBox(
                          child: Text(
                            'Get money',
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.white, fontSize: (18.0 / 853) * MediaQuery.of(context).size.height),
                          ),
                          width: MediaQuery.of(context).size.width * 25 / 100,
                        ),
                        color: Colors.black,
                        elevation: 10.0,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
                        ),
                      ),
                    ): Container(),
                    Container(
                      child: ButtonCircle(
                          Icon(
                            Icons.filter_center_focus,
                            size: (25.0 / 853) * MediaQuery.of(context).size.height,
                            color: Colors.white,
                          ),
                              () {

                          }
                      ),
                      width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
                    ),
                    Container(
                      child: ButtonCircle(
                          Icon(
                            Icons.call,
                            size: (25.0 / 853) * MediaQuery.of(context).size.height,
                            color: Colors.white,
                          ),
                              () {

                          }
                      ),
                      width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
                    ),
                    Container(
                      child: ButtonCircle(
                          Icon(
                            Icons.group,
                            size: (25.0 / 853) * MediaQuery.of(context).size.height,
                            color: Colors.white,
                          ),
                              () {

                          }
                      ),
                      width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: (30.0 / 853) * MediaQuery.of(context).size.height),),
                Container(
                  child: Text(
                    '\$ ${getMoneyDescription()}',
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
                    ButtonQuiz(
                      current_question.answers[0].description,
                          () async {
                        if(!checkingAnswerFinished) {
                          setState(() {
                            isAnswerAClicked = true;
                            selectedAnswerIndex = 0;
                          });
                          checkAnswer(0);
                        }
                      },
                      textLeft: 'A:',
                      buttonColor: getAnswerButtonColor(0),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: (20.0 / 853) * MediaQuery.of(context).size.height),),
                    ButtonQuiz(
                      current_question.answers[1].description,
                          () async {
                        if(!checkingAnswerFinished) {
                          setState(() {
                            isAnswerBClicked = true;
                            selectedAnswerIndex = 1;
                          });
                          checkAnswer(1);
                        }
                      },
                      textLeft: 'B:',
                      buttonColor: getAnswerButtonColor(1),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ButtonQuiz(
                      current_question.answers[2].description,
                          () async{
                        if(!checkingAnswerFinished) {
                          setState(() {
                            isAnswerCClicked = true;
                            selectedAnswerIndex = 2;
                          });
                          checkAnswer(2);
                        }
                      },
                      textLeft: 'C:',
                      buttonColor: getAnswerButtonColor(2),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ButtonQuiz(
                      current_question.answers[3].description,
                          () async {
                        if(!checkingAnswerFinished) {
                          setState(() {
                            isAnswerDClicked = true;
                            selectedAnswerIndex = 3;
                          });
                          checkAnswer(3);
                        }
                      },
                      textLeft: 'D:',
                      buttonColor: getAnswerButtonColor(3),
                    )
                  ],
                )
              ],
            ),
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
      ),
    );
  }

  checkAnswer(int index) async {
    controller.stop();
    await new Future.delayed(Duration(seconds : timeToWaitAfterAnswer));
    /*setState(() {
      checkingAnswerFinished = true;
    });*/
    setState(() {
      if(index == 0) {
        isAnswerAClicked = false;
      }
      else if(index == 1) {
        isAnswerBClicked = false;
      }
      else if(index == 2) {
        isAnswerCClicked = false;
      }
      else if(index == 3) {
        isAnswerDClicked = false;
      }
    });
    checkingAnswerFinished = true;
    flashLight().then((value) {
      //await new Future.delayed(Duration(seconds : timeToWaitAfterAnswer));

      onAnswerClicked(current_question.answers[index]);
    });
  }

  Future flashLight() async {
    for (int i = 0; i < 5; i++) {
      await new Future.delayed(Duration(milliseconds: 500));
      setState(() {
        doFlash = !doFlash;
      });
    }
    doFlash = false;
  }

  onAnswerClicked(Answer answer) async {
    setState(() {
      checkingAnswerFinished = false;
      selectedAnswerIndex = -1;
    });
      //load another question
      if(answer.is_valid_answer && controller.value > 0) {
        currentMoney = moneyManagement.stepUp();
        if(current_question_index < questions.length) {
          setState(() {
            current_question = questions[current_question_index++];
            controller.stop();
          });
          showTransition();
        }
        else {
          if(level < 2) {
            setState(() {
              level += 1;
              initQuestions(transition: true);
            });
          }
          else {
            //jackpot player becomes millionaire
            showTransition(finish: true);
          }
        }
      }
      else {
        int stepBefore = moneyManagement.currentStep-1;
        setState(() {
          currentMoney = moneyManagement.playerFail(level);
        });
        int stepAfter = moneyManagement.currentStep;
        //show transition of losing money when failing question
        if(stepBefore > 1) {
          showTransition(start: stepBefore, end: stepAfter, finish: true, jackpot: false, reverse: true);
        }
        else {
          finishGame();
        }
      }
  }

  finishGame({jackpot: false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogGameFinished(currentMoney, jackpot: jackpot,),
    ).then((value) {
      if(value) {
        play();
      }
      else {
        Navigator.pop(context);
      }
    });
  }

  Future showTransition({finish: false, start: 0, end: 0, jackpot: true, reverse: false}) async {
    int from, to;
    if(reverse) {
      from = start;
      to = end;
    }
    else {
      from = moneyManagement.currentStep - 2;
      to = moneyManagement.currentStep - 1;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogStepTransition(from, to),
    ).then((value) {
      if(finish) {
        finishGame(jackpot: jackpot);
      }
      else {
        controller.reverse(from: 30);
      }
    });
  }

  Color getAnswerButtonColor(int index) {
    Color color;
    if (checkingAnswerFinished) {
      if (current_question.answers[index].is_valid_answer) {
        if (doFlash) {
          color = Colors.black;
        }
        else {
          color = Colors.green;
        }
      }
      else {
        if (index == selectedAnswerIndex) {
          color = Colors.red;
        }
        else {
          color = Colors.black;
        }
      }
    }
    else {
      if ((isAnswerDClicked && index == 3) || (isAnswerCClicked && index == 2) || (isAnswerBClicked && index == 1)
       || (isAnswerAClicked && index == 0)) {
        color = Colors.orange;
      }
      else {
        color = Colors.black;
      }
    }
    return color;
  }

}