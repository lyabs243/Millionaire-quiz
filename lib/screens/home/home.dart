import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/dialog_latest_results.dart';
import 'package:millionaire_quiz/components/dialog_settings.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/settings.dart';
import 'package:millionaire_quiz/screens/about/about.dart';
import 'package:millionaire_quiz/screens/game_play/game_play.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:millionaire_quiz/services/constants.dart';

class HomePage extends StatefulWidget {

  String title = 'Millionaire quiz';

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver {

  AudioCache audioPlayer;
  AudioPlayer player;
  Settings _settings;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Settings.getInstance().then((value) {
      setState(() {
        _settings = value;
        if(_settings.audioEnable) {
          playMainSong();
        }
      });
    });
    audioPlayer = AudioCache();
    AppPages.CURRENT_PAGE = AppPages.PAGE_HOME;
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
    if (AppPages.CURRENT_PAGE == AppPages.PAGE_HOME) {
      if (state == AppLifecycleState.paused && player != null) {
        player.pause();
      }
      else if (state == AppLifecycleState.resumed && player != null && (_settings != null && _settings.audioEnable)) {
        player.resume();
      }
    }
  }

  playMainSong() async {
    player = await audioPlayer.loop('audio/main_theme.mp3');
  }


  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
            child: Container(
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
                            if(player != null) {
                              player.pause();
                            }
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_context){
                                  return GamePlay();
                                }
                            )).then((value) {
                              if(player != null && (_settings != null && _settings.audioEnable)) {
                                player.resume();
                              }
                              AppPages.CURRENT_PAGE = AppPages.PAGE_HOME;
                            });
                          },
                          textAlign: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20.0),),
                        ButtonQuiz(
                          'Score',
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
                          'About',
                              () {
                            Navigator.push(context, MaterialPageRoute(builder: (_context) {
                              return About();
                            }));
                          },
                          textAlign: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20.0),),
                        ButtonQuiz(
                          'Settings',
                              () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => DialogSettings(),
                            ).then((value) {
                              Settings.settingsInstance = value;
                              setState(() {
                                if(_settings.audioEnable != value.audioEnable) {
                                  if(value.audioEnable) {
                                    playMainSong();
                                  }
                                  else {
                                    if(player != null) {
                                      player.stop();
                                    }
                                  }
                                }
                                _settings = value;
                              });
                            });
                          },
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                )
            ),
          ),
        );
  }
}