import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_quiz.dart';
import 'package:millionaire_quiz/components/quiz_page.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/screens/home/home.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPagePageState createState() {
    return _SignInPagePageState();
  }
}

class _SignInPagePageState extends State<SignInPage> {

  GoogleSignIn _googleSignIn;

  @override
  initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    try {
      var result = await _googleSignIn.signIn();

      User user = User();
      user.id = result.id;
      user.fullName = result.displayName;
      user.urlProfilPic = result.photoUrl;

      User.setUser(user).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    } catch (error) {
      Fluttertoast.showToast(
          msg: MyLocalizations.of(context).localization['error_occured'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
      );
    }
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
                    Padding(padding: EdgeInsets.only(top: 70.0),),
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
                          MyLocalizations.of(context).localization['sign_in_with_google'],
                          () {
                            _handleSignIn();
                          },
                          textAlign: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20.0),),
                        ButtonQuiz(
                          MyLocalizations.of(context).localization['continue_without_signing'],
                          () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
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