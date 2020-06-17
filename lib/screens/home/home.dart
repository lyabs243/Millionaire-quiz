import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/dialog_latest_results.dart';
import 'package:millionaire_quiz/components/dialog_settings.dart';
import 'package:millionaire_quiz/components/dialog_top_leadboard.dart';
import 'package:millionaire_quiz/components/layout_load.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/settings.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/screens/about/about.dart';
import 'package:millionaire_quiz/screens/game_play/game_play.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:millionaire_quiz/screens/home/components/dialog_must_signin.dart';
import 'package:millionaire_quiz/screens/sign_in/sign_in_page.dart';
import 'package:millionaire_quiz/services/constants.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:millionaire_quiz/services/no_animation_pageroute.dart';
import '../../services/constants.dart' as constants;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver {

  AudioCache audioPlayer;
  AudioPlayer player;
  Settings _settings;
  bool isLoading = true;

  User currentUser;

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
    User.getCurrentUser().then((_user) {
      setState(() {
        currentUser = _user;
        isLoading = false;
      });
    });
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
          body: (isLoading)?
              LayoutLoad():
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: QuizPage.quizDecoration(),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 40.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (constants.USING_SERVER)?
                        Container(
                          height: (40.0 / 853) * MediaQuery.of(context).size.height,
                          child: new RaisedButton(
                            onPressed: () {
                              if (currentUser != null && currentUser.id.length > 0) { //logout
                                GoogleSignIn _googleSignIn = GoogleSignIn(
                                  scopes: [
                                    'email',
                                    'https://www.googleapis.com/auth/contacts.readonly',
                                  ],
                                );
                                _googleSignIn.signOut();
                                currentUser.fullName = '';
                                currentUser.id = '';
                                currentUser.urlProfilPic = '';
                                User.setUser(currentUser);
                                Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) {
                                  return SignInPage();
                                }));
                              }
                              else {
                                Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) {
                                  return SignInPage();
                                }));
                              }
                            },
                            highlightColor: Colors.orange,
                            child: SizedBox(
                              child: Text(
                                (currentUser != null && currentUser.id.length > 0)?
                                MyLocalizations.of(context).localization['sign_out']:
                                MyLocalizations.of(context).localization['sign_in'],
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
                                Icons.share,
                                size: (25.0 / 853) * MediaQuery.of(context).size.height,
                                color: Colors.white,
                              ),
                                  () {

                              }
                          ),
                          width: (MediaQuery.of(context).size.width * 70 / 100) / 5,
                        ),
                        Container(
                          child: ButtonCircle(
                              Icon(
                                Icons.star,
                                size: (25.0 / 853) * MediaQuery.of(context).size.height,
                                color: Colors.white,
                              ),
                              () {

                              }
                          ),
                          width: (MediaQuery.of(context).size.width * 70 / 100) / 5,
                        ),
                        Container(
                          child: ButtonCircle(
                              Icon(
                                Icons.settings,
                                size: (25.0 / 853) * MediaQuery.of(context).size.height,
                                color: Colors.white,
                              ),
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
                              }
                          ),
                          width: (MediaQuery.of(context).size.width * 70 / 100) / 5,
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
                          MyLocalizations.of(context).localization['play'],
                              () {
                            if(player != null) {
                              player.pause();
                            }
                            Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) {
                              return GamePlay();
                            })).then((value) {
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
                          MyLocalizations.of(context).localization['top_leadboard'],
                          () {
                            if (currentUser.id.length > 0) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => DialogTopLeadBoard(),
                              );
                            }
                            else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => DialogMustSignin(),
                              ).then((value) {
                                if (value) {
                                  Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) {
                                    return SignInPage();
                                  }));
                                }
                              });
                            }
                          },
                          textAlign: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20.0),),
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
                          MyLocalizations.of(context).localization['about'],
                              () {
                                Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) {
                                  return About();
                                }));
                          },
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                )
            ),
          ),
        );
  }
}