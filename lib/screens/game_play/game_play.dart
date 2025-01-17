import 'dart:math';

import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/layout_load.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/answer.dart';
import 'package:millionaire_quiz/models/leaderboard.dart';
import 'package:millionaire_quiz/models/question.dart';
import 'package:millionaire_quiz/models/score.dart';
import 'package:millionaire_quiz/models/settings.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/screens/game_play/components/dialog/dialog_want_quit_game.dart';
import 'package:millionaire_quiz/screens/game_play/components/game_play_body.dart';
import 'file:///D:/code/Millionaire-quiz/lib/screens/game_play/components/dialog/dialog_ask_audience.dart';
import 'file:///D:/code/Millionaire-quiz/lib/screens/game_play/components/dialog/dialog_get_money.dart';
import 'package:millionaire_quiz/screens/game_play/components/game_play_header.dart';
import 'package:millionaire_quiz/screens/game_play/components/layout_question_load_failed.dart';
import 'package:millionaire_quiz/services/constants.dart';
import 'components/dialog/dialog_call_friend.dart';
import 'components/dialog/dialog_game_finished.dart';
import '../../models/money_mangement.dart';
import 'components/dialog/dialog_step_transition.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../../services/constants.dart' as constants;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePlay extends StatefulWidget {

  @override
  _GamePlayState createState() {
    return _GamePlayState();
  }

}

class _GamePlayState extends State<GamePlay>  with TickerProviderStateMixin, WidgetsBindingObserver {

  List<Question> questions = [];
  BuildContext _context;
  int level = 0, currentBonusButtonIndex = 0;
  AdmobInterstitial interstitialAd, interstitialAdBonusButtons;
  int current_question_index = 0, currentMoney = 0;
  Question current_question;
  int timeToWaitAfterAnswer = 1, selectedAnswerIndex = -1;
  bool checkingAnswerFinished = false, doFlash = false;
  MoneyManagement moneyManagement;
  bool callFriendEnable = true, askAudienceEnable = true, hideAnswersEnable = true;
  Color callFriendBorderColor = Colors.blue, callFriendFillColor = Colors.black, askAudienceBorderColor = Colors.blue,
  askAudienceFillColor = Colors.black, hideAnswersBorderColor = Colors.blue, hideAnswersFillColor = Colors.black;
  List<bool> answersVisible = [true, true, true, true];

  AnimationController controller;

  AudioCache audioPlayer;
  AudioPlayer player;
  Settings _settings;

  bool is_loading = true, isAnswerAClicked = false, isAnswerBClicked = false, isAnswerCClicked = false,
      isAnswerDClicked = false, canShowDialog = false, canShowTransition = false;

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
    AppPages.CURRENT_PAGE = AppPages.PAGE_GAMEPLAY;
    Settings.getInstance().then((value) {
      setState(() {
        _settings = value;
      });
    });
    if(constants.SHOW_ADMOB) {
      interstitialAd = AdmobInterstitial(
        adUnitId: constants.ADMOB_INTERSTITIAL_ID,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) async {
          if (event == AdmobAdEvent.closed ||
              event == AdmobAdEvent.failedToLoad) {
            if  (canShowTransition) {
              setState(() {
                is_loading = false;
              });
              showTransition();
              interstitialAd.load();
            }
            canShowTransition = false;
          }
        },
      );
      interstitialAdBonusButtons = AdmobInterstitial(
        adUnitId: constants.ADMOB_INTERSTITIAL_ID,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) async {
          if (event == AdmobAdEvent.closed ||
              event == AdmobAdEvent.failedToLoad) {
            if (canShowDialog && currentBonusButtonIndex != 2) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                  (currentBonusButtonIndex == 0)?
                    DialogCallFriend(current_question):
                    DialogAskAudience(current_question)
                  ,
              ).then((value) {
                controller.reverse(from: controller.value);
                setState(() {
                  if (currentBonusButtonIndex == 0) {
                    callFriendFillColor = Colors.grey;
                    callFriendBorderColor = Colors.white;
                    callFriendEnable = false;
                  }
                  else if (currentBonusButtonIndex == 1) {
                    askAudienceFillColor = Colors.grey;
                    askAudienceBorderColor = Colors.white;
                    askAudienceEnable = false;
                  }
                });
              });
            }
            if(currentBonusButtonIndex == 2) {
              currentBonusButtonIndex = -1;
              controller.reverse(from: controller.value);
              hideTwoAnswers();

              setState(() {
                hideAnswersFillColor = Colors.grey;
                hideAnswersBorderColor = Colors.white;
                hideAnswersEnable = false;
              });
            }
            interstitialAdBonusButtons.load();
            canShowDialog = false;
          }
        },
      );
      interstitialAd.load();
      interstitialAdBonusButtons.load();
    }
    moneyManagement = new MoneyManagement();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    controller.addStatusListener((status) {
      if(status == AnimationStatus.dismissed) {
        wrongAnswer();
      }
    });
    audioPlayer = AudioCache();
    play();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if(player != null) {
      player.dispose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if(player != null) {
        player.stop();
      }
    }
  }

  void exitGame() {
    controller.stop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogExitGame(),
    ).then((value) {
      if(value) {
        Navigator.pop(context);
      }
      else {
        controller.reverse(from: controller.value);
      }
    });
  }

  play() async {
    //play audio start
    if(_settings != null && _settings.audioEnable) {
      player = await audioPlayer.play('audio/lets_play.mp3');
    }

    level = 0;
    moneyManagement.currentStep = 0;
    currentMoney = 0;
    setState(() {
      callFriendEnable = true;
      callFriendBorderColor = Colors.blue;
      callFriendFillColor = Colors.black;

      askAudienceEnable = true;
      askAudienceBorderColor = Colors.blue;
      askAudienceFillColor = Colors.black;

      hideAnswersEnable = true;
      hideAnswersBorderColor = Colors.blue;
      hideAnswersFillColor = Colors.black;
    });
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
        canShowTransition = true;
        if (constants.SHOW_ADMOB) {
          interstitialAd.show();
        }
        else {
          if  (canShowTransition) {
            setState(() {
              is_loading = false;
            });
            showTransition();
            interstitialAd.load();
          }
          canShowTransition = false;
        }
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
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: QuizPage.quizDecoration(),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: (is_loading)?
              LayoutLoad():
              ((questions.length > 0)?
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 40.0),),
                    GamePlayHeader(currentMoney, onBonusCallAFriendClicked, onBonusAskAudienceClicked,
                        onBonusHideAnswersClicked, onGetMoneyClicked, hideAnswersBorderColor, hideAnswersFillColor,
                        askAudienceFillColor, askAudienceBorderColor, callFriendFillColor, callFriendBorderColor, exitGame),
                    Padding(padding: EdgeInsets.only(bottom: (30.0 / 853) * MediaQuery.of(context).size.height),),
                    GamePlayBody(getMoneyDescription(), current_question, controller, answersVisible, onAnswerAclicked,
                        onAnswerBClicked, onAnswerCClicked, onAnswerDClicked, getAnswerButtonColor)
                  ],
                ),
              ):
              LoadFailed(() {
                setState(() {
                  is_loading = true;
                });
                initQuestions();
              })),
            ),
          ),
        ),
        onWillPop: () {

        });
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
    initAnswersVisibility();
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
        wrongAnswer();
      }
  }

  void wrongAnswer () {
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

  finishGame({jackpot: false}) async {
    if (jackpot) {
      if ((_settings != null && _settings.audioEnable)) {
        if (player != null) {
          player.stop();
        }
        player = await audioPlayer.play('audio/jackpot.mp3');
      }
    }
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
    Score score = Score(currentMoney);
    Score.addLastResult(score);

    //add score to server
    User.getInstance().then((_user) {
      LeaderBoard.addGameResult(context, _user.id, currentMoney);
    });
  }

  void initAnswersVisibility() {
    for (int i=0; i<answersVisible.length; i++) {
      setState(() {
        answersVisible[i] = true;
      });
    }
  }

  void onGetMoneyClicked() {
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
  }

  void onBonusHideAnswersClicked() {
    if (hideAnswersEnable) {
      currentBonusButtonIndex = 2;
      controller.stop();
      if(constants.SHOW_ADMOB) {
        interstitialAdBonusButtons.show();
      }
      else {
        currentBonusButtonIndex = -1;
        controller.reverse(from: controller.value);
        hideTwoAnswers();

        setState(() {
          hideAnswersFillColor = Colors.grey;
          hideAnswersBorderColor = Colors.white;
          hideAnswersEnable = false;
        });
      }
    }
  }

  void onBonusCallAFriendClicked() {
    if (callFriendEnable) {
      controller.stop();
      currentBonusButtonIndex = 0;
      if(constants.SHOW_ADMOB) {
        canShowDialog = true;
        interstitialAdBonusButtons.show();
      }
      else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              DialogCallFriend(current_question),
        ).then((value) {
          controller.reverse(from: controller.value);
          setState(() {
            callFriendFillColor = Colors.grey;
            callFriendBorderColor = Colors.white;
            callFriendEnable = false;
          });
        });
      }
    }
  }

  void onBonusAskAudienceClicked() {
    if (askAudienceEnable) {
      currentBonusButtonIndex = 1;
      controller.stop();
      if(constants.SHOW_ADMOB) {
        canShowDialog = true;
        interstitialAdBonusButtons.show();
      }
      else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              DialogAskAudience(current_question),
        ).then((value) {
          controller.reverse(from: controller.value);
          setState(() {
            askAudienceFillColor = Colors.grey;
            askAudienceBorderColor = Colors.white;
            askAudienceEnable = false;
          });
        });
      }
    }
  }

  void hideTwoAnswers() {
    //generate random value of answer that will not be hide
    int max = 2;
    int min = 0;
    Random rnd = new Random();

    //array of all index that can be checked, index of good answer will be removed from this array
    List<int> indexes = [0, 1, 2, 3];

    //remove correct answer index from the list
    for ( int j=0; j<current_question.answers.length; j++) {
      if (current_question.answers[j].is_valid_answer) {
        indexes.removeAt(j);
        break;
      }
    }

    int indexAnswerVisible = min + rnd.nextInt(max - min + 1);
    indexAnswerVisible = indexes[indexAnswerVisible];
    for (int i=0; i<answersVisible.length; i++) {
      if (!current_question.answers[i].is_valid_answer && i != indexAnswerVisible) {
        setState(() {
          answersVisible[i] = false;
        });
      }
    }
  }

  void onAnswerAclicked() async {
    if(!checkingAnswerFinished) {
      setState(() {
        isAnswerAClicked = true;
        selectedAnswerIndex = 0;
      });
      checkAnswer(0);
    }
  }

  void onAnswerBClicked() async {
    if(!checkingAnswerFinished) {
      setState(() {
        isAnswerBClicked = true;
        selectedAnswerIndex = 1;
      });
      checkAnswer(1);
    }
  }

  void onAnswerCClicked() async{
    if(!checkingAnswerFinished) {
      setState(() {
        isAnswerCClicked = true;
        selectedAnswerIndex = 2;
      });
      checkAnswer(2);
    }
  }

  void onAnswerDClicked() async {
    if(!checkingAnswerFinished) {
      setState(() {
        isAnswerDClicked = true;
        selectedAnswerIndex = 3;
      });
      checkAnswer(3);
    }
  }

  Future showTransition({finish: false, start: 0, end: 0, jackpot: true, reverse: false}) async {
    int from, to;
    if(reverse) {
      if ((_settings != null && _settings.audioEnable)) {
        if (player != null) {
          player.stop();
        }
        player = await audioPlayer.play('audio/wrong_answer.mp3');
      }
      from = start;
      to = end;
    }
    else {
      if ((_settings != null && _settings.audioEnable)) {
        if (player != null) {
          player.stop();
        }
        player = await audioPlayer.play('audio/correct_answer.mp3');
      }
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