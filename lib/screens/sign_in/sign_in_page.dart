import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/dialog_want_exit.dart';
import 'package:millionaire_quiz/components/layout_app_logo.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/screens/home/home.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:millionaire_quiz/services/no_animation_pageroute.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../services/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPagePageState createState() {
    return _SignInPagePageState();

  }
}

class _SignInPagePageState extends State<SignInPage> {

  ProgressDialog _progressDialog;

  @override
  initState() {
    super.initState();
    _progressDialog = ProgressDialog(context, isDismissible: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSignIn(BuildContext _context) async {
    _progressDialog.show();
    User.handleSignIn(_context).then((value) {
      _progressDialog.hide();
      if (value) {
        Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }
      else {
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).localization['error_occured'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }


  Widget build(BuildContext context) {
    _progressDialog.style(message: MyLocalizations.of(context).localization['please_wait']);
    return WillPopScope(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: QuizPage.quizDecoration(),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 70.0),),
                  LayoutAppLogo(),
                  Padding(padding: EdgeInsets.only(bottom: 40.0),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ButtonQuiz(
                        MyLocalizations.of(context).localization['sign_in_with_google'],
                            () {
                          _handleSignIn(context);
                        },
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0),),
                      ButtonQuiz(
                        MyLocalizations.of(context).localization['continue_without_signing'],
                            () {
                          Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        },
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    ],
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: MyLocalizations.of(context).localization['term_use_text'],
                          style: new TextStyle(color: Colors.white,fontSize: 18.0),
                        ),
                        new TextSpan(
                          text: MyLocalizations.of(context).localization['term_use'],
                          style: new TextStyle(
                            color: Colors.yellow,
                            fontSize: 18.0,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(constants.LINK_TERMS_USE);
                            },
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        ),
      ),
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => DialogWantExit(),
        ).then((value) {
          if(value) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });

        return false;
      }
    );
  }
}