import 'package:flutter/material.dart';
import 'package:millionaire_quiz/models/question.dart';
import '../../../models/money_mangement.dart';
import '../../../services/constants.dart' as constants;
import 'package:admob_flutter/admob_flutter.dart';

class DialogAskAudience extends StatelessWidget {

  Question question;
  AdmobBanner admobBanner;
  String correctAnswer, answer;
  int maxSize = 250;

  DialogAskAudience(this.question) {
    int index = 0;
    question.answers.forEach((element) {
      if(element.is_valid_answer) {
        answer = element.description;
        if(index == 0) {
          correctAnswer = 'A';
        }
        else if(index == 1) {
          correctAnswer = 'B';
        }
        else if(index == 2) {
          correctAnswer = 'C';
        }
        else {
          correctAnswer = 'D';
        }
      }
      index++;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(constants.SHOW_ADMOB) {
      admobBanner = AdmobBanner(
        adUnitId: constants.ADMOB_BANNER_ID,
        adSize: AdmobBannerSize.LARGE_BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return WillPopScope(
      child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              (constants.SHOW_ADMOB)?
              Container(
                child: admobBanner,
              ): Container(),
              SizedBox(height: (16.0 / 853) * MediaQuery.of(context).size.height),
              RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'Audience result:  ',
                      style: new TextStyle(color: Colors.white, fontSize: (28.0 / 853) * MediaQuery.of(context).size.height),
                    ),
                  ],
                ),
              ),
              SizedBox(height: (24.0 / 853) * MediaQuery.of(context).size.height),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: 5 / 100 * ((maxSize / 853) * MediaQuery.of(context).size.height),
                          color: Colors.blue,
                        ),
                        SizedBox(height: (4.0 / 853) * MediaQuery.of(context).size.height),
                        Container(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 25.0
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: 10 / 100 * ((maxSize / 853) * MediaQuery.of(context).size.height),
                          color: Colors.blue,
                        ),
                        SizedBox(height: (4.0 / 853) * MediaQuery.of(context).size.height),
                        Container(
                          child: Text(
                            'B',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 25.0
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: 70 / 100 * ((maxSize / 853) * MediaQuery.of(context).size.height),
                          color: Colors.blue,
                        ),
                        SizedBox(height: (4.0 / 853) * MediaQuery.of(context).size.height),
                        Container(
                          child: Text(
                            'C',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 25.0
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: 15 / 100 * ((maxSize / 853) * MediaQuery.of(context).size.height),
                          color: Colors.blue,
                        ),
                        SizedBox(height: (4.0 / 853) * MediaQuery.of(context).size.height),
                        Container(
                          child: Text(
                            'D',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 25.0
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: (24.0 / 853) * MediaQuery.of(context).size.height),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // To close the dialog
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.group,
                size: (80.0 / 853) * MediaQuery.of(context).size.height,
                color: Colors.white,
              ),
              radius: Consts.avatarRadius,
            ),
          )
        ),//...top circlular image part,
      ],
    ),
      onWillPop: () {},
    );
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}