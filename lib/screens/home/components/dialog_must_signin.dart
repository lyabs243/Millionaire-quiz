import 'package:flutter/material.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import '../../../services/constants.dart' as constants;

class DialogMustSignin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
              Text(
                '${MyLocalizations.of(context).localization['must_signin_leaderboard']}',
                textAlign: TextAlign.center,
                textScaleFactor: 1.4,
                style: TextStyle(
                  fontSize: (16.0 / 853) * MediaQuery.of(context).size.height,
                  color: Colors.white
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
                        MyLocalizations.of(context).localization['sign_in'],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // To close the dialog
                      },
                      child: Text(
                        MyLocalizations.of(context).localization['cancel'],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
  static const double avatarRadius = 30.0;
}