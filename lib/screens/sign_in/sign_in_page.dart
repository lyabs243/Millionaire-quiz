import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/layout_app_logo.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/screens/home/home.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:millionaire_quiz/services/no_animation_pageroute.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
    return Scaffold(
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
                    )
                  ],
                )
            ),
          ),
        );
  }
}